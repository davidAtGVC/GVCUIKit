/*
 * UIViewController+GVCUIKit.h
 * 
 * Created by David Aspinall on 11-10-02. 
 * Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
 *
 */

#import "UIViewController+GVCUIKit.h"

#import "GVCStackedViewController.h"
#import "GVCSlideViewController.h"

/**
 * 
 */
@implementation UIViewController (GVCUIKit)

- (void)gvc_scrollViewDidEndDecelerating:(UIScrollView *)scrollView 
{
	if ( [self conformsToProtocol:@protocol(UITableViewDynamicContentController)] == YES )
	{
		UIViewController <UITableViewDynamicContentController> *target = (UIViewController <UITableViewDynamicContentController> *)self;
		if ([scrollView isKindOfClass:[UITableView class]])
			[target loadDynamicContentForIndexPaths: [(UITableView *)scrollView indexPathsForVisibleRows]];
	}
}

- (void)gvc_scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate 
{
	if ( [self conformsToProtocol:@protocol(UITableViewDynamicContentController)] == YES )
	{
		UIViewController <UITableViewDynamicContentController> *target = (UIViewController <UITableViewDynamicContentController> *)self;
		if ([scrollView isKindOfClass:[UITableView class]] && (decelerate == NO)) 
		{
			[target loadDynamicContentForIndexPaths: [(UITableView *)scrollView indexPathsForVisibleRows]];
		}
	}
}

- (GVCSlideViewController *)gvc_slideViewController
{
	GVCSlideViewController *slideContainer = nil;
	
	if ( [self isKindOfClass:[GVCSlideViewController class]] == YES)
	{
		slideContainer = (GVCSlideViewController *)self;
	}
	else
	{
		UIViewController *parent = [self parentViewController];
		if ((parent != nil) && (parent != [parent parentViewController]))
		{
			slideContainer = [parent gvc_slideViewController];
		}
	}
	
    return slideContainer;
}

- (GVCStackedViewController *)gvc_stackedViewController
{
	GVCStackedViewController *stackContainer = nil;
	
	if ( [self isKindOfClass:[GVCStackedViewController class]] == YES)
	{
		stackContainer = (GVCStackedViewController *)self;
	}
	else
	{
		UIViewController *parent = [self parentViewController];
		if ((parent != nil) && (parent != [parent parentViewController]))
		{
			stackContainer = [parent gvc_stackedViewController];
		}
	}
	
    return stackContainer;
}



@end
