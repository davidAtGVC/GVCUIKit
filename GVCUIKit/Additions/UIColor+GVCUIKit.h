/*
 * UIColor+GVCUIKit.h
 * 
 * Created by David Aspinall on 11-10-02. 
 * Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface UIColor (GVCUIKit)

-(BOOL)isMonochrome;

-(CGFloat)red;
-(CGFloat)green;
-(CGFloat)blue;

-(CGFloat)hue;
-(CGFloat)saturation;
-(CGFloat)brightness;

-(CGFloat)alpha;

-(void)rgba:(float[4])arr;
-(void)hsba:(float[4])arr;

-(UIColor *)reverseColor;

@end

void RGB2HSL(float r, float g, float b, float* outH, float *outS, float *outV);
void HSL2RGB(float h, float s, float l, float* outR, float* outG, float* outB);
