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
		[self setActive:NO];
        [self setAlertView:[[GVCStatusView alloc] initWithFrame:CGRectZero]];
        [[self alertView] setAlpha:0];
        [[self alertView] setBorderWidth:4];
        [[self alertView] setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin)];
        
        UIView *base = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [base setBackgroundColor:[UIColor clearColor]];
        [base setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [base setUserInteractionEnabled:NO];
        [base addSubview:[self alertView]];
		[base setAlpha:0];


        [self setView:base];
	}
	return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
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
	[self stopAlert];
}

- (void) startAlertWithMessage:(NSString *)message
{
    [self enqueueMessage:message];
}

- (void) stopAlert
{
	[self clearQueue];
	if ( active == YES )
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(hideAlertView)];
		[alertView setAlpha:0];
		[[self view] setAlpha:0];
		[UIView commitAnimations];
	}
}

- (void)hideAlertView
{
	[self setActive:NO];
    [[self view] removeFromSuperview];
}


- (void)showNextAlertMessage:(NSTimeInterval)animation
{
	if ( [alerts count] > 0 )
	{
		GVCStatusItem *item = [alerts objectAtIndex:0];
		[alerts removeObjectAtIndex:0];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:animation];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(processMessageQueue)];
		[alertView displayItem:item];
		[alertView setAlpha:1];
		[[self view] setAlpha:1];
		[UIView commitAnimations];
	}
    else
    {
        [self stopAlert];
    }
}

- (void)processMessageQueue
{
	if ([alerts count] > 0) 
	{
		[self showNextAlertMessage:1.0];
	}
}

- (void)enqueueMessage:(NSString *)message
{
    [self enqueueMessage:message accessory:GVC_StatusItemAccessory_ACTIVITY position:GVC_StatusItemPosition_TOP];
}

- (void)enqueueMessage:(NSString *)message accessory:(GVC_StatusItemAccessory)type
{
    [self enqueueMessage:message accessory:type position:GVC_StatusItemPosition_TOP];
}

- (void)enqueueMessage:(NSString *)message accessory:(GVC_StatusItemAccessory)type position:(GVC_StatusItemPosition)pos
{
    GVC_ASSERT_VALID_STRING( message );
	GVCStatusItem *item = [[GVCStatusItem alloc] init];
    [item setMessage:message];
    [item setAccessoryType:type];
    [item setAccessoryPosition:pos];

    [self enqueue:item];
}

- (void)enqueue:(GVCStatusItem *)item
{
    GVC_ASSERT(item != nil, @"Status Item is nil");
    
    [alerts addObject:item];
    
    if ( active == NO )
    {
        [self setActive:YES];
        
        [alertView setAlpha:0.0];
        UIWindow *keyWindow  = [[UIApplication sharedApplication] keyWindow];
        
        [keyWindow addSubview:[self view]];
        [keyWindow bringSubviewToFront:[self view]];
    }
    [self showNextAlertMessage:0.4];
}

- (void)clearQueue
{
    [alerts removeAllObjects];
}

@end



@implementation GVCStatusItem

@synthesize message;
@synthesize progress;
@synthesize image;

@synthesize accessoryType;
@synthesize accessoryPosition;
@synthesize activityStyle;

@end
