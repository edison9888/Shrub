//
//  SARecordViewController.m
//  Shrub
//
//  Created by Andrew Carter on 3/5/13.
//  Copyright (c) 2013 Pinch Studios. All rights reserved.
//

#import "SARecordViewController.h"

#import "SAMenuViewController.h"

@interface SARecordViewController ()

@end

@implementation SARecordViewController

#pragma mark - Instance Method

- (IBAction)closeButtonPressed:(id)sender
{
    [[self menuViewController] hideAccessoryViewController:^{
       
        [[self menuViewController] setAccessoryViewController:nil];
        
    }];
}

@end
