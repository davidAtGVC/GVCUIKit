/*
 * GVCUIProtocols.h
 * 
 * Created by David Aspinall on 12-06-22. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <GVCFoundation/GVCFoundation.h>

#ifndef GVCUIKit_GVCUIProtocols_h
#define GVCUIKit_GVCUIProtocols_h

@protocol GVCDismissPopoverProtocol <NSObject>
- (void)dismissPopover:sender;
@end


@protocol GVCViewTitleProtocol <NSObject>
- (NSString *)viewTitle;
@end


#endif
