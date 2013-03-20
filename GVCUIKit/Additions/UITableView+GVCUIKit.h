/*
 * UITableView+GVCUIKit.h
 * 
 * Created by David Aspinall on 12-06-29. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>

@interface UITableView (GVCUIKit)

- (void)gvc_scrollToTop:(BOOL)animated;
- (void)gvc_scrollToBottom:(BOOL)animated;

/**
 * Calculates the default table cell margin based on the table style
 * @returns cell margin as a CGFloat
 */
- (CGFloat)gvc_tableCellMargin;

@end
