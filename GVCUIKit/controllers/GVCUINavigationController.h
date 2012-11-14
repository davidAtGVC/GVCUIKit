/*
 * GVCUINavigationController.h
 * 
 * Created by David Aspinall on 12-05-08. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */


#import <UIKit/UIKit.h>
#import "GVCUIProtocols.h"

@protocol GVCUIModalViewControllerModalDismiss <UINavigationControllerDelegate>
@optional
- (void)willDismissModalController;
@end

@interface GVCUINavigationController : UINavigationController <GVCViewTitleProtocol>

- (IBAction)dismissModalViewController:(id)sender;

/** Passes this message to the current top view controller, if it is a GVCUIViewController */
- (NSString *)viewTitleKey;

@end
