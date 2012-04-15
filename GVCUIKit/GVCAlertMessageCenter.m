//
//  GVCAlertMessageCenter.m
//  HL7Domain
//
//  Created by David Aspinall on 10-12-13.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import "GVCAlertMessageCenter.h"
#import "UIView+GVCUIKit.h"

#import "GVCStatusView.h"

@interface GVCAlertMessageCenter()
@property (nonatomic, strong) NSMutableArray *alerts;
@property (nonatomic, strong) GVCStatusView *alertView;
@property (nonatomic, assign) BOOL active;
- (void)showNextAlertMessage:(NSTimeInterval)animation;
- (void)processMessageQueue;
- (void)hideAlertView;
@end


@implementation GVCAlertMessageCenter

@synthesize alerts;
@synthesize alertView;
@synthesize active;

GVC_SINGLETON_CLASS(GVCAlertMessageCenter);

- (id) init
{
	self=[super init];
	if(self != nil)
	{
		[self setAlerts:[[NSMutableArray alloc] init]];
		[self setAlertView:[[GVCStatusView alloc] init]];
		[self setActive:NO];
	}
	return self;
}

- (void)setActive:(BOOL)yesNo
{
	dispatch_sync( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		if ( yesNo == YES )
		{
			if ( active == NO )
				[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
		}
		else
		{
			if ( active == YES )
				[[UIApplication sharedApplication] endIgnoringInteractionEvents];
		}
		
		active = yesNo;
	});
}

- (void) timedAlert:(NSTimeInterval)interval withMessage:(NSString *)message
{
	
}

- (void)keyWindowChanged:(NSNotification *)notification
{

	[self setActive:NO];
}

- (void) startAlertWithMessage:(NSString *)message
{
	GVC_ASSERT_VALID_STRING( message );
	
	if ( [alerts containsObject:message] == NO )
		[alerts addObject:message];

	if ( active == NO )
	{
		[self setActive:YES];

		[alertView setAlpha:0.0];
		UIWindow *keyWindow  = [[UIApplication sharedApplication] keyWindow];

		[keyWindow addSubview:alertView];
		[keyWindow bringSubviewToFront:alertView];
	}
	[self showNextAlertMessage:0.4];
}

- (void) stopAlert
{
	[alerts removeAllObjects];
	if ( active == YES )
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(hideAlertView)];
		[alertView setAlpha:0];
		[UIView commitAnimations];
	}
}

- (void)hideAlertView
{
	[self setActive:NO];
	[[[UIApplication sharedApplication] keyWindow] sendSubviewToBack:alertView];
	[alertView removeFromSuperview];
}


- (void)showNextAlertMessage:(NSTimeInterval)animation
{
	if ( [alerts count] > 0 )
	{
		NSString *message = [alerts objectAtIndex:0];
		[alerts removeObjectAtIndex:0];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:animation];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(processMessageQueue)];
		[alertView updateMessage:message];
		[alertView setAlpha:1];
		[UIView commitAnimations];
	}
}

- (void)processMessageQueue
{
	if ([alerts count] > 0) 
	{
		[self showNextAlertMessage:1.0];
	}
}

@end


