
#import <UIKit/UIKit.h>

@protocol GVCPagedGridCollectionLayoutDelegate <NSObject>
@required
- (BOOL)deletionModeEnabledForCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout;
@end


@interface GVCPagedGridCollectionLayout : UICollectionViewFlowLayout

@end


/**
 * Simple class to track visibility of the delete marker
 */
@interface GVCPagedGridCollectionLayoutAttributes : UICollectionViewLayoutAttributes
@property (nonatomic, assign, getter = isDeleteVisible) BOOL deleteVisible;
@end
