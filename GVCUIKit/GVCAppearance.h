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

/**
 * loads the appearance configuration from [MAIN_BUNDLE]/appearance.json
 */
- (void)applyDefaultAppearance;

/**
 * loads the appearance configuration from provided json data
 */
- (void)applyAppearance:(NSData *)jsonData;

@end
