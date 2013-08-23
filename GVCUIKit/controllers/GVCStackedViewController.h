//
//  GVCStackedViewController.h
//  GVCUIKit
//
//  Created by David Aspinall on 2013-03-27.
//
//

#import <UIKit/UIKit.h>
#import "GVCUIViewController.h"

/** menuSegue */
GVC_DEFINE_EXTERN_STR(STACKED_MENU_SEGUE_ID);
/** defaultSegue */
GVC_DEFINE_EXTERN_STR(STACKED_DEFAULT_SEGUE_ID);

/**
 * Operation block declaration is used for the start and finished operation blocks
 * @param operation the operation that has started or finished
 */
typedef void (^GVCStackedViewSegueBlock)(UIStoryboardSegue *segue, id sender);


@interface GVCStackedViewController : GVCUIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong, readonly) UIViewController *menuViewController;
@property (assign, nonatomic) CGFloat menuViewWidth;

@property (nonatomic, strong, readonly) UIViewController *defaultViewController;

@property (strong, nonatomic) GVCStack *viewControllerStack;

/** Performs the segue, executes the block during the prepareForSegue: method */
- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender prepareBlock:(GVCStackedViewSegueBlock)block;


// toggle them opened/closed
- (IBAction)toggleMenuPanel:(id)sender;

@end

/**
 * storyboard segue to connect the container to the side scenes.  Must be menuSegue as identifer
 */
@interface GVCStackedMenuViewSegue : UIStoryboardSegue
@end

/**
 * storyboard segue to connect the container on of the root view scene.  The 'defaultSegue' is loaded automatically
 */
@interface GVCStackedRootViewSegue : UIStoryboardSegue
@end

