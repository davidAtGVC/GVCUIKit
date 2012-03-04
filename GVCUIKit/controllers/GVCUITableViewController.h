//
//  DATableViewController.h
//
//  Created by David Aspinall on 10-03-29.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GVCUITableViewController : UITableViewController <UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong, nonatomic) IBOutlet UIView *tableFooterView;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellTemplate;

- (NSString *)viewTitleKey;

- (IBAction)reload:(id)sender;

- (UITableViewCell *)dequeueOrLoadReusableCellFromClass:(Class)cellClass forTable:(UITableView *)tv withIdentifier:(NSString *)identifier;
- (UITableViewCell *)dequeueOrLoadReusableCellFromNib:(NSString *)cellNibName forTable:(UITableView *)tv withIdentifier:(NSString *)identifier;

@end
