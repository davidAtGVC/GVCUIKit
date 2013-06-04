/*
 * GVCUIViewWithTableController.m
 * 
 * Created by David Aspinall on 12-05-10. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <GVCFoundation/GVCFoundation.h>

#import "GVCUIViewWithTableController.h"
#import "GVCUITableViewCell.h"
#import "GVCUIProtocols.h"

#import "UITableViewCell+GVCUIKit.h"

@implementation GVCUIViewWithTableController

- (IBAction)reload:(id)sender
{
	[[self tableView] reloadData];
}

- (void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
    
	// set default title
	[[self tableView] reloadData];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
//	[[self tableView] setAutoresizesSubviews:YES];
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation 
{
    [self reload:nil];
	return [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

#pragma mark - keyboard resize
-(void) keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds 
{
	if ( [self tableView] != nil)
	{
		UIEdgeInsets e = UIEdgeInsetsMake(0, 0, bounds.size.height, 0);
		
		[[self tableView] setContentInset:e];
		[[self tableView] setScrollIndicatorInsets:e];
        
        NSIndexPath *idxPath = [[self tableView] indexPathForSelectedRow];
        if ( idxPath != nil )
        {
            [[self tableView] scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionMiddle animated:animated];
        }
	}
}

-(void) keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds 
{
	if ( [self tableView] != nil)
	{
		[[self tableView] setContentInset:UIEdgeInsetsZero];
		[[self tableView] setScrollIndicatorInsets:UIEdgeInsetsZero];
	}
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


//- (CGFloat)tableView:(UITableView*)tv heightForRowAtIndexPath:(NSIndexPath*)indexPath
//{
//	CGFloat height = 0.0;
//	id <UITableViewDataSource> dataSource = [tv dataSource];
//	
//	if ((dataSource != nil) && ([dataSource conformsToProtocol:@protocol(GVCTableViewDataSourceProtocol)] == YES))
//	{
//		id object = [(id <GVCTableViewDataSourceProtocol>)dataSource tableView:tv objectForRowAtIndexPath:indexPath];
//		Class cls = [(id <GVCTableViewDataSourceProtocol>)dataSource tableView:tv cellClassForObject:object];
//		
//		if ( cls != nil )
//		{
//			height = [cls tableView:tv rowHeightForObject:object];
//		}
//	}
//	
//	return (height > 44.0) ? height : 44.0;
//}

#pragma mark - GVCTableViewDataSourceProtocol
/*
 Each row of the table is represented by a single object
 */
- (NSArray *)tableView:(UITableView *)tableView rowsForSection:(NSUInteger)section
{
	return nil;
}


- (id)tableView:(UITableView*)tableView objectForRowAtIndexPath:(NSIndexPath*)indexPath
{
	return nil;
}

- (NSIndexPath*)tableView:(UITableView*)tableView indexPathForObject:(id)object
{
	NSIndexPath *indexPath = nil;
	NSInteger sectionCount = [self numberOfSectionsInTableView:tableView];
	for ( NSInteger section = 0; section < sectionCount && indexPath == nil; section ++)
	{
		NSArray *rows = [self tableView:tableView rowsForSection:section];
		NSUInteger rowIndex = [rows indexOfObject:object];
		if ( rowIndex != NSNotFound )
		{
			indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:section];
		}
	}
	return indexPath;
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object
{
	return [GVCUITableViewCell class];
}


@end
