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
        CGRect rect = [dateLabel boundingRectWithSize:frame.size options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[[self titleLabel] font]} context:nil];
		if ( rect.size.width > frame.size.width )
		{
			dateLabel = [date gvc_FormattedDate:(NSDateFormatterMediumStyle)];
			rect = [dateLabel boundingRectWithSize:frame.size options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[[self titleLabel] font]} context:nil];
			if ( rect.size.width > frame.size.width )
			{
				dateLabel = [date gvc_FormattedDate:(NSDateFormatterShortStyle)];
			}
		}
		[[self titleLabel] setText:dateLabel];
		[self setNeedsLayout];
	}
}

@end
