//
//  GVCSwitchCell.h
//
//  Created by David Aspinall on 12-06-19.
//  Copyright (c) 2012 Global Village Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GVCEditCell.h"

@interface GVCSwitchCell : GVCEditCell

@property (strong, nonatomic) IBOutlet UISwitch *switchControl;

- (BOOL)switchValue;
- (void)setSwitchValue:(BOOL)val;

@end
