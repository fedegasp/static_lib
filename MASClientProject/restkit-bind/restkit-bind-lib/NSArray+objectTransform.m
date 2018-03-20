//
//  NSArray+objectTransform.m
//  restkit-bind
//
//  Created by Federico Gasperini on 04/07/16.
//  Copyright © 2016 Federico Gasperini. All rights reserved.
//

#import "NSArray+objectTransform.h"

@interface NSArray (objectTransform)

-(id)objectWithMapping:(NSDictionary*)mapping;

@end

@implementation NSObject (objectTransform)

-(id)objectWithMapping:(NSDictionary*)mapping
{
   if (!mapping)
      return self;
   
   NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
   for (NSString* k in [mapping.allKeys filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
      return ![evaluatedObject hasSuffix:@"$mapping"];
   }]])
   {
      NSString* targetProp = mapping[k];
      id obj = [self valueForKeyPath:k];
      NSDictionary* nestedMapping = mapping[[NSString stringWithFormat:@"%@$mapping",k]];
      id mapped = [obj objectWithMapping:nestedMapping];
      if (mapped)
         dict[targetProp] = mapped;
   }
   return dict;
}

@end


@implementation NSArray (objectTransform)

-(instancetype)objectWithMapping:(NSDictionary*)mapping
{
   NSMutableArray* arr = [[NSMutableArray alloc] initWithCapacity:self.count];
   for (id obj in self)
   {
      id mapped = [obj objectWithMapping:mapping];
      if (mapped)
         [arr addObject:mapped];
   }
   return arr.count ? arr : nil;
}

@end
