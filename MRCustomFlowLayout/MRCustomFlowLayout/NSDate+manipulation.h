//
//  NSDate+manipulation.h
//  calendar
//
//  Created by Federico Gasperini on 19/04/17.
//  Copyright © 2017 Accenture. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (manipulation)

-(NSDate*)firstDayOfMonth;
-(NSDate*)lastDayOfMonth;
-(NSDate*)dateInMonthWithDay:(NSInteger)day;

@end

NS_ASSUME_NONNULL_END
