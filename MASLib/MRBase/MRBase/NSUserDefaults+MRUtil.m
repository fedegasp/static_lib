//
//  NSUserDefaults+MRUtil.m
//  MRBase
//
//  Created by Dario Trisciuoglio on 01/12/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import "NSUserDefaults+MRUtil.h"
#import "NSDictionary+MRUtil.h"

@implementation NSUserDefaults (MRUtil)

+ (void)registerDefaultsFromSettingsBundle
{
   NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
   [defs synchronize];
   
   NSLog(@"%@", defs);
   
   NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
   
   if(!settingsBundle)
   {
      NSLog(@"Could not find Settings.bundle");
      return;
   }

   NSArray *dirFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:settingsBundle error:nil];
   NSArray *plistPaths = [dirFiles filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.plist'"]];
   NSArray* plists = [plistPaths valueForKey:@"lastPathComponent"];
   
   NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] init];
   
   for (NSString* file in plists)
   {
      NSLog(@"Eventually set default from %@", file);
      NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:file]];
      NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
      
      for (NSDictionary *prefSpecification in preferences)
      {
         NSString *key = [prefSpecification objectForKey:@"Key"];
         if (key)
         {
            // check if value readable in userDefaults
            id currentObject = [defs objectForKey:key];
            if (currentObject == nil)
            {
               // not readable: set value from Settings.bundle
               id objectToSet = [prefSpecification objectForKey:@"DefaultValue"];
               if (objectToSet)
               {
                  [defaultsToRegister setObject:objectToSet forKey:key];
                  NSLog(@"Setting object %@ for key %@", objectToSet, key);
               }
            }
         }
      }
   }
   
   if (defaultsToRegister.count)
   {
      NSLog(@"Registering default values from Settings.bundle");
      [defs registerDefaults:defaultsToRegister];
      [defs synchronize];
   }
}

- (void)setCustomObject:(id<NSCoding>)object forKey:(NSString *)key;
{
   NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
   [self setObject:encodedObject forKey:key];
}

- (id)customObjectForKey:(NSString *)key;
{
   NSData *encodedObject = [self objectForKey:key];
   id<NSCoding> object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
   return object;
}

@end
