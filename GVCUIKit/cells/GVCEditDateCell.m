    //
//  DADataDateCell.m
//
//  Created by David Aspinall on 10-04-15.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import "GVCEditDateCell.h"


@implementation GVCEditDateCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
    if (self != nil)
	{
		[self setCanSelectCell:YES];
    }
    return self;
}

@end
