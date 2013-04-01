//
//  GVCUIKitFunctions.h
//
//  Created by David Aspinall on 12-06-28.
//  Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
//

#ifndef _GVCUIKitFunctions_
#define _GVCUIKitFunctions_

#import <UIKit/UIKit.h>
#import <GVCFoundation/GVCMacros.h>

GVC_DEFINE_EXTERN_STR(GVC_DEFAULT_VIEW_TITLE);

/**
 * This function creates a rect matching the width and height of the parameter rect, but with the origin adjusted to center the rect over the parameter point
 * @param rect - the rect to reposition
 * @param center - the point to center the resulting rect
 * @returns the rect with an adjusted origin
 */
GVC_EXTERN CGRect gvc_CGRectWithCenter(CGRect rect, CGPoint center);

#endif // _GVCUIKitFunctions_
