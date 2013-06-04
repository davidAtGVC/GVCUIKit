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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil)
	{
        // Initialization code
		[[self textLabel] setAdjustsFontSizeToFitWidth:YES];
		[[self textLabel] setMinimumFontSize:10];
		[self prepareTextField];
     }
    
    return self;
}

-(void) prepareTextField
{
    if ([self textField] == nil)
    {
        [self setTextField:[[UITextField alloc] initWithFrame:CGRectZero]];
		[[self contentView] addSubview:textField];
    }
    
    [[self textField] setBackgroundColor:[UIColor whiteColor]];
    [[self textField] setTextColor:[UIColor colorWithRed:0.318 green:0.439 blue:0.569 alpha:1.000]];
    [[self textField] setFont:[UIFont systemFontOfSize:18]];
    [[self textField] setAdjustsFontSizeToFitWidth:YES];
    [[self textField] setMinimumFontSize:12];
    [[self textField] setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [[self textField] setClearButtonMode:UITextFieldViewModeWhileEditing];
    [[self textField] setAutocorrectionType:UITextAutocorrectionTypeNo];
    [[self textField] setKeyboardType:UIKeyboardTypeDefault];	// use the default type input method (entire keyboard)
    [[self textField] setReturnKeyType:UIReturnKeyDone];
    [[self textField] setDelegate:self];
    
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
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

- (void)prepareForReuse 
{
    [super prepareForReuse];
    [[self textLabel] setText:nil];
    [[self textField] setText:nil];
    [[self textField] setPlaceholder:nil];
}

- (void)layoutSubviews
{
	[self prepareTextField];
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
	
	CGRect frame = CGRectMake(boundsX, 0, width, contentRect.size.height);
	[textField setFrame:frame];
}

#pragma mark Text Field
- (BOOL)textField:(UITextField *)txtField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	BOOL changeOK = YES;
	NSString *newtext = [[txtField text] stringByReplacingCharactersInRange:range withString:string];
	if ( [self willChangeBlock] != nil )
	{
		changeOK = self.willChangeBlock([txtField text], newtext);
	}
	
	return changeOK;
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
    UITableView *tv = (UITableView *) [self superview];
    [tv selectRowAtIndexPath:[tv indexPathForCell:self] animated:YES scrollPosition:UITableViewScrollPositionTop];

	if (([self delegate] != nil) && [[self delegate] respondsToSelector:@selector(gvcEditCellDidBeginEditing:)])
	{
		[[self delegate] gvcEditCellDidBeginEditing:self];
	}
}

// saving here occurs both on return key and changing away
- (void)textFieldDidEndEditing:(UITextField *)txtField
{
//	((UITableView*)[self superview]).scrollEnabled = YES;
    UITableView *tv = (UITableView *) [self superview];
    [tv scrollToRowAtIndexPath:[tv indexPathForCell:self] atScrollPosition:UITableViewScrollPositionTop animated:YES];

	if (([self delegate] != nil) && [[self delegate] respondsToSelector:@selector(gvcEditCell:textChangedTo:)])
	{
		[[self delegate] gvcEditCell:self textChangedTo:[txtField text]];
	}
	
	if ( [self dataEndBlock] != nil )
	{
		self.dataEndBlock([txtField text]);
	}
}

@end
