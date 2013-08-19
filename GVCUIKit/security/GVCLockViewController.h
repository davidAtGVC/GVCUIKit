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

typedef enum { 
    GVCLockViewControllerMode_SET = 0, 
    GVCLockViewControllerMode_CHANGE, 
    GVCLockViewControllerMode_REMOVE,
    GVCLockViewControllerMode_UNLOCK
} GVCLockViewControllerMode;

@interface GVCLockViewController : GVCUIViewController

- (id)initForMode:(GVCLockViewControllerMode)mode nibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

@property (copy, nonatomic) GVCLockViewBlock successBlock;
@property (copy, nonatomic) GVCLockViewBlock failBlock;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) NSError *lastError;
@property (assign, nonatomic) GVCLockViewControllerMode lockMode;

- (IBAction)loginAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
- (IBAction)removeLockAction:(id)sender;

@end
