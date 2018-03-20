//
// MRBadgeCounter.m
//  ikframework
//
//  Created by Federico Gasperini on 03/11/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRBadgeCounter.h"

static MRBadgeCounter* __strong _defaultCounter = nil;

NSString* const MRUpdateBadgeValue = @"IKUpdateBadgeValue";
NSString* const MRBadgeTag = @"IKBadgeTag";

@interface MRBadgeCounter ()

@property (readwrite) id value;

@end

@implementation MRBadgeCounter
{
   id __strong _value;
   NSMutableDictionary* __strong _badgeValues;
}

+(instancetype)defaultCounter
{
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      _defaultCounter = [[self alloc] init];
   });
   return _defaultCounter;
}

-(NSMutableDictionary*)badgeValues
{
   if (!_badgeValues)
      _badgeValues = [[NSMutableDictionary alloc] init];
   return _badgeValues;
}

-(void)updateBadge:(id)tag withValue:(id)value
{
   NSDictionary* userInfo = tag ? userInfo = @{MRBadgeTag:tag} : nil;

   if (tag && value)
      self.badgeValues[tag] = value;
   else if (tag)
      [self.badgeValues removeObjectForKey:tag];
   else
      self.value = value;

   [[NSNotificationCenter defaultCenter] postNotificationName:MRUpdateBadgeValue
                                                       object:self
                                                     userInfo:userInfo];
}

-(void)updateBadgeValueWithBlock:(UpdateBlock)block
{
   if (!block) return;
   id value = nil;
   id tag = nil;
   if (block(&value, &tag))
      [self updateBadge:tag withValue:value];
}

-(id)valueForBadge:(id)tag
{
   return self.badgeValues[tag];
}

-(NSString*)overallDescription
{
   NSInteger __block count = 0;
   NSMutableString* __block buffer = [[NSMutableString alloc] init];
   [self.badgeValues enumerateKeysAndObjectsUsingBlock:^(id tag, id obj, BOOL *stop) {
      if ([obj respondsToSelector:@selector(integerValue)])
         count += [obj integerValue];
      else
         [buffer stringByAppendingFormat:@"%@: %@\n", tag, obj];
   }];
   if (count != 0)
      [buffer appendFormat:@"%ld", (long)count];
   if (self.value)
   {
      if ([self.value respondsToSelector:@selector(integerValue)])
         count += [self.value integerValue];
      else
         [buffer stringByAppendingString:[self.value description]];
   }
   return [buffer copy];
}

@end
