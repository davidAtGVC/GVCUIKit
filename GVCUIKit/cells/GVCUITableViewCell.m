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

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(NSObject *)object
{
//	id appearanceProxy = [self appearance];
//	if (appearanceProxy != nil)
//	{
//		GVCLogError(@"Appearance %@", appearanceProxy);
//		GVCLogError(@"Appearance Font %@", [appearanceProxy font]);
//		GVCLogError(@"Appearance UILabel %@", [appearanceProxy textLabel]);
//		
//	}
	
	UIFont *font = [UIFont boldSystemFontOfSize:GVC_DEFAULT_FONT_SIZE];
	CGFloat margin = [tableView gvc_tableCellMargin];
	CGFloat width = [tableView gvc_frameWidth] - (margin * 2);
	
	CGSize labelTextSize = [[object gvc_tableCellTitle] sizeWithFont:font constrainedToSize:CGSizeMake(75, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
	CGSize detailTextSize = [[object gvc_tableCellDetail] sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
	
	return MAX(detailTextSize.height, labelTextSize.height) + (20);
}


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
