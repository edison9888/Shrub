//
//  SADropdownView.m
//  Shrub
//
//  Created by Andrew Carter on 3/4/13.
//  Copyright (c) 2013 Pinch Studios. All rights reserved.
//

#import "SADropdownView.h"

#import "SADropdownItem.h"

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
                              [_items count] ? CGRectGetMaxY([[_items lastObject] bounds]) : SADropdownViewTopPadding,
                              CGRectGetWidth([self bounds]),
                              44.0f)];
    [_items addObject:item];
}

@end
