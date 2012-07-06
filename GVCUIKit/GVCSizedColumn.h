/*
 * GVCSizedColumn.h
 * 
 * Created by David Aspinall on 12-07-06. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>

@interface GVCSizedColumn : NSObject
- (id)init:(UIView *)view atIndex:(NSUInteger)idx forSize:(CGFloat)percent;
@property (weak, nonatomic) UIView *columnView;
@property (assign, nonatomic) NSUInteger columnIndex;
@property (assign, nonatomic) CGFloat sizePercentage;
@end
