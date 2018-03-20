//
//  NSObject+storyboarObjectId.m
//  ikframework
//
//  Created by Federico Gasperini on 10/02/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import "NSObject+storyboarObjectId.h"
#import <objc/runtime.h>

static char _storyboard_object_id_;
static char _storyboard_name_;

@implementation NSObject (storyboarObjectId)

-(void)setLanguageFileName:(NSString *)languageFileName
{
   objc_setAssociatedObject(self, &_storyboard_name_, languageFileName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString*)languageFileName
{
   return objc_getAssociatedObject(self, &_storyboard_name_);
}

-(void)setLocalizingKey:(NSString *)localizingKey
{
   objc_setAssociatedObject(self, &_storyboard_object_id_, localizingKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString*)localizingKey
{
   return objc_getAssociatedObject(self, &_storyboard_object_id_);
}

@end
