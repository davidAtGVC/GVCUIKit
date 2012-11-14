/*
 * GVCUITabViewController.m
 * 
 * Created by David Aspinall on 12-05-08. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCUITabBarController.h"
#import "GVCUINavigationController.h"
#import "GVCUIKitFunctions.h"

@implementation GVCUITabBarController

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		return YES;
	}
    
	return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (IBAction)dismissModalViewController:(id)sender
{
    UINavigationController *nav = [self navigationController];
    if ((nav != nil) && ([nav isKindOfClass:[GVCUINavigationController class]] == YES))
    {
        [(GVCUINavigationController *)[self navigationController] dismissModalViewController:sender];
    }
    else 
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (NSString *)viewTitleKey
{
	NSString *viewTitle = GVC_DEFAULT_VIEW_TITLE;
	if (([self selectedViewController] != nil) && ([[self selectedViewController] conformsToProtocol:@protocol(GVCViewTitleProtocol)] == YES))
	{
		viewTitle = [(id <GVCViewTitleProtocol>)[self selectedViewController] viewTitleKey];
	}
	
	return viewTitle;
}


@end
