//
//  GVCMonthCollectionReusableView.m
//  GVCUIKit
//
//  Created by David Aspinall on 2013-06-20.
//
//

#import "GVCMonthCollectionReusableView.h"
#import "UIView+GVCUIKit.h"

@implementation GVCMonthCollectionReusableView

- (id) initWithFrame:(CGRect)frame {
	
	self = [super initWithFrame:frame];
	if (self != nil)
	{
		CGRect topRect = CGRectMake( 0, 0, frame.size.width, frame.size.height / 2);
		CGRect bottomRect = CGRectMake( 0, frame.size.height / 2, frame.size.width, frame.size.height / 2);
		
		[self setMonthLabel:[[UILabel alloc] initWithFrame:topRect]];
		[[self monthLabel] setTextAlignment:NSTextAlignmentCenter];
		[[self monthLabel] setTextColor:[UIColor blueColor]];
		[[self monthLabel] setBackgroundColor:[UIColor clearColor]];
		[self addSubview:[self monthLabel]];
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setLocale:[NSLocale currentLocale]];
		
		CGFloat width =  floorf(frame.size.width / 7);
		for (int i = 0; i < 7; i++)
		{
			UILabel *wday = [[UILabel alloc] initWithFrame:CGRectMake(width * i, bottomRect.origin.y, width, bottomRect.size.height)];
			[wday setTextAlignment:NSTextAlignmentCenter];
			[wday setTextColor:[UIColor blueColor]];
			
			if (width > 30)
			{
				[wday setText:([formatter shortWeekdaySymbols])[i]];
				[wday setFont:[UIFont systemFontOfSize:12] ];
			}
			else
			{
				[wday setText:([formatter veryShortMonthSymbols])[i]];
				[wday setFont:[UIFont systemFontOfSize:10]];
			}
			
			[self addSubview:wday];
		}

	}
	return self;
}

- (void)prepareForReuse
{
	[super prepareForReuse];
	[[self monthLabel] setText:nil];
}

@end
