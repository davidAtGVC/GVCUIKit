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
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (NSString *)viewTitle
{
	NSString *viewTitle = nil;
	if (([self selectedViewController] != nil) && ([[self selectedViewController] conformsToProtocol:@protocol(GVCViewTitleProtocol)] == YES))
	{
		viewTitle = [(id <GVCViewTitleProtocol>)[self selectedViewController] viewTitle];
	}
	
	if ( gvc_IsEmpty(viewTitle) == YES)
	{
		viewTitle = GVC_LocalizedClassString(GVC_DEFAULT_VIEW_TITLE, GVC_CLASSNAME(self));
	}
	
	return viewTitle;
}


@end
