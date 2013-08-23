//
//  GVCCalendarTimeRowView.h
//  GVCUIKit
//
//  Created by David Aspinall on 2013-06-21.
//
//

#import <UIKit/UIKit.h>
#import <GVCFoundation/GVCMacros.h>
#import "GVCHighlightedTextReusableView.h"

// static identifier 'GVCCalendarTimeRowView'
GVC_DEFINE_EXTERN_STR(GVCCalendarTimeRowView_IDENTIFIER);

@interface GVCCalendarTimeRowView : GVCHighlightedTextReusableView

- (void)setTime:(NSDate *)time;

@end
