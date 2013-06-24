//
//  GVCCalendarDayEventCollectionViewController.m
//  GVCUIKit
//
//  Created by David Aspinall on 2013-06-21.
//
//

#import "GVCCalendarDayEventCollectionViewController.h"
#import "GVCCalendarDayEventCollectionViewLayout.h"
#import <GVCFoundation/GVCFoundation.h>


@interface GVCCalendarDayEventCollectionViewController ()

@end

@implementation GVCCalendarDayEventCollectionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	GVC_ASSERT([[[self collectionView] collectionViewLayout] isKindOfClass:[GVCCalendarDayEventCollectionViewLayout class]], @"Wrong collection layout class, should be 'GVCCalendarDayEventCollectionViewLayout'");
	
    [[self collectionView] setBackgroundColor:[UIColor whiteColor]];
    
    [[self collectionView] registerClass:[GVCCalendarEventViewCell class] forCellWithReuseIdentifier:GVCCalendarEventViewCell_IDENTIFIER];
    [[self collectionView] registerClass:[GVCCalendarDayHeaderView class] forSupplementaryViewOfKind:GVCCalendarDayEventDayHeaderType withReuseIdentifier:GVCCalendarDayHeaderView_IDENTIFIER];
    [[self collectionView] registerClass:[GVCCalendarTimeRowView class] forSupplementaryViewOfKind:GVCCalendarDayEventTimeRowType withReuseIdentifier:GVCCalendarTimeRowView_IDENTIFIER];
	
    // These are optional—if you don't want any of the decoration views, just don't register a class for it
    [[[self collectionView] collectionViewLayout] registerClass:[GVCGridlineReusableView class] forDecorationViewOfKind:GVCCalendarGridLayoutType];
//    [[self collectionView]Layout registerClass:MSTimeRowHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindTimeRowHeaderBackground];
//    [[self collectionView]Layout registerClass:MSDayColumnHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindDayColumnHeaderBackground];
}

#pragma mark - UICollectionViewDataSource

- (id <GVCCalendarEventProtocol>)eventAtIndexPath:(NSIndexPath *)indexPath
{
	GVC_SUBCLASS_RESPONSIBLE;
	return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GVCCalendarEventViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GVCCalendarEventViewCell_IDENTIFIER forIndexPath:indexPath];
	[cell setEvent:[self eventAtIndexPath:indexPath]];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view;
	GVCCalendarDayEventCollectionViewLayout *layout = (GVCCalendarDayEventCollectionViewLayout *)[[self collectionView] collectionViewLayout];
    if ([kind isEqualToString:GVCCalendarDayEventDayHeaderType] == YES)
	{
        GVCCalendarDayHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:GVCCalendarDayHeaderView_IDENTIFIER forIndexPath:indexPath];
		[header setDate:[layout dateForDayHeaderAtIndexPath:indexPath]];
        view = header;
    }
    else if ([kind isEqualToString:GVCCalendarDayEventTimeRowType] == YES)
	{
        GVCCalendarTimeRowView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:GVCCalendarTimeRowView_IDENTIFIER forIndexPath:indexPath];
		[header setTime:[layout dateForTimeRowAtIndexPath:indexPath]];
        view = header;
    }
    return view;
}

#pragma mark - MSCollectionViewCalendarLayout

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(GVCCalendarDayEventCollectionViewLayout *)collectionViewLayout dayForSection:(NSInteger)section
{
	id <GVCCalendarEventProtocol>event = [self eventAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
    return [event eventStartDate];
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(GVCCalendarDayEventCollectionViewLayout *)collectionViewLayout startTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	id <GVCCalendarEventProtocol>event = [self eventAtIndexPath:indexPath];
    return [event eventStartDate];
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(GVCCalendarDayEventCollectionViewLayout *)collectionViewLayout endTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	id <GVCCalendarEventProtocol>event = [self eventAtIndexPath:indexPath];
    return [event eventStartDate];
}

@end
