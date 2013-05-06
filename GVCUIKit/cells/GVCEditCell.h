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
@property (nonatomic, assign) BOOL canSelectCell;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (readwrite, copy) GVCEditCellWillChangeBlock willChangeBlock;
@property (readwrite, copy) GVCEditCellDidChangeBlock didChangeBlock;
@property (readwrite, copy) GVCEditCellEditingEndedBlock dataEndBlock;

@end


@protocol GVCEditTextCellDelegate <NSObject>
@optional
- (void) gvcEditCellDidBeginEditing:(GVCEditCell *)editableCell;
- (BOOL) gvcEditCellShouldReturn:(GVCEditCell *)editableCell;
- (void) gvcEditCell:(GVCEditCell *)editableCell textChangedTo:(NSString *)newText;
@end
