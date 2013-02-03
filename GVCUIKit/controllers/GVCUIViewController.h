//
//  GVCUIViewController.m
//
//  Created by David Aspinall on 10-04-05.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GVCUIProtocols.h"

@interface GVCUIViewController : UIViewController <GVCViewTitleProtocol>

@property (nonatomic, assign) BOOL autoresizesForKeyboard;

@property (strong, nonatomic) IBOutlet id callbackDelegate;

- (UINavigationBar *)navigationBar;
- (NSString *)viewTitle;

- (IBAction)dismissModalViewController:(id)sender;

#pragma mark -

/* Keyboard notifications */
- (UIView *)keyboardResizeView;

-(void) resizeForKeyboard:(NSNotification *)notification appearing:(BOOL)appearing;

-(void) keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds;
-(void) keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds animationDuration:(NSTimeInterval)aDuration;

-(void) keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds;
-(void) keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds animationDuration:(NSTimeInterval)aDuration;

-(void) keyboardDidAppear:(BOOL)animated withBounds:(CGRect)bounds;
-(void) keyboardDidDisappear:(BOOL)animated withBounds:(CGRect)bounds;

@end
