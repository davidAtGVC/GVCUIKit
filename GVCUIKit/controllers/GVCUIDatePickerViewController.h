//
//  GVCUIDatePickerViewController.h
//  GVCImmunization
//
//  Created by David Aspinall on 11-02-08.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GVCUIViewController.h"

@interface GVCUIDatePickerViewController : GVCUIViewController 

- (id) initWithMode:(UIDatePickerMode) m;

@property (assign)	UIDatePickerMode mode;
@property (strong, nonatomic) UIDatePicker *datePicker;

@property (strong, nonatomic) NSDate *minimumDate;
@property (strong, nonatomic) NSDate *maximumDate;

- (IBAction)dateChanged:sender;

@end
