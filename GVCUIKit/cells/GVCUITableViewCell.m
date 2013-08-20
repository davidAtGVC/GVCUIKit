//
//  GVCUITableViewCell.m
//
//  Created by David Aspinall on 10-12-07.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import "GVCUITableViewCell.h"

#import "UITableViewCell+GVCUIKit.h"
#import "UITableView+GVCUIKit.h"
#import "UIView+GVCUIKit.h"
#import "NSObject+GVCUIKit.h"

#import <GVCFoundation/GVCFoundation.h>

#define GVC_DEFAULT_FONT_SIZE 14

@implementation GVCUITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}

- (void)prepareForReuse 
{
    [super prepareForReuse];
//	[self setObject:nil];
}

@end
