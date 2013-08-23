/*
 * UIViewController+GVCUIKit.h
 * 
 * Created by David Aspinall on 11-10-02. 
 * Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>

@class GVCStackedViewController;
@class GVCSlideViewController;

@protocol UITableViewDynamicContentController
// passes array of index paths.
- (void)loadDynamicContentForIndexPaths:(NSArray *)pathArray;
@end

@interface UIViewController (GVCUIKit)

// The nearest parent in the view controller hierarchy that is a slide view controller.
@property (nonatomic, weak, readonly) GVCSlideViewController *gvc_slideViewController;

// The nearest parent in the view controller hierarchy that is a stack view controller.
@property (nonatomic, weak, readonly) GVCStackedViewController *gvc_stackedViewController;

@end
