//
//  GVCFunctions.m
//  GVCFoundation
//
//  Created by David Aspinall on 11-09-30.
//  Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVCUIKitFunctions.h"

GVC_DEFINE_STRVALUE(GVC_DEFAULT_VIEW_TITLE, viewTitle);

CGRect gvc_CGRectWithCenter(CGRect rect, CGPoint center)
{
	CGRect adjRect = CGRectZero;
	adjRect.origin.x = center.x - CGRectGetMidX(rect);
	adjRect.origin.y = center.y - CGRectGetMidY(rect);
	adjRect.size = rect.size;
	return adjRect;
}

