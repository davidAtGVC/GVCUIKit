/*
 * GVCColumnContainerView.h
 * 
 * Created by David Aspinall on 12-07-06. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>

@class GVCSizedColumn;

@interface GVCColumnContainerView : UIView

- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame forUILabelSizes:(NSArray *)set;

- (void)removeAll;

- (void)addSizedColumn:(GVCSizedColumn *)part;
- (void)addView:(UIView *)view atIndex:(NSUInteger)idx forSize:(CGFloat)percent;
- (void)addUILabel:(NSUInteger)idx forSize:(CGFloat)percent;

- (NSUInteger)viewCount;
- (GVCSizedColumn *)columnAtIndex:(NSUInteger)idx;
- (UIView *)viewAtIndex:(NSUInteger)index;

@end
