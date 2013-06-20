//
//  GVCYearCalendarViewController.h
//  GVCUIKit
//
//  Created by David Aspinall on 2013-06-11.
//
//

#import <UIKit/UIKit.h>
#import "GVCUICollectionViewController.h"

typedef enum {
	GVCYearCalendarViewController_POSITION_start,
	GVCYearCalendarViewController_POSITION_centre,
	GVCYearCalendarViewController_POSITION_end
} GVCYearCalendarViewController_POSITION;

/**
 * Calendar selected year
 * @param year the year selected by the user
 */
typedef void (^GVCYearCalendarViewControllerBlock)(NSInteger year);

@interface GVCYearCalendarViewController : GVCUICollectionViewController

- (void)showCalendarYear:(NSInteger)year position:(GVCYearCalendarViewController_POSITION)position;

@property (readwrite, copy) GVCYearCalendarViewControllerBlock selectedYearBlock;

@end
