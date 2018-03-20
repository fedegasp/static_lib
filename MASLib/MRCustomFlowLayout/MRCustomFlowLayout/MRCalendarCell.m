//
//  MRCalendarCell.m
//  calendar
//
//  Created by Federico Gasperini on 19/04/17.
//  Copyright © 2017 Accenture. All rights reserved.
//

#import "MRCalendarCell.h"
#if __has_include(<MRBase/UICollectionViewCell+MRUtil.h>)
#import <MRBase/UICollectionViewCell+MRUtil.h>
#endif

@implementation MRCalendarCell

-(void)awakeFromNib
{
   [super awakeFromNib];
   self.contentView.clipsToBounds = NO;
   self.contentView.backgroundColor = [UIColor clearColor];
   self.clipsToBounds = NO;
   self.backgroundColor = [UIColor clearColor];
}

-(void)setContent:(id)content
{
   [super setContent:content];
   [self setDate:content];
}

-(void)setDate:(NSDate *)date
{
   _date = date;
   static NSDateFormatter* df = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      df = [[NSDateFormatter alloc] init];
      df.dateFormat = @"d";
   });
   
   NSDateComponents* c = [[NSCalendar currentCalendar]
                          components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear
                          fromDate:date];
   _day = [c day];
   _month = [c month];
   _year = [c year];
   self.dayLabel.text = [df stringFromDate:date];
}

-(void)prepareForReuse
{
   [super prepareForReuse];
   self.past = NO;
   self.future = NO;
   self.dayLabel.text = nil;
   _day = 0;
   _month = 0;
   _year = 0;
}

@end
