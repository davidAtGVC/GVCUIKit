//
//  GVCCalendarTimeRowView.m
//  GVCUIKit
//
//  Created by David Aspinall on 2013-06-21.
//
//

#import "GVCCalendarTimeRowView.h"
#import <GVCFoundation/GVCFoundation.h>

GVC_DEFINE_STRVALUE(GVCCalendarTimeRowView_IDENTIFIER, GVCCalendarTimeRowView);

@implementation GVCCalendarTimeRowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
	{
    }
    return self;
}

- (void)layoutTitleLabel
{
    [[self titleLabel] sizeToFit];

	UIEdgeInsets margin = UIEdgeInsetsMake(0.0, 0.0, 0.0, 8.0);

    CGRect titleFrame = [[self titleLabel] frame];
    titleFrame.origin.x = nearbyintf(CGRectGetWidth([self frame]) - CGRectGetWidth(titleFrame)) - margin.right;
    titleFrame.origin.y = nearbyintf((CGRectGetHeight([self frame]) / 2.0) - (CGRectGetHeight(titleFrame) / 2.0));
    [[self titleLabel] setFrame:titleFrame];
}

- (void)setTime:(NSDate *)time
{
	if ( time != nil )
	{
		if ( [time gvc_isDate:[NSDate date] matchingComponents:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit)] == YES)
		{
			// today and the hour current
			[[self titleLabel] setTextColor:[self highlightTextColor]];
		}
		
		CGRect frame = [[self titleLabel] frame];
		NSString *timeLabel = [time gvc_FormattedTime:(NSDateFormatterMediumStyle)];
		CGSize textSize = [timeLabel sizeWithFont:[[self titleLabel] font]];
		if ( textSize.width > frame.size.width )
		{
			timeLabel = [time gvc_FormattedDate:(NSDateFormatterShortStyle)];
		}
		[[self titleLabel] setText:timeLabel];
		[self setNeedsLayout];
	}
}

@end
