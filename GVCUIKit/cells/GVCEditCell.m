//
//  DADataEditCell.m
//
//  Created by David Aspinall on 10-04-12.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import "GVCEditCell.h"


@implementation GVCEditCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) 
	{
    }
    return self;
}

- (void)prepareForReuse 
{
	[self setEditPath:nil];
	[super prepareForReuse];
}

@end
