//
//  GVCYearCalendarViewController.m
//  GVCUIKit
//
//  Created by David Aspinall on 2013-06-11.
//
//

#import "GVCYearCalendarViewController.h"
#import "GVCYearCollectionViewCell.h"
#import "UIView+GVCUIKit.h"
#import <GVCFoundation/GVCFoundation.h>


@interface GVCYearCalendarViewController ()
@property (assign, nonatomic) NSInteger focusYear;
@end

@implementation GVCYearCalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil)
	{
		[self setFocusYear:[[NSDate date] gvc_year]];
    }
    return self;
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	[self setFocusYear:[[NSDate date] gvc_year]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showCalendarYear:(NSInteger)year position:(GVCYearCalendarViewController_POSITION)position;
{
	switch (position)
	{
		case GVCYearCalendarViewController_POSITION_start:
			[self setFocusYear:year];
			break;

		case GVCYearCalendarViewController_POSITION_centre:
			[self setFocusYear:(year - 6)];
			break;

		default:
			[self setFocusYear:(year - 12)];
			break;
	}
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CalendarCellIdentifier = @"yearCell";
	
    GVCYearCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CalendarCellIdentifier forIndexPath:indexPath];
	[GVC_STRONG_REF(UILabel, [cell yearLabel]) setText:GVC_SPRINTF(@"%d", ([self focusYear] + [indexPath row]))];
	[cell gvc_showLeftShadow:YES withOpacity:0.6];

	CGFloat sz = [[GVC_STRONG_REF(UILabel, [cell yearLabel]) font] pointSize];
	if ([self focusYear] + [indexPath row] == [[NSDate date] gvc_year])
	{
		[GVC_STRONG_REF(UILabel, [cell yearLabel]) setFont:[UIFont boldSystemFontOfSize:sz]];
	}
	else
	{
		[GVC_STRONG_REF(UILabel, [cell yearLabel]) setFont:[UIFont systemFontOfSize:sz]];
	}
	
	return cell;
}

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//	return 1;
//}

// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	if ( [self selectedYearBlock] != nil )
	{
		GVCYearCalendarViewControllerBlock block = [self selectedYearBlock];
		block([self focusYear] + [indexPath row]);
	}
}

@end
