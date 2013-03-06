//
//  SARecordViewController.m
//  Shrub
//
//  Created by Andrew Carter on 3/5/13.
//  Copyright (c) 2013 Pinch Studios. All rights reserved.
//

#import "SARecordViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>

#import "SAMenuViewController.h"

@interface SARecordViewController () <AVCaptureVideoDataOutputSampleBufferDelegate>
{
    __weak IBOutlet UIView *_previewContainerView;
    AVCaptureSession *_captureSession;
    AVAssetWriter *_assetWriter;
    AVAssetWriterInput *_videoWriterInput;
    dispatch_queue_t _cameraQueue;
    AVCaptureConnection *_videoConnection;
    CMTime _lastVideoTime;
    CMTime _timeOffset;
    BOOL _shouldCaptureBuffer;
    BOOL _didBreakCapture;
}
@end

@implementation SARecordViewController

#pragma mark - UIViewController Overrides

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _cameraQueue = dispatch_queue_create("com.shrub.queue.cameraQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)viewDidLoad
{
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession beginConfiguration];
    [_captureSession setSessionPreset:AVCaptureSessionPreset640x480];
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    NSAssert(!error, @"Should be able to grab input");
    [_captureSession addInput:input];
    
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [output setAlwaysDiscardsLateVideoFrames:YES];
    NSDictionary *cameraSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange], kCVPixelBufferPixelFormatTypeKey,
                                    nil];
    [output setVideoSettings:cameraSettings];
    [output setSampleBufferDelegate:self queue:_cameraQueue];
    [_captureSession addOutput:output];
    _videoConnection = [output connectionWithMediaType:AVMediaTypeVideo];
    
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    [previewLayer setFrame:[_previewContainerView bounds]];
    [previewLayer setOrientation:AVCaptureVideoOrientationPortrait];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [[_previewContainerView layer] addSublayer:previewLayer];
    
    
    if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus] && [device lockForConfiguration:nil])
    {
        [device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        [device unlockForConfiguration];
    }
    
    if ([device isFlashAvailable] && [device lockForConfiguration:nil])
    {
        [device setFlashMode:AVCaptureFlashModeAuto];
        [device unlockForConfiguration];
    }
    
    [_captureSession commitConfiguration];
    
    NSString *documentsDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [documentsDir stringByAppendingPathComponent:@"movie.mp4"];
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    [[NSFileManager defaultManager] removeItemAtURL:fileURL error:nil];
    
    NSError *assetWriterError;
    _assetWriter = [AVAssetWriter assetWriterWithURL:fileURL
                                            fileType:AVFileTypeQuickTimeMovie
                                               error:&assetWriterError];
    NSAssert(!assetWriterError, [assetWriterError description]);
    
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoCodecH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:320], AVVideoWidthKey,
                                   [NSNumber numberWithInt:320], AVVideoHeightKey,
                                   nil];
    _videoWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    [_videoWriterInput setExpectsMediaDataInRealTime:YES];
    [_assetWriter addInput:_videoWriterInput];
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [_captureSession startRunning];
    //    [_assetWriter startWriting];
    //    [_assetWriter startSessionAtSourceTime:kCMTimeZero];
    
}

#pragma mark - Instance Method

- (IBAction)recordButtonTouchDown:(id)sender
{
    _shouldCaptureBuffer = YES;
}

- (IBAction)recordButtonTouchUp:(id)sender
{
    _shouldCaptureBuffer = NO;
    _didBreakCapture = YES;
}

- (IBAction)closeButtonPressed:(id)sender
{
    [_captureSession stopRunning];
    [_videoWriterInput markAsFinished];
    
    dispatch_async(_cameraQueue, ^{
        
        [_assetWriter finishWritingWithCompletionHandler:^{
            
            [[self menuViewController] hideAccessoryViewController:^{
                
                [[self menuViewController] setAccessoryViewController:nil];
                
            }];
            
        }];
        
    });
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate methods

// Credit to http://www.gdcl.co.uk/2013/02/20/iPhone-Pause.html
// http://www.gdcl.co.uk/license.htm
// for most of the code in the method below.

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if (connection == _videoConnection && _shouldCaptureBuffer)
    {
        if (CMSampleBufferDataIsReady(sampleBuffer))
        {
            if ([_assetWriter status] == AVAssetWriterStatusUnknown)
            {
                CMTime startTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
                [_assetWriter startWriting];
                [_assetWriter startSessionAtSourceTime:startTime];
            }
            if ([_videoWriterInput isReadyForMoreMediaData])
            {
                if (_didBreakCapture)
                {
                    _didBreakCapture = NO;
                    CMTime timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
                    CMTime offset = CMTimeSubtract(timestamp, _lastVideoTime);
                    if (_timeOffset.value == 0)
                    {
                        _timeOffset = offset;
                    }
                    else
                    {
                        _timeOffset = CMTimeAdd(_timeOffset, offset);
                    }
                }
                
                CFRetain(sampleBuffer);
                
                if (_timeOffset.value > 0)
                {
                    CFRelease(sampleBuffer);
                    CMItemCount count;
                    CMSampleBufferGetSampleTimingInfoArray(sampleBuffer, 0, nil, &count);
                    CMSampleTimingInfo *pInfo = malloc(sizeof(CMSampleTimingInfo) * count);
                    CMSampleBufferGetSampleTimingInfoArray(sampleBuffer, count, pInfo, &count);
                    for (CMItemCount i = 0; i < count; i++)
                    {
                        pInfo[i].decodeTimeStamp = CMTimeSubtract(pInfo[i].decodeTimeStamp, _timeOffset);
                        pInfo[i].presentationTimeStamp = CMTimeSubtract(pInfo[i].presentationTimeStamp, _timeOffset);
                    }
                    CMSampleBufferRef sout;
                    CMSampleBufferCreateCopyWithNewTiming(nil, sampleBuffer, count, pInfo, &sout);
                    sampleBuffer = sout;
                    free(pInfo);
                }
                
                CMTime timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
                CMTime dur = CMSampleBufferGetDuration(sampleBuffer);
                if (dur.value > 0)
                {
                    timestamp = CMTimeAdd(timestamp, dur);
                }
                _lastVideoTime = timestamp;
                
                [_videoWriterInput appendSampleBuffer:sampleBuffer];
                CFRelease(sampleBuffer);
            }
        }
    }
}

@end
