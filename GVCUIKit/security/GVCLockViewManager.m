//
//  GVCLockViewManager.m
//  GVCUIKit
//
//  Created by David Aspinall on 2013-06-28.
//
//

#import "GVCLockViewManager.h"

GVC_DEFINE_STR(GVCLockViewManager_splashOnResume);
GVC_DEFINE_STR(GVCLockViewManager_lockdownDelay);
GVC_DEFINE_STR(GVCLockViewManager_lockdownType);

GVC_DEFINE_STR(GVCLockViewManager_timerStart);


@interface GVCLockViewManager ()
@property (nonatomic, strong) UIViewController *currentModalViewController;
@end


@implementation GVCLockViewManager

GVC_SINGLETON_CLASS(GVCLockViewManager);

- (id)init
{
	self = [super init];
	if ( self != nil )
	{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startBackgroundTimer) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeSplashScreen) name:UIApplicationDidBecomeActiveNotification object:nil];
		
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		
		[self setSplashOnResume:[userDefaults boolForKey:GVCLockViewManager_splashOnResume]];
		[self setLockDownDelayInSeconds:[userDefaults integerForKey:GVCLockViewManager_lockdownDelay]];
    }
    return self;
}

#pragma mark - instance variables
- (GVCLockViewManager_TYPE)lockType
{
	return ([self lockDownDelayInSeconds] == 0 ? GVCLockViewManager_TYPE_always : GVCLockViewManager_TYPE_delay);
}

- (void)setSplashOnResume:(BOOL)splashOnResume
{
	_splashOnResume = splashOnResume;
	[[NSUserDefaults standardUserDefaults] setBool:splashOnResume forKey:GVCLockViewManager_splashOnResume];
}

- (void)setLockDownDelayInSeconds:(NSInteger)delay
{
	if ((delay < 0) || (delay > (60*60)))
	{
		delay = 300;
	}
	_lockDownDelayInSeconds = delay;
	[[NSUserDefaults standardUserDefaults] setInteger:delay forKey:GVCLockViewManager_lockdownDelay];
}

#pragma mark - UI
- (void)forceLoginViewForActiveApplication
{
	UIViewController *loginController = nil;
	if ( [self loginViewControllerBlock] != nil )
	{
		GVCLockViewManager_ShowLoginBlock block = [self loginViewControllerBlock];
		loginController = block();
		
		UIViewController *viewController;
		if (([self currentModalViewController] != nil) && ([[self currentModalViewController] presentingViewController] != nil))
		{
			viewController = [self currentModalViewController];
		}
		else
		{
			viewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
		}
		
		[viewController presentViewController:loginController animated:NO completion:nil];
	}
}

- (void)presentLoginViewForActiveApplication
{
    if (([self lockType] == GVCLockViewManager_TYPE_always) || ([self timeSinceBackground] >= [self lockDownDelayInSeconds]))
	{
		[self forceLoginViewForActiveApplication];
    }
}

- (void) registerViewControllerIfModal:(UIViewController *)controller
{
    if ([controller presentingViewController] != nil)
	{
		[self setCurrentModalViewController:controller];
    }
}

#pragma mark - Private Methods

- (void) startBackgroundTimer
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:GVCLockViewManager_timerStart];
    [self showSplashScreen];
}

- (NSTimeInterval)timeSinceBackground
{
    return [[NSDate date] timeIntervalSinceDate:[[NSUserDefaults standardUserDefaults] objectForKey:GVCLockViewManager_timerStart]];
}

#pragma mark Splash Screen management
- (void) showSplashScreen
{
    if ([self splashOnResume] == YES)
	{
        UIView *topView = [[[[UIApplication sharedApplication] keyWindow] subviews] lastObject];
        [topView endEditing:YES];
		
        // Don't show a splash screen if the application is in UIApplicationStateInactive (lock/power button press)
        UIApplication *application = [UIApplication sharedApplication];
        if ([application applicationState] == UIApplicationStateBackground)
		{
            UIImageView *splash = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default"]];
            [splash setFrame:[[application keyWindow] bounds]];
            [[application keyWindow] addSubview:splash];
        }
    }
}

- (void) removeSplashScreen
{
    if ([self splashOnResume] == YES)
	{
        UIWindow *thewindow = [[UIApplication sharedApplication] keyWindow];
        if ([[thewindow subviews] count] > 1)
		{
            [NSThread sleepForTimeInterval:1.0];
            [[[thewindow subviews] lastObject] removeFromSuperview];
        }
    }
}

@end
