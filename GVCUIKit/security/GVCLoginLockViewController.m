/*
 * GVCLoginLockViewController.m
 * 
 * Created by David Aspinall on 12-06-22. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCLoginLockViewController.h"

GVC_DEFINE_STRVALUE(GVCLoginLockViewController_USERNAME_KEY, username);
GVC_DEFINE_STRVALUE(GVCLoginLockViewController_PASSWORD_KEY, password);

@interface GVCLoginLockViewController ()
- (void)simulatedSuccess:(id)sender;
- (void)simulatedFail:(id)sender;
@end

@implementation GVCLoginLockViewController

@synthesize activityIndicator;
@synthesize usernameLabel;
@synthesize passwordLabel;
@synthesize usernameField;
@synthesize passwordField;
@synthesize loginButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) 
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setActivityIndicator:nil];
    [self setUsernameLabel:nil];
    [self setUsernameField:nil];
    [self setPasswordLabel:nil];
    [self setPasswordField:nil];
    [self setLoginButton:nil];

    [super viewDidUnload];
}

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[[self usernameLabel] setText:GVC_LocalizedString(@"Username", @"Username")];
	[[self passwordLabel] setText:GVC_LocalizedString(@"Password", @"Password")];
	[[self usernameField] setPlaceholder:GVC_LocalizedString(@"UsernamePlaceholder", @"john")];
	[[self passwordField] setPlaceholder:GVC_LocalizedString(@"PasswordPlaceholder", @"password")];
	[[self passwordField] setSecureTextEntry:YES];
	
	[[self loginButton] setTitle:GVC_LOGIN_LABEL forState:UIControlStateNormal];
	
	[[self usernameField] setEnabled:YES];
	[[self passwordField] setEnabled:YES];
	[[self loginButton] setEnabled:YES];
	
    NSString *username = [[GVCKeychain sharedGVCKeychain] secureObjectForKey:GVCLoginLockViewController_USERNAME_KEY];
	if ( username != nil )
	{
		[[self usernameField] setText:username];
	}
}


- (IBAction)loginAction:(id)sender 
{
    [[self view] resignFirstResponder];

    [[self usernameField] setEnabled:NO];
	[[self passwordField] setEnabled:NO];
	[[self loginButton] setEnabled:NO];

    [[self activityIndicator] startAnimating];
	[[self statusLabel] setText:GVC_LocalizedString(@"VerifyLogin", @"Verifying ..")];
    
    NSString *username = [[GVCKeychain sharedGVCKeychain] secureObjectForKey:GVCLoginLockViewController_USERNAME_KEY];
    NSString *password = [[GVCKeychain sharedGVCKeychain] secureObjectForKey:GVCLoginLockViewController_PASSWORD_KEY];
    GVC_ASSERT_VALID_STRING(username);
    GVC_ASSERT_VALID_STRING(password);
    if (([[[self usernameField] text] isEqualToString:username]) && ([[[self passwordField] text] isEqualToString:password]))
	{
        [self performSelector:@selector(simulatedSuccess:) withObject:sender afterDelay:0.5];
	}
    else
    {
        [self performSelector:@selector(simulatedFail:) withObject:sender afterDelay:0.5];
	}

}

- (void)simulatedSuccess:(id)sender 
{
    [super loginAction:nil];
}

- (void)simulatedFail:(id)sender 
{
    [[self usernameField] setEnabled:YES];
	[[self passwordField] setEnabled:YES];
	[[self loginButton] setEnabled:YES];
    
	[activityIndicator stopAnimating];
	[[self statusLabel] setText:GVC_LocalizedString(@"LoginFailed", @"Login Failed")];
}

@end
