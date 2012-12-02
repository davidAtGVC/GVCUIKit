/*
 * GVCAppearance.h
 * 
 * Created by David Aspinall on 2012-11-29. 
 * Copyright (c) 2012 __MyCompanyName__. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import <GVCFoundation/GVCMacros.h>

/**
 * This class 
 */
@interface GVCAppearance : NSObject

GVC_SINGLETON_HEADER(GVCAppearance);

- (void)applyDefaultAppearance;
- (void)applyAppearance:(NSData *)jsonData;

@end
