/*
 * UILabel+GVCUIKit.h
 * 
 * Created by David Aspinall on 12-06-26. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>

@interface UILabel (GVCUIKit)

/** UI Appearance method 
 */
- (void)gvc_setTextAttributes:(NSDictionary *)attributes UI_APPEARANCE_SELECTOR;

@end
