//
//  NSIndexPath+range.m
//  MRBase
//
//  Created by Federico Gasperini on 11/07/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "NSIndexPath+range.h"
#import <UIKit/UIKit.h>

@implementation NSIndexPath (range)

+(NSArray<NSIndexPath*>*)indexPathsWithRange:(NSRange)range inSection:(NSUInteger)section
{
   NSMutableArray* array = nil;
   if (range.location != NSNotFound)
   {
      array = [NSMutableArray arrayWithCapacity:range.length];
   
      for (NSUInteger i = 0; i < range.length; i++)
         [array addObject:[NSIndexPath indexPathForRow:i + range.location
                                             inSection:section]];
   }
   return [array copy];
}

@end
