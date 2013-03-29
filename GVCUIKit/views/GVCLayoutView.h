//
//  GVCLayoutView.h
//  GVCUIKit
//
//  Created by David Aspinall on 2013-03-28.
//
//

#import <UIKit/UIKit.h>

@interface GVCLayoutRow : NSObject
+ (GVCLayoutRow *)rowWithColumns:(NSUInteger)cols;
+ (GVCLayoutRow *)rowWithColumns:(NSUInteger)cols rowMargin:(CGFloat)rm colMargin:(CGFloat)cm;

@property (nonatomic, assign) NSUInteger columns;
@property (nonatomic, assign) CGFloat columnMargin;
@property (nonatomic, assign) CGFloat rowMargin;
@end

@protocol GVCLayoutDelegate;


@interface GVCLayoutView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet id <GVCLayoutDelegate> delegate;

/** Layout is an array of Layout Rows */
@property (nonatomic, strong) NSArray *layout;

- (void)addTapGesture;

- (void)reloadData;

@end



@protocol GVCLayoutDelegate <NSObject>
- (UIView *)viewForLayout:(GVCLayoutView *)layoutView atIndexPath:(NSIndexPath *)indexPath;
- (void)layout:(GVCLayoutView *)layoutView didSelectCellAtIndexPath:(NSIndexPath *)indexPath;
@end
