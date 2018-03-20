//
//  NSArray+MRInterface.m
//  MRframework
//
//  Created by Dario Trisciuoglio on 26/03/15.
//  Copyright (c) 2015 accenture. All rights reserved.
//

#import "NSArray+MRInterface.h"
#import <UIKit/UIKit.h>

@implementation NSArray (MRInterface)

-(BOOL)existsObjectAtIndex:(NSUInteger)index
{
   BOOL exists = NO;
   if(self.count > 0)
      exists = index <= (self.count - 1);
   return exists;
}

-(BOOL)existsObjectAtIndexPath:(NSIndexPath *)indexPath
{
   BOOL exists = NO;
   if(self.isMultiDimensional)
      if(indexPath.section <= (self.count - 1))
         exists = [self[indexPath.section] existsObjectAtIndex:indexPath.row];
   return exists;
}

-(BOOL)isMultiDimensional
{
   if(self.count > 0)
      return [[self lastObject] isKindOfClass:[NSArray class]];  //[self filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF isKindOfClass:%@",NSArray.class]].count == self.count;
   
   else
      return NO;
}

-(NSArray *)joinForKey:(NSString*)key andSortDescriptors:(NSArray*)sortDescriptors
{
   NSMutableArray* beans = [NSMutableArray new];
   NSSet* data = [NSSet setWithArray:[self valueForKey:key]];
   for (id value in data)
   {
      NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K = %@", key, value];
      NSArray* arrayP = [self filteredArrayUsingPredicate:predicate];
      if(sortDescriptors)
         arrayP = [arrayP sortedArrayUsingDescriptors:sortDescriptors];
      [beans addObject:arrayP];
   }
   return beans.copy;
}

-(NSArray *)joinForKey:(NSString*)key
{
   return [self joinForKey:key andSortDescriptors:nil];
}

-(NSDictionary *)partitionForKey:(NSString*)key andSortDescriptors:(NSArray*)sortDescriptors
{
   NSMutableDictionary* beans = [NSMutableDictionary new];
   NSSet* data = [NSSet setWithArray:[self valueForKeyPath:key]];
   for (id value in data)
   {
      NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K = %@", key, value];
      NSArray* arrayP = [self filteredArrayUsingPredicate:predicate];
      if(sortDescriptors)
         arrayP = [arrayP sortedArrayUsingDescriptors:sortDescriptors];
      [beans setObject:arrayP forKey:value];
   }
   return beans.copy;
}

-(NSDictionary *)partitionForKey:(NSString*)key
{
   return [self partitionForKey:key andSortDescriptors:nil];
}

@end
