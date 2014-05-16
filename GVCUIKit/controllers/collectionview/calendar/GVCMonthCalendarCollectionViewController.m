//
//  GVCMonthCalendarCollectionViewController.m
//  GVCUIKit
//
//  Created by David Aspinall on 2013-06-20.
//
//

#import "GVCMonthCalendarCollectionViewController.h"
#import "GVCMonthCollectionViewCell.h"
#import "GVCMonthCollectionReusableView.h"

#import <GVCFoundation/GVCFoundation.h>

GVC_DEFINE_STR(MONTH_DAY_CELL_IDENTIFIER);
GVC_DEFINE_STR(MONTH_DAY_HEADER_IDENTIFIER);

@interface GVCMonthCalendarCollectionViewController ()
@property (assign, nonatomic) NSInteger firstDayIndent;
@end

@implementation GVCMonthCalendarCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil)
	{
		[self setDate:[NSDate date]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	if ( [[self collectionView] isKindOfClass:[UICollectionView class]] == YES)
	{
		[(UICollectionView *)[self collectionView] registerClass:[GVCMonthCollectionViewCell class] forCellWithReuseIdentifier:MONTH_DAY_CELL_IDENTIFIER];
		[(UICollectionView *)[self collectionView] registerClass:[GVCMonthCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MONTH_DAY_HEADER_IDENTIFIER];
	}
	
	if ( [self date] == nil )
	{
		[self setDate:[NSDate date]];
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	UICollectionViewFlowLayout *flow = (UICollectionViewFlowLayout *)[[self collectionView] collectionViewLayout];
	CGFloat margin = [flow minimumInteritemSpacing] * 6;
	CGRect frame = [[self view] frame];
	CGFloat w = floorf((frame.size.width - margin) / 7);
	
	[flow setItemSize:CGSizeMake(w, w)];
	[flow setHeaderReferenceSize:CGSizeMake(frame.size.width, w)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - dates
- (void) setDate:(NSDate *)date
{
	_date = date;
	
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *comps = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:[date gvc_dateAdjustedToStartOfMonth]];
	[self setFirstDayIndent:(comps.weekday - 1)];

	if ( [[self view] isKindOfClass:[UICollectionView class]] == YES)
	{
		[(UICollectionView *)[self view] reloadData];
	}
}

- (NSDate *)dateForIndexPath:(NSIndexPath *)indexPath
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *dcomp = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[self date]];
    dcomp.day = (indexPath.row - [self firstDayIndent] + 1);
    return [cal dateFromComponents:dcomp];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	NSInteger days = 0;
	if ( [self date] != nil )
	{
		days = [[self date] gvc_numberOfDaysInMonth] + [self firstDayIndent];
	}
	return days;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
	static NSDateFormatter *formatter = nil;
	if (formatter == nil)
	{
		formatter = [[NSDateFormatter alloc] init];
		[formatter setLocale:[NSLocale currentLocale]];
		[formatter setDateFormat:@"YYYY / MMM"];
	}
	
	if ([kind isEqualToString:UICollectionElementKindSectionHeader] == YES)
	{
		GVCMonthCollectionReusableView *header = (GVCMonthCollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MONTH_DAY_HEADER_IDENTIFIER forIndexPath:indexPath];
		[[header monthLabel] setText:[formatter stringFromDate:[self date]]];
		return header;
	}
	
	return nil;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GVCMonthCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MONTH_DAY_CELL_IDENTIFIER forIndexPath:indexPath];
	long day = [indexPath row] - [self firstDayIndent];
	
	[cell setBackgroundColor:[UIColor gvc_randomColor]];
	if (day >= 0)
	{
		[[cell dayLabel] setText:GVC_SPRINTF(@"%@", @(day + 1))];
	}
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	if ( [self selectedDateBlock] != nil )
	{
		GVCMonthCalendarCollectionViewControllerBlock block = [self selectedDateBlock];
		block(nil);
	}
}

@end
