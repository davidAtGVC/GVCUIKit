//
//  GVCSlideViewController.h
//  GVCUIKit
//
//  Created by David Aspinall on 2013-03-27.
//
//

#import <UIKit/UIKit.h>
#import "GVCUIViewController.h"

/** rightSegue */
GVC_DEFINE_EXTERN_STR(SLIDE_RIGHT_SEGUE_ID);
/** leftSegue */
GVC_DEFINE_EXTERN_STR(SLIDE_LEFT_SEGUE_ID);
/** defaultSegue */
GVC_DEFINE_EXTERN_STR(SLIDE_DEFAULT_SEGUE_ID);

/**
 * Operation block declaration is used for the start and finished operation blocks
 * @param operation the operation that has started or finished
 */
typedef void (^GVCSlideViewSegueBlock)(UIStoryboardSegue *segue, id sender);


/** The Slide view controller supports 3 sub-view controllers.  The root and 2 hidden views on the left and right sides */
@interface GVCSlideViewController : GVCUIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong, readonly) UIViewController *leftViewController;
@property (nonatomic, strong, readonly) UIViewController *rootViewController;
@property (nonatomic, strong, readonly) UIViewController *rightViewController;

/** Performs the segue, executes the block during the prepareForSegue: method */
- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender prepareBlock:(GVCSlideViewSegueBlock)block;

/**
 * Width values may be a percentage (0.0 - 0.8) or a fixed width (60.0 - 80% bounds)
 */
@property (assign, nonatomic) CGFloat leftViewWidth;
@property (assign, nonatomic) CGFloat rightViewWidth;

// toggle them opened/closed
- (IBAction)toggleLeftPanel:(id)sender;
- (IBAction)toggleRightPanel:(id)sender;

@end

/**
 * storyboard segue to connect the container to the side scenes.  Must be leftSegue or rightSegue as identifers
 */
@interface GVCSlideMenuViewSegue : UIStoryboardSegue
@end

/**
 * storyboard segue to connect the container on of the root view scene.  The 'defaultSegue' is loaded automatically
 */
@interface GVCSlideRootViewSegue : UIStoryboardSegue
@end

