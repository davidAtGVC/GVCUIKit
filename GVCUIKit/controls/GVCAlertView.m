//
//  GVCAlertView.m
//  GVCUIKit
//
//  Created by David Aspinall on 2012-12-17.
//
//

#import "GVCAlertView.h"

@implementation GVCAlertView

+ (id)alertWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle okTitle:(NSString *)okTitle dismissBlock:(GVCAlertViewDismissBlock)disBlock okBlock:(GVCAlertViewOKBlock)oBlock
{
	return [[self alloc] initWithTitle:title message:message dismissTitle:dismissTitle okTitle:okTitle dismissBlock:disBlock okBlock:oBlock];
}

+ (void)showWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle okTitle:(NSString *)okTitle dismissBlock:(GVCAlertViewDismissBlock)disBlock okBlock:(GVCAlertViewOKBlock)oBlock
{
	GVCAlertView *alert = [[self alloc] initWithTitle:title message:message dismissTitle:dismissTitle okTitle:okTitle dismissBlock:disBlock okBlock:oBlock];
	[alert show];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle okTitle:(NSString *)okTitle dismissBlock:(GVCAlertViewDismissBlock)disBlock okBlock:(GVCAlertViewOKBlock)oBlock
{
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:dismissTitle otherButtonTitles:okTitle, nil];
    
    if (self != nil)
	{
		[self setDismissBlock:disBlock];
		[self setOkBlock:oBlock];
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle dismissBlock:(GVCAlertViewDismissBlock)disBlock
{
	return [self initWithTitle:title message:message dismissTitle:dismissTitle okTitle:nil dismissBlock:disBlock okBlock:nil];
}


#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.numberOfButtons == 2)
	{
        if (buttonIndex == 0)
		{
            if ([self dismissBlock] != nil)
			{
                GVCAlertViewDismissBlock block = [self dismissBlock];
				block();
            }
        }
		else
		{
            if ([self okBlock] != nil)
			{
				GVCAlertViewOKBlock block = [self okBlock];
				block();
            }
        }
    }
	else
	{
		if ([self dismissBlock] != nil)
		{
			GVCAlertViewDismissBlock block = [self dismissBlock];
			block();
		}
    }
}

@end
