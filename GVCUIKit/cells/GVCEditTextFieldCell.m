//
//  DADataTextFieldCell.m
//
//  Created by David Aspinall on 10-04-13.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import "GVCEditTextFieldCell.h"


@implementation GVCEditTextFieldCell

@synthesize textField;
@synthesize isSecure;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
    if (self != nil)
	{
        // Initialization code
		[[self textLabel] setAdjustsFontSizeToFitWidth:YES];
		[[self textLabel] setMinimumFontSize:10];
		
		textField = [[UITextField alloc] initWithFrame:CGRectZero];
		textField.textColor = [UIColor colorWithRed:12850./65535 green:20303./65535 blue:34181./65535 alpha:1.0];
		textField.font = [UIFont systemFontOfSize:18];
		[textField setAdjustsFontSizeToFitWidth:YES];
		[textField setMinimumFontSize:12];
		textField.autocorrectionType = UITextAutocorrectionTypeNo;
		textField.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
		textField.returnKeyType = UIReturnKeyDone;
		
		textField.delegate = self;
		[self.contentView addSubview:textField];
    }
    return self;
}

- (void)setIsSecure:(BOOL)val
{
	isSecure = val;
	[textField setSecureTextEntry:isSecure];
}

- (UIKeyboardType)keyboardType
{
	return [textField keyboardType];
}
- (void)setKeyboardType:(UIKeyboardType)kt
{
	[textField setKeyboardType:kt];
}

- (UITextAutocapitalizationType)autocapitalizationType
{
	return [textField autocapitalizationType];
}

- (void)setAutocapitalizationType:(UITextAutocapitalizationType)kt
{
	[textField setAutocapitalizationType:kt];
}

- (UITextAutocorrectionType)autocorrectionType
{
	return [textField autocorrectionType];
}

- (void)setAutocorrectionType:(UITextAutocorrectionType)kt
{
	[textField setAutocorrectionType:kt];
}


- (void)layoutSubviews
{
	[super layoutSubviews];
	
    CGRect contentRect = [self.contentView bounds];
	CGSize textLabelSize = CGSizeZero;
	if ( [self textLabel] != nil )
	{
		textLabelSize = [[self textLabel] bounds].size;
		textLabelSize.width += 10.0;
	}
	
	float boundsX = contentRect.origin.x + textLabelSize.width;
	float width = contentRect.size.width;
	if(contentRect.origin.x == 0.0) 
	{
		boundsX = 10.0 + textLabelSize.width;
		width -= (20 + textLabelSize.width);
	}
	
	CGRect frame = CGRectMake(boundsX, 10, width, contentRect.size.height);
	[textField setFrame:frame];
}

#pragma mark Text Field
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)atextField
{
	// on return key we send away the keyboard
    [textField resignFirstResponder];
	BOOL should = YES;
	if (([self delegate] != nil) && [[self delegate] respondsToSelector:@selector(gvcEditCellShouldReturn:)])
	{
		should = [[self delegate] gvcEditCellShouldReturn:self];
	}

	return should;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	if (([self delegate] != nil) && [[self delegate] respondsToSelector:@selector(gvcEditCellDidBeginEditing:)])
	{
		[[self delegate] gvcEditCellDidBeginEditing:self];
	}
}

// saving here occurs both on return key and changing away
- (void)textFieldDidEndEditing:(UITextField *)txtField
{
//	((UITableView*)[self superview]).scrollEnabled = YES;
	
	if (([self delegate] != nil) && [[self delegate] respondsToSelector:@selector(gvcEditCell:textChangedTo:)])
	{
		[[self delegate] gvcEditCell:self textChangedTo:[txtField text]];
	}
}	

@end
