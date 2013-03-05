//
//  SADropdownItem.m
//  Shrub
//
//  Created by Andrew Carter on 3/4/13.
//  Copyright (c) 2013 Pinch Studios. All rights reserved.
//

#import "SADropdownItem.h"

#import "UIColor+SAHelpers.h"

@implementation SADropdownItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor SADarkGreyColor]];
        [[self titleLabel] setTextColor:[UIColor SALightGreyColor]];
        [[self titleLabel] setShadowColor:[UIColor blackColor]];
        [[self titleLabel] setShadowOffset:CGSizeMake(0.0f, 1.0f)];
        [self setBackgroundImage:[UIImage imageNamed:@"dropdown_item_bg"] forState:UIControlStateNormal];
    }
    return self;
}

@end
