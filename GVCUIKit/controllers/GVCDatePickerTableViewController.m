//
//  GVCDatePickerTable.m
//
//  Created by David Aspinall on 11-02-08.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import "GVCDatePickerTableViewController.h"
#import <GVCFoundation/GVCFoundation.h>
#import "UITableViewCell+GVCUIKit.h"
#import "GVCUITableViewCell.h"

@implementation GVCDatePickerTableViewController

- (IBAction)dateChanged:sender
{
	[self setCurrentDate:[[self datePicker] date]];
	if ( [self callbackDelegate] != nil )
	{
		[[self callbackDelegate] setValue:[self currentDate] forKey:[self labelKey]];
	}
    [[self gvcTableView] reloadData];
}

- (void)loadView
{
    [super loadView];
    
    [self setView:[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
	
    UITableView *theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 35.0, 320.0, 150.0) style:UITableViewStyleGrouped];
    theTableView.delegate = self;
    theTableView.dataSource = self;
    [[self view] addSubview:theTableView];
	[self setGvcTableView:theTableView];
	
    UIDatePicker *theDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 200.0, 0.0, 0.0)];
    [theDatePicker setDatePickerMode:UIDatePickerModeDate];
    [self setDatePicker:theDatePicker];
	
    [[self datePicker] addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    [[self view] addSubview:[self datePicker]];
	[[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (void)viewWillAppear:(BOOL)animated 
{
    if ([self currentDate] != nil)
        [[self datePicker] setDate:[self currentDate] animated:YES];
    else 
        [[self datePicker] setDate:[NSDate date] animated:YES];
	
	[[self datePicker] sizeToFit];
	[[self datePicker] setMinimumDate:[self minimumDate]];
	[[self datePicker] setMaximumDate:[self maximumDate]];

    [[self gvcTableView] reloadData];
	[self setHidesBottomBarWhenPushed:YES];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

#pragma mark - Table View Methods
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;	
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath  
{
	static NSString *DateCellIdentifier = @"DateCellIdentifier";
	
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:DateCellIdentifier forIndexPath:indexPath];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:DateCellIdentifier];
	}

    [[cell textLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    [[cell textLabel] setNumberOfLines:0];
    [[cell detailTextLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    [[cell detailTextLabel] setNumberOfLines:0];
	
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
	[[cell textLabel] setText:GVC_LocalizedString([self labelKey], [self labelKey])];
	[[cell detailTextLabel] setText:[formatter stringFromDate:[[self datePicker] date]]];
    
    return cell;
}

#pragma mark - GVCTableViewDataSourceProtocol

- (NSArray *)tableView:(UITableView *)tableView rowsForSection:(NSUInteger)section
{
	return ([[self datePicker] date] != nil ? @[[[self datePicker] date]] : [NSArray array]);
}

- (id)tableView:(UITableView*)tableView objectForRowAtIndexPath:(NSIndexPath*)indexPath
{
	return [[self datePicker] date];
}

- (NSIndexPath*)tableView:(UITableView*)tableView indexPathForObject:(id)object
{
	return (object != nil ? [NSIndexPath indexPathForItem:1 inSection:1] : nil);
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object
{
	return [GVCUITableViewCell class];
}


@end

