//
//  GVCEditTextViewCell.m
//
//  Created by David Aspinall on 12-06-19.
//  Copyright (c) 2012 Global Village Consulting. All rights reserved.
//

#import "GVCEditTextViewCell.h"

@interface GVCEditTextViewCell ()

@end


@implementation GVCEditTextViewCell

@synthesize textView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        [self setTextView:[[UITextView alloc] initWithFrame:CGRectZero]];
        [[self textView] setFont:[UIFont boldSystemFontOfSize:14.0]];
        [[self textView] setBackgroundColor:[UIColor clearColor]];
        [[self contentView] addSubview:[self textView]];
    }
    return self;
}


- (void)layoutSubviews 
{
    [super layoutSubviews];
	CGRect r = CGRectInset(self.contentView.bounds, 8, 8);
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


@end
