//
//  GVCRoundBorderView.h
//  GVCImmunization
//
//  Created by David Aspinall on 11-02-08.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GVCRoundBorderView : UIView <UIAppearance, UIAppearanceContainer>

@property (strong, nonatomic) UIColor *borderColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor *contentColor UI_APPEARANCE_SELECTOR;


@property (assign, nonatomic) NSInteger borderWidth UI_APPEARANCE_SELECTOR;
@property (assign, nonatomic) NSInteger cornerRadius UI_APPEARANCE_SELECTOR;

@end
