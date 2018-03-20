//
//  MRCalendarFlowLayout.m
//  calendar
//
//  Created by Federico Gasperini on 18/04/17.
//  Copyright © 2017 Accenture. All rights reserved.
//

#import "MRCalendarFlowLayout.h"
#import "NSDate+manipulation.h"
#import "MRCalendarCell.h"

@interface MRCalendarFlowLayout ()

@property (readonly) NSInteger startMonth;
@property (readonly) NSInteger startYear;
@property (readonly) NSCalendar* calendar;
@property (readonly) NSDateFormatter* monthLabelFormatter;

@end

#define UNUSED -1

NSInteger dayIndexTranslation[8] = {UNUSED, 6, 0, 1, 2, 3, 4, 5};
NSInteger dayIndexInverseTranslation[8] = {1, 2, 3, 4, 5, 6, 0};

@implementation MRCalendarFlowLayout
{
   BOOL startPosition;
   NSCalendar* _calendar;
   NSInteger _startMonth;
   NSInteger _startYear;
   NSDate* _startDate;
   NSIndexPath* _startDateIndexPath;
   
   NSInteger viewMonth;
   
   NSArray* _monthName;
}

@dynamic collectionViewDelegate;

-(instancetype)init
{
   self = [super init];
   if (self)
   {
      _startMonth = -1;
      _startYear = -1;
   }
   return self;
}

-(instancetype)initWithCoder:(NSCoder*)coder
{
   self = [super initWithCoder:coder];
   if (self)
   {
      _startMonth = -1;
      _startYear = -1;
   }
   return self;
}

-(void)setRows:(NSInteger)rows{}
-(void)setCols:(NSInteger)cols{}

-(NSInteger)rows {return 6;}
-(NSInteger)cols {return 7;}

-(NSInteger) initialSection
{
   switch (self.calendarBehaviour)
   {
      case CalendarBehaviourNormal:
         return 127;
         
      case CalendarBehaviourCantViewPast:
         return 0;
         
      case CalendarBehaviourCantViewFuture:
         return 255;
         
      default:
         return 127;
   }
}

-(void)setSelectedDate:(NSDate*)date
{
   _selectedDate = date;
   [self setSelectedDate:date animated:YES];
}

-(void)setSelectedDate:(NSDate*)date animated:(BOOL)animated
{
   if (date)
   {
      NSIndexPath* idx = [self indexPathForDate:date];
      [self.collectionView selectItemAtIndexPath:idx
                                        animated:NO
                                  scrollPosition:UICollectionViewScrollPositionNone];
      
      [self scrollToDate:date animated:animated];
   }
   else
   {
      NSArray* idps = [self.collectionView indexPathsForSelectedItems];
      for (NSIndexPath* idp in idps)
         [self.collectionView deselectItemAtIndexPath:idp animated:YES];
   }
   _selectedDate = date;
}

-(void)scrollToDate:(nonnull NSDate*)date
{
   [self scrollToDate:date animated:YES];
}

-(void)scrollToDate:(NSDate *)date animated:(BOOL)animated
{
   NSIndexPath* idx = [self indexPathForDate:date];
   CGRect visibleRect = self.collectionView.bounds;
   if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
      visibleRect.origin.x = self.collectionView.bounds.size.width * idx.section;
   else
      visibleRect.origin.y = self.collectionView.bounds.size.height * idx.section;
   [self.collectionView scrollRectToVisible:visibleRect
                                   animated:animated];
   
   if ([self.collectionViewDelegate respondsToSelector:
        @selector(calendarDidShowMonth:ofYear:)])
   {
      NSDateComponents* comp = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth
                                                fromDate:date];
      [self.collectionViewDelegate calendarDidShowMonth:comp.month
                                           ofYear:comp.year];
   }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
   return 256;
}

-(void)invalidateLayout
{
   [super invalidateLayout];
   if (_currentSection == 0)
   {
      NSDateComponents* comp = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth
                                                fromDate:self.startDate];
      viewMonth = comp.month;
      
      CGPoint offset = CGPointMake(0, 0);
      UIScrollView* scrollView = self.collectionView;
      
      if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
         offset.x = (scrollView.frame.size.width - scrollView.contentInset.left - scrollView.contentInset.left) *
         ([self initialSection]) - scrollView.contentInset.left;
      else
         offset.y = (scrollView.frame.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom) *
         ([self initialSection]) - scrollView.contentInset.top;
      self.collectionView.contentOffset = offset;
   }
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(MRCalendarCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
   if ([cell isKindOfClass:MRCalendarCell.class])
   {
      if (indexPath.section == [self initialSection])
      {
         NSDate* d = [self dateForIndexPath:indexPath];
         NSComparisonResult comparision = [d compare:self.startDate];
         cell.past = comparision == NSOrderedAscending;
         cell.future = comparision == NSOrderedDescending;
      }
      else
      {
         cell.past = indexPath.section < [self initialSection];
         cell.future = indexPath.section > [self initialSection];
      }
   }
   
   [super collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
}

-(BOOL)indexPathIsEmpty:(NSIndexPath *)indexPath
{
   if (self.hideSurroundingDays)
   {
      NSInteger deltaMonths = indexPath.section - [self initialSection];
      NSDate* date = [self.calendar dateByAddingUnit:NSCalendarUnitMonth
                                               value:deltaMonths
                                              toDate:self.startDate
                                             options:NSCalendarMatchStrictly];
      NSInteger currentMonth = [self.calendar component:NSCalendarUnitMonth
                                               fromDate:date];
      NSInteger dateMonth = [[NSCalendar currentCalendar]
                             component:NSCalendarUnitMonth
                             fromDate:[self dateForIndexPath:indexPath]];

      return dateMonth != currentMonth;
   }
   return NO;
}

-(id)itemAtIndexPath:(NSIndexPath*)indexPath
{
   return [self dateForIndexPath:indexPath];
}

-(void)setCurrentSection:(NSInteger)currentSection
{
   if (_currentSection != currentSection)
   {
      [super setCurrentSection:currentSection];
      NSInteger section = [[self.collectionView indexPathsForVisibleItems] firstObject].section;
      NSInteger deltaMonths = section - [self initialSection];
      NSDate* date = [self.calendar dateByAddingUnit:NSCalendarUnitMonth
                                               value:deltaMonths
                                              toDate:self.startDate
                                             options:NSCalendarMatchStrictly];
      NSDateComponents* comp = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth
                                                fromDate:date];
      if (self.monthLabel)
      {
         if (self.monthLabelFormatter)
            self.monthLabel.text = [self.monthLabelFormatter stringFromDate:date];
         else
            self.monthLabel.text = [_monthName[comp.month - 1 % _monthName.count] capitalizedString];
      }
      //self.monthLabel.text = [NSString stringWithFormat:@"%@ %ld", [_monthName[comp.month - 1 % _monthName.count] capitalizedString] , (long)comp.year];
      if ([self.collectionViewDelegate respondsToSelector:@selector(calendarDidShowMonth:ofYear:)])
      {
         [self.collectionViewDelegate calendarDidShowMonth:comp.month
                                                    ofYear:comp.year];
      }
   }
}

-(void)setMonthLabelFormat:(NSString *)monthLabelFormat
{
    _monthLabelFormat = monthLabelFormat;
    if (monthLabelFormat.length)
    {
        _monthLabelFormatter = [[NSDateFormatter alloc] init];
        _monthLabelFormatter.dateFormat = monthLabelFormat;
    }
    else
        _monthLabelFormatter = nil;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   [self.collectionViewDelegate calendarDidSelectDate:[self dateForIndexPath:indexPath]];
   if ([self.collectionViewDelegate respondsToSelector:@selector(calendarDidSelectDay:month:year:)])
   {
      MRCalendarCell* c = (id)[self.collectionView cellForItemAtIndexPath:indexPath];
      if ([c isKindOfClass:MRCalendarCell.class])
         [self.collectionViewDelegate calendarDidSelectDay:c.day
                                                     month:c.month
                                                      year:c.year];
   }
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
   if ([self.collectionViewDelegate respondsToSelector:@selector(calendarDidDeselectDate:)])
      [self.collectionViewDelegate calendarDidDeselectDate:[self dateForIndexPath:indexPath]];
}

-(NSDate*)dateForIndexPath:(NSIndexPath*)indexPath
{
   NSInteger deltaMonths = indexPath.section - [self initialSection];
   NSDate* date = [self.calendar dateByAddingUnit:NSCalendarUnitMonth
                                         value:deltaMonths
                                        toDate:self.startDate
                                       options:NSCalendarMatchStrictly];

   NSInteger day = 0;
   day = indexPath.item + 1 - [self firstWeekdayOfMonth:[date firstDayOfMonth]];
   
   return [date dateInMonthWithDay:day];
}

-(void)setStartDate:(NSDate *)startDate
{
   _startDate = [[NSCalendar currentCalendar] dateBySettingHour:12
                                                         minute:0
                                                         second:0
                                                         ofDate:startDate
                                                        options:0];
   _startYear = -1;
   _startMonth = -1;
   _startDateIndexPath = nil;
   startPosition = NO;
}

-(NSDate*)startDate
{
   return _startDate ?: [[NSCalendar currentCalendar] dateBySettingHour:12
                                                                 minute:0
                                                                 second:0
                                                                 ofDate:[NSDate date]
                                                                options:0];
}

-(NSInteger)startMonth
{
   if (_startMonth == -1)
      _startMonth = [self.calendar component:NSCalendarUnitMonth
                                    fromDate:self.startDate];
   return _startMonth;
}

-(NSInteger)startYear
{
   if (_startYear == -1)
      _startYear = [self.calendar component:NSCalendarUnitYear
                                   fromDate:self.startDate];
   return _startYear;
}

-(NSCalendar*)calendar
{
   if (!_calendar)
      _calendar = [NSCalendar currentCalendar];
   return _calendar;
}

-(NSIndexPath*)startDateIndexPath
{
   if (!_startDateIndexPath)
      _startDateIndexPath = [self indexPathForDate:self.startDate];
   return _startDateIndexPath;
}

-(NSIndexPath*)indexPathForDate:(NSDate*)date
{
   NSInteger calendarItem = [self itemIndexForDate:date];
   NSInteger calendarSection = [self calendarSectionForDate:date];
   return [NSIndexPath indexPathForItem:calendarItem
                              inSection:calendarSection];
}

-(NSInteger)itemIndexForDate:(NSDate*)date
{
   NSInteger firstWeekday = [self firstWeekdayOfMonth:date];
   NSInteger dayOfMonth = [self.calendar component:NSCalendarUnitDay
                                          fromDate:date];
   return firstWeekday + dayOfMonth - 1;
}

-(NSInteger)calendarSectionForDate:(NSDate*)date
{
   NSDateComponents* start = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth
                                              fromDate:self.startDate];
   NSDateComponents* target = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth
                                               fromDate:date];

   NSInteger delta = (target.year - start.year) * 12 + target.month - start.month;
   
   return [self initialSection] + delta;
}

-(NSInteger)firstWeekdayOfMonth:(NSDate*)date
{
   NSInteger firstWeekdayOfMonth = [self.calendar component:NSCalendarUnitWeekday
                                                   fromDate:[date firstDayOfMonth]];
   return dayIndexTranslation[firstWeekdayOfMonth];
}

-(void)setWeekDaysLabels:(NSArray *)weekDaysLabels
{
   _weekDaysLabels = weekDaysLabels;
   NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
   NSArray *daySymbols = dateFormatter.shortStandaloneWeekdaySymbols;
   NSUInteger idx = 0;
   for (UILabel* l in weekDaysLabels)
      l.text = [daySymbols[dayIndexInverseTranslation[(idx++ % 7)]] capitalizedString];
}

-(void)setMonthLabel:(UILabel *)monthLabel
{
   _monthLabel = monthLabel;
   _monthName = [[NSDateFormatter alloc] init].monthSymbols;
}

@end


@implementation MRCalendarFlowLayout (ibinspectable)

@dynamic calendarBehaviour;

@end

