//
//  NSArray+MRInterface.h
//  MRframework
//
//  Created by Dario Trisciuoglio on 26/03/15.
//  Copyright (c) 2015 accenture. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (MRInterface)

-(BOOL)existsObjectAtIndex:(NSUInteger)index;
-(BOOL)existsObjectAtIndexPath:(NSIndexPath *)indexPath;
-(BOOL)isMultiDimensional;

-(NSArray *)joinForKey:(NSString*)key andSortDescriptors:(NSArray*)sortDescriptors;
-(NSArray *)joinForKey:(NSString*)key;

-(NSDictionary *)partitionForKey:(NSString*)key andSortDescriptors:(NSArray*)sortDescriptors;
-(NSDictionary *)partitionForKey:(NSString*)key;

@end
