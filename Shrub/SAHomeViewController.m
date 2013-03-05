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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[self navigationItem] setTitle:@"Home"];
        
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:[self menuViewController] action:@selector(toggleMenuHidden)];
        [[self navigationItem] setLeftBarButtonItem:leftBarButton];
    }
    return self;
}

@end
