//
//  GVCImageCell.h
//  GVCUIKit
//
//  Created by David Aspinall on 2013-05-21.
//
//

#import <UIKit/UIKit.h>
#import "GVCUITableViewCell.h"

@interface GVCImageCell : GVCUITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (void)displayImage:(UIImage *)image;

@end
