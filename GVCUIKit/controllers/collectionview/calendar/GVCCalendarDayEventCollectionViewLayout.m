//
//  GVCCalendarDayEventCollectionViewLayout.m
//  GVCUIKit
//
//  Created by David Aspinall on 2013-06-21.
//
//

#import "GVCCalendarDayEventCollectionViewLayout.h"
#import <GVCFoundation/GVCFoundation.h>


GVC_DEFINE_STR(GVCCalendarDayEventTimeRowType);
GVC_DEFINE_STR(GVCCalendarDayEventTimeRowBackgroundType);
GVC_DEFINE_STR(GVCCalendarDayEventDayHeaderType);
GVC_DEFINE_STR(GVCCalendarDayEventDayHeaderBackgroundType);

NSUInteger const GVCCalendarDayEventCollectionMinimumOverlayZ = 1000.0;
NSUInteger const GVCCalendarDayEventCollectionMinimumCellZ = 100.0;  // Allows for 100 items in a section's background
NSUInteger const GVCCalendarDayEventCollectionMinimumBackgroundZ = 0.0;

@interface GVCCalendarDayEventCollectionViewLayout ()

@property (nonatomic, strong) NSMutableArray *allAttributes;
@property (nonatomic, strong) NSMutableDictionary *itemAttributes;
@property (nonatomic, strong) NSMutableDictionary *dayHeaderAttributes;
@property (nonatomic, strong) NSMutableDictionary *dayHeaderBackgroundAttributes;
@property (nonatomic, strong) NSMutableDictionary *timeRowHeaderAttributes;
@property (nonatomic, strong) NSMutableDictionary *timeRowHeaderBackgroundAttributes;
@property (nonatomic, strong) NSMutableDictionary *horizontalGridlineAttributes;
@end


@implementation GVCCalendarDayEventCollectionViewLayout

- (id)init
{
    self = [super init];
    if (self != nil)
	{
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil)
	{
        [self initialize];
    }
    return self;
}

#pragma mark - UICollectionViewLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
//    if (gvc_IsEmpty([self allAttributes]) == YES)
//	{
//        [self.allAttributes addObjectsFromArray:[self.dayHeaderAttributes allValues]];
//        [self.allAttributes addObjectsFromArray:[self.timeRowHeaderAttributes allValues]];
//        [self.allAttributes addObjectsFromArray:[self.horizontalGridlineAttributes allValues]];
//        [self.allAttributes addObjectsFromArray:[self.itemAttributes allValues]];
//    }
}

//- (void)prepareSectionLayoutForSections:(NSIndexSet *)sectionIndexes
//{
//    if (self.collectionView.numberOfSections == 0) {
//        return;
//    }
//    
//    BOOL needsToPopulateItemAttributes = (self.itemAttributes.count == 0);
//    BOOL needsToPopulateHorizontalGridlineAttributes = (self.horizontalGridlineAttributes.count == 0);
//    
//    CGFloat calendarGridMinX = (self.timeRowHeaderWidth + self.contentMargin.left);
//    CGFloat calendarGridWidth = (self.collectionViewContentSize.width - self.timeRowHeaderWidth - self.contentMargin.left - self.contentMargin.right);
//    
//    [sectionIndexes enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
//        
//        NSInteger earliestHour = [self earliestHourForSection:section];
//        NSInteger latestHour = [self latestHourForSection:section];
//        
//        CGFloat columnMinY = (section == 0) ? 0.0 : [self stackedSectionHeightUpToSection:section];
//        CGFloat nextColumnMinY = (section == (NSUInteger)self.collectionView.numberOfSections) ? self.collectionViewContentSize.height : [self stackedSectionHeightUpToSection:(section + 1)];
//        CGFloat calendarGridMinY = (columnMinY + self.dayHeaderHeight + self.contentMargin.top);
//        
//        // Day Column Header
//        CGFloat dayHeaderMinY = fminf(fmaxf(self.collectionView.contentOffset.y, columnMinY), (nextColumnMinY - self.dayHeaderHeight));
//        NSIndexPath *dayHeaderIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
//        UICollectionViewLayoutAttributes *dayHeaderAttributes = [self layoutAttributesForSupplementaryViewAtIndexPath:dayHeaderIndexPath ofKind:GVCCalendarDayEventDayHeaderType withItemCache:self.dayHeaderAttributes];
//        // Frame
//        dayHeaderAttributes.frame = CGRectMake(0.0, dayHeaderMinY, self.collectionViewContentSize.width, self.dayHeaderHeight);
//        dayHeaderAttributes.zIndex = [self zIndexForElementKind:GVCCalendarDayEventDayHeaderType floating:YES];
//        
//        // Day Column Header Background
//        NSIndexPath *dayHeaderBackgroundIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
//        UICollectionViewLayoutAttributes *dayHeaderBackgroundAttributes = [self layoutAttributesForDecorationViewAtIndexPath:dayHeaderBackgroundIndexPath ofKind:GVCCalendarDayEventDayHeaderBackgroundType withItemCache:self.dayHeaderBackgroundAttributes];
//        // Frame
//        CGFloat dayHeaderBackgroundMinX = -nearbyintf(self.collectionView.frame.size.width / 2.0);
//        CGFloat dayHeaderBackgroundWidth = fmaxf(self.collectionViewContentSize.width + self.collectionView.frame.size.width, self.collectionView.frame.size.width);
//        dayHeaderBackgroundAttributes.frame = CGRectMake(dayHeaderBackgroundMinX, dayHeaderMinY, dayHeaderBackgroundWidth, self.dayHeaderHeight);
//        // Floating
//        dayHeaderBackgroundAttributes.hidden = NO;
//        dayHeaderBackgroundAttributes.zIndex = [self zIndexForElementKind:GVCCalendarDayEventDayHeaderBackgroundType floating:YES];
//        
//        // Time Row Headers
//        NSUInteger timeRowHeaderIndex = 0;
//        for (NSInteger hour = earliestHour; hour <= latestHour; hour++) {
//            // Time Row Header
//            NSIndexPath *timeRowHeaderIndexPath = [NSIndexPath indexPathForItem:timeRowHeaderIndex inSection:section];
//            UICollectionViewLayoutAttributes *timeRowHeaderAttributes = [self layoutAttributesForSupplementaryViewAtIndexPath:timeRowHeaderIndexPath ofKind:GVCCalendarDayEventTimeRowType withItemCache:self.timeRowHeaderAttributes];
//            // Frame
//            CGFloat titleRowHeaderMinY = (calendarGridMinY + (self.hourHeight * (hour - earliestHour)) - nearbyintf(self.hourHeight / 2.0));
//            timeRowHeaderAttributes.frame = CGRectMake(0.0, titleRowHeaderMinY, self.timeRowHeaderWidth, self.hourHeight);
//            timeRowHeaderAttributes.zIndex = [self zIndexForElementKind:GVCCalendarDayEventTimeRowType];
//            timeRowHeaderIndex++;
//        }
//        
//        if (needsToPopulateItemAttributes) {
//            // Items
//            CGFloat sectionMinX = (calendarGridMinX + self.sectionMargin.left);
//            NSMutableArray *sectionItemAttributes = [NSMutableArray new];
//            for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item++) {
//                
//                NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
//                UICollectionViewLayoutAttributes *itemAttributes = [self layoutAttributesForCellAtIndexPath:itemIndexPath withItemCache:self.itemAttributes];
//                [sectionItemAttributes addObject:itemAttributes];
//                
//                NSDateComponents *itemStartTime = [self startTimeForIndexPath:itemIndexPath];
//                NSDateComponents *itemEndTime = [self endTimeForIndexPath:itemIndexPath];
//                
//                CGFloat startHourY = ((itemStartTime.hour - earliestHour) * self.hourHeight);
//                CGFloat startMinuteY = (itemStartTime.minute * self.minuteHeight);
//                
//                CGFloat endHourY;
//                if (itemEndTime.day != itemStartTime.day) {
//                    endHourY = (([[NSCalendar currentCalendar] maximumRangeOfUnit:NSCalendarUnitHour].length - earliestHour) * self.hourHeight) + ((itemEndTime.hour) * self.hourHeight);
//                } else {
//                    endHourY = ((itemEndTime.hour - earliestHour) * self.hourHeight);
//                }
//                CGFloat endMinuteY = (itemEndTime.minute * self.minuteHeight);
//                
//                CGFloat itemMinY = (startHourY + startMinuteY + calendarGridMinY + self.cellMargin.top);
//                CGFloat itemMaxY = (endHourY + endMinuteY + calendarGridMinY - self.cellMargin.bottom);
//                CGFloat itemMinX = (calendarGridMinX + self.sectionMargin.left + self.cellMargin.left);
//                CGFloat itemMaxX = (itemMinX + (self.sectionWidth - self.cellMargin.left - self.cellMargin.right));
//                itemAttributes.frame = CGRectMake(itemMinX, itemMinY, (itemMaxX - itemMinX), (itemMaxY - itemMinY));
//                
//                itemAttributes.zIndex = [self zIndexForElementKind:nil];
//            }
//            [self adjustItemsForOverlap:sectionItemAttributes inSection:section sectionMinX:sectionMinX];
//        }
//        
//        // Horizontal Gridlines
//        if (needsToPopulateHorizontalGridlineAttributes) {
//            NSUInteger horizontalGridlineIndex = 0;
//            for (NSInteger hour = earliestHour; hour <= latestHour; hour++) {
//                NSIndexPath *horizontalGridlineIndexPath = [NSIndexPath indexPathForItem:horizontalGridlineIndex inSection:section];
//                UICollectionViewLayoutAttributes *horizontalGridlineAttributes = [self layoutAttributesForDecorationViewAtIndexPath:horizontalGridlineIndexPath ofKind:GVCCalendarGridLayout withItemCache:self.horizontalGridlineAttributes];
//                // Frame
//                CGFloat horizontalGridlineMinY = (calendarGridMinY + (self.hourHeight * (hour - earliestHour))) - nearbyintf(self.horizontalGridlineHeight / 2.0);
//                horizontalGridlineAttributes.frame = CGRectMake(calendarGridMinX, horizontalGridlineMinY, calendarGridWidth, self.horizontalGridlineHeight);
//                horizontalGridlineAttributes.zIndex = [self zIndexForElementKind:GVCCalendarGridLayout];
//                horizontalGridlineIndex++;
//            }
//        }
//    }];
//}

- (void)adjustItemsForOverlap:(NSArray *)sectionItemAttributes inSection:(NSUInteger)section sectionMinX:(CGFloat)sectionMinX
{
    NSMutableSet *adjustedAttributes = [NSMutableSet new];
    NSUInteger sectionZ = GVCCalendarDayEventCollectionMinimumCellZ;
    
    for (UICollectionViewLayoutAttributes *itemAttributes in sectionItemAttributes) {
        
        // If an item's already been adjusted, move on to the next one
        if ([adjustedAttributes containsObject:itemAttributes]) {
            continue;
        }
        
        // Find the other items that overlap with this item
        NSMutableArray *overlappingItems = [NSMutableArray new];
        CGRect itemFrame = itemAttributes.frame;
        [overlappingItems addObjectsFromArray:[sectionItemAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *layoutAttributes, NSDictionary *bindings) {
            if ((layoutAttributes != itemAttributes)) {
                return CGRectIntersectsRect(itemFrame, layoutAttributes.frame);
            } else {
                return NO;
            }
        }]]];
        
        // If there's items overlapping, we need to adjust them
        if (overlappingItems.count) {
            
            // Add the item we're adjusting to the overlap set
            [overlappingItems insertObject:itemAttributes atIndex:0];
            
            // Find the minY and maxY of the set
            CGFloat minY = CGFLOAT_MAX;
            CGFloat maxY = CGFLOAT_MIN;
            for (UICollectionViewLayoutAttributes *overlappingItemAttributes in overlappingItems) {
                if (CGRectGetMinY(overlappingItemAttributes.frame) < minY) {
                    minY = CGRectGetMinY(overlappingItemAttributes.frame);
                }
                if (CGRectGetMaxY(overlappingItemAttributes.frame) > maxY) {
                    maxY = CGRectGetMaxY(overlappingItemAttributes.frame);
                }
            }
            
            // Determine the number of divisions needed (maximum number of currently overlapping items)
            NSInteger divisions = 1;
            for (CGFloat currentY = minY; currentY <= maxY; currentY += 1.0) {
                NSInteger numberItemsForCurrentY = 0;
                for (UICollectionViewLayoutAttributes *overlappingItemAttributes in overlappingItems) {
                    if ((currentY >= CGRectGetMinY(overlappingItemAttributes.frame)) && (currentY < CGRectGetMaxY(overlappingItemAttributes.frame))) {
                        numberItemsForCurrentY++;
                    }
                }
                if (numberItemsForCurrentY > divisions) {
                    divisions = numberItemsForCurrentY;
                }
            }
            
            // Adjust the items to have a width of the section size divided by the number of divisions needed
            CGFloat divisionWidth = nearbyintf(self.sectionWidth / divisions);
            
            NSMutableArray *dividedAttributes = [NSMutableArray array];
            for (UICollectionViewLayoutAttributes *divisionAttributes in overlappingItems) {
                
                CGFloat itemWidth = (divisionWidth - self.cellMargin.left - self.cellMargin.right);
                
                // It it hasn't yet been adjusted, perform adjustment
                if (![adjustedAttributes containsObject:divisionAttributes]) {
					
                    CGRect divisionAttributesFrame = divisionAttributes.frame;
                    divisionAttributesFrame.origin.x = (sectionMinX + self.cellMargin.left);
                    divisionAttributesFrame.size.width = itemWidth;
					
                    // Horizontal Layout
                    NSInteger adjustments = 1;
                    for (UICollectionViewLayoutAttributes *dividedItemAttributes in dividedAttributes) {
                        if (CGRectIntersectsRect(dividedItemAttributes.frame, divisionAttributesFrame)) {
                            divisionAttributesFrame.origin.x = sectionMinX + ((divisionWidth * adjustments) + self.cellMargin.left);
                            adjustments++;
                        }
                    }
					
                    // Stacking (lower items stack above higher items, since the title is at the top)
                    divisionAttributes.zIndex = sectionZ;
                    sectionZ ++;
                    
                    divisionAttributes.frame = divisionAttributesFrame;
                    [dividedAttributes addObject:divisionAttributes];
                    [adjustedAttributes addObject:divisionAttributes];
                }
            }
        }
    }
}

//- (CGSize)collectionViewContentSize
//{
//	CGFloat height = [self stackedSectionHeight];
//	CGFloat width = (self.timeRowHeaderWidth + self.contentMargin.left + self.sectionMargin.left + self.sectionWidth + self.sectionMargin.right + self.contentMargin.right);
//    return CGSizeMake(width, height);
//}

//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return self.itemAttributes[indexPath];
//}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:GVCCalendarDayEventDayHeaderType]) {
        return self.dayHeaderAttributes[indexPath];
    }
    else if ([kind isEqualToString:GVCCalendarDayEventTimeRowType]) {
        return self.timeRowHeaderAttributes[indexPath];
    }
    return nil;
}

//- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
//{
//	if ([decorationViewKind isEqualToString:GVCCalendarGridLayoutType]) {
//        return self.horizontalGridlineAttributes[indexPath];
//    }
//    else if ([decorationViewKind isEqualToString:GVCCalendarDayEventTimeRowBackgroundType]) {
//        return self.timeRowHeaderBackgroundAttributes[indexPath];
//    }
//    else if ([decorationViewKind isEqualToString:GVCCalendarDayEventDayHeaderType]) {
//        return self.dayHeaderBackgroundAttributes[indexPath];
//    }
//    return nil;
//}

//- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    NSMutableIndexSet *visibleSections = [NSMutableIndexSet indexSet];
//    [[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.collectionView.numberOfSections)] enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
//        CGRect sectionRect = [self rectForSection:section];
//        if (CGRectIntersectsRect(sectionRect, rect)) {
//            [visibleSections addIndex:section];
//        }
//    }];
//    
//    // Update layout for only the visible sections
//    [self prepareSectionLayoutForSections:visibleSections];
//    
//    // Return the visible attributes (rect intersection)
//    return [self.allAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *layoutAttributes, NSDictionary *bindings) {
//        return CGRectIntersectsRect(rect, layoutAttributes.frame);
//    }]];
//}

//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
//{
//    // Required for sticky headers
//    return YES;
//}

#pragma mark - MSCollectionViewCalendarLayout

- (void)initialize
{
    self.allAttributes = [NSMutableArray new];
    self.itemAttributes = [NSMutableDictionary new];
    self.dayHeaderAttributes = [NSMutableDictionary new];
    self.dayHeaderBackgroundAttributes = [NSMutableDictionary new];
    self.timeRowHeaderAttributes = [NSMutableDictionary new];
    self.timeRowHeaderBackgroundAttributes = [NSMutableDictionary new];
    self.horizontalGridlineAttributes = [NSMutableDictionary new];
    
    self.hourHeight = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 80.0 : 80.0);
    self.sectionWidth = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 236.0 : 234.0);
    self.dayHeaderHeight = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 60.0 : 50.0);
    self.timeRowHeaderWidth = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 60.0 : 60.0);
    self.horizontalGridlineHeight = 1.0;
    self.sectionMargin = UIEdgeInsetsMake(0.0, 8.0, 0.0, 8.0);
    self.cellMargin = UIEdgeInsetsMake(0.0, 1.0, 1.0, 0.0);
    self.contentMargin = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? UIEdgeInsetsMake(30.0, 0.0, 30.0, 30.0) : UIEdgeInsetsMake(20.0, 0.0, 20.0, 10.0));
}


#pragma mark - Layout

//- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewAtIndexPath:(NSIndexPath *)indexPath ofKind:(NSString *)kind withItemCache:(NSMutableDictionary *)itemCache
//{
//    UICollectionViewLayoutAttributes *layoutAttributes = itemCache[indexPath];
//    if (layoutAttributes == nil )
//	{
//        layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:kind withIndexPath:indexPath];
//        itemCache[indexPath] = layoutAttributes;
//    }
//    return layoutAttributes;
//}
//
//- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewAtIndexPath:(NSIndexPath *)indexPath ofKind:(NSString *)kind withItemCache:(NSMutableDictionary *)itemCache
//{
//    UICollectionViewLayoutAttributes *layoutAttributes = itemCache[indexPath];
//    if (layoutAttributes == nil )
//	{
//        layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
//        itemCache[indexPath] = layoutAttributes;
//    }
//    return layoutAttributes;
//}
//
//- (UICollectionViewLayoutAttributes *)layoutAttributesForCellAtIndexPath:(NSIndexPath *)indexPath withItemCache:(NSMutableDictionary *)itemCache
//{
//    UICollectionViewLayoutAttributes *layoutAttributes = itemCache[indexPath];
//    if (layoutAttributes == nil )
//	{
//        layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//        itemCache[indexPath] = layoutAttributes;
//    }
//    return layoutAttributes;
//}

- (void)invalidateLayout
{
	[super invalidateLayout];
	
	// Invalidate cached item attributes
    [self.itemAttributes removeAllObjects];
    [self.horizontalGridlineAttributes removeAllObjects];
    [self.dayHeaderAttributes removeAllObjects];
    [self.dayHeaderBackgroundAttributes removeAllObjects];
    [self.timeRowHeaderAttributes removeAllObjects];
    [self.timeRowHeaderBackgroundAttributes removeAllObjects];
    [self.allAttributes removeAllObjects];
}

#pragma mark Dates

- (NSDate *)dateForTimeRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger earliestHour = [self earliestHourForSection:indexPath.section];
    NSDateComponents *dateComponents = [self dayForSection:indexPath.section];
    dateComponents.hour = (earliestHour + indexPath.item);
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}

- (NSDate *)dateForDayHeaderAtIndexPath:(NSIndexPath *)indexPath
{
	id <GVCCalendarDayEventCollectionViewLayoutDelegate> del = [self delegate];
	
	NSDate *date = nil;
	if ( del != nil )
	{
		date =[del collectionView:[self collectionView] layout:self dayForSection:indexPath.section];
		date = [date gvc_dateAdjustedToStartOfDay];
	}
	return date;
}


#pragma mark Section Sizing

- (CGRect)rectForSection:(NSInteger)section
{
	CGFloat columnMinY = (section == 0) ? 0.0 : [self stackedSectionHeightUpToSection:section];
	CGFloat nextColumnMinY = (section == self.collectionView.numberOfSections) ? self.collectionViewContentSize.height : [self stackedSectionHeightUpToSection:(section + 1)];
	CGRect sectionRect = CGRectMake(0.0, columnMinY, self.collectionViewContentSize.width, (nextColumnMinY - columnMinY));
    return sectionRect;
}

- (CGFloat)maxSectionHeight
{
    CGFloat maxSectionHeight = 0.0;
    for (NSInteger section = 0; section < self.collectionView.numberOfSections; section++)
	{
        NSInteger earliestHour = [self earliestHour];
        NSInteger latestHour = [self latestHourForSection:section];
        CGFloat sectionColumnHeight = 0.0;
        if ((earliestHour != NSDateComponentUndefined) && (latestHour != NSDateComponentUndefined)) {
            sectionColumnHeight = (self.hourHeight * (latestHour - earliestHour));
        }
        
        if (sectionColumnHeight > maxSectionHeight) {
            maxSectionHeight = sectionColumnHeight;
        }
    }
	return (maxSectionHeight + (self.dayHeaderHeight + self.contentMargin.top + self.contentMargin.bottom));
}

- (CGFloat)stackedSectionHeight
{
    return [self stackedSectionHeightUpToSection:self.collectionView.numberOfSections];
}

- (CGFloat)stackedSectionHeightUpToSection:(NSInteger)upToSection
{
    CGFloat stackedSectionHeight = 0.0;
    for (NSInteger section = 0; section < upToSection; section++)
	{
        CGFloat sectionColumnHeight = [self sectionHeight:section];
        stackedSectionHeight += sectionColumnHeight;
    }
    return (stackedSectionHeight + ((self.dayHeaderHeight + self.contentMargin.top + self.contentMargin.bottom) * upToSection));
}

- (CGFloat)sectionHeight:(NSInteger)section
{
    NSInteger earliestHour = [self earliestHourForSection:section];
    NSInteger latestHour = [self latestHourForSection:section];
    
    if ((earliestHour != NSDateComponentUndefined) && (latestHour != NSDateComponentUndefined)) {
        return (self.hourHeight * (latestHour - earliestHour));
    }
	return 0.0;
}

- (CGFloat)minuteHeight
{
    return (self.hourHeight / 60.0);
}

#pragma mark Z Index

- (CGFloat)zIndexForElementKind:(NSString *)elementKind
{
    return [self zIndexForElementKind:elementKind floating:NO];
}

- (CGFloat)zIndexForElementKind:(NSString *)elementKind floating:(BOOL)floating
{
	// Day Column Header
	if ([elementKind isEqualToString:GVCCalendarDayEventDayHeaderType]) {
		return (GVCCalendarDayEventCollectionMinimumOverlayZ + (floating ? 6.0 : 4.0));
	}
	// Day Column Header Background
	else if ([elementKind isEqualToString:GVCCalendarDayEventDayHeaderBackgroundType]) {
		return (GVCCalendarDayEventCollectionMinimumOverlayZ + (floating ? 5.0 : 3.0));
	}
	// Time Row Header
	if ([elementKind isEqualToString:GVCCalendarDayEventTimeRowType]) {
		return (GVCCalendarDayEventCollectionMinimumOverlayZ + 1.0);
	}
	// Time Row Header Background
	else if ([elementKind isEqualToString:GVCCalendarDayEventTimeRowBackgroundType]) {
		return GVCCalendarDayEventCollectionMinimumOverlayZ;
	}
	// Cell
	else if (elementKind == nil) {
		return GVCCalendarDayEventCollectionMinimumCellZ;
	}
	// Horizontal Gridline
	else if ([elementKind isEqualToString:GVCCalendarGridLayoutType]) {
		return GVCCalendarDayEventCollectionMinimumBackgroundZ;
	}
    return CGFLOAT_MIN;
}

#pragma mark Hours

- (NSInteger)earliestHour
{
    NSInteger earliestHour = NSIntegerMax;
    for (NSInteger section = 0; section < self.collectionView.numberOfSections; section++)
	{
        CGFloat sectionEarliestHour = [self earliestHourForSection:section];
        if ((sectionEarliestHour < earliestHour) && (sectionEarliestHour != NSDateComponentUndefined))
		{
            earliestHour = sectionEarliestHour;
        }
    }
    if (earliestHour != NSIntegerMax)
	{
        return earliestHour;
    }
	return 0;
}

- (NSInteger)latestHour
{
    NSInteger latestHour = NSIntegerMin;
    for (NSInteger section = 0; section < self.collectionView.numberOfSections; section++)
	{
        CGFloat sectionLatestHour = [self latestHourForSection:section];
        if ((sectionLatestHour > latestHour) && (sectionLatestHour != NSDateComponentUndefined))
		{
            latestHour = sectionLatestHour;
        }
    }
    if (latestHour != NSIntegerMin)
	{
        return latestHour;
    }
	return 0;
}

- (NSInteger)earliestHourForSection:(NSInteger)section
{
//    NSInteger earliestHour = NSIntegerMax;
//    for (NSInteger item = 0; item < [[self collectionView] numberOfItemsInSection:section]; item++)
//	{
//        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
//        NSDateComponents *itemStartTime = [self startTimeForIndexPath:itemIndexPath];
//        if (itemStartTime.hour < earliestHour)
//		{
//            earliestHour = itemStartTime.hour;
//        }
//    }
//    if (earliestHour != NSIntegerMax)
//	{
//        return earliestHour;
//    }
	return 1;
}

- (NSInteger)latestHourForSection:(NSInteger)section
{
//    NSInteger latestHour = NSIntegerMin;
//    for (NSInteger item = 0; item < [self.collectionView numberOfItemsInSection:section]; item++)
//	{
//        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
//        NSDateComponents *itemEndTime = [self endTimeForIndexPath:itemIndexPath];
//        NSInteger itemEndTimeHour;
//        if ([self dayForSection:section].day == itemEndTime.day)
//		{
//            itemEndTimeHour = (itemEndTime.hour + ((itemEndTime.minute > 0) ? 1 : 0));
//        }
//		else
//		{
//            itemEndTimeHour = [[NSCalendar currentCalendar] maximumRangeOfUnit:NSCalendarUnitHour].length + (itemEndTime.hour + ((itemEndTime.minute > 0) ? 1 : 0));;
//        }
//        if (itemEndTimeHour > latestHour)
//		{
//            latestHour = itemEndTimeHour;
//        }
//    }
//	
//    if (latestHour != NSIntegerMin)
//	{
//        return latestHour;
//    }
    return 23;
}

#pragma mark Delegate Wrappers

- (NSDateComponents *)dayForSection:(NSInteger)section
{
	NSDateComponents *dayDateComponents = nil;
	id <GVCCalendarDayEventCollectionViewLayoutDelegate> del = [self delegate];
	if (del != nil)
	{
		NSDate *date = [del collectionView:self.collectionView layout:self dayForSection:section];
		date = [date gvc_dateAdjustedToStartOfDay];
		dayDateComponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitEra) fromDate:date];
	}
    return dayDateComponents;
}

- (NSDateComponents *)startTimeForIndexPath:(NSIndexPath *)indexPath
{
	NSDateComponents *itemStartTimeDateComponents = nil;
	id <GVCCalendarDayEventCollectionViewLayoutDelegate> del = [self delegate];
	if (del != nil)
	{
		NSDate *date = [del collectionView:self.collectionView layout:self startTimeForItemAtIndexPath:indexPath];
		itemStartTimeDateComponents = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
	}
	return itemStartTimeDateComponents;
}

- (NSDateComponents *)endTimeForIndexPath:(NSIndexPath *)indexPath
{
	NSDateComponents *itemEndTime = nil;
	id <GVCCalendarDayEventCollectionViewLayoutDelegate> del = [self delegate];
	if (del != nil)
	{
		NSDate *date = [del collectionView:self.collectionView layout:self endTimeForItemAtIndexPath:indexPath];
		itemEndTime = [[NSCalendar currentCalendar] components:(NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
	}
    return itemEndTime;
}

@end
