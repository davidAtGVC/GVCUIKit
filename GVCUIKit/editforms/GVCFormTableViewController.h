/*
 * UDDetailTableViewController.h
 * 
 * Created by David Aspinall on 12-06-26. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import <GVCFoundation/GVCFoundation.h>
#import "GVCUIViewWithTableController.h"
#import "GVCUIDatePickerViewController.h"
#import "GVCFormEntryProtocols.h"
#import "GVCUIProtocols.h"

@interface GVCFormTableViewController : GVCUIViewWithTableController  <GVCUIDatePickerCallbackProtocol, GVCDismissPopoverProtocol>

/** convenience method for formSubmission.form */
- (id <GVCForm>)form;

@property (strong, nonatomic) id <GVCFormSubmission> formSubmission;

- (IBAction)saveAction:(id)sender;
- (IBAction)cancelAction:(id)sender;

@property (strong, nonatomic) UIPopoverController *popover;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@end
