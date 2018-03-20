//
//  NSDate+manipulation.m
//  calendar
//
//  Created by Federico Gasperini on 19/04/17.
//  Copyright © 2017 Accenture. All rights reserved.
//

#import "NSDate+manipulation.h"

#define ALL_DATE_COMPONENTS NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitTimeZone

@implementation NSDate (manipulation)

-(NSDate*)firstDayOfMonth
{
   return [self dateInMonthWithDay:1];
}

-(NSDate*)lastDayOfMonth
{
   NSCalendar* c = [NSCalendar currentCalendar];
   NSRange r = [c rangeOfUnit:NSCalendarUnitDay
                       inUnit:NSCalendarUnitMonth
                      forDate:self];
   return [self dateInMonthWithDay:r.length];
}

-(NSDate*)dateInMonthWithDay:(NSInteger)day
{
   NSCalendar* c = [NSCalendar currentCalendar];
   NSDateComponents* comp = [c components:ALL_DATE_COMPONENTS fromDate:self];
   comp.day = day;
   return [c dateFromComponents:comp];
}

@end
