//
//  MRCalendarFlowLayout.h
//  calendar
//
//  Created by Federico Gasperini on 18/04/17.
//  Copyright © 2017 Accenture. All rights reserved.
//

#import "MRTransposedGridLayout.h"

typedef enum : NSInteger {
   CalendarBehaviourCantViewPast = -1,
   CalendarBehaviourNormal,
   CalendarBehaviourCantViewFuture
} CalendarBehaviour;

@protocol MRCalendarDelegate <MRGridLayoutDelegate>

-(void)calendarDidSelectDate:(nonnull NSDate*)date;

@optional
-(void)calendarDidSelectDay:(NSInteger)day month:(NSInteger)m year:(NSInteger)year;
-(void)calendarDidDeselectDate:(nonnull NSDate*)date;
-(void)calendarDidShowMonth:(NSInteger)m ofYear:(NSInteger)y;

@end

@interface MRCalendarFlowLayout : MRTransposedGridLayout

@property (nonatomic, assign) CalendarBehaviour calendarBehaviour;

@property (nonatomic, weak, readwrite, nullable) IBOutlet id<MRCalendarDelegate> collectionViewDelegate;

@property (assign) IBInspectable BOOL hideSurroundingDays;

@property (nonatomic, strong, nullable) IBOutletCollection(UILabel) NSArray* weekDaysLabels;
@property (nonatomic, weak, nullable) IBOutlet UILabel* monthLabel;
@property (nonatomic, strong, nullable) IBInspectable NSString* monthLabelFormat;

@property (nonatomic, strong, nonnull) NSDate* startDate;
@property (nonatomic, nullable) NSDate* selectedDate;
-(void)setSelectedDate:(nullable NSDate*)date animated:(BOOL)animated;
-(void)scrollToDate:(nonnull NSDate*)date animated:(BOOL)animated;
-(void)scrollToDate:(nonnull NSDate*)date;

@end


@interface MRCalendarFlowLayout (ibinspectable)

@property (nonatomic, assign) IBInspectable NSInteger calendarBehaviour;

@end

