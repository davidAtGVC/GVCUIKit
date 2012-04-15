//
//  GVCStatusView.h
//
//  Created by David Aspinall on 10-12-13.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GVCProgressBarView.h"
#import "GVCRoundBorderView.h"

@interface GVCStatusView : GVCRoundBorderView 

- (id)initWithFrame:(CGRect)frame;

@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet GVCProgressBarView *progressBar;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (void)deviceOrientationDidChange:(NSNotification *)notification;

- (void)updateMessage:(NSString *)msg;
- (void)updateProgress:(float)progress;
- (void)updateMessage:(NSString *)msg andProgress:(float)progress;

@end
