/*
 * UIView+GVCUIKit.h
 * 
 * Created by David Aspinall on 11-10-02. 
 * Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
 *
 */

#import "UIView+GVCUIKit.h"
#import "GVCFoundation.h"

@implementation UIView (GVCUIKit)


- (CGRect)gvc_rectForString:(NSString *)contents atOrigin:(CGPoint)origin constrainedToSize:(CGSize)constrainedSize forFont:(UIFont *)font
{
	GVC_ASSERT( (origin.x >= 0.0) && (origin.y >= 0.0), @"Origin point is invalid" );
	GVC_ASSERT( font != nil, @"Unable to calculate string size without a valid font" );
	
	CGFloat x = origin.x;
	CGFloat y = origin.y;
	CGFloat width = 0.0;
	CGFloat height = 0.0;
	
	if ( gvc_IsEmpty(contents) == NO)
	{
		CGSize textSize = [contents sizeWithFont:font constrainedToSize:constrainedSize lineBreakMode:UILineBreakModeWordWrap];
		width = textSize.width;
		height = textSize.height + 2.0;			
	}
	return CGRectMake(x, y, width, height);
}

- (void)gvc_drawRoundRectangleInRect:(CGRect)rect withRadius:(CGFloat)radius color:(UIColor*)color
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	[color set];
	
	CGRect rrect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height );
	
	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFill);
}

- (void)gvc_drawRoundRectangleInRect:(CGRect)rect withRadius:(CGFloat)rad borderWidth:(CGFloat)thickness color:(UIColor*)color borderColor:(UIColor*)border
{
	if ( color == nil )
		color = [UIColor darkGrayColor];
		
	if ( border == nil )
		border = [UIColor whiteColor];
	
	CGRect rrect = CGRectInset(rect, thickness/2, thickness/2);
	[self gvc_drawRoundRectangleInRect:rrect withRadius:rad color:color];

	CGFloat radius = rad;
	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
//	CGContextSetFillColorWithColor( context, [color CGColor] );
//	CGContextDrawPath(context, kCGPathFill);

	CGContextSetStrokeColorWithColor(context, [border CGColor]);
	CGContextSetLineWidth(context, thickness);
	CGContextDrawPath(context, kCGPathStroke);
}

@end
