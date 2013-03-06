//
//  SARootMenuViewController.m
//  Shrub
//
//  Created by Andrew Carter on 3/4/13.
//  Copyright (c) 2013 Pinch Studios. All rights reserved.
//

#import "SARootMenuViewController.h"

#import "SAHomeViewController.h"
#import "SAActivityViewController.h"
#import "SAExploreViewController.h"
#import "SAProfileViewController.h"
#import "SARecordViewController.h"

static NSString * const SAMenuItemTitleKey = @"SAMenuItemTitle";
static NSString * const SAMenuItemViewControllerClassKey = @"SAMenuItemViewControllerClass";

@interface SARootMenuViewController () <SAMenuViewControllerDatasource, SAMenuViewControllerDelegate>
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
        [self setAccessoryViewController:[SARecordViewController new]];
        [self setDatasource:self];
        [self setDelegate:self];
        
        _menuItems = @[@{SAMenuItemTitleKey :  @"Home", SAMenuItemViewControllerClassKey : [SAHomeViewController class]},
                       @{SAMenuItemTitleKey : @"Explore", SAMenuItemViewControllerClassKey : [SAExploreViewController class]},
                       @{SAMenuItemTitleKey :  @"Activity", SAMenuItemViewControllerClassKey : [SAActivityViewController class]},
                       @{SAMenuItemTitleKey : @"Profile", SAMenuItemViewControllerClassKey : [SAProfileViewController class]}
                       ];
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

- (void)menuViewController:(SAMenuViewController *)menuViewController didSelectRowAtIndex:(NSUInteger)index
{
    Class viewControllerClass = _menuItems[index][SAMenuItemViewControllerClassKey];
    if (![[self contentViewController] isKindOfClass:viewControllerClass])
    {
        [self setContentViewController:[viewControllerClass new]];
    }
    [self setMenuHidden:YES];
}

#pragma mark - SAMenuViewControllerDatasource Methods

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
    return _menuItems[index][SAMenuItemTitleKey];
}

@end