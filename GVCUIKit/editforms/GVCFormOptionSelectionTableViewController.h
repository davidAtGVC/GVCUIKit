//
//  GVCFormOptionSelectionTableViewController.h
//
//  Created by David Aspinall on 12-06-27.
//  Copyright (c) 2012 Global Village Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GVCFoundation/GVCFoundation.h>
#import "GVCUITableViewController.h"
#import "GVCFormEntryProtocols.h"
#import "GVCUIProtocols.h"

@interface GVCFormOptionSelectionTableViewController : GVCUITableViewController

@property (strong, nonatomic) id <GVCFormSubmissionValue> formValue;

@end
