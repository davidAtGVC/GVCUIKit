//
//  GVCCalendarDayEventCollectionViewController.h
//  GVCUIKit
//
//  Created by David Aspinall on 2013-06-21.
//
//

#import <GVCUIKit/GVCUIKit.h>

@protocol GVCCalendarEventProtocol;

@interface GVCCalendarDayEventCollectionViewController : GVCUICollectionViewController

- (id <GVCCalendarEventProtocol>)eventAtIndexPath:(NSIndexPath *)indexPath;

@end
