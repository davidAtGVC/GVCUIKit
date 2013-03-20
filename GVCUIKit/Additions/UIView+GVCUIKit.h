/*
 * UIView+GVCUIKit.h
 * 
 * Created by David Aspinall on 11-10-02. 
 * Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface UIView (GVCUIKit)

+ (CGPoint)gvc_SharpenPoint:(CGPoint)point;
+ (CGSize)gvc_SharpenSize:(CGSize)size;
+ (CGRect)gvc_SharpenRect:(CGRect)rect;

- (CGRect)gvc_rectForString:(NSString *)contents atOrigin:(CGPoint)origin constrainedToSize:(CGSize)constrainedSize forFont:(UIFont *)font;

- (void)gvc_addRoundRectangleToContext:(CGContextRef)context inRect:(CGRect)rect withRadius:(CGFloat)radius;
- (void)gvc_drawRoundRectangleInRect:(CGRect)rect withRadius:(CGFloat)radius color:(UIColor*)color;
- (void)gvc_drawRoundRectangleInRect:(CGRect)rect withRadius:(CGFloat)rad borderWidth:(CGFloat)thickness color:(UIColor*)color borderColor:(UIColor*)border;

/**
 * Adjust the cell width.  This is a convenience for view.frame.size.width
 * @returns frame width
 */
- (CGFloat)gvc_frameWidth;

/**
 * Adjust the cell width.  This is a convenience for view.frame.size.width
 * @param width to change the frame
 */
- (void)gvc_setFrameWidth:(CGFloat)width;

/**
 * Adjust the cell width.  This is a convenience for view.frame.size.width
 * @returns frame height
 */
- (CGFloat)gvc_frameHeight;

/**
 * Adjust the cell width.  This is a convenience for view.frame.size.width
 * @param height to change the frame
 */
- (void)gvc_setFrameHeight:(CGFloat)height;

@end
