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
@property (assign, nonatomic) NSUInteger failCount;
@end

@implementation GVCLoginLockViewController

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
	[self setFailCount:0];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setActivityIndicator:nil];
    [self setUsernameLabel:nil];
    [self setUsernameField:nil];
    [self setPasswordLabel:nil];
    [self setPasswordField:nil];
    [self setPasswordConfirmLabel:nil];
    [self setPasswordConfirmField:nil];
    [self setLoginButton:nil];
	[self setResetButton:nil];
	
    [super viewDidUnload];
}

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
    UILabel *strongStatusLabel = [self statusLabel];
    
    UILabel *strongUserNameLabel = [self usernameLabel];
    UILabel *strongPasswordLabel = [self passwordLabel];
    
    UITextField *strongUsernameField = [self usernameField];
    
    UITextField *strongPasswordField = [self passwordConfirmField];
    UITextField *strongPasswordConfirmField = [self passwordConfirmField];
    
    UILabel *strongPasswordConfirmLabel = [self passwordConfirmLabel];
    
    UIButton *strongLoginButton = [self loginButton];
    UIButton *strongResetButton = [self resetButton];
    
    if (strongStatusLabel != nil)
    {
        [strongStatusLabel setHidden:YES];
    }
    
    if (strongUserNameLabel != nil)
    {
        [strongUserNameLabel setText:GVC_LocalizedString(@"Username", @"Username")];
        [self setUsernameLabel:strongUserNameLabel];
    }
    
    if (strongPasswordLabel != nil)
    {
        [strongPasswordLabel setText:GVC_LocalizedString(@"Password", @"Password")];
        [self setPasswordLabel:strongPasswordLabel];
    }
    
    if (strongUsernameField != nil)
    {
        [strongUsernameField setPlaceholder:GVC_LocalizedString(@"UsernamePlaceholder", @"john")];
    }
    
    if (strongPasswordField != nil)
    {
        [strongPasswordField setPlaceholder:GVC_LocalizedString(@"PasswordPlaceholder", @"password")];
    }
	
	if (([self lockMode] == GVCLockViewControllerMode_SET) || ([self lockMode] == GVCLockViewControllerMode_CHANGE))
    {
        if (strongPasswordConfirmLabel != nil)
        {
            [strongPasswordConfirmLabel setText:GVC_LocalizedString(@"PasswordConfirm", @"Confirm Password")];
            [self setPasswordConfirmLabel:strongPasswordLabel];
        }
        
        if (strongPasswordConfirmField != nil)
        {
            [strongPasswordConfirmField setPlaceholder:GVC_LocalizedString(@"PasswordConfirmPlaceholder", @"password")];
            [strongPasswordConfirmField setSecureTextEntry:YES];
            [strongPasswordConfirmField setEnabled:YES];
            [strongPasswordConfirmField setDelegate:self];
            [self setPasswordConfirmField:strongPasswordConfirmField];
        }
        
        if (strongLoginButton != nil)
        {
            [strongLoginButton setTitle:GVC_SAVE_LABEL forState:UIControlStateNormal];
            [self setLoginButton:strongLoginButton];
        }
    }
    else
    {
        if (strongLoginButton != nil)
        {
            [strongLoginButton setTitle:GVC_LOGIN_LABEL forState:UIControlStateNormal];
        }
    }
	
    
    if (strongStatusLabel != nil)
    {
        [self setStatusLabel:strongStatusLabel];
    }
    
    if (strongUsernameField != nil)
    {
        [strongUsernameField setEnabled:YES];
        [strongUsernameField setDelegate:self];
    }
    
    if (strongPasswordField != nil)
    {
        [strongPasswordField setEnabled:YES];
        [strongPasswordField setDelegate:self];
        [strongPasswordField setSecureTextEntry:YES];
    }

    if (strongLoginButton != nil)
    {
        [strongLoginButton setEnabled:YES];
    }

    if (strongResetButton != nil)
    {
        [strongResetButton setEnabled:NO];
        [strongResetButton setHidden:YES];
    }
    
	
	
    NSString *username = [[GVCKeychain sharedGVCKeychain] secureObjectForKey:GVCLoginLockViewController_USERNAME_KEY];
	if ( username != nil )
	{
		[strongUsernameField setText:username];
	}
    
    
    if (strongUsernameField != nil)
    {
        [self setUsernameField:strongUsernameField];
    }
    
    if (strongPasswordField != nil)
    {
        [self setPasswordField:strongPasswordField];
    }
    
    if (strongLoginButton != nil)
    {
        [self setLoginButton:strongLoginButton];
    }
    
    if (strongResetButton != nil)
    {
        [self setResetButton:strongResetButton];
    }
    
    if (strongPasswordConfirmField != nil)
    {
        [self setPasswordConfirmField:strongPasswordConfirmField];
    }
    
}


- (IBAction)loginAction:(id)sender
{
    [[self view] resignFirstResponder];
    
       
    UITextField *strongUsernameField = [self usernameField];
    UITextField *strongPasswordField = [self passwordField];
    UITextField *strongPasswordConfirmField = [self passwordConfirmField];
    UIActivityIndicatorView *strongActivityIndicator = [self activityIndicator];
    
    UILabel *strongStatusLabel = [self statusLabel];

    
    UIButton *strongLoginButton = [self loginButton];
    
    if (strongActivityIndicator != nil)
    {
        [strongActivityIndicator startAnimating];
    }
    
    if (strongStatusLabel != nil)
    {
        [strongStatusLabel setHidden:NO];
        [strongStatusLabel setTextColor:[UIColor blackColor]];
        [strongStatusLabel setText:GVC_LocalizedString(@"VerifyLogin", @"Verifying ..")];
    }
    
    if (strongUsernameField != nil)
    {
        [strongUsernameField setEnabled:NO];        
    }
    
    if (strongPasswordField != nil)
    {
        [strongPasswordField setEnabled:NO];
    }
    
    if (strongLoginButton != nil)
    {
        [strongLoginButton setEnabled:NO];
    }
    
    if (([self lockMode] == GVCLockViewControllerMode_SET) || ([self lockMode] == GVCLockViewControllerMode_CHANGE))
    {
        [strongPasswordConfirmField setEnabled:NO];
    }

    NSString *failMessage = nil;
    NSString *enteredUsername = [strongUsernameField text];
    NSString *enteredPassword = [strongPasswordField text];
    NSString *enteredConfirm = [strongPasswordConfirmField text];
    NSString *username = [[GVCKeychain sharedGVCKeychain] secureObjectForKey:GVCLoginLockViewController_USERNAME_KEY];
    NSString *password = [[GVCKeychain sharedGVCKeychain] secureObjectForKey:GVCLoginLockViewController_PASSWORD_KEY];
    BOOL success = NO;
    
    if ((gvc_IsEmpty(enteredUsername) == NO) && (gvc_IsEmpty(enteredPassword) == NO))
    {
        switch ([self lockMode])
        {
            case GVCLockViewControllerMode_CHANGE:
            {
                GVC_ASSERT_NOT_EMPTY(username);
                GVC_ASSERT_NOT_EMPTY(password);
                
                if ( [enteredPassword isEqualToString:enteredConfirm] == YES )
                {
                    [[GVCKeychain sharedGVCKeychain] setSecureObject:enteredUsername forKey:GVCLoginLockViewController_USERNAME_KEY];
                    [[GVCKeychain sharedGVCKeychain] setSecureObject:enteredPassword forKey:GVCLoginLockViewController_PASSWORD_KEY];
                    success = YES;
                }
                else
                {
                    failMessage = GVC_LocalizedString(@"ConfirmPasswordMissmatch", @"Passwords do not match");
                }
                break;
            }
            case GVCLockViewControllerMode_SET:
                if ( [enteredPassword isEqualToString:enteredConfirm] == YES )
                {
                    [[GVCKeychain sharedGVCKeychain] setSecureObject:enteredUsername forKey:GVCLoginLockViewController_USERNAME_KEY];
                    [[GVCKeychain sharedGVCKeychain] setSecureObject:enteredPassword forKey:GVCLoginLockViewController_PASSWORD_KEY];
                    success = YES;
                }
                else
                {
                    failMessage = GVC_LocalizedString(@"ConfirmPasswordMissmatch", @"Passwords do not match");
                }
                break;
            case GVCLockViewControllerMode_UNLOCK:
            {
                GVC_ASSERT_NOT_EMPTY(username);
                GVC_ASSERT_NOT_EMPTY(password);
                
                success = (([[strongUsernameField text] isEqualToString:username]) && ([[strongPasswordField text] isEqualToString:password]));
                if ( success == NO )
                {
                    failMessage = GVC_LocalizedString(@"LoginFailed", @"Login Failed");
                }
                break;
            }
            case GVCLockViewControllerMode_REMOVE:
                if (([[strongUsernameField text] isEqualToString:username]) && ([[strongPasswordField text] isEqualToString:password]))
                {
                    [[GVCKeychain sharedGVCKeychain] removeSecureObjectForKey:GVCLoginLockViewController_USERNAME_KEY];
                    [[GVCKeychain sharedGVCKeychain] removeSecureObjectForKey:GVCLoginLockViewController_PASSWORD_KEY];
                }
                else
                {
                    failMessage = GVC_LocalizedString(@"LoginFailed", @"Login Failed");
                }

                break;
                
            default:
                break;
        }
    }
    else
    {
        failMessage = GVC_LocalizedString(@"MissingUsernameOrPassword", @"Please enter username and password");
    }
                    
    
    if ( success == YES )
	{
        [self performSelector:@selector(simulatedSuccess:) withObject:nil afterDelay:0.5];
	}
    else
    {
        [self performSelector:@selector(simulatedFail:) withObject:failMessage afterDelay:1.5];
	}
    
//   Set instance variables based on strong local variables

    if (strongActivityIndicator != nil)
    {
        [self setActivityIndicator:strongActivityIndicator];
    }

    if (strongUsernameField != nil)
    {
        [self setUsernameField:strongUsernameField];
    }

    if (strongStatusLabel != nil)
    {
        [self setStatusLabel:strongStatusLabel];
    }

    if (strongPasswordField != nil)
    {
        [self setPasswordField:strongPasswordField];
    }

    if (strongPasswordConfirmField != nil)
    {
        [self setPasswordConfirmField:strongPasswordConfirmField];
    }

    if (strongLoginButton != nil)
    {
        [self setLoginButton:strongLoginButton];
    }


}

- (void)simulatedSuccess:(NSString *)message
{
	[self setFailCount:0];
    
    
    UITextField *strongUsernameField = [self usernameField];
    UITextField *strongPasswordField = [self passwordField];
    UITextField *strongPasswordConfirmField = [self passwordConfirmField];
    UIButton *strongLoginButton = [self loginButton];

    UIActivityIndicatorView *strongActivityIndicator = [self activityIndicator];
    
    UILabel *strongStatusLabel = [self statusLabel];

    if (strongUsernameField != nil)
    {
        [strongUsernameField setEnabled:YES];
        [self setUsernameField:strongUsernameField];
    }
  
    if (strongPasswordField != nil)
    {
        [strongPasswordField setEnabled:YES];
        [self setPasswordField:strongPasswordField];
    }
  
    if (strongPasswordConfirmField != nil)
    {
        [strongPasswordConfirmField setEnabled:YES];
        [self setPasswordConfirmField:strongPasswordConfirmField];
    }
  
    if (strongLoginButton != nil)
    {
        [strongLoginButton setEnabled:YES];
        [self setLoginButton:strongLoginButton];
    }

    if (strongActivityIndicator != nil)
    {
        [strongActivityIndicator stopAnimating];
        [self setActivityIndicator:strongActivityIndicator];
    }
    
    if (strongStatusLabel != nil)
    {
        [strongStatusLabel setTextColor:[UIColor darkGrayColor]];
        [strongStatusLabel setText:(gvc_IsEmpty(message) ? @"Success" : message)];
        [self setStatusLabel:strongStatusLabel];
    }

    [super loginAction:nil];
}

- (void)simulatedFail:(NSString *)message 
{
    
    UITextField *strongUsernameField = [self usernameField];
    UITextField *strongPasswordField = [self passwordField];
    UITextField *strongPasswordConfirmField = [self passwordConfirmField];
    
    UIButton *strongLoginButton = [self loginButton];
    UIButton *strongResetButton = [self resetButton];
    
    UIActivityIndicatorView *strongActivityIndicator = [self activityIndicator];
    
    UILabel *strongStatusLabel = [self statusLabel];
    
    if (strongUsernameField != nil)
    {
        [strongUsernameField setEnabled:YES];
        [self setUsernameField:strongUsernameField];
    }
    
    if (strongPasswordField != nil)
    {
        [strongPasswordField setEnabled:YES];
        [strongPasswordField becomeFirstResponder];
        [self setPasswordField:strongPasswordField];
    }
    
    if (strongPasswordConfirmField != nil)
    {
        [strongPasswordConfirmField setEnabled:YES];
        [self setPasswordConfirmField:strongPasswordConfirmField];
    }
    
    if (strongLoginButton != nil)
    {
        [strongLoginButton setEnabled:YES];
        [self setLoginButton:strongLoginButton];
    }
    
    if (strongActivityIndicator != nil)
    {
        [strongActivityIndicator stopAnimating];
        [self setActivityIndicator:strongActivityIndicator];
    }
    
    if (strongStatusLabel != nil)
    {
        [strongStatusLabel setTextColor:[UIColor redColor]];
        [strongStatusLabel setText:(gvc_IsEmpty(message) ? @"Fail" : message)];
        [self setStatusLabel:strongStatusLabel];
    }

	[self setFailCount:[self failCount]+1];

	if ( [self failCount] > 3 )
	{
        if (strongResetButton != nil)
        {
            [strongResetButton setTitle:@"Reset login" forState:UIControlStateNormal];
            [strongResetButton setEnabled:YES];
            [strongResetButton setHidden:NO];
            [self setResetButton:strongResetButton];
        }
       
	}
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UITextField *strongPasswordField = [self passwordField];
    UITextField *strongPasswordConfirmField = [self passwordConfirmField];
    
    if ( textField == [self usernameField] )
    {
        if (strongPasswordField != nil)
        {
            [strongPasswordField becomeFirstResponder];
        }
    }
    else if ( textField == [self passwordField] )
    {
        if ( strongPasswordConfirmField == nil )
        {
            [self loginAction:textField];
        }
        else
        {
            [strongPasswordConfirmField becomeFirstResponder];
        }
    }
    else 
    {
        [self loginAction:textField];
    }
    
    [self setPasswordField:strongPasswordField];
    [self setPasswordConfirmField:strongPasswordConfirmField];
    
    return YES;
}

- (IBAction)removeLockAction:(id)sender
{
	[[GVCKeychain sharedGVCKeychain] removeSecureObjectForKey:GVCLoginLockViewController_USERNAME_KEY];
	[[GVCKeychain sharedGVCKeychain] removeSecureObjectForKey:GVCLoginLockViewController_PASSWORD_KEY];
	[self performSelector:@selector(simulatedSuccess:) withObject:nil afterDelay:0.5];
}

@end
