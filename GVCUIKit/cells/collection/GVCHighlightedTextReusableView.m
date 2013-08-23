//
//  GVCHighlightedTextReusableView.m
//  GVCUIKit
//
//  Created by David Aspinall on 2013-06-21.
//
//

#import "GVCHighlightedTextReusableView.h"

@implementation GVCHighlightedTextReusableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
	{
		[self setBackgroundColor:[UIColor clearColor]];
        
		[self setDefaultTextColor:[UIColor blackColor]];
		[self setHighlightTextColor:[UIColor blueColor]];
		
		[self setTitleLabel:[[UILabel alloc] initWithFrame:frame]];
		[[self titleLabel] setBackgroundColor:[UIColor clearColor]];
        [self addSubview:[self titleLabel]];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutTitleLabel];
}

- (void)layoutTitleLabel
{
    [[self titleLabel] sizeToFit];
    CGRect titleFrame = [[self titleLabel] frame];
    titleFrame.origin.x = nearbyintf((CGRectGetWidth([self frame]) / 2.0) - (CGRectGetWidth(titleFrame) / 2.0));
    titleFrame.origin.y = nearbyintf((CGRectGetHeight([self frame]) / 2.0) - (CGRectGetHeight(titleFrame) / 2.0));
    [[self titleLabel] setFrame:titleFrame];
}

- (void)prepareForReuse
{
	[super prepareForReuse];
	[[self titleLabel] setText:nil];
	[[self titleLabel] setTextColor:[self defaultTextColor]];
}

@end
