//
//  GVCAlertView.h
//  GVCUIKit
//
//  Created by David Aspinall on 2012-12-17.
//
//

#import <UIKit/UIKit.h>

/**
 * GVCAlertView block declaration is used for when the OK button is pressed
 */
typedef void (^GVCAlertViewOKBlock)();

/**
 * GVCAlertView block declaration is used for when the cancel or dismiss button is pressed
 */
typedef void (^GVCAlertViewDismissBlock)();

@interface GVCAlertView : UIAlertView


+ (id)alertWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle okTitle:(NSString *)okTitle dismissBlock:(GVCAlertViewDismissBlock)disBlock okBlock:(GVCAlertViewOKBlock)oBlock;

+ (void)showWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle okTitle:(NSString *)okTitle dismissBlock:(GVCAlertViewDismissBlock)disBlock okBlock:(GVCAlertViewOKBlock)oBlock;

- (id)initWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle okTitle:(NSString *)okTitle dismissBlock:(GVCAlertViewDismissBlock)disBlock okBlock:(GVCAlertViewOKBlock)oBlock;

- (id)initWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle dismissBlock:(GVCAlertViewDismissBlock)disBlock;

@property (nonatomic, copy) GVCAlertViewDismissBlock dismissBlock;
@property (nonatomic, copy) GVCAlertViewOKBlock okBlock;

// TODO: add support for - (NSInteger)addButtonWithTitle:(NSString *)title;

@end
