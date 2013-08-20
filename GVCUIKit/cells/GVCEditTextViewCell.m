//
//  GVCEditTextViewCell.m
//
//  Created by David Aspinall on 12-06-19.
//  Copyright (c) 2012 Global Village Consulting. All rights reserved.
//

#import "GVCEditTextViewCell.h"
#import "UITextView+GVCUIKit.h"

@interface GVCEditTextViewCell ()

@end


@implementation GVCEditTextViewCell

@synthesize textView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
		[self prepareTextView];
    }
    return self;
}

- (void)prepareTextView
{
	if ( [self textView] == nil )
	{
		[self setTextView:[[UITextView alloc] initWithFrame:CGRectZero]];
		[[self contentView] addSubview:[self textView]];
	}
	[[self textView] setFont:[UIFont boldSystemFontOfSize:14.0]];
	[[self textView] setTextColor:[UIColor colorWithRed:0.318 green:0.439 blue:0.569 alpha:1.000]];
	[[self textView] setDelegate:self];
}

- (void)layoutSubviews
{
	[self prepareTextView];

    [super layoutSubviews];
	CGRect r = CGRectInset(self.contentView.bounds, 8, 0);
    if ( [self textLabel] != nil )
	{
        CGSize textLabelSize = [[self textLabel] bounds].size;
		textLabelSize.width += 10.0;
        r.origin.x += textLabelSize.width;
        r.size.width -= textLabelSize.width;
	}

	[[self textView] setFrame:r];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlight animated:(BOOL)animated 
{
    [super setHighlighted:highlight animated:animated];

	if (highlight == YES)
    {
		[[self textView] setTextColor:[UIColor whiteColor]];
    }
	else
    {
		[[self textView] setTextColor:[UIColor blackColor]];
    }
}

- (void)prepareForReuse 
{
    [super prepareForReuse];
    
    [[self textView] setText:nil];
    [[self textView] setDelegate:nil];
}

#pragma mark Text Field
- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	BOOL changeOK = YES;

	NSString *newtext = [[txtView text] stringByReplacingCharactersInRange:range withString:text];
	if ( [self willChangeBlock] != nil )
	{
		changeOK = self.willChangeBlock([txtView text], newtext);
	}

	return changeOK;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)txtView
{
	return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)txtView
{
	return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)txtView
{
	if (([self delegate] != nil) && [[self delegate] respondsToSelector:@selector(gvcEditCellDidBeginEditing:)])
	{
		[[self delegate] gvcEditCellDidBeginEditing:self];
	}
}

- (void)textViewDidChange:(UITextView *)txtView
{
	if (([self delegate] != nil) && [[self delegate] respondsToSelector:@selector(gvcEditCell:textChangedTo:)])
	{
		[[self delegate] gvcEditCell:self textChangedTo:[txtView text]];
	}
	
	if ( [self didChangeBlock] != nil )
	{
		self.didChangeBlock([txtView text]);
	}
}

// saving here occurs both on return key and changing away
- (void)textViewDidEndEditing:(UITextView *)txtView
{
	if (([self delegate] != nil) && [[self delegate] respondsToSelector:@selector(gvcEditCell:textChangedTo:)])
	{
		[[self delegate] gvcEditCell:self textChangedTo:[txtView text]];
	}

	if ( [self dataEndBlock] != nil )
	{
		self.dataEndBlock([txtView text]);
	}
}

@end
