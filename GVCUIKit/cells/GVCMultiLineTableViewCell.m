//
//  DAMultiLineTableViewCell.m
//
//  Created by David Aspinall on 16/09/09.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import "GVCMultiLineTableViewCell.h"
#import <GVCFoundation/GVCFoundation.h>

#define TITLE_LEFT_OFFSET 10
#define TITLE_TOP_OFFSET 6
#define TITLE_HEIGHT 30

#define VALUE_TOP_OFFSET 6
#define VALUE_HEIGHT 30

/**
 * $Date: 2009-01-20 16:28:51 -0500 (Tue, 20 Jan 2009) $
 * $Rev: 121 $
 * $Author: david $
*/
@implementation GVCMultiLineTableViewCell

@synthesize textView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self != nil)
	{
		[self setTextView:[[UILabel alloc] initWithFrame:CGRectZero]];
		textView.backgroundColor = [UIColor whiteColor];

		textView.font = [UIFont boldSystemFontOfSize:14];
		textView.textColor = [UIColor blackColor];
		textView.text = [NSString gvc_EmptyString];
		textView.textAlignment = NSTextAlignmentLeft;
		textView.lineBreakMode = NSLineBreakByWordWrapping;
		textView.numberOfLines = 0;
		
		[self.contentView addSubview: textView];
	}
	return self;
}

- (void)setText:(NSString *)text
{
	textView.text = text;
	[self layoutSubviews];
}

- (UILabel *)detailTextLabel
{
	return textView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
	/*
	 Views are drawn most efficiently when they are opaque and do not have a clear background, so in newLabelForMainText: the labels are made opaque and given a white background.  To show selection properly, however, the views need to be transparent (so that the selection color shows through).  
	 */
	[super setSelected:selected animated:animated];
	
	if(self.selectionStyle != UITableViewCellSelectionStyleNone)
	{
		UIColor *backgroundColor = selected || animated ? [UIColor clearColor] : [UIColor whiteColor];
		
		textView.backgroundColor = backgroundColor;
		textView.highlighted = selected;
		textView.opaque = !selected;
	}
}

+ (CGFloat)heightForWidth:(CGFloat)width withText:(NSString *)text
{
    CGRect msgRect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]} context:nil];

	return(msgRect.size.height > 44 ? msgRect.size.height + 10.0 : 44);
}

- (void)prepareForReuse 
{
    [super prepareForReuse];
    
    [[self textLabel] setText:nil];
    [[self textView] setText:nil];
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
	
	CGRect frame = CGRectMake(boundsX, 0, width, contentRect.size.height);
	[[self textView] setFrame:frame];
}

@end
