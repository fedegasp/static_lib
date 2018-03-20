//
//  BaseFactory.m
//  ikframework
//
//  Created by Federico Gasperini on 28/01/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import "BaseFactory.h"
#import <objc/runtime.h>

@interface BaseFactory ()

+ (NSArray *)classStringsForClassesOfType:(Class)filterType;

@end

@implementation BaseFactory
{
   __strong NSMutableDictionary* _providers;
}

-(instancetype)initForClass:(__unsafe_unretained Class)cl
{
   if ([cl conformsToProtocol:@protocol(AbstractProvider)])
   {
      self = [super init];
      if (self)
      {
         NSArray *providerClassStrings = [[self class] classStringsForClassesOfType:cl];
         _providers = [[NSMutableDictionary alloc] initWithCapacity:[providerClassStrings count]];
         for (id classString in providerClassStrings)
         {
            Class providerClass = NSClassFromString(classString);
            id<AbstractProvider> provider = [[providerClass alloc] factoryInit];
            [_providers setObject:provider forKey:[provider key]];
         }
      }
      return self;
   }
   return nil;
}

-(NSDictionary*)providers
{
   return _providers;
}


+ (NSArray *)classStringsForClassesOfType:(Class)filterType
{
   int numClasses = 0, newNumClasses = objc_getClassList(NULL, 0);
   Class *classList = NULL;
   
   while (numClasses < newNumClasses)
   {
      numClasses = newNumClasses;
      classList = (Class *)realloc(classList, sizeof(Class) * numClasses);
      newNumClasses = objc_getClassList(classList, numClasses);
   }
   
   NSMutableArray *classesArray = [NSMutableArray array];
   
   for (int i = 0; i < numClasses; i++)
   {
      Class superClass = classList[i];
      do {
         // recursively walk the inheritance hierarchy
         superClass = class_getSuperclass(superClass);
         if (superClass == filterType) {
            [classesArray addObject:NSStringFromClass(classList[i])];
            break;
         }
      }
      while (superClass);
   }
   
   free(classList);
   
   return classesArray;
}

@end
