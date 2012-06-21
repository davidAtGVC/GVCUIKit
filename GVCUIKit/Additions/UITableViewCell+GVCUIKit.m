/*
 * UITableViewCell+GVCUIKit.m
 * 
 * Created by David Aspinall on 12-06-19. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "UITableViewCell+GVCUIKit.h"

@implementation UITableViewCell (GVCUIKit)

+ (id)gvc_CellForTableView:(UITableView *)tv
{
    return [self gvc_CellWithStyle:[self gvc_DefaultCellStyle] forTableView:tv];
}

+ (id)gvc_CellWithStyle:(UITableViewCellStyle)style forTableView:(UITableView *)tableView;
{ 
    NSString *cellID = [self gvc_DefaultCellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil)
    {
        cell = [[self alloc] initWithStyle:style reuseIdentifier:cellID];
    }
    
    return cell;
}

+ (UITableViewCellStyle)gvc_DefaultCellStyle 
{
    return UITableViewCellStyleDefault;
}

+ (NSString *)gvc_DefaultCellIdentifier 
{
    return NSStringFromClass([self class]);
}

@end
