//
//  NSObject+valueValidation.m
//  ikframework
//
//  Created by Federico Gasperini on 13/03/15.
//  Copyright (c) 2015 accenture. All rights reserved.
//

#import "NSObject+valueValidation.h"

@implementation NSObject (valueValidation)

-(BOOL)setValue:(id)value forKey:(NSString *)key error:(NSError* __autoreleasing*)error
{
   id localValue = value;
   BOOL valid = [self validateValue:&localValue forKey:key error:error];
   [self setValue:localValue forKey:key];
   return valid;
}

-(BOOL)isValid
{
   return YES;
}

@end
