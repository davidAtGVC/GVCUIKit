//
//  GVCLockViewManager.h
//  GVCUIKit
//
//  Created by David Aspinall on 2013-06-28.
//
//

#import <Foundation/Foundation.h>
#import <GVCFoundation/GVCFoundation.h>

typedef enum {
    GVCLockViewManager_TYPE_always,
    GVCLockViewManager_TYPE_delay
} GVCLockViewManager_TYPE;

typedef UIViewController * (^GVCLockViewManager_ShowLoginBlock)(void);

@interface GVCLockViewManager : NSObject

GVC_SINGLETON_HEADER(GVCLockViewManager);

/** places the splash image over the screen on resume to hide the app contents. Default is YES */
@property (assign, nonatomic) BOOL splashOnResume;

/** delay in seconds before the application is locked.  Default is 300.  Saves into the user defaults database */
@property (assign, nonatomic) NSInteger lockDownDelayInSeconds;

- (GVCLockViewManager_TYPE)lockType;

/** This block should load and initialize the view controller that will perform the login.  The manager will present it */
@property (readwrite, copy) GVCLockViewManager_ShowLoginBlock loginViewControllerBlock;


- (void)forceLoginViewForActiveApplication;
- (void)presentLoginViewForActiveApplication;
- (void)registerViewControllerIfModal:(UIViewController *)controller;

@end
