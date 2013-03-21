/*
 * UILabel+GVCUIKit.h
 * 
 * Created by David Aspinall on 12-06-26. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>

@interface UILabel (GVCUIKit)

/**
 * Calculate the height required to display the specific parameters
 * @param text the content to display
 * @param width the expected width of the display frame
 * @param font, the font to base the height calculation upon
 * @returns height required for display
 */
+ (CGFloat)gvc_heightForText:(NSString *)text width:(CGFloat)width forFont:(UIFont *)font;

/**
 * Calculate the height required to display the specific parameters
 * @param text the content to display
 * @param width the expected width of the display frame
 * @param font, the font to base the height calculation upon
 * @param mode the linebreak mode
 * @returns height required for display
 */
+ (CGFloat)gvc_heightForText:(NSString *)text width:(CGFloat)width forFont:(UIFont *)font andLinebreak:(NSLineBreakMode)mode;

- (CGFloat)gvc_heightForText;

/** UI Appearance method 
 */
- (void)gvc_setTextAttributes:(NSDictionary *)attributes UI_APPEARANCE_SELECTOR;

@end
