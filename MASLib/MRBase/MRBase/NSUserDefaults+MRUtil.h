//
//  NSUserDefaults+MRUtil.h
//  MRBase
//
//  Created by Dario Trisciuoglio on 01/12/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (MRUtil)

+ (void)registerDefaultsFromSettingsBundle;

- (void)setCustomObject:(id<NSCoding>)object forKey:(NSString *)key;
- (id)customObjectForKey:(NSString *)key;

@end
