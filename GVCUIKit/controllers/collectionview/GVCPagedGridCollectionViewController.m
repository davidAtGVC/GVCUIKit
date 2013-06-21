//
//  GVCPagedGridCollectionViewController.m
//  GVCUIKit
//
//  Created by David Aspinall on 2013-06-20.
//
//

#import "GVCPagedGridCollectionViewController.h"

@interface GVCPagedGridCollectionViewController ()

@end

@implementation GVCPagedGridCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil)
	{
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(activateDeletionMode:)];
//    [longPress setDelegate:self];
//    [[self collectionView] addGestureRecognizer:longPress];
//	
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endDeletionMode:)];
//    [tap setDelegate:self];
//    [[self collectionView]  addGestureRecognizer:tap];
}

#pragma mark - data source methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

@end
