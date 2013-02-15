/*
 *  GVCTokenFieldView.h
 *
 *  Created by David Aspinall on 2013-02-03.
 *  Copyright (c) 2013 Global Village Consulting. All rights reserved.
 */

#import <UIKit/UIKit.h>


@class GVCTokenFieldView;

@protocol GVCTokenFieldViewDelegate <NSObject>

- (NSUInteger)numberOfTokensForFieldView:(GVCTokenFieldView *)fieldView;
- (NSString *)fieldView:(GVCTokenFieldView *)fieldView titleForTokenAtIndexPath:(NSIndexPath *)indexPath;

@end


/**
 * <#description#>
 */
@interface GVCTokenFieldView : UIView

@end
