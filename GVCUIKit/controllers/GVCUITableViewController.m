//
//  DATableViewController.m
//
//  Created by David Aspinall on 10-03-29.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import "GVCUITableViewController.h"
#import "GVCUITableViewCell.h"

#import "GVCFoundation.h"

@implementation GVCUITableViewController

@synthesize tableHeaderView;
@synthesize tableFooterView;
@synthesize cellTemplate;

- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	if (self != nil) 
	{
	}
	return self;
}

- (NSString *)viewTitleKey
{
	return @"viewTitle";
}

- (IBAction)reload:(id)sender
{
	[[self tableView] reloadData];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];

	// set default title
	[[self tableView] reloadData];
	[[self navigationItem] setTitle:GVC_LocalizedClassString([self viewTitleKey], GVC_CLASSNAME(self))];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];

	if (tableHeaderView != nil) 
	{
        [[self tableView] setTableHeaderView:tableHeaderView];
    }
	
	if (tableFooterView != nil) 
	{
        [[self tableView] setTableFooterView:tableFooterView];
    }
	[[self tableView] setAutoresizesSubviews:YES];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Return YES for supported orientations
    return YES;
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv 
{
	GVC_SUBCLASS_RESPONSIBLE;
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
	GVC_SUBCLASS_RESPONSIBLE;
	return nil;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section 
{
	GVC_SUBCLASS_RESPONSIBLE;
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	GVC_SUBCLASS_RESPONSIBLE;
    return nil;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	// Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	// Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}



 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tv canEditRowAtIndexPath:(NSIndexPath *)indexPath 
 {
	 // Return NO if you do not want the specified item to be editable.
	 return NO;
 }



/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
 {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tv deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tv moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tv canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath 
//{
//	if ( [cell isKindOfClass:[GVCUITableViewCell class]] == YES )
//	{
//		[(GVCUITableViewCell *)cell setUseDarkBackground:([indexPath row] % 2 == 0)];
//	}
//}

- (UITableViewCell *)dequeueOrLoadReusableCellFromClass:(Class)cellClass forTable:(UITableView *)tv withIdentifier:(NSString *)identifier
{
	UITableViewCell *cell = [self dequeueOrLoadReusableCellFromNib:NSStringFromClass(cellClass) forTable:tv withIdentifier:identifier];
	GVC_ASSERT( [cell isKindOfClass:cellClass], @"Wrong class %@ should be %@", GVC_CLASSNAME(cell), NSStringFromClass(cellClass));
	return cell;
}

- (UITableViewCell *)dequeueOrLoadReusableCellFromNib:(NSString *)cellNibName forTable:(UITableView *)tv withIdentifier:(NSString *)identifier
{
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) 
	{
        [[NSBundle mainBundle] loadNibNamed:cellNibName owner:self options:nil];
        cell = cellTemplate;
    }
	
	GVC_ASSERT( cell != nil, @"Could not find cellTemplate in %@", cellNibName );
	
	return cell;
}
@end
