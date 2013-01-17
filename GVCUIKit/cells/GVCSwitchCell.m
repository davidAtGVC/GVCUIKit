//
//  GVCSwitchCell.m
//
//  Created by David Aspinall on 12-06-19.
//  Copyright (c) 2012 Global Village Consulting. All rights reserved.
//

#import "GVCSwitchCell.h"

@interface GVCSwitchCell ()

@end


@implementation GVCSwitchCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
		UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
		[mySwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];

        [self setSwitchControl:mySwitch];
        [self setAccessoryView:[self switchControl]];
    }
    return self;
}

- (void)prepareForReuse 
{
    [super prepareForReuse];
    [[self switchControl] setOn:NO];
}

#pragma mark - UISwitch methods
- (BOOL)switchValue
{
	return [[self switchControl] isOn];
}

- (void)setSwitchValue:(BOOL)val
{
	[[self switchControl] setOn:val];
}

- (void)switchChanged:(id) sender
{
//	if (delegate && [delegate respondsToSelector:@selector(daBooleanCellSwitched:)])
//	{
//		[delegate daBooleanCellSwitched:self];
//	}
	if ( [self dataChangeBlock] != nil )
	{
		self.dataChangeBlock([NSNumber numberWithBool:[self switchValue]]);
	}
}

@end
