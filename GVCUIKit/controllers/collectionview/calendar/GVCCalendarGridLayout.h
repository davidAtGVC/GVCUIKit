//
//  GVCCalendarGridLayout.h
//  GVCUIKit
//
//  Created by David Aspinall on 2013-06-22.
//
//

#import <UIKit/UIKit.h>
#import <GVCFoundation/GVCMacros.h>

GVC_DEFINE_EXTERN_STR(GVCCalendarGridLayoutType);

@interface GVCCalendarGridLayout : UICollectionViewLayout

/** allows subclasses to override default values */
- (void)initializeLayout;

@property (assign, nonatomic) NSUInteger startHour;
@property (assign, nonatomic) NSUInteger endHour;

@property (assign, nonatomic, getter = isHighlightingWorkHours) BOOL highlightWorkHours;
@property (assign, nonatomic) NSUInteger workStartHour;
@property (assign, nonatomic) NSUInteger workEndHour;

- (CGFloat)oneHourHeight;

@end
