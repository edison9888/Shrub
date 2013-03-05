//
//  SADropdownView.h
//  Shrub
//
//  Created by Andrew Carter on 3/4/13.
//  Copyright (c) 2013 Pinch Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT CGFloat SADropdownViewTopPadding;

@class SADropdownItem;

@interface SADropdownView : UIView

- (void)removeAllItems;
- (void)addItem:(SADropdownItem *)item;

@end
