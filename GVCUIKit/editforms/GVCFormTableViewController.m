/*
 * GVCFormTableViewController.m
 * 
 * Created by David Aspinall on 12-06-26. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCFormTableViewController.h"
#import "GVCFormOptionSelectionTableViewController.h"
#import "GVCEditCell.h"
#import "GVCEditDateCell.h"
#import "GVCEditTextFieldCell.h"
#import "GVCEditTextViewCell.h"

#import "UITableViewCell+GVCUIKit.h"

@interface GVCFormTableViewController ()

@end

@implementation GVCFormTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) 
    {
		[self setShowDefaultFormButtons:YES];
    }
    return self;
}

- (NSString *)viewTitle
{
	return [[self form] name];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (UIBarButtonItem *)defaultSaveButton
{
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:GVC_SAVE_LABEL style:UIBarButtonItemStyleBordered target:self action:@selector(saveAction:)];
	[saveButton setStyle:UIBarButtonItemStyleDone];
	return saveButton;
}

- (UIBarButtonItem *)defaultCancelButton
{
	UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:GVC_CANCEL_LABEL style:UIBarButtonItemStyleBordered target:self action:@selector(cancelAction:)];
	return button;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self setAutoresizesForKeyboard:YES];
    [super viewWillAppear:animated];
	
	if (([self showDefaultFormButtons] == YES) && ([self navigationController] != nil))
	{
		UIBarButtonItem *saveButton = [self defaultSaveButton];
		if ( saveButton != nil )
		{
			[[self navigationItem] setRightBarButtonItem:saveButton];
		}
		
		UIBarButtonItem *cancelButton = [self defaultCancelButton];
		if ( cancelButton != nil )
		{
			[[self navigationItem] setLeftBarButtonItem:cancelButton];
		}
	}
}

- (IBAction)saveAction:(id)sender 
{
}

- (IBAction)cancelAction:(id)sender
{
}

#pragma mark - form protocol
- (id <GVCForm>)form
{
	GVC_DBC_REQUIRE(
					GVC_DBC_FACT_NOT_NIL([self formSubmission]);
					)
	
	id <GVCForm> theForm = [[self formSubmission] submittedForm];
	// implementation
	
	GVC_DBC_ENSURE(
				   GVC_DBC_FACT_NOT_NIL(theForm);
				   )

	return theForm;
}

- (NSArray *)sections
{
    return [[self form] sectionArray];
}

- (id <GVCFormQuestion>)questionAtIndexPath:(NSIndexPath *)indexPath
{
    id <GVCFormSection> sect = [[self sections] objectAtIndex:[indexPath section]];
    NSArray *questionArray = [self entriesPassingConditionsSection:sect];
    return [questionArray objectAtIndex:[indexPath row]];
}

- (NSArray *)entriesPassingConditionsSection:(id <GVCFormSection>)sect
{
    return [sect entriesPassingAllConditions:[self formSubmission]];
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv 
{
    return [[self sections] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    id <GVCFormSection> sect = [[self sections] objectAtIndex:section];
    return [sect sectionTitle];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section 
{
    id <GVCFormSection> sect = [[self sections] objectAtIndex:section];
    return [[self entriesPassingConditionsSection:sect] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell *cell = nil;
    
    id <GVCFormQuestion>question = [self questionAtIndexPath:indexPath];
    id <GVCFormSubmissionValue>value = [[self formSubmission] valueForQuestion:question];
    if (question != nil )
    {
		switch ([question entryType])
		{
			case GVCFormQuestion_Type_TEXT:
			{
				cell = [GVCEditTextFieldCell gvc_CellWithStyle:UITableViewCellStyleValue2 forTableView:tv];
				
				[[cell textLabel] setText:[question prompt]];
				[[cell textLabel] setNumberOfLines:0];
				[[cell textLabel] setLineBreakMode:NSLineBreakByWordWrapping];
				[[(GVCEditTextFieldCell *)cell textField] setText:[value submittedValue]];
				
				[(GVCUITableViewCell *)cell setDelegate:self];
				[(GVCEditCell *)cell setEditPath:indexPath];

				break;
			}

			case GVCFormQuestion_Type_MULTILINE_TEXT:
			{
				cell = [GVCEditTextViewCell gvc_CellWithStyle:UITableViewCellStyleDefault forTableView:tv];
				[[cell textLabel] setText:[question prompt]];
				[[cell textLabel] setNumberOfLines:0];
				[[cell textLabel] setLineBreakMode:NSLineBreakByWordWrapping];
				
				[[(GVCEditTextViewCell *)cell textView] setText:[value submittedValue]];
				
				[(GVCUITableViewCell *)cell setDelegate:self];
				[(GVCEditCell *)cell setEditPath:indexPath];
				break;
			}
				
			case GVCFormQuestion_Type_CHOICE:
			case GVCFormQuestion_Type_MULTI_CHOICE:
			{
				cell = [GVCUITableViewCell gvc_CellWithStyle:UITableViewCellStyleValue2 forTableView:tv];
				[[cell textLabel] setNumberOfLines:0];
				[[cell textLabel] setLineBreakMode:NSLineBreakByWordWrapping];
				[[cell detailTextLabel] setNumberOfLines:0];
				[[cell detailTextLabel] setLineBreakMode:NSLineBreakByWordWrapping];
				
				[[cell textLabel] setText:[question prompt]];
				if ( gvc_IsEmpty([value submittedValue]) == NO)
				{
					id <GVCFormQuestionChoice>choice = [value submittedValue];
					[[cell detailTextLabel] setText:[choice prompt]];
				}
				break;
			}
				
			case GVCFormQuestion_Type_DATE:
			{
				cell = [GVCEditDateCell gvc_CellWithStyle:UITableViewCellStyleValue2 forTableView:tv];
				[[cell textLabel] setText:[question prompt]];
				[[cell textLabel] setNumberOfLines:0];
				[[cell textLabel] setLineBreakMode:NSLineBreakByWordWrapping];
				
				NSDate *date = [value submittedValue];
				[[cell detailTextLabel] setText:[date gvc_FormattedDate:NSDateFormatterMediumStyle]];
				
				[(GVCUITableViewCell *)cell setDelegate:self];
				[(GVCEditCell *)cell setEditPath:indexPath];
				break;
			}
				
			case GVCFormQuestion_Type_NUMBER:
			{
				cell = [GVCEditTextFieldCell gvc_CellWithStyle:UITableViewCellStyleValue2 forTableView:tv];
				
				[[cell textLabel] setText:[question prompt]];
				[[cell textLabel] setNumberOfLines:1];
				[[(GVCEditTextFieldCell *)cell textField] setText:[value submittedValue]];
				
				[(GVCUITableViewCell *)cell setDelegate:self];
				[(GVCEditCell *)cell setEditPath:indexPath];

				break;
			}
				
			default:
			case GVCFormQuestion_Type_NOTATION:
			{
				cell = [GVCUITableViewCell gvc_CellWithStyle:UITableViewCellStyleDefault forTableView:tv];
				[[cell textLabel] setLineBreakMode:NSLineBreakByWordWrapping];
				[[cell textLabel] setText:[question prompt]];
				break;
			}
		}
    }
    else
    {
        cell = [UITableViewCell gvc_CellForTableView:tv];
		[[cell textLabel] setLineBreakMode:NSLineBreakByWordWrapping];
		[[cell textLabel] setText:[indexPath description]];

    }
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [[self view] endEditing:YES];
    [[self view] resignFirstResponder];

    id <GVCFormQuestion>question = [self questionAtIndexPath:indexPath];
	id <GVCFormSubmissionValue>value = [[self formSubmission] valueForQuestion:question];
    if (question != nil)
    {
        if ( [question entryType] == GVCFormQuestion_Type_DATE )
        {
            if ( [self popover] != nil )
            {
                [[self popover] dismissPopoverAnimated:YES];
            }

            [[self view] endEditing:YES];
            
            GVCUIDatePickerViewController *nextNav = [[GVCUIDatePickerViewController alloc] initWithMode:UIDatePickerModeDate];
            UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:nextNav];
            
            [nextNav setMaximumDate:[NSDate date]];
            [nextNav setCurrentDate:[value submittedValue]];
            [nextNav setCallbackDelegate:self];
            [nextNav setCallbackKey:[question keyword]];
            
            [self setPopover:pop];
            [[self popover] setPopoverContentSize:CGSizeMake(320, 220)];
            
            CGRect cellRect = [tv rectForRowAtIndexPath:indexPath]; 
            CGRect rect = [[tv superview] convertRect:cellRect fromView:tv];
            [[self popover] presentPopoverFromRect:rect inView:[tv superview] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else if (([question entryType] == GVCFormQuestion_Type_CHOICE) || ([question entryType] == GVCFormQuestion_Type_MULTI_CHOICE ))
        {
            if ( [self popover] != nil )
            {
                [[self popover] dismissPopoverAnimated:YES];
            }
            
            [[self view] endEditing:YES];
            
            GVCFormOptionSelectionTableViewController *nextNav = [[GVCFormOptionSelectionTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:nextNav];
            
            [nextNav setFormValue:value];
            [nextNav setCallbackDelegate:self];
//            [nextNav setCallbackKey:[question keyword]];
            
            [self setPopover:pop];
            [[self popover] setPopoverContentSize:CGSizeMake(320, 220)];
            
            CGRect cellRect = [tv rectForRowAtIndexPath:indexPath]; 
            CGRect rect = [[tv superview] convertRect:cellRect fromView:tv];
            [[self popover] presentPopoverFromRect:rect inView:[tv superview] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
    
    [tv deselectRowAtIndexPath:indexPath animated:YES];
    return nil;
}


- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat height = [tv rowHeight];
    id <GVCFormQuestion>question = [self questionAtIndexPath:indexPath];
    if (question != nil)
    {
		NSString *titleString = [question prompt];
		if ( [question entryType] == GVCFormQuestion_Type_NOTATION )
		{
			CGSize titleSize = [titleString sizeWithFont:[UIFont boldSystemFontOfSize:16] constrainedToSize:CGSizeMake(400, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
			height = MAX( height, titleSize.height);
		}
		else
		{
			id <GVCFormSubmissionValue>value = [[self formSubmission] valueForQuestion:question];
			NSString *detailString = [[value submittedValue] description];
			
			CGSize titleSize = [titleString sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(67, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
			CGSize detailSize = [detailString sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(400, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
			
			height = MAX( detailSize.height, titleSize.height);
		}

	}
	return MAX( [tv rowHeight], height);
}

- (void)setDate:(NSDate *)current forKey:(NSString *)callbackKey
{
    id <GVCFormQuestion>question = [[self form] questionForKeyword:callbackKey];
    if (question != nil )
    {
        GVC_ASSERT([question entryType] == GVCFormQuestion_Type_DATE, @"Cannot set date for question type %@", question);
        
		id <GVCFormSubmissionValue>value = [[self formSubmission] valueForQuestion:question];
        [value setSubmittedValue:current];
    }
    
    [self reload:self];
}

- (void) gvcEditCell:(GVCEditCell *)editableCell textChangedTo:(NSString *)newText;
{
    id <GVCFormQuestion>question = [self questionAtIndexPath:[editableCell editPath]];
	id <GVCFormSubmissionValue>value = [[self formSubmission] valueForQuestion:question];
    if ( value != nil )
    {
        [value setSubmittedValue:newText];
    }
}	

- (void)dismissPopover:sender
{
    if ( [self popover] != nil )
    {
        [[self popover] dismissPopoverAnimated:YES];
    }
    [self reload:nil];
}

- (BOOL)disablesAutomaticKeyboardDismissal
{
	return NO;
}

@end
