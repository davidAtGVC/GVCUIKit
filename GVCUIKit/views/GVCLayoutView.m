//
//  GVCLayoutView.m
//  GVCUIKit
//
//  Created by David Aspinall on 2013-03-28.
//
//

#import "GVCLayoutView.h"
#import <GVCFoundation/GVCFoundation.h>
#import <GVCUIKit/GVCUIKit.h>

@interface GVCLayoutView()
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) NSMutableArray *cellArray;
@end

@interface GVCLayoutRow ()
@property (nonatomic, assign) CGRect layoutRect;
@end



@implementation GVCLayoutView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
    if (self != nil)
	{
    }
    return self;
}

- (void)addTapGesture
{
	if ( [self tapGesture] == nil )
	{
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [tap setDelegate:self];
        [self setTapGesture:tap];
	}
	
	if ( [[self gestureRecognizers] containsObject:[self tapGesture]] == NO)
	{
		[self addGestureRecognizer:[self tapGesture]];
	}
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	if ([[self cellArray] count] > 0)
	{
		CGRect bounds = [self bounds];
		CGFloat sumRowSpacing = 0.0f;
		NSUInteger columnCount = 0;

		[self addTapGesture];
		
		for (GVCLayoutRow *row in [self layout])
		{
			sumRowSpacing += [row rowMargin];
			columnCount += [row columns];
		}

		GVC_ASSERT([[self cellArray] count] == columnCount, @"Cell views does not match column count");
		
		CGFloat y = 0.0f;
		NSUInteger cellId = 0;
		NSUInteger rowHeight = floorf((bounds.size.height - sumRowSpacing) / [[self layout] count]);
		for (NSUInteger rowIndex = 0; rowIndex < [[self layout] count]; rowIndex++)
		{
			GVCLayoutRow *row = [[self layout] objectAtIndex:rowIndex];
			if ([row columns] > 0)
			{
				CGFloat colSpacing = ([row columns] - 1) * [row columnMargin];
				NSUInteger colWidth = floorf((bounds.size.width - colSpacing) / [row columns]);
				CGFloat x = 0.0f;
				for (NSUInteger colIndex = 0; colIndex < [row columns]; colIndex++ )
				{
					UIView *cell = [[self cellArray] objectAtIndex:cellId];

					[cell gvc_showLeftShadow:YES withOpacity:0.6];
					[cell setTag:cellId];
					[cell setFrame:CGRectMake(x, y, colWidth, rowHeight)];
					x += (colWidth + [row columnMargin]);
					cellId++;
				}
				y += (rowHeight + [row rowMargin]);
			}
		}
	}
}

#pragma mark - Grid View

- (void)setLayout:(NSArray *)layout
{
	GVC_DBC_REQUIRE(
					GVC_DBC_FACT_NOT_NIL(layout);
					)
	
	// implementation
	NSArray *filtered = [layout gvc_filterForClass:[GVCLayoutRow class]];
	_layout = filtered;
	[self setCellArray:[NSMutableArray arrayWithCapacity:([_layout count] *3 )]];
	
	GVC_DBC_ENSURE(
				   GVC_DBC_FACT([_layout gvc_isEqualToArrayInAnyOrder:layout]);
				   )
}

- (void)reloadData
{
	for (UIView *view in [self cellArray])
	{
        [view removeFromSuperview];
    }
	[[self cellArray] removeAllObjects];

	for (NSUInteger rowIndex = 0; rowIndex < [[self layout] count]; rowIndex++)
	{
		GVCLayoutRow *row = [[self layout] objectAtIndex:rowIndex];
		for (NSUInteger colIndex = 0; colIndex < [row columns]; colIndex++ )
		{
			NSIndexPath *cellIndex = [NSIndexPath indexPathForItem:colIndex inSection:rowIndex];
			id <GVCLayoutDelegate>del = [self delegate];
			
			UIView *cell = [del viewForLayout:self atIndexPath:cellIndex];
			GVC_ASSERT_NOT_NIL(cell);
			
			[cell setAutoresizingMask:UIViewAutoresizingNone];
			[[self cellArray] addObject:cell];
			[self addSubview:cell];
		}
    }

	[self setNeedsLayout];
}

#pragma mark - Tap Gesture

- (void)tapGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] == YES)
	{
        UITapGestureRecognizer *tap = (UITapGestureRecognizer *)gestureRecognizer;
        if ([tap state] == UIGestureRecognizerStateEnded)
		{
			id <GVCLayoutDelegate>del = [self delegate];
			CGPoint location = [tap locationInView:self];

			NSUInteger cellId = 0;
			BOOL hitFound = NO;
			for (NSUInteger rowIndex = 0; (rowIndex < [[self layout] count]) && (hitFound == NO); rowIndex++)
			{
				GVCLayoutRow *row = [[self layout] objectAtIndex:rowIndex];
				for (NSUInteger colIndex = 0; (colIndex < [row columns]) && (hitFound == NO); colIndex++ )
				{
					NSIndexPath *cellIndex = [NSIndexPath indexPathForItem:colIndex inSection:rowIndex];
					UIView * view = [[self cellArray] objectAtIndex:cellId];
					CGPoint local = [view convertPoint:location fromView:self];
					if ([view pointInside:local withEvent:nil])
					{
						[del layout:self didSelectCellAtIndexPath:cellIndex];
                        hitFound = YES;
                    }

					cellId++;
				}
			}
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	// pass tap gestures into any UIControls
    return ([[self hitTest:[touch locationInView:self] withEvent:nil] isKindOfClass:[UIControl class]] == NO);
}

@end



@implementation GVCLayoutRow

+ (GVCLayoutRow *)rowWithColumns:(NSUInteger)cols
{
	return [GVCLayoutRow rowWithColumns:cols rowMargin:10.0 colMargin:10.0];
}

+ (GVCLayoutRow *)rowWithColumns:(NSUInteger)cols rowMargin:(CGFloat)rm colMargin:(CGFloat)cm
{
	GVCLayoutRow *row = [[GVCLayoutRow alloc] init];
	[row setColumns:cols];
	[row setRowMargin:rm];
	[row setColumnMargin:cm];
	return row;
}
@end

