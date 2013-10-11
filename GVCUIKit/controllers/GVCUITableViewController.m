//
//  DATableViewController.m
//
//  Created by David Aspinall on 10-03-29.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import "GVCUITableViewController.h"
#import "GVCUITableViewCell.h"
#import "GVCUIKitFunctions.h"
#import "GVCUIProtocols.h"
#import "GVCLockViewManager.h"

#import "UITableViewCell+GVCUIKit.h"

@implementation GVCUITableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	if (self != nil) 
	{
	}
	return self;
}

- (NSString *)viewTitle
{
	return GVC_LocalizedClassString(GVC_DEFAULT_VIEW_TITLE, GVC_CLASSNAME(self));;
}

- (IBAction)reload:(id)sender
{
	[[self tableView] reloadData];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self autoresizesForKeyboard] == YES)
	{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:)  name:UIKeyboardDidShowNotification  object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:)  name:UIKeyboardDidHideNotification  object:nil];
	}

}
- (void)viewDidAppear:(BOOL)animated 
{
	UINavigationBar *navBar = [self navigationBar];
	UINavigationItem *navItem = [navBar topItem];
	[navItem setTitle:[self viewTitle]];
	
	[super viewDidAppear:animated];
}


-(void) viewWillDisappear:(BOOL)animated 
{
	[super viewWillDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification  object:nil];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];

	if ([self tableHeaderView] != nil)
	{
        [[self tableView] setTableHeaderView:[self tableHeaderView]];
    }
	
	if ([self tableFooterView] != nil) 
	{
        [[self tableView] setTableFooterView:[self tableFooterView]];
    }

	[[GVCLockViewManager sharedGVCLockViewManager] registerViewControllerIfModal:self];
}

- (UINavigationBar *)navigationBar
{
	UINavigationController *navController = [self navigationController];
	return [navController navigationBar];
}


-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		return YES;
	}
    
	return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation 
{
	return [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}



#pragma mark [UIKeyboardNotifications]

-(void) resizeForKeyboard:(NSNotification *)notification appearing:(BOOL)appearing 
{
	NSDictionary *userInfo = [notification userInfo];
	
	// Get the ending frame rect
	NSValue *frameEndValue	= [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGRect keyboardRect = [frameEndValue CGRectValue];
	
	// Convert to window coordinates
	CGRect keyboardFrame = [[self view] convertRect:keyboardRect fromView:nil];
	
	NSNumber *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
	BOOL animated = ([animationDurationValue doubleValue] > 0.0) ? YES : NO; 
    
	if (animated == YES) 
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:[animationDurationValue doubleValue]];
	}
	
	if (appearing == YES) 
	{
		[self keyboardWillAppear:animated withBounds:keyboardFrame];
		[self keyboardWillAppear:animated withBounds:keyboardFrame animationDuration:[animationDurationValue doubleValue]];
	}
	else 
	{
		[self keyboardDidDisappear:animated withBounds:keyboardFrame];
	}
	
	if (animated == YES) 
	{
		[UIView commitAnimations];
	}
}

-(void) keyboardWillShow:(NSNotification *)notification 
{
    [self resizeForKeyboard:notification appearing:YES];
}

-(void) keyboardDidShow:(NSNotification *)notification 
{
	CGRect frameStart;
	[[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&frameStart];
	
	CGRect keyboardBounds = CGRectMake(0, 0, frameStart.size.width, frameStart.size.height);
	[self keyboardDidAppear:YES withBounds:keyboardBounds];
}

-(void) keyboardDidHide:(NSNotification *)notification 
{
    [self resizeForKeyboard:notification appearing:NO];
}

-(void) keyboardWillHide:(NSNotification *)notification 
{
	CGRect frameEnd;
	[[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&frameEnd];
	CGRect keyboardBounds = CGRectMake(0, 0, frameEnd.size.width, frameEnd.size.height);
	
	NSTimeInterval animationDuration;
	NSValue *animationDurationValue = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
	[animationDurationValue getValue:&animationDuration];
	[self keyboardWillDisappear:YES withBounds:keyboardBounds];
	[self keyboardWillDisappear:YES withBounds:keyboardBounds animationDuration:animationDuration];
}


#pragma mark API

-(void) keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds 
{
	if ( [[self view] isKindOfClass:[UIScrollView class]] == YES )
	{
		UIEdgeInsets e = UIEdgeInsetsMake(0, 0, bounds.size.height, 0);
		
		[(UIScrollView *)[self view] setContentInset:e];
		[(UIScrollView *)[self view] setScrollIndicatorInsets:e];
        
        NSIndexPath *idxPath = [[self tableView] indexPathForSelectedRow];
        if ( idxPath != nil )
        {
            [[self tableView] scrollToRowAtIndexPath:idxPath atScrollPosition:UITableViewScrollPositionMiddle animated:animated];
        }
	}
}

-(void) keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds animationDuration:(NSTimeInterval)aDuration 
{
    
}

-(void) keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds 
{
	if ( [[self view] isKindOfClass:[UIScrollView class]] == YES )
	{
		[(UIScrollView *)[self view] setContentInset:UIEdgeInsetsZero];
		[(UIScrollView *)[self view] setScrollIndicatorInsets:UIEdgeInsetsZero];
	}
}

-(void) keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds animationDuration:(NSTimeInterval)aDuration 
{
    
}

-(void) keyboardDidAppear:(BOOL)animated withBounds:(CGRect)bounds 
{
}

-(void) keyboardDidDisappear:(BOOL)animated withBounds:(CGRect)bounds 
{
}


#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv 
{
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
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


//#pragma mark - nib/xib cell loading
//- (UITableViewCell *)dequeueOrLoadReusableCellFromClass:(Class)cellClass forTable:(UITableView *)tv withIdentifier:(NSString *)identifier
//{
//	UITableViewCell *cell = [self dequeueOrLoadReusableCellFromNib:NSStringFromClass(cellClass) forTable:tv withIdentifier:identifier];
//	GVC_ASSERT( [cell isKindOfClass:cellClass], @"Wrong class %@ should be %@", GVC_CLASSNAME(cell), NSStringFromClass(cellClass));
//	return cell;
//}
//
//- (UITableViewCell *)dequeueOrLoadReusableCellFromNib:(NSString *)cellNibName forTable:(UITableView *)tv withIdentifier:(NSString *)identifier
//{
//	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:identifier];
//    if (cell == nil) 
//	{
//        [[NSBundle mainBundle] loadNibNamed:cellNibName owner:self options:nil];
//        cell = [self cellTemplate];
//    }
//	
//	GVC_ASSERT( cell != nil, @"Could not find cellTemplate in %@", cellNibName );
//	
//	return cell;
//}
@end
