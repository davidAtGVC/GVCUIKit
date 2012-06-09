//
//  GVCUIDatePickerViewController.m
//  GVCImmunization
//
//  Created by David Aspinall on 11-02-08.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import "GVCUIDatePickerViewController.h"
#import "GVCFoundation.h"

@implementation GVCUIDatePickerViewController

@synthesize datePicker;
@synthesize mode;
@synthesize minimumDate;
@synthesize maximumDate;

- (id) initWithMode:(UIDatePickerMode) m
{
	self = [super init];
	if (self != nil) 
	{
		[self setMode:m];
	}
	return self;
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[datePicker setDatePickerMode:mode];
	[datePicker setMinimumDate:[self minimumDate]];
	[datePicker setMaximumDate:[self maximumDate]];
}

- (IBAction)dateChanged:sender
{
	if ( [self callbackDelegate] != nil )
	{
		[[self callbackDelegate] setValue:[datePicker date] forKey:@"dateOfBirth"];//[self labelKey]];
	}
}

@end
