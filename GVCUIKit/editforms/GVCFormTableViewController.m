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
#import "GVCSwitchCell.h"

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

#pragma mark - Actions
- (IBAction)saveAction:(id)sender 
{
	[[self view] endEditing:YES];
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

- (NSIndexPath *)indexPathForQuestion:(id <GVCFormQuestion>)question inSection:(NSInteger)section
{
	GVC_DBC_REQUIRE(
					GVC_DBC_FACT_NOT_NIL(question);
					GVC_DBC_FACT(section >= 0);
					GVC_DBC_FACT(section < (NSInteger)[[self sections] count]);
					)
	
	// implementation
	NSIndexPath *path = nil;
	id<GVCFormSection> formSection = [[self sections] objectAtIndex:section];
	NSArray *entries = [self entriesPassingConditionsSection:formSection];
	NSInteger row = [entries indexOfObject:question];
	
	if ( row != NSNotFound )
	{
		path = [NSIndexPath indexPathForItem:row inSection:section];
	}
	
	GVC_DBC_ENSURE(
				   )
	return path;
}

- (NSIndexPath *)indexPathForQuestion:(id <GVCFormQuestion>)question
{
	GVC_DBC_REQUIRE(
					GVC_DBC_FACT_NOT_NIL(question);
					)

	NSIndexPath *path = nil;
	for (NSInteger section = 0; (path == nil) && (section < (NSInteger)[[self sections] count]); section++)
	{
		path = [self indexPathForQuestion:question inSection:section];
	}

	GVC_DBC_ENSURE(
	)

	return path;
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

- (void)tableview:(UITableView *)tv addRows:(NSNumber *)number afterQuestion:(id <GVCFormQuestion>)question
{
	GVC_DBC_REQUIRE(
					GVC_DBC_FACT_NOT_NIL(tv);
					GVC_DBC_FACT_NOT_NIL(question);
					GVC_DBC_FACT(number != 0);
					)
	
	// implementation
	NSIndexPath *path = [self indexPathForQuestion:question];
	NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:10];
	NSInteger total = ABS([number integerValue]);
	for ( NSInteger i = 1; i <= total; i++)
	{
		[indexPaths addObject:[NSIndexPath indexPathForItem:([path row] + i) inSection:[path section]]];
	}
	
	[tv beginUpdates];
	if ( [number integerValue] > 0)
	{
		[tv insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
	}
	else if ( [number integerValue] < 0 )
	{
		[tv deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
	}
	[tv endUpdates];
	
	GVC_DBC_ENSURE(
				   )
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
	static NSString *DefaultCellIdentifier = @"DefaultCellIdentifier";
	static NSString *GVCUITableViewCellIdent = @"GVCUITableViewCellIdent";
	static NSString *GVCUITableViewCellIdentNotation = @"GVCUITableViewCellIdentNotation";
	static NSString *GVCEditTextViewCellIdent = @"GVCEditTextViewCellIdent";
	static NSString *GVCEditTextFieldCellIdent = @"GVCEditTextFieldCellIdent";
	static NSString *GVCSwitchCellIdent = @"GVCSwitchCellIdent";
	static NSString *GVCEditDateCellIdent = @"GVCEditDateCellIdent";
	

    id <GVCFormQuestion>question = [self questionAtIndexPath:indexPath];
    id <GVCFormSubmissionValue>value = [[self formSubmission] valueForQuestion:question];
    if (question != nil )
    {
		switch ([question entryType])
		{
			case GVCFormQuestion_Type_TEXT:
			{
				cell = [tv dequeueReusableCellWithIdentifier:GVCEditTextFieldCellIdent];
				if (cell == nil)
				{
					cell = [[GVCEditTextFieldCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:GVCEditTextFieldCellIdent];
				}
				
				[[cell textLabel] setText:[question prompt]];
				[[cell textLabel] setNumberOfLines:0];
				[[cell textLabel] setLineBreakMode:NSLineBreakByWordWrapping];
				[[(GVCEditTextFieldCell *)cell textField] setText:[value submittedValue]];
				[(GVCEditTextFieldCell *)cell setDataEndBlock:^(NSObject *updatedValue){
					[value setSubmittedValue:updatedValue];
				}];

//				[(GVCUITableViewCell *)cell setDelegate:self];
				[(GVCEditCell *)cell setEditPath:indexPath];

				break;
			}

			case GVCFormQuestion_Type_MULTILINE_TEXT:
			{
				cell = [tv dequeueReusableCellWithIdentifier:GVCEditTextViewCellIdent];
				if (cell == nil)
				{
					cell = [[GVCEditTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GVCEditTextViewCellIdent];
				}
				[[cell textLabel] setText:[question prompt]];
				[[cell textLabel] setNumberOfLines:0];
				[[cell textLabel] setLineBreakMode:NSLineBreakByWordWrapping];
				
				[[(GVCEditTextViewCell *)cell textView] setText:[value submittedValue]];
				[(GVCEditTextViewCell *)cell setDataEndBlock:^(NSObject *updatedValue){
					[value setSubmittedValue:updatedValue];
				}];

//				[(GVCUITableViewCell *)cell setDelegate:self];
				[(GVCEditCell *)cell setEditPath:indexPath];
				break;
			}

			case GVCFormQuestion_Type_BOOLEAN:
			{
				cell = [tv dequeueReusableCellWithIdentifier:GVCSwitchCellIdent];
				if (cell == nil)
				{
					cell = [[GVCSwitchCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:GVCSwitchCellIdent];
				}
				
				[[cell detailTextLabel] setText:[question prompt]];
				[[cell detailTextLabel] setNumberOfLines:0];
				[[cell detailTextLabel] setLineBreakMode:NSLineBreakByWordWrapping];
				[[cell detailTextLabel] setLineBreakMode:NSLineBreakByWordWrapping];

				[(GVCSwitchCell *)cell setSwitchValue:([value submittedValue] != nil)];
				[(GVCSwitchCell *)cell setDataEndBlock:^(NSObject *updatedValue){
					if ([question isConditionQuestion] == YES)
					{
						NSInteger section = [indexPath section];
						id <GVCFormSection> sect = [[self sections] objectAtIndex:section];

						NSInteger beforeRows = [[sect entriesPassingAllConditions:[self formSubmission]] count];
						[value setSubmittedValue:updatedValue];
						NSInteger afterRows = [[sect entriesPassingAllConditions:[self formSubmission]] count];
						
						dispatch_async(dispatch_get_main_queue(), ^{
							[self tableview:tv addRows:[NSNumber numberWithInteger:(afterRows - beforeRows)] afterQuestion:question];
						});
					}
					else
					{
						[value setSubmittedValue:updatedValue];
					}
				}];
				
				[(GVCEditCell *)cell setEditPath:indexPath];
				
				break;
			}

			case GVCFormQuestion_Type_CHOICE:
			case GVCFormQuestion_Type_MULTI_CHOICE:
			{
				cell = [tv dequeueReusableCellWithIdentifier:GVCUITableViewCellIdent];
				if (cell == nil)
				{
					cell = [[GVCUITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:GVCUITableViewCellIdent];
				}

				[[cell textLabel] setNumberOfLines:0];
				[[cell textLabel] setLineBreakMode:NSLineBreakByWordWrapping];
				[[cell detailTextLabel] setNumberOfLines:0];
				[[cell detailTextLabel] setLineBreakMode:NSLineBreakByWordWrapping];
				
				[[cell textLabel] setText:[question prompt]];
				[[cell detailTextLabel] setText:[value displayValue]];
				break;
			}
				
			case GVCFormQuestion_Type_DATE:
			{
				cell = [tv dequeueReusableCellWithIdentifier:GVCEditDateCellIdent];
				if (cell == nil)
				{
					cell = [[GVCEditDateCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:GVCEditDateCellIdent];
				}

				[[cell textLabel] setText:[question prompt]];
				[[cell textLabel] setNumberOfLines:0];
				[[cell textLabel] setLineBreakMode:NSLineBreakByWordWrapping];
				
				[[cell detailTextLabel] setText:[value displayValue]];
				[(GVCSwitchCell *)cell setDataEndBlock:^(NSObject *updatedValue){
					[value setSubmittedValue:updatedValue];
				}];

				[(GVCEditCell *)cell setEditPath:indexPath];
				break;
			}
				
			case GVCFormQuestion_Type_NUMBER:
			{
				cell = [tv dequeueReusableCellWithIdentifier:GVCEditTextFieldCellIdent];
				if (cell == nil)
				{
					cell = [[GVCEditTextFieldCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:GVCEditTextFieldCellIdent];
				}
				
				[[cell textLabel] setText:[question prompt]];
				[[cell textLabel] setNumberOfLines:1];
				[[(GVCEditTextFieldCell *)cell textField] setText:[value displayValue]];
				[(GVCSwitchCell *)cell setDataEndBlock:^(NSObject *updatedValue){
					[value setSubmittedValue:updatedValue];
				}];

				[(GVCEditCell *)cell setEditPath:indexPath];

				break;
			}
				
			default:
			case GVCFormQuestion_Type_NOTATION:
			{
				cell = [tv dequeueReusableCellWithIdentifier:GVCUITableViewCellIdentNotation];
				if (cell == nil)
				{
					cell = [[GVCUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GVCUITableViewCellIdentNotation];
				}
				[[cell textLabel] setLineBreakMode:NSLineBreakByWordWrapping];
				[[cell textLabel] setText:[question prompt]];
				break;
			}
		}
    }
    else
    {
		cell = [tv dequeueReusableCellWithIdentifier:DefaultCellIdentifier];
		if (cell == nil)
		{
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DefaultCellIdentifier];
		}
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

            [self setPopover:pop];
            [[self popover] setPopoverContentSize:CGSizeMake(320, 220)];
            
            CGRect cellRect = [tv rectForRowAtIndexPath:indexPath]; 
            CGRect rect = [[tv superview] convertRect:cellRect fromView:tv];
            [[self popover] presentPopoverFromRect:rect inView:[tv superview] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
    
    return indexPath;
}


- (CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat height = [tv rowHeight];
    CGFloat tvWidth = [tv contentSize].width;
	CGFloat tvLeftWidth = floorf(tvWidth * 0.1);
	NSString *text = nil;
	NSString *detailsText = nil;

    id <GVCFormQuestion>question = [self questionAtIndexPath:indexPath];
    if (question != nil)
    {
		text = [question prompt];
		if (( [question entryType] != GVCFormQuestion_Type_NOTATION ) && ( [question entryType] != GVCFormQuestion_Type_BOOLEAN ))
		{
			id <GVCFormSubmissionValue>value = [[self formSubmission] valueForQuestion:question];
			detailsText = [value displayValue];
		}
	}

	if ( gvc_IsEmpty(text) == NO )
	{
		CGRect leftRect = [text boundingRectWithSize:CGSizeMake(tvLeftWidth, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]} context:nil];
		height = MAX(height, CGRectGetHeight( leftRect ));
	}

	if ( gvc_IsEmpty(detailsText) == NO)
	{
		CGRect rightRect = [detailsText boundingRectWithSize:CGSizeMake((tvWidth - tvLeftWidth), MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody]} context:nil];
		height = MAX(height, CGRectGetHeight( rightRect ));
	}

	return height;
}

#pragma mark - Callbacks

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
