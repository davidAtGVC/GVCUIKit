//
//  GVCStackedViewController.m
//  GVCUIKit
//
//  Created by David Aspinall on 2013-03-27.
//
//

#import <QuartzCore/QuartzCore.h>

#import "GVCStackedViewController.h"

#import "UIView+GVCUIKit.h"

#define DEFAULT_ANIMATION_DURATION 0.3

typedef enum {
    GVCStackedViewControllerVisible_ROOT = 1,
    GVCStackedViewControllerVisible_LEFT,
    GVCStackedViewControllerVisible_RIGHT
} GVCStackedViewControllerVisible;

GVC_DEFINE_STRVALUE(RIGHT_SEGUE_ID, rightSegue);
GVC_DEFINE_STRVALUE(LEFT_SEGUE_ID, leftSegue);
GVC_DEFINE_STRVALUE(DEFAULT_SEGUE_ID, defaultSegue);

@interface GVCStackedViewController ()

@property (nonatomic, assign) CGPoint panGestureOrigin;
@property (nonatomic, assign) CGFloat panGestureVelocity;

@property (nonatomic, strong, readwrite) UIViewController *leftViewController;
@property (nonatomic, strong, readwrite) UIViewController *rootViewController;
@property (nonatomic, strong, readwrite) UIViewController *rightViewController;

@property (nonatomic, assign) GVCStackedViewControllerVisible state;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end

@implementation GVCStackedViewController

#pragma mark - Icon

+ (UIImage *)defaultImage {
	static UIImage *defaultImage = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(20.f, 13.f), NO, 0.0f);
		
		[[UIColor blackColor] setFill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 20, 1)] fill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 5, 20, 1)] fill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 10, 20, 1)] fill];
		
		[[UIColor whiteColor] setFill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 1, 20, 2)] fill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 6,  20, 2)] fill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 11, 20, 2)] fill];
		
		defaultImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
	});
    return defaultImage;
}

#pragma mark - NSObject


//Support creating from Storyboard
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
	{
        [self _baseInit];
    }
    return self;
}

- (id)init
{
    if (self = [super init])
	{
        [self _baseInit];
    }
    return self;
}

- (void)_baseInit
{
}

#pragma mark - UIViewController

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
    [[self view] setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
	[self setState:GVCStackedViewControllerVisible_ROOT];

	if ( [self leftViewController] == nil )
	{
		@try {
			[self performSegueWithIdentifier:LEFT_SEGUE_ID sender:self];
		}
		@catch (NSException *exception) {
			GVCLogError(@"Caught exception %@", exception);
		}
	}
	
	if ( [self rightViewController] == nil )
	{
		@try {
			[self performSegueWithIdentifier:RIGHT_SEGUE_ID sender:self];
		}
		@catch (NSException *exception) {
			GVCLogError(@"Caught exception %@", exception);
		}
	}
	
	if ( [self rootViewController] == nil)
	{
		[self performSegueWithIdentifier:DEFAULT_SEGUE_ID sender:self];
	}
	
	CGRect bounds = [[self view] bounds];
	[[[self rootViewController] view] setFrame:CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height)];
}

#pragma mark - child view controllers

- (void)setRootViewController:(UIViewController *)newRootController
{
	UIViewController *previousRoot = [self rootViewController];
	_rootViewController = newRootController;
	
	if ( _rootViewController != nil)
	{
		switch ([self state])
		{
			case GVCStackedViewControllerVisible_LEFT:
			{
				[self setState:GVCStackedViewControllerVisible_ROOT];
				[UIView animateWithDuration:0.2f animations:^{
					// move the previous view offscreen
					[[previousRoot view] setGvc_frameX:[[self view] gvc_frameWidth]];
				} completion:^(__unused BOOL finished) {
					[previousRoot willMoveToParentViewController:nil];
					[[previousRoot view] removeFromSuperview];
					[previousRoot removeFromParentViewController];
					
					[_rootViewController willMoveToParentViewController:self];
					[self addChildViewController:_rootViewController];
					[[self view] addSubview:[_rootViewController view]];
					[_rootViewController didMoveToParentViewController:self];
					
					[self showRootPanel:nil];
				}];
				
				break;
			}
				
			case GVCStackedViewControllerVisible_RIGHT:
			{
				[self setState:GVCStackedViewControllerVisible_ROOT];
				[UIView animateWithDuration:0.2f animations:^{
					// move the previous view offscreen
					[[previousRoot view] setGvc_frameX:( -1 * [[self view] gvc_frameWidth])];
				} completion:^(__unused BOOL finished) {
					[previousRoot willMoveToParentViewController:nil];
					[[previousRoot view] removeFromSuperview];
					[previousRoot removeFromParentViewController];
					
					[_rootViewController willMoveToParentViewController:self];
					[self addChildViewController:_rootViewController];
					[[self view] addSubview:[_rootViewController view]];
					[_rootViewController didMoveToParentViewController:self];
					
					[self showRootPanel:nil];
				}];
				
				break;
			}
				
			case GVCStackedViewControllerVisible_ROOT:
			default:
			{
				[previousRoot willMoveToParentViewController:nil];
				[[previousRoot view] removeFromSuperview];
				[previousRoot removeFromParentViewController];
				
				[_rootViewController willMoveToParentViewController:self];
				[self addChildViewController:_rootViewController];
				[[self view] addSubview:[_rootViewController view]];
				[_rootViewController didMoveToParentViewController:self];
				
				[self showRootPanel:nil];
				break;
			}
		}
		
		[self placeButtonsOnRootView];
        [[self view] bringSubviewToFront:[_rootViewController view]];
		
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRootView:)];
        [pan setDelegate:(id<UIGestureRecognizerDelegate>)self];
        [[_rootViewController view] addGestureRecognizer:pan];
		[self setPanGesture:pan];
	}
}


- (void)setLeftViewController:(UIViewController *)controller
{
    if (_leftViewController != controller)
	{
		UIViewController *previous = _leftViewController;
		_leftViewController = controller;
		
        [previous willMoveToParentViewController:nil];
        [[previous view] removeFromSuperview];
        [previous removeFromParentViewController];
		
        if (_leftViewController != nil)
		{
			[_leftViewController willMoveToParentViewController:self];
            [self addChildViewController:_leftViewController];
            [_leftViewController didMoveToParentViewController:self];
			
			[self placeButtonsOnRootView];
        }
    }
	
	[[self view] bringSubviewToFront:[[self rootViewController] view]];
}

- (void)setRightViewController:(UIViewController *)controller
{
    if (_rightViewController != controller)
	{
		UIViewController *previous = _rightViewController;
		_rightViewController = controller;
		
        [previous willMoveToParentViewController:nil];
        [[previous view] removeFromSuperview];
        [previous removeFromParentViewController];
		
        if (_rightViewController != nil)
		{
			[_rightViewController willMoveToParentViewController:self];
            [self addChildViewController:_rightViewController];
            [_rightViewController didMoveToParentViewController:self];

			[self placeButtonsOnRootView];
		}
    }

	[[self view] bringSubviewToFront:[[self rootViewController] view]];
}

#pragma mark - widths
- (CGFloat)leftVisibleWidth
{
	CGRect bounds = [[self view] bounds];
	CGFloat w = [self leftViewWidth];
	if ((w <= 0.0f) || ((w >= 60.0) && (w < (bounds.size.width * 0.8f))))
	{
		// default 40%
		[self setLeftViewWidth:0.4];
		w = [self leftViewWidth];
	}
	
	return (w > 1.0) ? w : floorf( bounds.size.width * w);
}

- (CGFloat)rightVisibleWidth
{
	CGRect bounds = [[self view] bounds];
	CGFloat w = [self rightViewWidth];
	if ((w <= 0.0f) || ((w >= 60.0) && (w < (bounds.size.width * 0.8f))))
	{
		// default 40%
		[self setRightViewWidth:0.4];
		w = [self rightViewWidth];
	}

	return (w > 1.0) ? w : floorf( bounds.size.width * w);
}



#pragma mark - orientation

- (BOOL)shouldAutorotate
{
    if ([self rootViewController] != nil)
	{
        return [[self rootViewController] shouldAutorotate];
    }

	return YES;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
    if ([self rootViewController] != nil)
	{
        [[self rootViewController] willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
}

#pragma mark - Panel Buttons

- (void)placeButtonsOnRootView
{
	UIViewController *topViewController = [self rootViewController];
	if ([[self rootViewController] isKindOfClass:[UINavigationController class]] == YES)
	{
		UINavigationController *navController = (UINavigationController*)[self rootViewController];
		if ([[navController viewControllers] count] > 0)
		{
			topViewController = [[navController viewControllers] objectAtIndex:0];
		}
	}
	else if ([[self rootViewController] isKindOfClass:[UITabBarController class]] == YES)
	{
		UITabBarController *tabController = (UITabBarController*)[self rootViewController];
		topViewController = [tabController selectedViewController];
	}
	
	if ( [topViewController navigationItem] != nil )
	{
		if ([self leftViewController] != nil)
		{
			UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[[self class] defaultImage] style:UIBarButtonItemStylePlain target:self action:@selector(toggleLeftPanel:)];
			[[topViewController navigationItem] setLeftBarButtonItem:button];
		}

		if ([self rightViewController] != nil)
		{
			UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[[self class] defaultImage] style:UIBarButtonItemStylePlain target:self action:@selector(toggleRightPanel:)];
			[[topViewController navigationItem] setRightBarButtonItem:button];
		}
	}
}


#pragma mark - Gesture Recognizer Delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == [self panGesture])
	{
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer*)gestureRecognizer;
        CGPoint translation = [panGesture translationInView:[self view]];
		CGPoint velocity = [panGesture velocityInView:[self view]];
        if ((velocity.x < 600) && (sqrt(translation.x * translation.x) / sqrt(translation.y * translation.y) > 1))
		{
            return YES;
        }
        
        return NO;
    }
    
    if (gestureRecognizer == [self tapGesture])
	{
		// tap gesture is only good in the side menus
		if ( [self rootViewController] != nil)
		{
			if (([self state] == GVCStackedViewControllerVisible_LEFT) || ([self state] == GVCStackedViewControllerVisible_RIGHT))
			{
				return CGRectContainsPoint([[[self rootViewController] view] bounds], [gestureRecognizer locationInView:[self view]]);
			}
        }
        
        return NO;
    }
	
    return YES;
	
}

#pragma mark - Pan Gestures

- (void)panRootView:(UIGestureRecognizer *)sender
{
}

#pragma mark - show and hide
- (void)showLeftPanel:(void (^)(BOOL completed))completion
{
	if ( [[[self leftViewController] view] superview] == nil )
	{
		[[self view] addSubview:[[self leftViewController] view]];
	}

	CGRect bounds = [[self view] bounds];
	[[[self leftViewController] view] setFrame:CGRectMake(0.0, 0.0, [self leftVisibleWidth], bounds.size.height)];
	[[[self leftViewController] view] setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
	[[self view] sendSubviewToBack:[[self leftViewController] view]];

	[UIView animateWithDuration:DEFAULT_ANIMATION_DURATION delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		[[[self leftViewController] view] setHidden:NO];

		CGFloat menuSize = [self leftVisibleWidth];
		[[[self rootViewController] view] gvc_showLeftShadow:YES withOpacity:0.8];
		[[[self rootViewController] view] setFrame:CGRectMake(menuSize, 0.0, bounds.size.width, bounds.size.height)];
	} completion:^(BOOL finished) {
		[self setState:GVCStackedViewControllerVisible_LEFT];
		if (completion) {
            completion(finished);
        }
	}];
}
- (void)showRightPanel:(void (^)(BOOL completed))completion
{
	if ( [[[self rightViewController] view] superview] == nil )
	{
		[[self view] addSubview:[[self rightViewController] view]];
	}
	
	CGRect bounds = [[self view] bounds];
	CGFloat visiblePortion = bounds.size.width - [self rightVisibleWidth];
	[[[self rightViewController] view] setFrame:CGRectMake(visiblePortion, 0, [self rightVisibleWidth], bounds.size.height)];
	
	[[[self rightViewController] view] setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
	[[self view] sendSubviewToBack:[[self rightViewController] view]];

	[UIView animateWithDuration:DEFAULT_ANIMATION_DURATION delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		[[[self rightViewController] view] setHidden:NO];

		CGFloat menuSize = (-1 * [self rightVisibleWidth]);
		[[[self rootViewController] view] gvc_showRightShadow:YES withOpacity:0.8];
		[[[self rootViewController] view] setFrame:CGRectMake(menuSize, 0.0, bounds.size.width, bounds.size.height)];
	} completion:^(BOOL finished) {
		[self setState:GVCStackedViewControllerVisible_RIGHT];

		if (completion) {
            completion(finished);
        }
	}];
}
- (void)showRootPanel:(void (^)(BOOL completed))completion
{
	if ( [[[self rootViewController] view] superview] == nil )
	{
		[[self view] addSubview:[[self rootViewController] view]];
	}
	[[[self rootViewController] view] setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
	[[[self rootViewController] view] setHidden:NO];

	[UIView animateWithDuration:DEFAULT_ANIMATION_DURATION delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		CGRect bounds = [[self view] bounds];
		[[[self rootViewController] view] gvc_showLeftShadow:NO withOpacity:0.8];
		[[[self rootViewController] view] gvc_showRightShadow:NO withOpacity:0.8];
		[[[self rootViewController] view] setFrame:CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height)];
	} completion:^(BOOL finished) {
		[self setState:GVCStackedViewControllerVisible_ROOT];
		if ( [self leftViewController] != nil )
		{
			[[[self leftViewController] view] setHidden:YES];
		}
		
		if ( [self rightViewController] != nil )
		{
			[[[self rightViewController] view] setHidden:YES];
		}

		if (completion) {
            completion(finished);
        }
	}];
}

- (void)slideRootPanel:(GVCStackedViewControllerVisible)forView completion:(void (^)(BOOL completed))completion
{
    [UIView animateWithDuration:DEFAULT_ANIMATION_DURATION delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		// slide the root view off screen
		CGRect bounds = [[self view] bounds];
		[[[self rootViewController] view] setFrame:CGRectMake(bounds.size.width,0.0,bounds.size.width,bounds.size.height)];
    } completion:^(BOOL finished) {
        if (completion) {
            completion(finished);
        }
    }];
}

// toggle them opened/closed
- (IBAction)toggleLeftPanel:(id)sender
{
	if ( [self state] == GVCStackedViewControllerVisible_LEFT )
	{
		[self showRootPanel:^(BOOL completed) {
		}];
	}
	else
	{
		[self showLeftPanel:^(BOOL completed) {
		}];
	}
}

- (IBAction)toggleRightPanel:(id)sender
{
	if ( [self state] == GVCStackedViewControllerVisible_RIGHT )
	{
		[self showRootPanel:^(BOOL completed) {
		}];
	}
	else
	{
		[self showRightPanel:^(BOOL completed) {
		}];
	}
}


@end

#pragma mark - Custom Segues
@implementation GVCStackedMenuViewSegue

- (id)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination
{
	self = [super initWithIdentifier:identifier source:source destination:destination];
    if (self != nil)
	{
		NSArray *menuSegues = @[LEFT_SEGUE_ID, RIGHT_SEGUE_ID];
		GVC_ASSERT([menuSegues containsObject:[self identifier]] == YES, @"Menu Segue identifier must be %@", menuSegues);
    }
    return self;
}

- (void)perform
{
	// The source is a container controller
	GVC_ASSERT([[self sourceViewController] isKindOfClass:[GVCStackedViewController class]], @"Wrong source controller class");
	GVCStackedViewController *container = [self sourceViewController];
	
	if ( [[self identifier] isEqualToString:LEFT_SEGUE_ID] == YES )
	{
		[container setLeftViewController:[self destinationViewController]];
	}
	else
	{
		[container setRightViewController:[self destinationViewController]];
	}
}

@end


@implementation GVCStackedRootViewSegue

- (id)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination
{
	self = [super initWithIdentifier:identifier source:source destination:destination];
    if (self != nil)
	{
    }
    return self;
}

- (void)perform
{
	// The source is a container controller
	GVC_ASSERT([[self sourceViewController] isKindOfClass:[GVCStackedViewController class]], @"Wrong source controller class");
	GVCStackedViewController *container = [self sourceViewController];
	
	[container setRootViewController:[self destinationViewController]];
}

@end

