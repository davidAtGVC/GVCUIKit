//
//  GVCStatusView.m
//
//  Created by David Aspinall on 10-12-13.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import "GVCStatusView.h"
#import "GVCFoundation.h"

#import "UIView+GVCUIKit.h"
#import "GVCProgressBarView.h"

#define HUD_MARGIN 20.0
#define HUD_PADDING 4.0

@interface GVCStatusView ()
{
	float width;
	float height;
	float currentProgress;
	CGAffineTransform rotationTransform;
}
@property (copy, nonatomic) NSString *text;
@property (assign, nonatomic) float currentProgress;
@end

@implementation GVCStatusView

@synthesize text;
@synthesize progressBar;
@synthesize activityIndicator;
@synthesize messageLabel;
@synthesize currentProgress;

- (id)initWithFrame:(CGRect)frame;
{
	self = [super initWithFrame:frame];
	if (self != nil)
	{
		UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
		[label setAdjustsFontSizeToFitWidth:NO];
        [label setTextAlignment:UITextAlignmentCenter];
        [label setOpaque:NO];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        [self setMessageLabel:label];

		[self setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];

		[self setBorderColor:[UIColor lightGrayColor]];
		currentProgress = -1.0;
		width = 0.0;
		height = 0.0;
		rotationTransform = CGAffineTransformIdentity;

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)coder 
{
    self = [super initWithCoder:coder];
    if (self != nil) 
	{
		UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
		[label setAdjustsFontSizeToFitWidth:NO];
        [label setTextAlignment:UITextAlignmentCenter];
        [label setOpaque:NO];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        [self setMessageLabel:label];
		
		[self setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
		
		[self setBorderColor:[UIColor lightGrayColor]];
		currentProgress = -1.0;
		width = 0.0;
		height = 0.0;
    }
    return self;
}

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)
- (void)setTransformForCurrentOrientation:(BOOL)animated 
{
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	NSInteger degrees = 0;
	
	if (UIInterfaceOrientationIsLandscape(orientation))
	{
		if (orientation == UIInterfaceOrientationLandscapeLeft)
		{
			degrees = -90;
		} 
		else
		{ 
			degrees = 90; 
		}
	}
	else
	{
		if (orientation == UIInterfaceOrientationPortraitUpsideDown)
		{ 
			degrees = 180;
		} 
		else
		{ 
			degrees = 0; 
		}
	}
	
	rotationTransform = CGAffineTransformMakeRotation(RADIANS(degrees));
	
	if (animated == YES) 
	{
		[UIView beginAnimations:nil context:nil];
	}
	[self setTransform:rotationTransform];
	if (animated == YES)
	{
		[UIView commitAnimations];
	}
}

- (void)deviceOrientationDidChange:(NSNotification *)notification 
{ 
	if ( [self superview] != nil )
	{
		if ([[self superview] isKindOfClass:[UIWindow class]]) 
		{
			[self setTransformForCurrentOrientation:YES];
		}
			// Stay in sync with the parent view (make sure we cover it fully)
		[self setFrame:[[self superview] bounds]];
		[self setNeedsLayout];
		[self setNeedsDisplay];
	}
}

- (void)updateMessage:(NSString *)msg
{
    [self setText:msg];
    [self update];
}

- (void)updateProgress:(float)progress
{
    if ( progress > 0.0 && progress < 1.0)
        currentProgress = progress;
    [self update];    
}

- (void)updateMessage:(NSString *)msg andProgress:(float)progress
{
    if ( progress > 0.0 && progress < 1.0)
        currentProgress = progress;
    [self setText:msg];
    [self update];
}

- (void)update
{
	if ([NSThread isMainThread]) 
	{
        [[self progressBar] setProgress:currentProgress];
		[self setNeedsLayout];
		[self setNeedsDisplay];
	}
	else
	{
		[self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
	}
}

- (void)layoutSubviews
{
		//	CGRect superframe = [[self superview] frame];
    CGRect myframe = [[self superview] bounds]; //[self bounds];

	CGRect progressRect = CGRectZero;
	CGSize textSize = CGSizeZero;

	UIView *indicator = nil;
	if (currentProgress <= 0.0 )
	{
			// remove progress view
		[[self progressBar] removeFromSuperview];
		
		if ( [self activityIndicator] == nil )
		{
            [self setActivityIndicator:[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]];
		}
		
		[self addSubview:[self activityIndicator]];
		[[self activityIndicator] startAnimating];
		[[self activityIndicator] setHidesWhenStopped:YES];
		
		indicator = [self activityIndicator];
	}
	else
	{
			// remove activity view
		[[self activityIndicator] stopAnimating];
		[[self activityIndicator] removeFromSuperview];
		
		if ( [self progressBar] == nil )
		{
			[self setProgressBar:[GVCProgressBarView standardWhiteProgressView]];
		}
		[self addSubview:[self progressBar]];
		[[self progressBar] setProgress:currentProgress];
		indicator = [self progressBar];
	}
	progressRect = [indicator frame];

	if ( [self text] != nil )
	{
		textSize = [[self text] sizeWithFont:[[self messageLabel] font] constrainedToSize:CGSizeMake(200, 100) lineBreakMode:UILineBreakModeWordWrap];
	}

		// width is largest width + top and bottom margin
	width = MAX(progressRect.size.width, textSize.width) + (HUD_MARGIN * 2);
		// heigth is sum of all heights plus margin plus padding between both
	height = progressRect.size.height + textSize.height;
	height += (HUD_MARGIN * 2) + (HUD_PADDING * 2);
	
		// make it square
	width = MAX( width, height );
	height = width;

	CGRect boxRect = CGRectMake(floorf((myframe.size.width - width) / 2), floorf((myframe.size.height - height) / 2), floorf(width), floorf(height));
	[self setFrame:boxRect];

	progressRect.origin.x = floor((boxRect.size.width - progressRect.size.width) / 2);
	progressRect.origin.y = floor((boxRect.size.height - progressRect.size.height) / 2);
	[indicator setFrame:progressRect];
	
	CGRect messageFrame = CGRectMake(floor((boxRect.size.width - textSize.width) / 2),
							   floor(progressRect.origin.y + progressRect.size.height + HUD_PADDING),
							   textSize.width, textSize.height);
	[[self messageLabel] setFrame:messageFrame];
	[self addSubview:[self messageLabel]];
}

- (void)dealloc 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
