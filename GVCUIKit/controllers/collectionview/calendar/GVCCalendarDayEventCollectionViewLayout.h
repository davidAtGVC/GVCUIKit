//
//  GVCCalendarDayEventCollectionViewLayout.h
//  GVCUIKit
//
//  Created by David Aspinall on 2013-06-21.
//
//

#import <UIKit/UIKit.h>
#import <GVCFoundation/GVCMacros.h>
#import "GVCCalendarGridLayout.h"

GVC_DEFINE_EXTERN_STR(GVCCalendarDayEventTimeRowType);
GVC_DEFINE_EXTERN_STR(GVCCalendarDayEventTimeRowBackgroundType);
GVC_DEFINE_EXTERN_STR(GVCCalendarDayEventDayHeaderType);
GVC_DEFINE_EXTERN_STR(GVCCalendarDayEventDayHeaderBackgroundType);

@protocol GVCCalendarDayEventCollectionViewLayoutDelegate;

@interface GVCCalendarDayEventCollectionViewLayout : GVCCalendarGridLayout

@property (nonatomic, weak) id <GVCCalendarDayEventCollectionViewLayoutDelegate> delegate;

@property (nonatomic, assign) CGFloat sectionWidth;
@property (nonatomic, assign) CGFloat hourHeight;
@property (nonatomic, assign) CGFloat dayHeaderHeight;
@property (nonatomic, assign) CGFloat timeRowHeaderWidth;
@property (nonatomic, assign) CGSize currentTimeIndicatorSize;
@property (nonatomic, assign) CGFloat horizontalGridlineHeight;
@property (nonatomic, assign) CGFloat currentTimeHorizontalGridlineHeight;

@property (nonatomic, assign) UIEdgeInsets sectionMargin;
@property (nonatomic, assign) UIEdgeInsets contentMargin;
@property (nonatomic, assign) UIEdgeInsets cellMargin;

- (NSDate *)dateForTimeRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSDate *)dateForDayHeaderAtIndexPath:(NSIndexPath *)indexPath;

@end



@protocol GVCCalendarDayEventCollectionViewLayoutDelegate <UICollectionViewDelegate>

@required

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(GVCCalendarDayEventCollectionViewLayout *)collectionViewLayout dayForSection:(NSInteger)section;

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(GVCCalendarDayEventCollectionViewLayout *)collectionViewLayout startTimeForItemAtIndexPath:(NSIndexPath *)indexPath;

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(GVCCalendarDayEventCollectionViewLayout *)collectionViewLayout endTimeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
