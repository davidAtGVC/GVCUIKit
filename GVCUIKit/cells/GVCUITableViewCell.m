//
//  GVCUITableViewCell.m
//
//  Created by David Aspinall on 10-12-07.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import "GVCUITableViewCell.h"

@implementation GVCUITableViewCell

@synthesize useDarkBackground;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setUseDarkBackground:(BOOL)flag
{
    if ((flag != useDarkBackground) || (self.backgroundView == nil)) 
	{
        useDarkBackground = flag;
		
		UIColor *lightColor = [UIColor colorWithRed:0.612 green:0.616 blue:0.624 alpha:1.000];
		UIColor *darkColor = [UIColor colorWithRed:0.521 green:0.526 blue:0.538 alpha:1.000];
		
		[self setBackgroundColor:(useDarkBackground ? darkColor : lightColor)];
    }
}



@end
