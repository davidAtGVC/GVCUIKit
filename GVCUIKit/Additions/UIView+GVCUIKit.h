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

- (void)gvc_addRoundRectangleToContext:(CGContextRef)context inRect:(CGRect)rect withRadius:(CGFloat)radius;
- (void)gvc_drawRoundRectangleInRect:(CGRect)rect withRadius:(CGFloat)radius color:(UIColor*)color;
- (void)gvc_drawRoundRectangleInRect:(CGRect)rect withRadius:(CGFloat)rad borderWidth:(CGFloat)thickness color:(UIColor*)color borderColor:(UIColor*)border;

/**
 * draws a simple shadow under the view
 */
- (void)gvc_showLeftShadow:(BOOL)showing withOpacity:(float)opaque;
- (void)gvc_showRightShadow:(BOOL)showing withOpacity:(float)opaque;

/**
 * This is a convenience for view.frame.size
 * @returns frame size
 */
@property (nonatomic) CGSize gvc_frameSize;

/**
 * This is a convenience for view.frame.origin
 * @returns frame origin
 */
@property (nonatomic) CGPoint gvc_frameOrigin;

/**
 * This is a convenience for view.frame.origin.x
 * @returns frame origin x
 */
@property (nonatomic) CGFloat gvc_frameX;

/**
 * This is a convenience for view.frame.origin.y
 * @returns frame origin y
 */
@property (nonatomic) CGFloat gvc_frameY;

/**
 * Adjust the view width.  This is a convenience for view.frame.size.width
 * @returns frame width
 */
@property (nonatomic) CGFloat gvc_frameWidth;

/**
 * Adjust the view width.  This is a convenience for view.frame.size.width
 * @returns frame height
 */
@property (nonatomic) CGFloat gvc_frameHeight;

@end
