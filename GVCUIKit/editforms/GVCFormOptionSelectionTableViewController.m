//
//  GVCFormOptionSelectionTableViewController.m
//  GVCCaseManagement
//
//  Created by David Aspinall on 12-06-27.
//  Copyright (c) 2012 Global Village Consulting. All rights reserved.
//

#import "GVCFormOptionSelectionTableViewController.h"
#import "UITableViewCell+GVCUIKit.h"

@interface GVCFormOptionSelectionTableViewController ()

@end

@implementation GVCFormOptionSelectionTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self != nil)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


#pragma mark - UDF
- (id <GVCFormQuestion>)question
{
    return [[self formValue] submittedQuestion];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    return [[self question] prompt];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self question] choiceArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *FormOptionIdentifier = @"FormOptionIdentifier";
	
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:FormOptionIdentifier];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:FormOptionIdentifier];
	}

    NSArray *options = [[self question] choiceArray];
    id <GVCFormQuestionChoice>opt = [options objectAtIndex:[indexPath row]];

    [[cell detailTextLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    [[cell detailTextLabel] setText:[opt prompt]];
    [cell setAccessoryType:UITableViewCellAccessoryNone];

    if ( [[self formValue] isChoiceSelected:opt] == YES )
    {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *options = [[self question] choiceArray];
    id <GVCFormQuestionChoice>opt = [options objectAtIndex:[indexPath row]];

    if ( [[self question] entryType] == GVCFormQuestion_Type_CHOICE )
    {
        // single selection, if the same value is selected, do nothing
        if ( [[self formValue] isChoiceSelected:opt] == NO )
        {
            [[self formValue] selectQuestionChoice:opt];

			id strongDelegate = [self callbackDelegate];
            if ((strongDelegate != nil) && ([strongDelegate conformsToProtocol:@protocol(GVCDismissPopoverProtocol)] == YES ))
            {
                [(id <GVCDismissPopoverProtocol>)strongDelegate dismissPopover:nil];
            }
        }
    }
    else
    {
        if ( [[self formValue] isChoiceSelected:opt] == NO )
        {
            [[self formValue] selectQuestionChoice:opt];
        }
        else
        {
            [[self formValue] deselectQuestionChoice:opt];
        }
        [self reload:nil];
		id strongDelegate = [self callbackDelegate];
		if (strongDelegate != nil)
		{
			[strongDelegate reload:nil];
		}
    }
}

@end
