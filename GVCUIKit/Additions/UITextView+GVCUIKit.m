/*
 * UITextView+GVCUIKit.m
 * 
 * Created by David Aspinall on 12-06-27. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "UITextView+GVCUIKit.h"

@implementation UITextView (GVCUIKit)

- (CGRect)gvc_rectForSelectedText
{
	UITextRange *selectionRange = [self selectedTextRange];
	NSArray *selectionRects = [self selectionRectsForRange:selectionRange];
	CGRect completeRect = CGRectNull;
	for (UITextSelectionRect *selectionRect in selectionRects)
	{
		if (CGRectIsNull(completeRect) == YES)
		{
			completeRect = selectionRect.rect;
		}
		else
		{
			completeRect = CGRectUnion(completeRect,selectionRect.rect);
		}
	}
	return completeRect;
}

@end
