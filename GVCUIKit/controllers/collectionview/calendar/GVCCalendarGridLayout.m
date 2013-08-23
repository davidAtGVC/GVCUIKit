//
//  GVCCalendarGridLayout.m
//  GVCUIKit
//
//  Created by David Aspinall on 2013-06-22.
//
//

#import "GVCCalendarGridLayout.h"

GVC_DEFINE_STR(GVCCalendarGridLayoutType);


@interface GVCCalendarGridLayout ()
@property (nonatomic, strong) NSMutableDictionary *gridlineAttributes;
@property (nonatomic, strong) NSMutableDictionary *itemAttributes;
@end


@implementation GVCCalendarGridLayout

- (id)init
{
    self = [super init];
    if (self != nil)
	{
        [self initializeLayout];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil)
	{
        [self initializeLayout];
    }
    return self;
}

- (void)initializeLayout
{
	[self setStartHour:0];
	[self setEndHour:23];
	[self setWorkStartHour:8];
	[self setWorkEndHour:17];
	[self setHighlightWorkHours:YES];
}

#pragma mark - internal variables
- (void)setStartHour:(NSUInteger)startHour
{
	_startHour = startHour;
	[self invalidateLayout];
}

- (void)setEndHour:(NSUInteger)endHour
{
	_endHour = endHour;
	[self invalidateLayout];
}

- (void)setWorkStartHour:(NSUInteger)startHour
{
	_workStartHour = startHour;
	[self invalidateLayout];
}

- (void)setWorkEndHour:(NSUInteger)endHour
{
	_workEndHour = endHour;
	[self invalidateLayout];
}

- (void)setHighlightWorkHours:(BOOL)highlightWorkHours
{
	_highlightWorkHours = highlightWorkHours;
	[self invalidateLayout];
}

- (CGFloat)oneHourHeight
{
	return 80.0;
}

- (CGSize)collectionViewContentSize
{
	CGFloat height = ([self endHour] - [self startHour]) * [self oneHourHeight];
	CGFloat width = [[self collectionView] frame].size.width;
    return CGSizeMake(width, height);
}

#pragma mark - layout
- (void)prepareLayout
{
    [super prepareLayout];
	NSMutableDictionary *gridLayoutInfo = [NSMutableDictionary dictionary];
	NSMutableDictionary *itemLayoutInfo = [NSMutableDictionary dictionary];

	CGFloat height = [self oneHourHeight];
	CGFloat width = [self collectionViewContentSize].width;
	NSInteger sectionCount = [[self collectionView] numberOfSections];
    for (NSInteger section = 0; section < sectionCount; section++)
	{
		NSUInteger gridIndex = 0;
		for (NSUInteger hour = [self startHour]; hour <= [self endHour]; hour++)
		{
			NSIndexPath *indexPath = [NSIndexPath indexPathForItem:gridIndex inSection:section];
			UICollectionViewLayoutAttributes *gridAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:GVCCalendarGridLayoutType withIndexPath:indexPath];

			CGFloat gridMinY = floorf(height * gridIndex); // - nearbyintf(gridIndex / 2.0);
			[gridAttributes setFrame:CGRectMake( 0, gridMinY, width, height)];
			[gridAttributes setZIndex:0];

			[gridLayoutInfo setObject:gridAttributes forKey:indexPath];
			gridIndex++;
		}
		
		// items
		NSInteger itemCount = [[self collectionView] numberOfItemsInSection:section];
		for ( NSInteger row = 0; row < itemCount; row++)
		{
			NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:section];
			UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
						
			[itemAttributes setFrame:CGRectMake(10, 10, width - 10, height)];
			[itemAttributes setCenter:CGPointMake( (width / 2), (height / 2) )];

			[itemLayoutInfo setObject:itemAttributes forKey:indexPath];
		}
	}
	
	[self setGridlineAttributes:gridLayoutInfo];
	[self setItemAttributes:itemLayoutInfo];

}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
	return [[self itemAttributes] objectForKey:indexPath];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewLayoutAttributes *attributes = nil;
	if ([kind isEqualToString:GVCCalendarGridLayoutType] == YES)
	{
        attributes = [[self gridlineAttributes] objectForKey:indexPath];
    }

    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [[NSMutableArray alloc] initWithCapacity:4];
	
	[[[self gridlineAttributes] allValues] enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *attributes, NSUInteger idx, BOOL *stop) {
		if (CGRectIntersectsRect(rect, [attributes frame]))
		{
			[allAttributes addObject:attributes];
		}
	}];

    return allAttributes;
}

@end
