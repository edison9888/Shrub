//
//  SARootMenuViewController.m
//  Shrub
//
//  Created by Andrew Carter on 3/4/13.
//  Copyright (c) 2013 Pinch Studios. All rights reserved.
//

#import "SARootMenuViewController.h"

#import "SAHomeViewController.h"

@interface SARootMenuViewController () <SAMenuViewControllerDatasource>
{
    NSArray *_menuItems;
}
@end

@implementation SARootMenuViewController

#pragma mark - SAMenuViewController Overrides

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self setDatasource:self];
        
        _menuItems = @[@"Home", @"Explore", @"Activity", @"Profile"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SAHomeViewController *homeViewController = [SAHomeViewController new];
    [self setContentViewController:homeViewController];
    [self reloadData];
}

#pragma mark - SAMenuViewControllerDelegate Methods

- (NSUInteger)numberOfRowsInMenuViewController:(SAMenuViewController *)menuViewController
{
    return [_menuItems count];
}

- (UIImage *)menuViewController:(SAMenuViewController *)menuViewController imageForRowAtIndex:(NSUInteger)index
{
    return nil;
}

- (NSString *)menuViewController:(SAMenuViewController *)menuViewController titleForRowAtIndex:(NSUInteger)index
{
    return _menuItems[index];
}

@end