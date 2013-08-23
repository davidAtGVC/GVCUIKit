//
//  GVCCalendarEventViewCell.h
//  GVCUIKit
//
//  Created by David Aspinall on 2013-06-21.
//
//

#import <UIKit/UIKit.h>
#import <GVCFoundation/GVCMacros.h>

@protocol GVCCalendarEventProtocol;


// static identifier 'GVCCalendarEventViewCell'
GVC_DEFINE_EXTERN_STR(GVCCalendarEventViewCell_IDENTIFIER);

@interface GVCCalendarEventViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *noteLabel;

- (void)setEvent:(id <GVCCalendarEventProtocol>)event;

@end
