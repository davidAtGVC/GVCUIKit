//
//  GVCDayCalendarHeaderView.h
//  GVCUIKit
//
//  Created by David Aspinall on 2013-06-21.
//
//

#import <UIKit/UIKit.h>
#import <GVCFoundation/GVCMacros.h>
#import "GVCHighlightedTextReusableView.h"

// static identifier 'GVCCalendarDayHeaderView'
GVC_DEFINE_EXTERN_STR(GVCCalendarDayHeaderView_IDENTIFIER);

@interface GVCCalendarDayHeaderView : GVCHighlightedTextReusableView

- (void)setDate:(NSDate *)date;

@end
