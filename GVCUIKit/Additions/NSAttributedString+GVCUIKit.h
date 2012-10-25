//
//  NSAttributedString+GVCUIKit.h
//
//  Created by David Aspinall on 12-04-19.
//  Copyright (c) 2012 Global Village Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface NSAttributedString (GVCUIKit)

+ (CTTextAlignment)gvc_CTTextAlignmentFromUITextAlignment:(UITextAlignment)alignment;
+ (CTLineBreakMode)gvc_CTTextLineBreakModeFromUILineBreakMode:(UILineBreakMode)lineBreakMode;

- (CGSize)gvc_sizeConstrainedToWidth:(CGFloat)width;

@end


@interface NSMutableAttributedString (GVCUIKit)

+ (NSMutableAttributedString *)gvc_MutableAttributedStringFromUILabel:(UILabel *)label;
+ (NSMutableAttributedString *)gvc_MutableAttributed:(NSString *)str font:(UIFont *)font color:(UIColor *)colr alignment:(UITextAlignment)align lineBreakMode:(UILineBreakMode)mode;

- (void)gvc_setTextAlignment:(UITextAlignment)align lineBreakMode:(UILineBreakMode)mode;
- (void)gvc_setTextAlignment:(UITextAlignment)align lineBreakMode:(UILineBreakMode)mode range:(NSRange)range;

- (void)gvc_setTextColor:(UIColor *)color range:(NSRange)range;
- (void)gvc_setTextColor:(UIColor *)color;

- (void)gvc_setFont:(UIFont *)font range:(NSRange)range;
- (void)gvc_setFont:(UIFont *)font;

@end

