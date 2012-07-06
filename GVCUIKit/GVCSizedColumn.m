/*
 * GVCSizedColumn.m
 * 
 * Created by David Aspinall on 12-07-06. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCSizedColumn.h"
#import "GVCFoundation.h"


@interface GVCSizedColumn ()

@end

@implementation GVCSizedColumn

@synthesize columnView;
@synthesize columnIndex;
@synthesize sizePercentage;

- (id)init:(UIView *)view atIndex:(NSUInteger)idx forSize:(CGFloat)percent
{
    self = [super init];
    if (self != nil) 
    {
        [self setColumnView:view];
        [self setColumnIndex:idx];
        [self setSizePercentage:percent];
    }
    return self;
}

- (id)init
{
    return [self init:nil atIndex:0 forSize:0.0];
}

- (NSString *)description
{
    return GVC_SPRINTF(@"%@ (%d) %f %@", [super description], [self columnIndex], [self sizePercentage], [self columnView]);
}
@end
