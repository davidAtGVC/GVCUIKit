
#import "GVCUIViewController.h"
#import "GVCUIKitFunctions.h"

@interface GVCUIViewController ()
-(void) keyboardWillShow:(NSNotification *)notification;
-(void) keyboardDidShow:(NSNotification *)notification;
-(void) keyboardDidHide:(NSNotification *)notification;
-(void) keyboardWillHide:(NSNotification *)notification;
@end


@implementation GVCUIViewController

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self != nil)
	{
		[self setAutoresizesForKeyboard:NO];
	}
	return self;
}

- (NSString *)viewTitle
{
	return GVC_LocalizedClassString(GVC_DEFAULT_VIEW_TITLE, GVC_CLASSNAME(self));
}

#pragma mark - UIViewController

-(void) viewWillAppear:(BOOL)animated 
{
	[super viewWillAppear:animated];

	if ([self autoresizesForKeyboard] == YES)
	{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:)  name:UIKeyboardDidShowNotification  object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:)  name:UIKeyboardDidHideNotification  object:nil];
	}
}

-(void) viewDidAppear:(BOOL)animated 
{
	[super viewDidAppear:animated];
	[[[self navigationBar] topItem] setTitle:[self viewTitle]];
}

-(void) viewWillDisappear:(BOOL)animated 
{
	[super viewWillDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification  object:nil];
}

-(void) viewDidDisappear:(BOOL)animated 
{
	[super viewDidDisappear:animated];
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		return YES;
	}

	return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration 
{
	return [super willAnimateRotationToInterfaceOrientation:fromInterfaceOrientation duration:duration];
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation 
{
	return [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (UINavigationBar *)navigationBar
{
	return [[self navigationController] navigationBar];
}

- (IBAction)dismissModalViewController:(id)sender
{
    UIViewController *target = nil;
    UINavigationController *navController = [self navigationController] ;
    if ( navController == nil )
    {
        target = [self parentViewController];
        if (target != nil)
        {
            if ([target isKindOfClass:[UINavigationController class]] == YES )
            {
                navController = (UINavigationController *)target;
            }
            else
            {
                navController = [target navigationController];
            }
        }
        else
        {
            target = [self presentingViewController];
            if (target != nil)
            {
                if ([target isKindOfClass:[UINavigationController class]] == YES )
                {
                    navController = (UINavigationController *)target;
                }
                else if ( [target navigationController] != nil )
                {
                    navController = [target navigationController];
                }
            }
        }
    }
    [navController dismissViewControllerAnimated:YES completion:^(){
        if ([[self callbackDelegate] respondsToSelector:NSSelectorFromString(@"tableView")] == YES ) 
        {
            id tv = [[self callbackDelegate] valueForKey:@"tableView"];
            if ((tv != nil) && ([tv isKindOfClass:[UITableView class]] == YES))
                [(UITableView *)tv reloadData];
        }
    }];
}


#pragma mark - UIKeyboardNotifications

- (UIView *)keyboardResizeView
{
	return [self view];
}

-(void) resizeForKeyboard:(NSNotification *)notification appearing:(BOOL)appearing 
{
	NSDictionary *userInfo = [notification userInfo];
	
	// Get the ending frame rect
	NSValue *frameEndValue	= [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGRect keyboardRect = [frameEndValue CGRectValue];
	
	// Convert to window coordinates
	CGRect keyboardFrame = [[self keyboardResizeView] convertRect:keyboardRect fromView:nil];
	
	NSNumber *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
	BOOL animated = ([animationDurationValue doubleValue] > 0.0) ? YES : NO; 

	if (animated == YES) 
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:[animationDurationValue doubleValue]];
	}
	
	if (appearing == YES) 
	{
		[self keyboardWillAppear:animated withBounds:keyboardFrame];
		[self keyboardWillAppear:animated withBounds:keyboardFrame animationDuration:[animationDurationValue doubleValue]];
	}
	else 
	{
		[self keyboardDidDisappear:animated withBounds:keyboardFrame];
	}
	
	if (animated == YES) 
	{
		[UIView commitAnimations];
	}
}

-(void) keyboardWillShow:(NSNotification *)notification 
{
//	if ([self isViewAppearing] == YES) 
	{
		[self resizeForKeyboard:notification appearing:YES];
	}
}

-(void) keyboardDidShow:(NSNotification *)notification 
{
	CGRect frameStart;
	[[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&frameStart];
	
	CGRect keyboardBounds = CGRectMake(0, 0, frameStart.size.width, frameStart.size.height);
	[self keyboardDidAppear:YES withBounds:keyboardBounds];
}

-(void) keyboardDidHide:(NSNotification *)notification 
{
//	if ([self isViewAppearing] == YES) 
	{
		[self resizeForKeyboard:notification appearing:NO];
	}
}

-(void) keyboardWillHide:(NSNotification *)notification 
{
	CGRect frameEnd;
	[[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&frameEnd];
	CGRect keyboardBounds = CGRectMake(0, 0, frameEnd.size.width, frameEnd.size.height);
	
	NSTimeInterval animationDuration;
	NSValue *animationDurationValue = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
	[animationDurationValue getValue:&animationDuration];
	[self keyboardWillDisappear:YES withBounds:keyboardBounds];
	[self keyboardWillDisappear:YES withBounds:keyboardBounds animationDuration:animationDuration];
}


#pragma mark - API

-(void) keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds 
{
	if ( [[self keyboardResizeView] isKindOfClass:[UIScrollView class]] == YES )
	{
		UIEdgeInsets e = UIEdgeInsetsMake(0, 0, bounds.size.height, 0);
		
		[(UIScrollView *)[self keyboardResizeView] setContentInset:e];
		[(UIScrollView *)[self keyboardResizeView] setScrollIndicatorInsets:e];
	}
}

-(void) keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds animationDuration:(NSTimeInterval)aDuration 
{

}

-(void) keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds 
{
	if ( [[self keyboardResizeView] isKindOfClass:[UIScrollView class]] == YES )
	{
		[(UIScrollView *)[self keyboardResizeView] setContentInset:UIEdgeInsetsZero];
		[(UIScrollView *)[self keyboardResizeView] setScrollIndicatorInsets:UIEdgeInsetsZero];
	}
}

-(void) keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds animationDuration:(NSTimeInterval)aDuration 
{

}

-(void) keyboardDidAppear:(BOOL)animated withBounds:(CGRect)bounds 
{
}

-(void) keyboardDidDisappear:(BOOL)animated withBounds:(CGRect)bounds 
{
}

@end
