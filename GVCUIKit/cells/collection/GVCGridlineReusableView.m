//
//  GVCGridlineReusableView.m
//  GVCUIKit
//
//  Created by David Aspinall on 2013-06-21.
//
//

#import "GVCGridlineReusableView.h"
#import "UIColor+GVCUIKit.h"
#import <QuartzCore/QuartzCore.h>

@implementation GVCGridlineReusableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
	{
        [self setBackgroundColor:[UIColor blackColor]];
        [self setBackgroundColor:[UIColor gvc_ColorFromHexString:@"#e4e4e4"]];
        [[self layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [[self layer] setBorderWidth:1.0];
    }
    return self;
}


@end
