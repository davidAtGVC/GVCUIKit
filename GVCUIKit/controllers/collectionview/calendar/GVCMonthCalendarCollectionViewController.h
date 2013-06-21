//
//  GVCMonthCalendarCollectionViewController.h
//  GVCUIKit
//
//  Created by David Aspinall on 2013-06-20.
//
//

#import <GVCUIKit/GVCUIKit.h>

/**
 * Calendar selected year
 * @param year the year selected by the user
 */
typedef void (^GVCMonthCalendarCollectionViewControllerBlock)(NSDate *selectedDate);

@interface GVCMonthCalendarCollectionViewController : GVCUICollectionViewController

@property (strong, nonatomic) NSDate *date;

@property (readwrite, copy) GVCMonthCalendarCollectionViewControllerBlock selectedDateBlock;

@end
