//
//  GVCColumnContainerCell.m
//
//  Created by David Aspinall on 12-06-20.
//  Copyright (c) 2012 Global Village Consulting. All rights reserved.
//

#import "GVCColumnContainerCell.h"

@interface GVCColumnContainerCell ()
@property (nonatomic, strong) NSMutableArray *widths;
@end


@implementation GVCColumnContainerCell

@synthesize widths;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
    }
    return self;
}

- (NSArray *)autoPositionViews
{
    return [[[self contentView] subviews] gvc_filterArrayForAccept:^BOOL(id item) {
        BOOL accept = ( [item isKindOfClass:[UILabel class]] || [item isKindOfClass:[UITextView class]] || [item isKindOfClass:[UITextField class]] );
        return accept;
    }];
}
- (UIView *)viewAtIndex:(NSUInteger)idx
{
    NSArray *positionViews = [self autoPositionViews];
    return (idx < [positionViews count] ? [positionViews objectAtIndex:idx] : nil );
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)prepareForReuse 
{
    [super prepareForReuse];
}

- (void)layoutSubviews 
{
    [super layoutSubviews];
	
    NSArray *autoViews = [self autoPositionViews];
    int count = [autoViews count];
	if ( count > 0 )
	{
		if ( gvc_IsEmpty([self widths]) == YES )
		{
			[self setWidths:[NSMutableArray arrayWithCapacity:count]];
			for ( NSInteger i = 0; i < count; i++ )
			{
				[[self widths] addObject:[NSNumber numberWithFloat:(float) (1.0 / (float)count)]];
			}
		}
        
		CGRect contentRect = [[self contentView] bounds];
		if(contentRect.origin.x == 0.0) 
		{
			contentRect.origin.x = 10.0;
			contentRect.size.width -= 20;
		}
		
		float xoffset = contentRect.origin.x;
		float width = contentRect.size.width;
		CGRect frame;
		
		for(int i = 0; i < count; ++i)
		{
			UIView *aview = [autoViews objectAtIndex:i];
			
			float thisWidth = width * [[[self widths] objectAtIndex:i] floatValue];
			frame = CGRectMake(xoffset, 0, thisWidth, contentRect.size.height);
			[aview setFrame:frame];
			xoffset += thisWidth;
		}
	}
}

@end
