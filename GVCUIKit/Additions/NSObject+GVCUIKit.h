/*
 * NSObject+GVCUIKit.h
 * 
 * Created by David Aspinall on 2013-01-31. 
 * Copyright (c) 2013 __MyCompanyName__. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

/**
 * <#description#>
 */
@interface NSObject (GVCUIKit)

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
