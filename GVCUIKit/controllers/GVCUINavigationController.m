/*
 * GVCUINavigationController.m
 * 
 * Created by David Aspinall on 12-05-08. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCUINavigationController.h"
#import "GVCUIKitFunctions.h"


@implementation GVCUINavigationController

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
    if (([self delegate] != nil) && ([[self delegate] respondsToSelector:@selector(willDismissModalController)] == YES))
    {
        [(id <GVCUIModalViewControllerModalDismiss>)[self delegate] willDismissModalController];
    }
        
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)viewTitle
{
	NSString *viewTitle = nil;
	if (([self topViewController] != nil) && ([[self topViewController] conformsToProtocol:@protocol(GVCViewTitleProtocol)] == YES))
	{
		viewTitle = [(id <GVCViewTitleProtocol>)[self topViewController] viewTitle];
	}
	
	if ( gvc_IsEmpty(viewTitle) == YES)
	{
		viewTitle = GVC_LocalizedClassString(GVC_DEFAULT_VIEW_TITLE, GVC_CLASSNAME(self));
	}
	
	return viewTitle;
}

@end
