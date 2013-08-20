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
