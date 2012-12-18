/*
 * UILabel+GVCUIKit.m
 * 
 * Created by David Aspinall on 12-06-26. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "UILabel+GVCUIKit.h"
#import <GVCFoundation/GVCFoundation.h>

@implementation UILabel (GVCUIKit)

- (CGFloat)gvc_heightForCell
{
	return [self gvc_heightForText];
}

- (CGFloat)gvc_heightForText
{
    CGFloat height = 0.0;
	if (gvc_IsEmpty([self text]) == NO)
	{
		CGFloat frameWidth = [self frame].size.width;
		CGSize sizeFor1Line = [[self text] sizeWithFont:[self font] constrainedToSize:CGSizeMake(frameWidth, 1) lineBreakMode:[self lineBreakMode]];
		CGSize size = [[self text] sizeWithFont:[self font] constrainedToSize:CGSizeMake(frameWidth, sizeFor1Line.height * self.numberOfLines) lineBreakMode:[self lineBreakMode]];
		height = size.height;
	}
    return height;
}


- (void)gvc_setTextAttributes:(NSDictionary *)attributes
{
    UIFont *font = [attributes objectForKey:UITextAttributeFont];
    if (font != nil)
	{
        [self setFont:font];
    }
	
    UIColor *textColor = [attributes objectForKey:UITextAttributeTextColor];
    if (textColor != nil)
	{
        [self setTextColor:textColor];
    }
	
    UIColor *textShadowColor = [attributes objectForKey:UITextAttributeTextShadowColor];
    if (textShadowColor != nil)
	{
		[self setShadowColor:textShadowColor];
    }
	
    NSValue *shadowOffsetValue = [attributes objectForKey:UITextAttributeTextShadowOffset];
    if (shadowOffsetValue != nil)
	{
        UIOffset shadowOffset = [shadowOffsetValue UIOffsetValue];
		[self setShadowOffset:CGSizeMake(shadowOffset.horizontal, shadowOffset.vertical)];
    }
}

@end
