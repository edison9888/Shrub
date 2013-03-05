//
//  SAMenuViewController.m
//  Shrub
//
//  Created by Andrew Carter on 3/4/13.
//  Copyright (c) 2013 Pinch Studios. All rights reserved.
//

#import "SAMenuViewController.h"

#import "SADropdownView.h"
#import "SAMenuView.h"
#import <objc/runtime.h>
#import "SADropdownItem.h"
#import <QuartzCore/QuartzCore.h>

static const void *SAMenuViewControllerKey = &SAMenuViewControllerKey;

@interface SAMenuViewController ()
{
    __weak SAMenuView *_menuView;
    UINavigationController *_menuNavigationController;
    SADropdownView *_dropdownView;
}

@end

@implementation SAMenuViewController

#pragma mark - UIViewController Overrides

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _menuHidden = YES;
        
        _menuNavigationController = [UINavigationController new];
        [[_menuNavigationController view] setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [self addChildViewController:_menuNavigationController];
        
        _dropdownView = [[SADropdownView alloc] initWithFrame:CGRectMake(0.0f, 44.0f - SADropdownViewTopPadding, 320.0f, 0.0f)];
    }
    return self;
}

- (void)loadView
{
    SAMenuView *menuView = [[SAMenuView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setView:menuView];
    _menuView = menuView;
}

- (void)viewDidLoad
{
    [[self view] addSubview:[_menuNavigationController view]];
}

#pragma mark - Accessors

- (void)setContentViewController:(UIViewController *)contentViewController
{
    _contentViewController = contentViewController;
    [_menuNavigationController setViewControllers:@[[self contentViewController]]];
}

- (void)setMenuHidden:(BOOL)menuHidden
{
    if ([self isMenuHidden])
    {
        [_dropdownView setTransform:CGAffineTransformMakeTranslation(0.0f, -CGRectGetHeight([_dropdownView bounds]))];
        [[_menuNavigationController view] insertSubview:_dropdownView belowSubview:[_menuNavigationController navigationBar]];
        
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            [_dropdownView setTransform:CGAffineTransformIdentity];
            
        } completion:^(BOOL finished) {
            
            
        }];
    }
    else
    {
        [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [_dropdownView setTransform:CGAffineTransformMakeTranslation(0.0f, SADropdownViewTopPadding - [[_dropdownView layer] cornerRadius])];
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
                
                [_dropdownView setTransform:CGAffineTransformMakeTranslation(0.0f, -CGRectGetHeight([_dropdownView bounds]))];
                
            } completion:^(BOOL finished) {
                
                [_dropdownView removeFromSuperview];
                
            }];
            
        }];
    }
    
    _menuHidden = menuHidden;
}

#pragma mark - Instance Methods

- (void)reloadData
{
    [_dropdownView removeAllItems];
    
    if ([[self datasource] conformsToProtocol:@protocol(SAMenuViewControllerDatasource)])
    {
        for (NSUInteger i = 0; i < [[self datasource] numberOfRowsInMenuViewController:self]; i++)
        {
            SADropdownItem *item = [SADropdownItem new];
            if ([[self datasource] respondsToSelector:@selector(menuViewController:titleForRowAtIndex:)])
            {
                [item setTitle:[[self datasource] menuViewController:self titleForRowAtIndex:i] forState:UIControlStateNormal];
            }
            if ([[self datasource] respondsToSelector:@selector(menuViewController:imageForRowAtIndex:)])
            {
                [item setImage:[[self datasource] menuViewController:self imageForRowAtIndex:i] forState:UIControlStateNormal];
            }
            [_dropdownView addItem:item];
        }
    }
    
    [_dropdownView sizeToFit];
}

- (void)toggleMenuHidden
{
    [self setMenuHidden:![self isMenuHidden]];
}

@end

@implementation UIViewController (SAMenuViewController)

- (SAMenuViewController *)menuViewController
{
    SAMenuViewController *menuViewController = objc_getAssociatedObject(self, SAMenuViewControllerKey);
    UIViewController *parentViewController = [self parentViewController];
    
    if (!menuViewController && parentViewController)
    {
        menuViewController = objc_getAssociatedObject(self, SAMenuViewControllerKey);
        parentViewController = [parentViewController parentViewController];
    }
    
    return menuViewController;
}

- (void)setMenuViewController:(SAMenuViewController *)menuViewController
{
    objc_setAssociatedObject(self, SAMenuViewControllerKey, menuViewController, OBJC_ASSOCIATION_ASSIGN);
}

@end