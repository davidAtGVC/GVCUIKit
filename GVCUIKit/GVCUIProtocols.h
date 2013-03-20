/*
 * GVCUIProtocols.h
 * 
 * Created by David Aspinall on 12-06-22. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <GVCFoundation/GVCFoundation.h>

#ifndef GVCUIKit_GVCUIProtocols_h
#define GVCUIKit_GVCUIProtocols_h

@protocol GVCDismissPopoverProtocol <NSObject>
- (void)dismissPopover:sender;
@end


@protocol GVCViewTitleProtocol <NSObject>
- (NSString *)viewTitle;
@end


@protocol GVCTableViewDataSourceProtocol <UITableViewDataSource>

- (NSArray *)tableView:(UITableView *)tableView rowsForSection:(NSUInteger)section;

/*
 Each row of the table is represented by a single object
 */
- (id)tableView:(UITableView*)tableView objectForRowAtIndexPath:(NSIndexPath*)indexPath;
- (NSIndexPath*)tableView:(UITableView*)tableView indexPathForObject:(id)object;

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object;

@end


@protocol GVCTableViewCellDataProtocol <NSObject>

@optional
/**
 * For object used as data holders for GVCTableViewDataSourceProtocol
 * @returns cell title string
 */
- (NSString *)gvc_tableCellTitle;

/**
 * For object used as data holders for GVCTableViewDataSourceProtocol
 * @returns cell detail string
 */
- (NSString *)gvc_tableCellDetail;

@end
#endif
