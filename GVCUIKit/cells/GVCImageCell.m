//
//  GVCImageCell.m
//  GVCUIKit
//
//  Created by David Aspinall on 2013-05-21.
//
//

#import "GVCImageCell.h"

@implementation GVCImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)displayImage:(UIImage *)image
{
	if ( [self imageView] == nil )
	{
		[self setImageView:[[UIImageView alloc] initWithFrame:[[self contentView] bounds]]];
		[[self imageView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[[self imageView] setContentMode:(UIViewContentModeCenter)];
		[[self imageView] setClipsToBounds:YES];
		[[self contentView] addSubview:[self imageView]];
	}
	
	[[self imageView] setImage:image];
}

@end
