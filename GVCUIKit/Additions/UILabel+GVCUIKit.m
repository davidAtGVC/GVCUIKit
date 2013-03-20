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

+ (CGFloat)gvc_heightForText:(NSString *)text width:(CGFloat)width forFont:(UIFont *)font
{
	return [self gvc_heightForText:text width:width forFont:font andLinebreak:NSLineBreakByWordWrapping];
}

+ (CGFloat)gvc_heightForText:(NSString *)text width:(CGFloat)width forFont:(UIFont *)font andLinebreak:(NSLineBreakMode)mode
{
	if (text == nil)
		GVC_ASSERT_NOT_NIL(text);
	GVC_ASSERT_NOT_NIL(font);

	if ( width <= 0.0 )
		width = 9999;

	CGSize maximumSize = CGSizeMake(width, 9999);
	CGSize dynamicSize = [text sizeWithFont:font constrainedToSize:maximumSize lineBreakMode:mode];
	return dynamicSize.height;
}

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
		height = [UILabel gvc_heightForText:[self text] width:frameWidth forFont:[self font] andLinebreak:[self lineBreakMode]];
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
