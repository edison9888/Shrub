//
//  SAHomeViewController.m
//  Shrub
//
//  Created by Andrew Carter on 3/4/13.
//  Copyright (c) 2013 Pinch Studios. All rights reserved.
//

#import "SAHomeViewController.h"

#import "SAMenuViewController.h"

@interface SAHomeViewController ()

@end

@implementation SAHomeViewController

#pragma mark - UIViewController Overrides

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[self navigationItem] setTitle:@"Home"];
        
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:[self menuViewController] action:@selector(toggleMenuHidden)];
        [[self navigationItem] setLeftBarButtonItem:leftBarButton];
        
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(cameraButtonPressed:)];
        [[self navigationItem] setRightBarButtonItem:rightBarButton];
    }
    return self;
}

#pragma mark - Instance Methods

- (void)cameraButtonPressed:(id)sender
{
    NSLog(@"%@", [self menuViewController]);
    [[self menuViewController] showAccessoryViewController];
}

@end
