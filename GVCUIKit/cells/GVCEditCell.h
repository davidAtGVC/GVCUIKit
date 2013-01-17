//
//  DADataEditCell.h
//
//  Created by David Aspinall on 10-04-12.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GVCUITableViewCell.h"

/**
 * Alternate method to update values using blocks instead of delgates
 */
typedef void (^GVCEditCellChangedBlock)(NSObject *updatedValue);

@interface GVCEditCell : GVCUITableViewCell

@property (strong, nonatomic) NSIndexPath *editPath;
@property (nonatomic, assign) BOOL canSelectCell;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (readwrite, copy) GVCEditCellChangedBlock dataChangeBlock;

@end


@protocol GVCEditTextCellDelegate <NSObject>
@optional
- (void) gvcEditCellDidBeginEditing:(GVCEditCell *)editableCell;
- (BOOL) gvcEditCellShouldReturn:(GVCEditCell *)editableCell;
- (void) gvcEditCell:(GVCEditCell *)editableCell textChangedTo:(NSString *)newText;
@end
