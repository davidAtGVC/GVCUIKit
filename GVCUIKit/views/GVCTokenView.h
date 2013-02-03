/*
 * GVCTokenView.h
 * 
 * Created by David Aspinall on 2013-02-01. 
 * Copyright (c) 2013 __MyCompanyName__. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>

/**
 * <#description#>
 */
@interface GVCTokenView : UIView

@property (strong,nonatomic) NSString *text;
@property (strong,nonatomic) UIFont *font UI_APPEARANCE_SELECTOR;

@property (strong,nonatomic) UIColor *bgColor UI_APPEARANCE_SELECTOR;
@property (strong,nonatomic) UIColor *selectedBgColor UI_APPEARANCE_SELECTOR;

@property (strong,nonatomic) UIColor *borderColor UI_APPEARANCE_SELECTOR;
@property (strong,nonatomic) UIColor *selectedBorderColor UI_APPEARANCE_SELECTOR;

@property (strong,nonatomic) UIColor *textColor UI_APPEARANCE_SELECTOR;
@property (strong,nonatomic) UIColor *selectedTextColor UI_APPEARANCE_SELECTOR;

@property (assign, nonatomic, getter=isSelected) BOOL selected;

- (IBAction)updateBadgeText:(id)sender;

-(void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end
