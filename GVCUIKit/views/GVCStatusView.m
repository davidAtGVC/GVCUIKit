//
//  GVCStatusView.m
//
//  Created by David Aspinall on 10-12-13.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "GVCStatusView.h"
#import "GVCTextLayer.h"
#import "GVCProgressBarLayer.h"
#import "GVCAlertMessageCenter.h"

#import "NSAttributedString+GVCUIKit.h"
#import "UIView+GVCUIKit.h"

@interface GVCStatusView ()
@property (strong, nonatomic) GVCStatusItem *currentItem;
@property (weak, nonatomic) id currentAccessory;
@property (assign, nonatomic) CGRect calculatedViewRect;
@property (assign, nonatomic) CGRect calculatedAccessoryRect;
@property (assign, nonatomic) CGRect calculatedMessageRect;
@end


static float ACCESSOR_MARGIN = 8.0;
//static float TOP_MARGIN = 4.0;
static float BOX_MARGIN = 24.0;
static float MIN_H = 40.0;
static float MIN_W = 160.0;


@implementation GVCStatusView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self != nil )
	{
        [self setMessageLayer:[[CATextLayer alloc] init]];
		[[self messageLayer] setContentsScale:[[UIScreen mainScreen] scale]];
		[[self messageLayer] setAnchorPoint:CGPointMake(0, 0)];
        [[self messageLayer] setBackgroundColor:[UIColor clearColor].CGColor];
        [[self messageLayer] setForegroundColor:[UIColor whiteColor].CGColor];

		UIFont *systemBoldFont = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        [[self messageLayer] setFont:(CGFontRef)systemBoldFont];
        
        [[self messageLayer] setFontSize:14];
        [[self messageLayer] setWrapped:YES];
		[[self layer] addSublayer:[self messageLayer]];
        
        [self setProgressLayer:[[GVCProgressBarLayer alloc] init]];
		[[self progressLayer] setContentsScale:[[UIScreen mainScreen] scale]];
		[[self progressLayer] setAnchorPoint:CGPointMake(0, 0)];
        [[self progressLayer] setBackgroundColor:[UIColor clearColor].CGColor];
        [[self progressLayer] setBarProgressColor:[UIColor whiteColor]];
		[[self layer] addSublayer:[self progressLayer]];
        
        [self setActivityView:[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]];
        [[self activityView] setHidesWhenStopped:YES];
        
        [self setImageLayer:[[CALayer alloc] init]];
		[[self imageLayer] setAnchorPoint:CGPointMake(0, 0)];
		[[self layer] addSublayer:[self imageLayer]];

        [self setBorderColor:[UIColor lightGrayColor]];
        [self setContentColor:[UIColor colorWithRed:0.012 green:0.537 blue:0.875 alpha:1.000]];
        [self setAlpha:0.0];
    }
	
    return self;
}

- (void)calculateViewFrames
{
    CGRect superFrame = [[self superview] bounds];
    CGRect boxRect = CGRectZero;
    CGRect accessoryRect = CGRectZero;
    CGRect messageRect = CGRectZero;
    id accessory = nil;
    
    if ( [self currentItem] != nil )
    {
		CGRect msgRect = [[[self currentItem] message] boundingRectWithSize:CGSizeMake(MIN_W, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]} context:nil];
        CGSize accessorySize = CGSizeZero;
        CGSize itemSize = CGSizeZero;
        
        if (([[self currentItem] accessoryPosition] == GVC_StatusItemPosition_LEFT) || ([[self currentItem] accessoryPosition] == GVC_StatusItemPosition_RIGHT))
        {
            // progress bars can only be top or bottom
            if ( [[self currentItem] accessoryType] == GVC_StatusItemAccessory_PROGRESS )
            {
                [[self currentItem] setAccessoryPosition:GVC_StatusItemPosition_BOTTOM];
            }
        }
        
        switch ([[self currentItem] accessoryType]) {
            case GVC_StatusItemAccessory_ACTIVITY:
                accessorySize = CGSizeMake(37, 37);
                accessory = [self activityView];
                
                [[self progressLayer] removeFromSuperlayer];
                [[self imageLayer] removeFromSuperlayer];
                if ( [[self subviews] containsObject:[self activityView]] == NO )
                {
                    [self addSubview:[self activityView]];
                }
                [[self activityView] startAnimating];
                break;
                
            case GVC_StatusItemAccessory_PROGRESS:
                accessorySize = CGSizeMake(MIN_W, 20);
                accessory = [self progressLayer];
                [[self activityView] stopAnimating];
                [[self activityView] removeFromSuperview];
                [[self imageLayer] removeFromSuperlayer];
                
                if ( [[[self layer] sublayers] containsObject:[self progressLayer]] == NO )
                {
                    [[self layer] addSublayer:[self progressLayer]];
                }
                
                break;
                
            case GVC_StatusItemAccessory_IMAGE:
                // size image or scale to max
                accessorySize = [[[self currentItem] image] size];
                accessory = [self imageLayer];
                [[self imageLayer] setContents:(id)[[self currentItem] image].CGImage];
                
                [[self activityView] stopAnimating];
                [[self activityView] removeFromSuperview];
                [[self progressLayer] removeFromSuperlayer];
                
                if ( [[[self layer] sublayers] containsObject:[self imageLayer]] == NO )
                {
                    [[self layer] addSublayer:[self imageLayer]];
                }
                
                break;
                
            case GVC_StatusItemAccessory_NONE:
            default:
                break;
        }
        
        switch ([[self currentItem] accessoryPosition]) {
            case GVC_StatusItemPosition_LEFT:
                itemSize = CGSizeMake(accessorySize.width +  msgRect.size.width + ACCESSOR_MARGIN + BOX_MARGIN,
                                      MAX(accessorySize.height, msgRect.size.height) + BOX_MARGIN);
                itemSize = CGSizeMake(MAX(itemSize.width, MIN_W), MAX(itemSize.height, MIN_H));
                
                accessoryRect = CGRectMake(BOX_MARGIN / 2, BOX_MARGIN / 2, accessorySize.width, accessorySize.height);
                messageRect = CGRectMake((BOX_MARGIN / 2) + accessorySize.width + ACCESSOR_MARGIN, BOX_MARGIN / 2, msgRect.size.width, msgRect.size.height);
                break;
            case GVC_StatusItemPosition_RIGHT:
                itemSize = CGSizeMake(accessorySize.width + msgRect.size.width + ACCESSOR_MARGIN + BOX_MARGIN,
                                      MAX(accessorySize.height,msgRect.size.height) + BOX_MARGIN);
                itemSize = CGSizeMake(MAX(itemSize.width, MIN_W), MAX(itemSize.height, MIN_H));
                
                messageRect = CGRectMake(BOX_MARGIN / 2, BOX_MARGIN / 2, msgRect.size.width, msgRect.size.height);
                accessoryRect = CGRectMake(BOX_MARGIN / 2 + msgRect.size.width + ACCESSOR_MARGIN, BOX_MARGIN / 2, accessorySize.width, accessorySize.height);
                break;
                
            case GVC_StatusItemPosition_TOP:
                itemSize = CGSizeMake(MAX(accessorySize.width, msgRect.size.width) + BOX_MARGIN,
                                      accessorySize.height + msgRect.size.height + ACCESSOR_MARGIN + BOX_MARGIN);
                itemSize = CGSizeMake(MAX(itemSize.width, MIN_W), MAX(itemSize.height, MIN_H));
                
                accessoryRect = CGRectMake((itemSize.width - accessorySize.width) / 2,
                                           BOX_MARGIN / 2,
                                           accessorySize.width, accessorySize.height);
                messageRect = CGRectMake((itemSize.width - msgRect.size.width) / 2,
                                         BOX_MARGIN / 2 + ACCESSOR_MARGIN + accessorySize.height,
                                         msgRect.size.width, msgRect.size.height);
                break;
            case GVC_StatusItemPosition_BOTTOM:
            default:
                itemSize = CGSizeMake(MAX(accessorySize.width, msgRect.size.width) + BOX_MARGIN,
                                      accessorySize.height + msgRect.size.height + ACCESSOR_MARGIN + BOX_MARGIN);
                itemSize = CGSizeMake(MAX(itemSize.width, MIN_W), MAX(itemSize.height, MIN_H));
                
                messageRect = CGRectMake((itemSize.width - msgRect.size.width) / 2,
                                         BOX_MARGIN / 2,
                                         msgRect.size.width, msgRect.size.height);
                accessoryRect = CGRectMake((itemSize.width - accessorySize.width) / 2,
                                           BOX_MARGIN / 2 + ACCESSOR_MARGIN + msgRect.size.height,
                                           accessorySize.width, accessorySize.height);
                break;
        }
        
        boxRect = CGRectMake((superFrame.size.width - itemSize.width) / 2, 
                             (superFrame.size.height - itemSize.height) / 2, 
                             itemSize.width, 
                             itemSize.height
                             );
    }
    [self setCurrentAccessory:accessory];
    [self setCalculatedViewRect:[UIView gvc_SharpenRect:boxRect]];
    [self setCalculatedAccessoryRect:[UIView gvc_SharpenRect:accessoryRect]];
    [self setCalculatedMessageRect:[UIView gvc_SharpenRect:messageRect]];
}

- (void)displayItem:(GVCStatusItem *)item
{
    [self setCurrentItem:item];
    [self update];
}

- (void)update
{
	if ([NSThread isMainThread]) 
	{
        [self calculateViewFrames];
        if ( CGRectEqualToRect([self frame], CGRectZero) == YES )
        {
            [self setFrame:[self calculatedViewRect]];
        }

        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [CATransaction setCompletionBlock:^{
            [UIView animateWithDuration:.4 animations:^{ 
                if ( CGRectEqualToRect([self frame], [self calculatedViewRect]) == NO )
                {
                    [self setFrame:[self calculatedViewRect]];
                    [self setNeedsDisplay];
                }
                
                [[self messageLayer] setFrame:[self calculatedMessageRect]];
                
                id strongAccessory = [self currentAccessory];
                if ( strongAccessory != nil )
                {
                    [strongAccessory setFrame:[self calculatedAccessoryRect]];
                }
                [self setAlpha:1.0];
            } completion:^(BOOL finished) {
                if (finished == YES) 
                {
                    [[self superview] setUserInteractionEnabled:YES];
                }
            }];
        }];
        
        [[self progressLayer] setProgress:[[self currentItem] progress]];
        [[self progressLayer] setNeedsDisplay];
        [[self messageLayer] setString:[[self currentItem] message]];

        [CATransaction commit];
	}
	else
	{
		[self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
	}
}

- (void)show
{
    [self setAlpha:0.0];
    [self update];
}

- (void)hide
{
	if ([NSThread isMainThread]) 
	{
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [CATransaction setCompletionBlock:^{
            [UIView animateWithDuration:.6 animations:^{ 
                [self setAlpha:0.0];
            } completion:^(BOOL finished) {
                if (finished == YES) 
                {
                    [[self superview] setUserInteractionEnabled:NO];
                }
            }];
        }];
        
        [CATransaction commit];
	}
	else
	{
		[self performSelectorOnMainThread:@selector(hide) withObject:nil waitUntilDone:NO];
	}
}

- (void)drawRect:(CGRect)rect 
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGRect rrect = [UIView gvc_SharpenRect:CGRectInset(rect, [self borderWidth]-1, [self borderWidth]-1)];
    [self gvc_addRoundRectangleToContext:context inRect:rrect withRadius:[self cornerRadius]];
    CGContextClip(context);

    CGContextRestoreGState(context);
}

@end
