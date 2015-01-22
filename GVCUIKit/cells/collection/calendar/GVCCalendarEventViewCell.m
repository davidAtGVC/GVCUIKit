//
//  GVCCalendarEventViewCell.m
//  GVCUIKit
//
//  Created by David Aspinall on 2013-06-21.
//
//

#import "GVCCalendarEventViewCell.h"

#import <QuartzCore/QuartzCore.h>
#import <GVCFoundation/GVCFoundation.h>


GVC_DEFINE_STRVALUE(GVCCalendarEventViewCell_IDENTIFIER, GVCCalendarEventViewCell);

@implementation GVCCalendarEventViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
	{
		[[self layer] setRasterizationScale:[[UIScreen mainScreen] scale]];
        [[self layer] setShouldRasterize:YES];
		
		[[[self contentView] layer] setBorderWidth:1.0];
        [[[self contentView] layer] setCornerRadius:4.0];
        [[[self contentView] layer] setMasksToBounds:YES];

		[self setTimeLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
        [[self timeLabel] setBackgroundColor:[UIColor clearColor]];
        [[self timeLabel] setNumberOfLines:0];
        [[self timeLabel] setFont:[UIFont systemFontOfSize:12.0]];
        [[self contentView] addSubview:[self timeLabel]];
        
		[self setTitleLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
        [[self titleLabel] setBackgroundColor:[UIColor clearColor]];
        [[self titleLabel] setNumberOfLines:0];
        [[self titleLabel] setFont:[UIFont boldSystemFontOfSize:12.0]];
        [[self contentView] addSubview:[self titleLabel]];
        
		[self setNoteLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
        [[self noteLabel] setBackgroundColor:[UIColor clearColor]];
        [[self noteLabel] setNumberOfLines:0];
        [[self noteLabel] setFont:[UIFont systemFontOfSize:12.0]];
        [[self contentView] addSubview:[self noteLabel]];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(4.0, 5.0, 4.0, 5.0);
	CGRect frame = [[self contentView] frame];
    CGFloat contentMargin = 2.0;
    CGFloat contentWidth = (CGRectGetWidth(frame) - padding.left - padding.right);
    
    CGSize maxTimeSize = CGSizeMake(contentWidth, CGRectGetHeight(frame) - padding.top - padding.bottom);
    CGRect timeRect = [[[self timeLabel] text] boundingRectWithSize:maxTimeSize options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[[self timeLabel] font]} context:nil];
    CGRect timeFrame = [[self timeLabel] frame];
    timeFrame.size = timeRect.size;
    timeFrame.origin.x = padding.left;
    timeFrame.origin.y = padding.top;
    [[self timeLabel] setFrame:timeFrame];
	
    CGSize maxTitleSize = CGSizeMake(contentWidth, CGRectGetHeight(frame) - (CGRectGetMaxY(timeFrame) + contentMargin) - padding.bottom);
    CGRect titleRect = [[[self titleLabel] text] boundingRectWithSize:maxTitleSize options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[[self titleLabel] font]} context:nil];
    CGRect titleFrame = [[self titleLabel] frame];
    titleFrame.size = titleRect.size;
    titleFrame.origin.x = padding.left;
    titleFrame.origin.y = (CGRectGetMaxY(timeFrame) + contentMargin);
    [[self titleLabel] setFrame:timeFrame];
    
    CGSize maxNoteSize = CGSizeMake(contentWidth, CGRectGetHeight(frame) - (CGRectGetMaxY(titleFrame) + contentMargin) - padding.bottom);
    CGRect noteRect = [[[self noteLabel] text] boundingRectWithSize:maxNoteSize options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[[self noteLabel] font]} context:nil];
    CGRect noteFrame = [[self noteLabel] frame];
    noteFrame.size = noteRect.size;
    noteFrame.origin.x = padding.left;
    noteFrame.origin.y = (CGRectGetMaxY(titleFrame) + contentMargin);
    [[self noteLabel] setFrame:noteFrame];
}


- (void)setEvent:(id <GVCCalendarEventProtocol>)event
{
	
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"h:mm a";
    
    [[self timeLabel] setText:[[event eventStartDate] gvc_FormattedTime:(NSDateFormatterShortStyle)]];
    [[self titleLabel] setText:[event eventTitle]];
	[[self noteLabel] setText:[event eventDescription]];
    
    [self setNeedsLayout];
}

@end
