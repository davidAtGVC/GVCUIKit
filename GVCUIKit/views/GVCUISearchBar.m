//
//  GVCUISearchBar.m
//  GVCUIKit
//
//  Created by David Aspinall on 2013-02-20.
//
//

#import "GVCUISearchBar.h"

@implementation GVCUISearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
	{
		[self setHideCancelButton:YES];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
	if ( [self hideCancelButton] == YES)
	{
		[self setShowsCancelButton:NO animated:NO];
	}
}

@end
