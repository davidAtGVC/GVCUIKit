//
//  GVCColumnContainerCell.h
//
//  Created by David Aspinall on 12-06-20.
//  Copyright (c) 2012 Global Village Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GVCUIKit.h"
#import "GVCUITableViewCell.h"

@interface GVCColumnContainerCell : GVCUITableViewCell

- (UIView *)viewAtIndex:(NSUInteger)index;

@end
