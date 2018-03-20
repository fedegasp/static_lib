//
//  NSDictionary+MRUtil.m
//  MRBase
//
//  Created by Dario Trisciuoglio on 29/11/13.
//  Copyright (c) 2013 Dario Trisciuoglio. All rights reserved.
//

#import "NSDictionary+MRUtil.h"

@implementation NSDictionary (IKInterface)

-(BOOL)existsObjectAtKey:(NSString*)key
{
   BOOL exists = NO;
   for(NSString* k in self.allKeys)
   {
      if([k isEqualToString:key])
      {
         exists = YES;
         break;
      }
   }
   return exists;
}

-(NSDictionary *)removeNullValues
{
   NSMutableDictionary* dictionary = self.mutableCopy;
   NSArray* keysForNullValues = [dictionary allKeysForObject:[NSNull null]];
   [dictionary removeObjectsForKeys:keysForNullValues];
   NSArray* keysForStingEmptity = [dictionary allKeysForObject:@""];
   [dictionary removeObjectsForKeys:keysForStingEmptity];
   return [dictionary copy];
}

-(BOOL)saveToPlistWithName:(NSString*)name
{
   NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   NSString* documentsDirectory = paths[0];
   NSString* filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", name]];
   return [self saveToPlistWithName:name andFilePath:filePath];
}

-(BOOL)saveToPlistWithName:(NSString*)name andFilePath:(NSString*)filePath
{
    BOOL isSave = NO;
    NSError* error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSString* bundle = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
        if(bundle)
            [[NSFileManager defaultManager] copyItemAtPath:bundle toPath:filePath error:&error];
    }
    NSDictionary* d = [self removeNullValues];
    isSave = [d writeToFile:filePath atomically:YES];
    return isSave;
}

-(BOOL)saveToPlistWithFilePath:(NSString*)filePath
{
    return [self saveToPlistWithName:nil andFilePath:filePath];
}

@end

@implementation NSMutableDictionary (IKInterface)

-(void)safeEntries:(NSDictionary *)value
{
   @try
   {
      [self addEntriesFromDictionary:value];
   }
   @catch (NSException *exception) {}
}

@end
