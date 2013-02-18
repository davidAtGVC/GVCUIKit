/*
 * UINavigationController+GVCUIKit.m
 * 
 * Created by David Aspinall on 2013-02-01. 
 * Copyright (c) 2013 Global Village Consulting. All rights reserved.
 *
 */

#import "UINavigationController+GVCUIKit.h"

@implementation UINavigationController (GVCUIKit)

// This fixes an issue with the keyboard not dismissing on the iPad's login screen.
// http://stackoverflow.com/questions/3372333/ipad-keyboard-will-not-dismiss-if-modal-view-controller-presentation-style-is-ui/3386768#3386768
// http://developer.apple.com/library/ios/#documentation/uikit/reference/UIViewController_Class/Reference/Reference.html

- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}


@end
