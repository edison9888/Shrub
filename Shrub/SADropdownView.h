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
@class SADropdownView;

@protocol SADropdownViewDelegate <NSObject>

- (void)dropdownView:(SADropdownView *)dropdownView itemSelectedAtIndex:(NSUInteger)index;

@end

@interface SADropdownView : UIView

@property (nonatomic, weak) id <SADropdownViewDelegate> delegate;

- (void)removeAllItems;
- (void)addItem:(SADropdownItem *)item;

@end