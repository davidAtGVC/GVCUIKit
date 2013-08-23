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

GVC_DEFINE_STRVALUE(STACKED_MENU_SEGUE_ID, menuSegue);
GVC_DEFINE_STRVALUE(STACKED_DEFAULT_SEGUE_ID, defaultSegue);

@interface GVCStackedViewController ()
@property (nonatomic, copy) GVCStackedViewSegueBlock segueBlock;
@property (nonatomic, strong, readwrite) UIViewController *menuViewController;
@property (nonatomic, strong, readwrite) UIViewController *defaultViewController;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGPoint panGestureOrigin;
@end

@implementation GVCStackedViewController

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

- (void)awakeFromNib
{
	[super awakeFromNib];
	[self setViewControllerStack:[[GVCStack alloc] init]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
    [[self view] setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
	
	if ( [self menuViewController] == nil )
	{
		@try {
			[self performSegueWithIdentifier:STACKED_MENU_SEGUE_ID sender:self];
		}
		@catch (NSException *exception) {
			GVCLogError(@"Caught exception %@", exception);
		}
	}

	if ( [self defaultViewController] == nil )
	{
		@try {
			[self performSegueWithIdentifier:STACKED_DEFAULT_SEGUE_ID sender:self];
		}
		@catch (NSException *exception) {
			GVCLogError(@"Caught exception %@", exception);
		}
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self showMenuPanel:^(BOOL completed) {
		// show default view
	}];
}

#pragma mark - overrides
- (void)setMenuViewController:(UIViewController *)controller
{
    if (_menuViewController != controller)
	{
		UIViewController *previous = _menuViewController;
		_menuViewController = controller;
		
        [previous willMoveToParentViewController:nil];
        [[previous view] removeFromSuperview];
        [previous removeFromParentViewController];
		
        if (_menuViewController != nil)
		{
			[_menuViewController willMoveToParentViewController:self];
            [self addChildViewController:_menuViewController];
            [_menuViewController didMoveToParentViewController:self];
			
//			[self placeButtonsOnRootView];
        }
    }
	
//	[[self view] bringSubviewToFront:[[self rootViewController] view]];
}

- (void)setDefaultViewController:(UIViewController *)newRootController
{
	if (_defaultViewController != nil)
	{
		[_defaultViewController willMoveToParentViewController:nil];
		
		[self showNewRootController:newRootController completion:^(BOOL completed) {
			void(^transitionCompletion)(BOOL finished) = ^(BOOL finished) {
				[_defaultViewController removeFromParentViewController];
				[newRootController didMoveToParentViewController:self];
				_defaultViewController = newRootController;
				
//				[self placeButtonsOnRootView];
//				[self placePanGestureOnRootView];
				[[self view] bringSubviewToFront:[_defaultViewController view]];
			};
			
			[self transitionFromViewController:_defaultViewController
							  toViewController:newRootController
									  duration:0.2
									   options:UIViewAnimationOptionTransitionCrossDissolve
									animations:nil
									completion:transitionCompletion];
		}];
	}
	else
	{
		_defaultViewController = newRootController;
		[self showNewRootController:_defaultViewController completion:^(BOOL completed) {
//			[self placeButtonsOnRootView];
//			[self placePanGestureOnRootView];
		}];
	}
}

#pragma mark - buttons

#pragma mark - Segue
- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender prepareBlock:(GVCStackedViewSegueBlock)block
{
	[self setSegueBlock:block];
	[self performSegueWithIdentifier:identifier sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ( [self segueBlock] != nil )
	{
		GVCStackedViewSegueBlock block = [self segueBlock];
		block(segue, sender);
		[self setSegueBlock:nil];
	}
}

#pragma mark - widths
- (CGFloat)menuVisibleWidth
{
	CGRect bounds = [[self view] bounds];
	CGFloat w = [self menuViewWidth];
	if ((w <= 0.0f) || ((w >= 60.0) && (w < (bounds.size.width * 0.8f))))
	{
		// default 40%
		[self setMenuViewWidth:0.4];
		w = [self menuViewWidth];
	}
	
	return (w > 1.0) ? w : floorf( bounds.size.width * w);
}

#pragma mark - show / hide
- (IBAction)toggleMenuPanel:(id)sender
{
	
}

- (void)loadMenuPanel
{
	if ( [[[self menuViewController] view] superview] == nil )
	{
		[[self view] addSubview:[[self menuViewController] view]];
	}
	
	CGRect bounds = [[self view] bounds];
	[[[self menuViewController] view] setFrame:CGRectMake(0.0, 0.0, [self menuVisibleWidth], bounds.size.height)];
	[[[self menuViewController] view] setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
//	[[self view] sendSubviewToBack:[[self menuViewController] view]];
	[[[self menuViewController] view] setHidden:NO];
}

- (void)showMenuPanel:(void (^)(BOOL completed))completion
{
	[self loadMenuPanel];
	[[self tapGesture] setEnabled:YES];
	
	[UIView animateWithDuration:DEFAULT_ANIMATION_DURATION delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//		CGRect bounds = [[self view] bounds];
//		CGFloat menuSize = [self menuViewWidth];
//		[[[self rootViewController] view] gvc_showLeftShadow:YES withOpacity:0.8];
//		[[[self rootViewController] view] setFrame:CGRectMake(menuSize, 0.0, bounds.size.width, bounds.size.height)];
	} completion:^(BOOL finished) {
//		[self setState:GVCSlideViewControllerVisible_LEFT];
		if (completion) {
            completion(finished);
        }
	}];
}

- (void)showNewRootController:(UIViewController *)controller completion:(void (^)(BOOL completed))completion
{
	// clear out the stack, start fresh
	while ([[self viewControllerStack] isEmpty] == NO)
	{
		UIViewController *popController = (UIViewController *)[[self viewControllerStack] popObject];
		[[popController view] removeFromSuperview];
		[popController willMoveToParentViewController:nil];
		[popController removeFromParentViewController];
	}
	
	[controller willMoveToParentViewController:self];
	[self addChildViewController:controller];
	[[self view] addSubview:[controller view]];
	[controller didMoveToParentViewController:self];
	[[controller view] setNeedsLayout];
	
	[[self viewControllerStack] pushObject:controller];
	
	[[controller view] setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
	[[controller view] setHidden:NO];
	[[self tapGesture] setEnabled:NO];
	
	[UIView animateWithDuration:DEFAULT_ANIMATION_DURATION delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		CGRect bounds = [[self view] bounds];
		[[controller view] gvc_showLeftShadow:NO withOpacity:0.8];
		[[controller view] gvc_showRightShadow:NO withOpacity:0.8];
		[[controller view] setFrame:CGRectMake([self menuVisibleWidth], 0.0, (bounds.size.width - [self menuVisibleWidth]), bounds.size.height)];
		[[self view] bringSubviewToFront:[controller view]];
	} completion:^(BOOL finished) {
		if (completion) {
            completion(finished);
        }
	}];
}

@end

#pragma mark - Custom Segues
@implementation GVCStackedMenuViewSegue

- (id)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination
{
	self = [super initWithIdentifier:identifier source:source destination:destination];
    if (self != nil)
	{
		GVC_ASSERT([STACKED_MENU_SEGUE_ID isEqualToString:[self identifier]] == YES, @"Menu Segue identifier must be %@", STACKED_MENU_SEGUE_ID);
    }
    return self;
}

- (void)perform
{
	// The source is a container controller
	GVC_ASSERT([[self sourceViewController] isKindOfClass:[GVCStackedViewController class]], @"Wrong source controller class");
	GVCStackedViewController *container = [self sourceViewController];
	
	if ( [[self identifier] isEqualToString:STACKED_MENU_SEGUE_ID] == YES )
	{
		[container setMenuViewController:[self destinationViewController]];
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
	if ( [[self identifier] isEqualToString:STACKED_DEFAULT_SEGUE_ID] == YES )
	{
		[container setDefaultViewController:[self destinationViewController]];
	}
	else
	{
		// root view segue should pop all controllers off the stack
		[container showNewRootController:[self destinationViewController] completion:nil];
//		[container pushViewController:[self destinationViewController]];
		//	[container setRootViewController:[self destinationViewController]];
	}
}

@end

