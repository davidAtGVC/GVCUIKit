//
//  UIStoryboard+GVCUIKit.m
//  GVCUIKit
//
//  Created by David Aspinall on 2013-05-15.
//
//

#import "UIStoryboard+GVCUIKit.h"
#import <GVCFoundation/GVCFoundation.h>

@implementation UIStoryboard (GVCUIKit)

+ (UIStoryboard *)gvc_mainStoryboard
{
    return [UIStoryboard gvc_storyboardNamed:@"MainStoryboard"];
}


+ (UIStoryboard *)gvc_storyboardNamed:(NSString *)name
{
	GVC_DBC_REQUIRE(
					GVC_DBC_FACT_NOT_EMPTY(name);
					)
	
	// implementation
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];

	GVC_DBC_ENSURE(
				   GVC_DBC_FACT_NOT_NIL(storyboard);
				   )
	return storyboard;
}


@end
