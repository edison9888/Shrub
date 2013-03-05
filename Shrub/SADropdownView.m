//
//  SADropdownView.m
//  Shrub
//
//  Created by Andrew Carter on 3/4/13.
//  Copyright (c) 2013 Pinch Studios. All rights reserved.
//

#import "SADropdownView.h"

#import "SADropdownItem.h"
#import "UIColor+SAHelpers.h"
#import <QuartzCore/QuartzCore.h>

CGFloat SADropdownViewTopPadding = 30.0f;

@interface SADropdownView ()
{
    NSMutableArray *_items;
}
@end

@implementation SADropdownView

#pragma mark - UIView Overrides

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _items = [NSMutableArray new];
        [self setBackgroundColor:[UIColor SADarkGreyColor]];
        
        [[self layer] setCornerRadius:6.0f];
        [[self layer] setMasksToBounds:YES];
    }
    return self;
}

- (void)sizeToFit
{
    [self setFrame:CGRectMake(CGRectGetMinX([self frame]),
                              CGRectGetMinY([self frame]),
                              CGRectGetWidth([self bounds]),
                              [_items count] ? CGRectGetMaxY([[_items lastObject] frame]) : 0.0f)];
}

#pragma mark - Instance Methods

- (void)removeAllItems
{
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_items removeAllObjects];
}

- (void)addItem:(SADropdownItem *)item
{
    [self addSubview:item];
        
    [item setFrame:CGRectMake(0.0f,
                              [_items count] ? CGRectGetMaxY([[_items lastObject] frame]) : SADropdownViewTopPadding,
                              CGRectGetWidth([self bounds]),
                              52.0f)];
    [_items addObject:item];
}

@end
