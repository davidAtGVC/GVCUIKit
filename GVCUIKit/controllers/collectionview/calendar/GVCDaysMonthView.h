//
//  GVCDaysMonthView.h
//  GVCUIKit
//
//  Created by David Aspinall on 2013-06-20.
//
//

#import <UIKit/UIKit.h>

@protocol GVCDaysMonthViewDelegate <NSObject>
- (void)calendarView:(UIView *)calendar didSelectDate:(NSDate *)date;
@end

@protocol GVCDaysMonthViewDataSource <NSObject>
@optional
- (NSArray *)calendarView:(UIView *)calendar highlightDatesForCalendarMonth:(NSDate *)date;
@end

@interface GVCDaysMonthView : UIView

@property (nonatomic, strong) UIColor *headerBackgroundColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *highlightedBackgroundColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *textColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *highlightedTextColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, weak) id delegate;
@property (nonatomic, weak) id datasource;

@property (nonatomic, strong) NSDate *focusDate;

@end
