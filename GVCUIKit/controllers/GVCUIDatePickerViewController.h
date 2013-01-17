//
//  GVCUIDatePickerViewController.h
//  GVCImmunization
//
//  Created by David Aspinall on 11-02-08.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GVCUIViewController.h"

@protocol GVCUIDatePickerCallbackProtocol <NSObject>
@optional
- (void)setDate:(NSDate *)current forKey:(NSString *)callbackKey;
@end

/**
 * Alternate method to update values using blocks instead of delgates
 */
typedef void (^GVCUIDatePickerBlock)(NSDate *selectedDate);


@interface GVCUIDatePickerViewController : GVCUIViewController 

- (id) initWithMode:(UIDatePickerMode) m;

@property (assign)	UIDatePickerMode mode;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (strong, nonatomic) NSDate *minimumDate;
@property (strong, nonatomic) NSDate *maximumDate;
@property (strong, nonatomic) NSDate *currentDate;

@property (strong, nonatomic) NSString *callbackKey;

@property (readwrite, copy) GVCUIDatePickerBlock dateChangeBlock;

- (IBAction)dateChanged:sender;

@end
