/*
 * GVCTokenView.m
 * 
 * Created by David Aspinall on 2013-02-01. 
 * Copyright (c) 2013 __MyCompanyName__. All rights reserved.
 *
 */

#import "GVCTokenView.h"
#import "UIColor+GVCUIKit.h"

#import <GVCFoundation/GVCFoundation.h>
#import <QuartzCore/QuartzCore.h>


@interface GVCTokenView ()
@property (strong, nonatomic) UILabel *textLabel;
@end

@implementation GVCTokenView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self != nil)
	{
    }
    
    return  self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if ( self != nil )
	{
		[self setFont:[aDecoder decodeObjectForKey:GVC_PROPERTY(font)]];
		[self setBgColor:[aDecoder decodeObjectForKey:GVC_PROPERTY(bgColor)]];
		[self setSelectedBgColor:[aDecoder decodeObjectForKey:GVC_PROPERTY(selectedBgColor)]];
		[self setBorderColor:[aDecoder decodeObjectForKey:GVC_PROPERTY(borderColor)]];
		[self setSelectedBorderColor:[aDecoder decodeObjectForKey:GVC_PROPERTY(selectedBorderColor)]];
		[self setTextColor:[aDecoder decodeObjectForKey:GVC_PROPERTY(textColor)]];
		[self setSelectedTextColor:[aDecoder decodeObjectForKey:GVC_PROPERTY(selectedTextColor)]];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[super encodeWithCoder:aCoder];
	
	[aCoder encodeObject:[self font] forKey:GVC_PROPERTY(font)];
	[aCoder encodeObject:[self bgColor] forKey:GVC_PROPERTY(bgColor)];
	[aCoder encodeObject:[self selectedBgColor] forKey:GVC_PROPERTY(selectedBgColor)];
	
	[aCoder encodeObject:[self borderColor] forKey:GVC_PROPERTY(borderColor)];
	[aCoder encodeObject:[self selectedBorderColor] forKey:GVC_PROPERTY(selectedBorderColor)];
	
	[aCoder encodeObject:[self textColor] forKey:GVC_PROPERTY(textColor)];
	[aCoder encodeObject:[self selectedTextColor] forKey:GVC_PROPERTY(selectedTextColor)];
}


- (void)initializeDefaults
{
	[self setSelected:NO];
	
	if ( [self bgColor] == nil )
	{
		[self setBgColor:[UIColor colorWithRed:0.53 green:0.6 blue:0.738 alpha:1.]];
	}
	if ( [self selectedBgColor] == nil )
	{
		[self setSelectedBgColor:[UIColor colorWithRed:0.324 green:0.460 blue:0.737 alpha:1.000]];
	}

	if ( [self borderColor] == nil )
	{
		[self setBorderColor:[UIColor whiteColor]];
	}
	if ( [self selectedBorderColor] == nil )
	{
		[self setSelectedBorderColor:[UIColor whiteColor]];
	}
	
	if ( [self textColor] == nil )
	{
		[self setTextColor:[UIColor whiteColor]];
	}
	if ( [self selectedTextColor] == nil )
	{
		[self setSelectedTextColor:[UIColor yellowColor]];
	}
	
	if ([self font] == nil)
	{
		[self setFont:[UIFont boldSystemFontOfSize:16]];
	}
	
	if ( [self textLabel] == nil)
	{
		[self setTextLabel:[[UILabel alloc] initWithFrame:[self bounds]]];
        [[self textLabel] setBackgroundColor:[UIColor clearColor]];
		[self addSubview:[self textLabel]];
	}

	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture)];
    [tapGesture setNumberOfTapsRequired:1];
    [tapGesture setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:tapGesture];

    [self setSelected:NO animated:NO];
}

-(void)layoutSubviews
{
	[self initializeDefaults];

	[self setAlpha:1.0];
    [[self layer] setMasksToBounds:YES];
    [[self layer] setCornerRadius:(self.bounds.size.height / 2)];
    [[self layer] setBorderWidth:1];

	[[self textLabel] setFont:[self font]];
	[[self textLabel] setTextColor:[self textColor]];
	[[self textLabel] setText:[self text]];
    [[self textLabel] sizeToFit];

    CGRect frame = [[self textLabel] frame];
    frame.origin.x = 10.0;
    frame.origin.y = 2.0;
    frame.size.width = MAX(frame.size.width, 20.0);
    frame.size.height = MAX(frame.size.height, 20.0);
    [[self textLabel] setFrame:frame];

	[self setBounds:CGRectMake(0, 0, frame.size.width + (2 * 10.0), frame.size.height + (2 * 2.0))];

    [super layoutSubviews];
}

- (void)handleTapGesture
{
	BOOL selStatus = [self isSelected];
	[self setSelected:!selStatus animated:YES];
}


#pragma mark - selection
-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[self setSelected:selected];
	if ( animated == YES )
	{
		if ( selected == YES )
		{
			[UIView animateWithDuration:1.0
							 animations:^{
								 [[self layer] setBorderColor:[[self selectedBorderColor] CGColor]];
								 [self setBackgroundColor:[self selectedBgColor]];
								 [[self textLabel] setTextColor:[self selectedTextColor]];
							 }
							 completion:^(BOOL finished){
							 }];
		}
		else
		{
			[UIView animateWithDuration:1.0
							 animations:^{
								 [[self layer] setBorderColor:[[self borderColor] CGColor]];
								 [self setBackgroundColor:[self bgColor]];
								 [[self textLabel] setTextColor:[self textColor]];
							 }
							 completion:^(BOOL finished){
							 }];
		}
	}
	else
	{
		if ( selected == YES )
		{
			[[self layer] setBorderColor:[[self selectedBorderColor] CGColor]];
			[self setBackgroundColor:[self selectedBgColor]];
			[[self textLabel] setTextColor:[self selectedTextColor]];
		}
		else
		{
			[[self layer] setBorderColor:[[self borderColor] CGColor]];
			[self setBackgroundColor:[self bgColor]];
			[[self textLabel] setTextColor:[self textColor]];
		}
	}
}

- (IBAction)updateBadgeText:(id)sender
{
    if ( [sender isKindOfClass:[UITextField class]] == YES )
    {
        [self setText:[(UITextField *)sender text]];
    }
    else if ([sender isKindOfClass:[UISlider class]] == YES )
    {
        UISlider *slider = (UISlider *)sender;
        float min = [slider minimumValue];
        float max = [slider maximumValue];
        float val = [slider value];
        
        int progress = ((val - min) / (max - min)) * 100;
        [self setText:GVC_SPRINTF(@"%d %%", progress)];
    }
    [self setNeedsLayout];
}

@end
