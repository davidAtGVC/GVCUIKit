/*
 * UITextView+GVCUIKit.h
 * 
 * Created by David Aspinall on 12-06-27. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>

@interface UITextView (GVCUIKit)

/**
 * Returns the rect of the currently selected text.  If the text line wraps then it returns the union of all selected text.  Tries to place the rect in the centre of the selection for popup or menu display
 */
- (CGRect)gvc_rectForSelectedText;

@end
