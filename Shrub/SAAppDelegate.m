//
//  SAAppDelegate.m
//  Shrub
//
//  Created by Andrew Carter on 3/4/13.
//  Copyright (c) 2013 Pinch Studios. All rights reserved.
//

#import "SAAppDelegate.h"

#import "SARootMenuViewController.h"
#import "UIColor+SAHelpers.h"

@implementation SAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
    [[self window] setBackgroundColor:[UIColor whiteColor]];
    
    [self setupAppearanceProxy];
    
    SARootMenuViewController *menuViewController = [SARootMenuViewController new];
    [[self window] setRootViewController:menuViewController];
    [[self window] makeKeyAndVisible];
    return YES;
}

- (void)setupAppearanceProxy
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigation_bar_bg"]
                                       forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor SAGreenColor]];
}

@end
