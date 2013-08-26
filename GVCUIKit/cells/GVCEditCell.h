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
typedef void (^GVCEditCellEditingEndedBlock)(NSObject *updatedValue);
typedef BOOL (^GVCEditCellWillChangeBlock)(NSObject *oldValue, NSObject *updatedValue);
typedef void (^GVCEditCellDidChangeBlock)(NSObject *updatedValue);

@interface GVCEditCell : GVCUITableViewCell

@property (strong, nonatomic) NSIndexPath *editPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (copy, nonatomic) GVCEditCellWillChangeBlock willChangeBlock;
@property (copy, nonatomic) GVCEditCellDidChangeBlock didChangeBlock;
@property (copy, nonatomic) GVCEditCellEditingEndedBlock dataEndBlock;

@end


@protocol GVCEditTextCellDelegate <NSObject>
@optional
- (void) gvcEditCellDidBeginEditing:(GVCEditCell *)editableCell;
- (BOOL) gvcEditCellShouldReturn:(GVCEditCell *)editableCell;
- (void) gvcEditCell:(GVCEditCell *)editableCell textChangedTo:(NSString *)newText;
@end
