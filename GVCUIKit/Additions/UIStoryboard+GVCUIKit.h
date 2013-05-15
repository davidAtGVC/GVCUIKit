//
//  UIStoryboard+GVCUIKit.h
//  GVCUIKit
//
//  Created by David Aspinall on 2013-05-15.
//
//

#import <UIKit/UIKit.h>

@interface UIStoryboard (GVCUIKit)

+ (UIStoryboard *)gvc_mainStoryboard;
+ (UIStoryboard *)gvc_storyboardNamed:(NSString *)name;

@end
