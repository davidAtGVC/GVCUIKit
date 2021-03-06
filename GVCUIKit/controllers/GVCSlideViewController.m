//
//  GVCSlideViewController.m
//  GVCUIKit
//
//  Created by David Aspinall on 2013-03-27.
//
//

#import <QuartzCore/QuartzCore.h>

#import "GVCSlideViewController.h"

#import "UIView+GVCUIKit.h"
#import "UIImage+GVCUIKit.h"

#define DEFAULT_ANIMATION_DURATION 0.3

typedef enum {
    GVCSlideViewControllerVisible_ROOT = 1,
    GVCSlideViewControllerVisible_LEFT,
    GVCSlideViewControllerVisible_RIGHT
} GVCSlideViewControllerVisible;

GVC_DEFINE_STRVALUE(SLIDE_RIGHT_SEGUE_ID, rightSegue);
GVC_DEFINE_STRVALUE(SLIDE_LEFT_SEGUE_ID, leftSegue);
GVC_DEFINE_STRVALUE(SLIDE_DEFAULT_SEGUE_ID, defaultSegue);

@interface GVCSlideViewController ()
@property (nonatomic, copy) GVCSlideViewSegueBlock segueBlock;
@property (nonatomic, strong, readwrite) UIViewController *leftViewController;
@property (nonatomic, strong, readwrite) UIViewController *rootViewController;
@property (nonatomic, strong, readwrite) UIViewController *rightViewController;

@property (nonatomic, assign) GVCSlideViewControllerVisible state;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGPoint panGestureOrigin;
@property (nonatomic, assign) GVCSlideViewControllerVisible panningState;
@end

@implementation GVCSlideViewController

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
	[self setState:GVCSlideViewControllerVisible_ROOT];

	if ( [self leftViewController] == nil )
	{
		@try {
			[self performSegueWithIdentifier:SLIDE_LEFT_SEGUE_ID sender:self];
		}
		@catch (NSException *exception) {
			GVCLogError(@"Caught exception %@", exception);
		}
	}
	
	if ( [self rightViewController] == nil )
	{
		@try {
			[self performSegueWithIdentifier:SLIDE_RIGHT_SEGUE_ID sender:self];
		}
		@catch (NSException *exception) {
			GVCLogError(@"Caught exception %@", exception);
		}
	}
	
	if ( [self rootViewController] == nil)
	{
		[self performSegueWithIdentifier:SLIDE_DEFAULT_SEGUE_ID sender:self];
	}
	
	CGRect bounds = [[self view] bounds];
	[[[self rootViewController] view] setFrame:CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height)];

	if ([self tapGesture] == nil)
	{
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(performTapGesture:)];
        [tap setDelegate:self];
        [[self view] addGestureRecognizer:tap];
        [tap setEnabled:NO];
        [self setTapGesture:tap];
    }
}

#pragma mark - child view controllers

- (void)setRootViewController:(UIViewController *)newRootController
{
	if (_rootViewController != nil)
	{
		[_rootViewController willMoveToParentViewController:nil];
		[self addChildViewController:newRootController];

		[self showRootPanel:^(BOOL completed) {
			void(^transitionCompletion)(BOOL finished) = ^(BOOL finished) {
				[_rootViewController removeFromParentViewController];
				[newRootController didMoveToParentViewController:self];
				_rootViewController = newRootController;
				
				[self placeButtonsOnRootView];
				[self placePanGestureOnRootView];
				[[self view] bringSubviewToFront:[_rootViewController view]];
			};
			
			[self transitionFromViewController:_rootViewController
							  toViewController:newRootController
									  duration:0.2
									   options:UIViewAnimationOptionTransitionCrossDissolve
									animations:nil
									completion:transitionCompletion];
		}];
	}
	else
	{
		_rootViewController = newRootController;
		
		[self addChildViewController:_rootViewController];
		[[self view] addSubview:[_rootViewController view]];
		[_rootViewController didMoveToParentViewController:self];

		[self showRootPanel:^(BOOL completed) {
			[self placeButtonsOnRootView];
			[self placePanGestureOnRootView];
			[[self view] bringSubviewToFront:[_rootViewController view]];
		}];
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
			UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage gvc_hamburgerControlImage] style:UIBarButtonItemStylePlain target:self action:@selector(toggleLeftPanel:)];
			[[topViewController navigationItem] setLeftBarButtonItem:button];
		}

		if ([self rightViewController] != nil)
		{
			UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage gvc_hamburgerControlImage] style:UIBarButtonItemStylePlain target:self action:@selector(toggleRightPanel:)];
			[[topViewController navigationItem] setRightBarButtonItem:button];
		}
	}
}

- (void)placePanGestureOnRootView
{
	//        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(performPanGesture:)];
	//        [pan setDelegate:(id<UIGestureRecognizerDelegate>)self];
	//        [[_rootViewController view] addGestureRecognizer:pan];
	//		[self setPanGesture:pan];

    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(performPanGesture:)];
    [panGesture setDelegate:self];
//    [panGesture setMaximumNumberOfTouches:1];
//    [panGesture setMinimumNumberOfTouches:1];
	[self setPanGesture:panGesture];
	
    [[[self rootViewController] view] addGestureRecognizer:[self panGesture]];
}


#pragma mark - Gesture Recognizer Delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	BOOL isValid = NO;
    if (gestureRecognizer == [self panGesture])
	{
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer*)gestureRecognizer;
        CGPoint translate = [panGesture translationInView:[[self rootViewController] view]];
        if (translate.x < 0)
		{
			// pan right is only allowed if the right controller is set
            isValid = ([self state] == GVCSlideViewControllerVisible_LEFT) || ([self rightViewController] != nil);
        }
		else if (translate.x > 0)
		{
			// pan left is only allowed if the left controller is set
            isValid = ([self state] == GVCSlideViewControllerVisible_RIGHT) || ([self leftViewController] != nil);
        }
		else
		{
//			BOOL possible = translate.x != 0 && ((fabsf(translate.y) / fabsf(translate.x)) < 1.0f);
//			if (possible && ((translate.x > 0 && self.leftPanel) || (translate.x < 0 && self.rightPanel))) {
//				return YES;
//			}
		}
    }
	else if ( gestureRecognizer == [self tapGesture])
	{
		isValid = CGRectContainsPoint([[[self rootViewController] view] frame], [gestureRecognizer locationInView:[self view]]);
	}

    return isValid;
	
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gesture shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)other
{
    return (gesture == [self tapGesture]);
}

#pragma mark - Gestures

- (void)performTapGesture:(UIGestureRecognizer *)gesture
{
	[[self tapGesture] setEnabled:NO];
	[self showRootPanel:^(BOOL completed) {
		// nothing
	}];
}

- (void)performPanGesture:(UIGestureRecognizer *)gesture
{
	UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gesture;
	
    UIView *panningView = [panGesture view];
    UIView *rootView = [[self rootViewController] view];
	CGRect bounds = [[self view] bounds];

	if ([panGesture state] == UIGestureRecognizerStateBegan)
	{
//		CGPoint translation = [panGesture translationInView:[self view]];
		[self setPanGestureOrigin:[rootView gvc_frameOrigin]];
		
		// default is unchanged state
		[self setPanningState:[self state]];
	}

	if ([panGesture velocityInView:panningView].x > 0)
	{
		if ( [self state] == GVCSlideViewControllerVisible_RIGHT)
		{
			// if right is visible, then the taget is ROOT
			[self setPanningState:GVCSlideViewControllerVisible_ROOT];
		}
		else
		{
			[self setPanningState:GVCSlideViewControllerVisible_LEFT];
			[self loadLeftPanel];
		}
	}
	else
	{
		if ( [self state] == GVCSlideViewControllerVisible_LEFT)
		{
			// if left is visible, then the taget is ROOT
			[self setPanningState:GVCSlideViewControllerVisible_ROOT];
		}
		else
		{
			[self setPanningState:GVCSlideViewControllerVisible_RIGHT];
			[self loadRightPanel];
		}
	}
	
	CGPoint translation = [panGesture translationInView:[self view]];
	CGRect rootFrame = [rootView frame];
	CGFloat newX = [self panGestureOrigin].x + translation.x;
	if ((newX > 0.0) && ([self leftViewController] == nil))
	{
		newX = rootFrame.origin.x;
	}
	else
	{
		[[[self rootViewController] view] gvc_showLeftShadow:YES withOpacity:0.8];
	}
	
	if ((newX < 0.0) && ([self rightViewController] == nil))
	{
		newX = rootFrame.origin.x;
	}
	else
	{
		[[[self rootViewController] view] gvc_showRightShadow:YES withOpacity:0.8];
	}
	
	[rootView setFrame:CGRectMake(newX, 0.0f, rootFrame.size.width, rootFrame.size.height)];
			
	if ([panGesture state] == UIGestureRecognizerStateEnded)
	{
		CGFloat minimum = floorf(bounds.size.width * 0.15f);
		
		if ([self panningState] == GVCSlideViewControllerVisible_RIGHT)
		{
			if (((-1 * translation.x) > minimum ) && ([self rightViewController] != nil))
			{
				[self showRightPanel:nil];
			}
			else
			{
				[self showRootPanel:nil];
			}
		}
		else if ([self panningState] == GVCSlideViewControllerVisible_LEFT)
		{
			if ((translation.x > minimum) && ([self leftViewController] != nil))
			{
				[self showLeftPanel:nil];
			}
			else
			{
				[self showRootPanel:nil];
			}
		}
		else
		{
			[self showRootPanel:nil];
		}
	}

	if ([panGesture state] == UIGestureRecognizerStateCancelled)
	{
		if ( [self state] == GVCSlideViewControllerVisible_LEFT)
		{
			[self showLeftPanel:nil];
		}
		else if ( [self state] == GVCSlideViewControllerVisible_RIGHT)
		{
			[self showRightPanel:nil];
		}
		else
		{
			[self showRootPanel:nil];
		}
	}
}

#pragma mark - show and hide
- (void)loadLeftPanel
{
	if ( [[[self leftViewController] view] superview] == nil )
	{
		[[self view] addSubview:[[self leftViewController] view]];
	}
	
	CGRect bounds = [[self view] bounds];
	[[[self leftViewController] view] setFrame:CGRectMake(0.0, 0.0, [self leftVisibleWidth], bounds.size.height)];
	[[[self leftViewController] view] setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
	[[self view] sendSubviewToBack:[[self leftViewController] view]];
	[[[self leftViewController] view] setHidden:NO];
}

- (void)loadRightPanel
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
	[[[self rightViewController] view] setHidden:NO];
}

- (void)showLeftPanel:(void (^)(BOOL completed))completion
{
	[self loadLeftPanel];
	[[self tapGesture] setEnabled:YES];

	[UIView animateWithDuration:DEFAULT_ANIMATION_DURATION delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		CGRect bounds = [[self view] bounds];
		CGFloat menuSize = [self leftVisibleWidth];
		[[[self rootViewController] view] gvc_showLeftShadow:YES withOpacity:0.8];
		[[[self rootViewController] view] setFrame:CGRectMake(menuSize, 0.0, bounds.size.width, bounds.size.height)];
	} completion:^(BOOL finished) {
		[self setState:GVCSlideViewControllerVisible_LEFT];
		if (completion) {
            completion(finished);
        }
	}];
}
- (void)showRightPanel:(void (^)(BOOL completed))completion
{
	[self loadRightPanel];
	[[self tapGesture] setEnabled:YES];

	[UIView animateWithDuration:DEFAULT_ANIMATION_DURATION delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		[[[self rightViewController] view] setHidden:NO];

		CGRect bounds = [[self view] bounds];
		CGFloat menuSize = (-1 * [self rightVisibleWidth]);
		[[[self rootViewController] view] gvc_showRightShadow:YES withOpacity:0.8];
		[[[self rootViewController] view] setFrame:CGRectMake(menuSize, 0.0, bounds.size.width, bounds.size.height)];
	} completion:^(BOOL finished) {
		[self setState:GVCSlideViewControllerVisible_RIGHT];

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
	[[self tapGesture] setEnabled:NO];

	[UIView animateWithDuration:DEFAULT_ANIMATION_DURATION delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		CGRect bounds = [[self view] bounds];
		[[[self rootViewController] view] gvc_showLeftShadow:NO withOpacity:0.8];
		[[[self rootViewController] view] gvc_showRightShadow:NO withOpacity:0.8];
		[[[self rootViewController] view] setFrame:CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height)];
	} completion:^(BOOL finished) {
		[self setState:GVCSlideViewControllerVisible_ROOT];
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

- (void)slideRootPanel:(GVCSlideViewControllerVisible)forView completion:(void (^)(BOOL completed))completion
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
	if ( [self state] == GVCSlideViewControllerVisible_LEFT )
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
	if ( [self state] == GVCSlideViewControllerVisible_RIGHT )
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

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender prepareBlock:(GVCSlideViewSegueBlock)block
{
	[self setSegueBlock:block];
	[self performSegueWithIdentifier:identifier sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ( [self segueBlock] != nil )
	{
		GVCSlideViewSegueBlock block = [self segueBlock];
		block(segue, sender);
		[self setSegueBlock:nil];
	}
}

@end

#pragma mark - Custom Segues
@implementation GVCSlideMenuViewSegue

- (id)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination
{
	self = [super initWithIdentifier:identifier source:source destination:destination];
    if (self != nil)
	{
		NSArray *menuSegues = @[SLIDE_LEFT_SEGUE_ID, SLIDE_RIGHT_SEGUE_ID];
		GVC_ASSERT([menuSegues containsObject:[self identifier]] == YES, @"Menu Segue identifier must be %@", menuSegues);
    }
    return self;
}

- (void)perform
{
	// The source is a container controller
	GVC_ASSERT([[self sourceViewController] isKindOfClass:[GVCSlideViewController class]], @"Wrong source controller class");
	GVCSlideViewController *container = [self sourceViewController];
	
	if ( [[self identifier] isEqualToString:SLIDE_LEFT_SEGUE_ID] == YES )
	{
		[container setLeftViewController:[self destinationViewController]];
	}
	else
	{
		[container setRightViewController:[self destinationViewController]];
	}
}

@end


@implementation GVCSlideRootViewSegue

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
	GVC_ASSERT([[self sourceViewController] isKindOfClass:[GVCSlideViewController class]], @"Wrong source controller class");
	GVCSlideViewController *container = [self sourceViewController];
	
	[container setRootViewController:[self destinationViewController]];
}

@end

