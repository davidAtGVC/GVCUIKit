//
//  GVCYearCollectionViewCell.m
//  GVCUIKit
//
//  Created by David Aspinall on 2013-06-20.
//
//

#import "GVCYearCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import <GVCFoundation/GVCFoundation.h>

@implementation GVCYearCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self !=  nil)
	{
		[[self layer] setRasterizationScale:[[UIScreen mainScreen] scale]];
        [[self layer] setShouldRasterize:YES];

		CGRect insetBounds = CGRectInset([self bounds], 6, 0);
		
		UILabel *yLabel = [[UILabel alloc] initWithFrame:insetBounds];
		[self setYearLabel:yLabel];
		[yLabel setBackgroundColor:[UIColor whiteColor]];
		[yLabel setTextAlignment:NSTextAlignmentCenter];
		[yLabel setFont:[UIFont systemFontOfSize:20]];
		[yLabel setTextColor:[UIColor blueColor]];

        [self addSubview:yLabel];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
	UILabel *yLabel = [self yearLabel];

	[yLabel setBackgroundColor:[UIColor whiteColor]];
	[yLabel setTextAlignment:NSTextAlignmentCenter];
	[yLabel setFont:[UIFont systemFontOfSize:20]];
	[yLabel setTextColor:[UIColor blueColor]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
	CGRect insetBounds = CGRectInset([self bounds], 6, 0);
    UIEdgeInsets padding = UIEdgeInsetsMake(4.0, 5.0, 4.0, 5.0);
    CGFloat contentWidth = (CGRectGetWidth(insetBounds) - padding.left - padding.right);
    
    CGRect yearFrame = [GVC_STRONG_REF(UILabel, [self yearLabel]) frame];
    yearFrame.size.height = insetBounds.size.height;
    yearFrame.size.width = contentWidth;
    yearFrame.origin.x = padding.left;
    yearFrame.origin.y = padding.top;
    [GVC_STRONG_REF(UILabel, [self yearLabel]) setFrame:yearFrame];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
