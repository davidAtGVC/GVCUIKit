/*
 * GVCLockViewController.m
 * 
 * Created by David Aspinall on 12-06-22. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCLockViewController.h"
#import "GVCFoundation.h"

@interface GVCLockViewController ()

@end

@implementation GVCLockViewController

@synthesize statusLabel;
@synthesize lastError;
@synthesize successBlock;
@synthesize failBlock;

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
}

- (IBAction)loginAction:(id)sender 
{
    GVC_ASSERT_NOT_NIL(successBlock);
    self.successBlock(nil);
}

- (IBAction)cancelAction:(id)sender
{
    GVC_ASSERT_NOT_NIL(failBlock);
    self.failBlock([self lastError]);
}

@end
