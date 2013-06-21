//  GVCPagedGridCollectionLayout.m

#import "GVCPagedGridCollectionLayout.h"

@implementation GVCPagedGridCollectionLayout

- (id)init
{
    if (self = [super init])
    {
//        [self setItemSize:CGSizeMake(144, 144)];
//        [self setMinimumInteritemSpacing:48];
//        [self setMinimumLineSpacing:48];
        [self setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [self setSectionInset:UIEdgeInsetsMake(32, 32, 32, 32)];
    }
    return self;
}

- (BOOL)isDeletionModeOn
{
	id delegate = [[self collectionView] delegate];
    if ((delegate != nil) && ([[delegate class] conformsToProtocol:@protocol(GVCPagedGridCollectionLayoutDelegate)] == YES))
    {
        return [(id <GVCPagedGridCollectionLayoutDelegate>)delegate deletionModeEnabledForCollectionView:[self collectionView] layout:self];
    }
    return NO;
    
}

+ (Class)layoutAttributesClass
{
    return [GVCPagedGridCollectionLayoutAttributes class];
}

- (GVCPagedGridCollectionLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GVCPagedGridCollectionLayoutAttributes *attributes = (GVCPagedGridCollectionLayoutAttributes *)[super layoutAttributesForItemAtIndexPath:indexPath];
	[attributes setDeleteVisible:[self isDeletionModeOn]];
    return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributesInRect = [super layoutAttributesForElementsInRect:rect];
    
    for (GVCPagedGridCollectionLayoutAttributes *attributes in attributesInRect)
    {
		[attributes setDeleteVisible:[self isDeletionModeOn]];
    }
    return attributesInRect;
}

@end



#pragma mark - GVCPagedGridCollectionLayoutAttributes
@implementation GVCPagedGridCollectionLayoutAttributes

- (id)copyWithZone:(NSZone *)zone
{
    GVCPagedGridCollectionLayoutAttributes *attributes = [super copyWithZone:zone];
    [attributes setDeleteVisible:[self isDeleteVisible]];
    return attributes;
}
@end

