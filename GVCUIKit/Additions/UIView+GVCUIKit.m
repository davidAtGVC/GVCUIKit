/*
 * UIView+GVCUIKit.h
 * 
 * Created by David Aspinall on 11-10-02. 
 * Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
 *
 */

#import "UIView+GVCUIKit.h"
#import <QuartzCore/QuartzCore.h>
#import <GVCFoundation/GVCFoundation.h>

@implementation UIView (GVCUIKit)


+ (CGPoint)gvc_SharpenPoint:(CGPoint)point
{
    return CGPointMake(floorf(point.x), floorf(point.y));
}

+ (CGSize)gvc_SharpenSize:(CGSize)size
{
    return CGSizeMake(floorf(size.width), floorf(size.height));
}

+ (CGRect)gvc_SharpenRect:(CGRect)rect
{
    return CGRectMake(floorf(rect.origin.x), floorf(rect.origin.y), floorf(rect.size.width), floorf(rect.size.height));
}

- (void)gvc_addRoundRectangleToContext:(CGContextRef)context inRect:(CGRect)rect withRadius:(CGFloat)radius
{
	CGRect rrect = [UIView gvc_SharpenRect:rect];
	
	CGFloat minx = floorf(CGRectGetMinX(rrect)), midx = floorf(CGRectGetMidX(rrect)), maxx = floorf(CGRectGetMaxX(rrect));
	CGFloat miny = floorf(CGRectGetMinY(rrect)), midy = floorf(CGRectGetMidY(rrect)), maxy = floorf(CGRectGetMaxY(rrect));
	
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
}


- (void)gvc_drawRoundRectangleInRect:(CGRect)rect withRadius:(CGFloat)radius color:(UIColor*)color
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	[color set];
    [self gvc_addRoundRectangleToContext:context inRect:rect withRadius:radius];
	CGContextDrawPath(context, kCGPathFill);
}

- (void)gvc_drawRoundRectangleInRect:(CGRect)rect withRadius:(CGFloat)rad borderWidth:(CGFloat)thickness color:(UIColor*)color borderColor:(UIColor*)border
{
	if ( color == nil )
		color = [UIColor darkGrayColor];
		
	if ( border == nil )
		border = [UIColor whiteColor];

	CGContextRef context = UIGraphicsGetCurrentContext();
	CGRect rrect = [UIView gvc_SharpenRect:CGRectInset(rect, thickness/2, thickness/2)];

	// fill
    [color set];
    [self gvc_addRoundRectangleToContext:context inRect:rrect withRadius:rad];
	CGContextDrawPath(context, kCGPathFill);
    
    // border
    [self gvc_addRoundRectangleToContext:context inRect:rrect withRadius:rad];
	CGContextSetStrokeColorWithColor(context, [border CGColor]);
	CGContextSetLineWidth(context, thickness);
	CGContextDrawPath(context, kCGPathStroke);
}

- (void)gvc_showLeftShadow:(BOOL)showing withOpacity:(float)opaque
{
	CALayer  *layer = [self layer];
	layer.shadowOpacity = (showing == YES ? opaque : 0.0f);
	
	if (showing == YES)
	{
		layer.shadowColor = [UIColor blackColor].CGColor;
		layer.cornerRadius = 4.0f;
		layer.shadowRadius = 4.0f;
		layer.masksToBounds = NO;
		layer.shadowPath = [UIBezierPath bezierPathWithRect:layer.bounds].CGPath;
	}
}

- (void)gvc_showRightShadow:(BOOL)showing withOpacity:(float)opaque
{
	CALayer  *layer = [self layer];
	layer.shadowOpacity = (showing == YES ? opaque : 0.0f);
	
	if (showing == YES)
	{
		layer.shadowColor = [UIColor blackColor].CGColor;
		layer.cornerRadius = 4.0f;
		layer.shadowRadius = 4.0f;
		layer.masksToBounds = NO;
		layer.shadowPath = [UIBezierPath bezierPathWithRect:layer.bounds].CGPath;
	}
}

#pragma mark - Frame 
- (CGSize)gvc_frameSize
{
	return [self frame].size;
}

- (void)setGvc_frameSize:(CGSize)size
{
	CGPoint origin = [self frame].origin;
	[self setFrame:CGRectMake(origin.x, origin.y, size.width, size.height)];
}

- (CGPoint)gvc_frameOrigin
{
	return [self frame].origin;
}

- (void)setGvc_frameOrigin:(CGPoint)point
{
	CGSize size = [self frame].size;
	[self setFrame:CGRectMake(point.x, point.y, size.width, size.height)];
}

- (CGFloat)gvc_frameX
{
	return [self frame].origin.x;
}

- (void)setGvc_frameX:(CGFloat)x
{
	CGRect frame = [self frame];
	frame.origin.x = x;
	[self setFrame:frame];
}

- (CGFloat)gvc_frameY
{
	return [self frame].origin.y;
}

- (void)setGvc_frameY:(CGFloat)y
{
	CGRect frame = [self frame];
	frame.origin.y = y;
	[self setFrame:frame];
}


- (CGFloat)gvc_frameWidth
{
	return [self frame].size.width;
}

- (void)setGvc_frameWidth:(CGFloat)width
{
	CGRect frame = [self frame];
	frame.size.width = width;
	[self setFrame:frame];
}

- (CGFloat)gvc_frameHeight
{
	return [self frame].size.height;
}

- (void)setGvc_frameHeight:(CGFloat)height
{
	CGRect frame = [self frame];
	frame.size.height = height;
	[self setFrame:frame];
}

@end
