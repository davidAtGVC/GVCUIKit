/*
 * GVCLockViewController.h
 * 
 * Created by David Aspinall on 12-06-22. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "GVCUIViewController.h"

typedef void (^GVCLockViewBlock)(NSError *err);

@interface GVCLockViewController : GVCUIViewController

@property (readwrite, copy) GVCLockViewBlock successBlock;
@property (readwrite, copy) GVCLockViewBlock failBlock;

@property (nonatomic, strong) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) NSError *lastError;

- (IBAction)loginAction:(id)sender;
- (IBAction)cancelAction:(id)sender;

@end
