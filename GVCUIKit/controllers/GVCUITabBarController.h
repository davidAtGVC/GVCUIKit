/*
 * GVCUITabViewController.h
 * 
 * Created by David Aspinall on 12-05-08. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "GVCUIProtocols.h"

@interface GVCUITabBarController : UITabBarController <GVCViewTitleProtocol>

- (IBAction)dismissModalViewController:(id)sender;

@end
