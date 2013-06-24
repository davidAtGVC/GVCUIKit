//
//  GVCDayCalendarHeaderView.m
//  GVCUIKit
//
//  Created by David Aspinall on 2013-06-21.
//
//

#import "GVCCalendarDayHeaderView.h"
#import <GVCFoundation/GVCFoundation.h>

GVC_DEFINE_STRVALUE(GVCCalendarDayHeaderView_IDENTIFIER, GVCCalendarDayHeaderView);

@interface GVCCalendarDayHeaderView ()
@end


@implementation GVCCalendarDayHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
	{
    }
    return self;
}

- (void)setDate:(NSDate *)date
{
	if ( date != nil )
	{
		if ( [date gvc_isEqualToDateIgnoringTime:[NSDate date]] == YES)
		{
			// today
			[[self titleLabel] setTextColor:[self highlightTextColor]];
		}

		CGRect frame = [[self titleLabel] frame];
		NSString *dateLabel = [date gvc_FormattedDate:(NSDateFormatterLongStyle)];
		CGSize textSize = [dateLabel sizeWithFont:[[self titleLabel] font]];
		if ( textSize.width > frame.size.width )
		{
			dateLabel = [date gvc_FormattedDate:(NSDateFormatterMediumStyle)];
			textSize = [dateLabel sizeWithFont:[[self titleLabel] font]];
			if ( textSize.width > frame.size.width )
			{
				dateLabel = [date gvc_FormattedDate:(NSDateFormatterShortStyle)];
				
				// textSize = [dateLabel sizeWithFont:[[self titleLabel] font]];
			}
		}
		[[self titleLabel] setText:dateLabel];
		[self setNeedsLayout];
	}
}

@end
