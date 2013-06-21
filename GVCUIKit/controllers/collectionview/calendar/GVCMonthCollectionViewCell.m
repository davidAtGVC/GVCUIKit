//
//  GVCMonthCollectionViewCell.m
//  GVCUIKit
//
//  Created by David Aspinall on 2013-06-20.
//
//

#import "GVCMonthCollectionViewCell.h"

@implementation GVCMonthCollectionViewCell

- (id) initWithFrame:(CGRect)frame {
	
	self = [super initWithFrame:frame];
	if (self != nil)
	{
		[self setDayLabel:[[UILabel alloc] initWithFrame:(CGRect){CGPointZero, frame.size}]];
		[[self dayLabel] setTextAlignment:NSTextAlignmentCenter];
		[[self dayLabel] setBackgroundColor:[UIColor clearColor]];
		[[self contentView] addSubview:[self dayLabel]];
	}
	return self;
}

- (void)prepareForReuse
{
	[super prepareForReuse];
	[[self dayLabel] setText:nil];
}

@end
