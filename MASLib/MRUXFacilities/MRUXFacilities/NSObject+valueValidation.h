//
//  NSObject+valueValidation.h
//  ikframework
//
//  Created by Federico Gasperini on 13/03/15.
//  Copyright (c) 2015 accenture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MRBase/NSString+validation.h>

@interface NSObject (valueValidation)

/**
 * Sets a value for a key if it is valid according to KVC validating pattern.
 * Any proposed value is discarded.
 */
-(BOOL)setValue:(id)value forKey:(NSString *)key error:(NSError* __autoreleasing*)error;

/**
 * Tells whether the bean value is in its domain (default YES).
 */
-(BOOL)isValid;

@end
