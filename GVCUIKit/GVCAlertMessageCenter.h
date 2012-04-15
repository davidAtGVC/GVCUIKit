//
//  GVCAlertMessageCenter.h
//  HL7Domain
//
//  Created by David Aspinall on 10-12-13.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <dispatch/dispatch.h>

#import "GVCFoundation.h"

@class GVCStatusView;

@interface GVCAlertMessageCenter : NSObject 

GVC_SINGLETON_HEADER(GVCAlertMessageCenter);

- (void) timedAlert:(NSTimeInterval)interval withMessage:(NSString *)message;

- (void) startAlertWithMessage:(NSString *)message;
- (void) stopAlert;


@end
