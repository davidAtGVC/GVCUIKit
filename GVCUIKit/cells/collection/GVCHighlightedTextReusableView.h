//
//  GVCHighlightedTextReusableView.h
//  GVCUIKit
//
//  Created by David Aspinall on 2013-06-21.
//
//

#import <UIKit/UIKit.h>

@interface GVCHighlightedTextReusableView : UICollectionReusableView

@property (strong, nonatomic) UIColor *defaultTextColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor *highlightTextColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UILabel *titleLabel;

/** this is called from -layoutSubviews allowing subclasses to layout the title label differently
 */
- (void)layoutTitleLabel;

@end
