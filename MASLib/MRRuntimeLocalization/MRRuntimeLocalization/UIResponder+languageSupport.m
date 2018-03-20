//
//  UIView+languageSupport.m
//  ikframework
//
//  Created by Federico Gasperini on 30/10/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import "UIResponder+languageSupport.h"
#import "NSLocale+languageSupport.h"
#import <MRBase/JRSwizzle.h>
#import <objc/runtime.h>

NSNotificationName LocaleChangeNotification = @"LocaleChangeNotification";

#ifndef __has_feature
#define __has_feature(x) 0 /* for non-clang compilers */
#endif

#if __has_feature(objc_arc)
#error ARC must be disabled!
#endif

@implementation UIResponder (languageSupport)

+(void)load
{
   [self jr_swizzleMethod:@selector(awakeFromNib)
               withMethod:@selector(loc_awakeFromNib)
                    error:NULL];
   [self jr_swizzleMethod:@selector(dealloc)
               withMethod:@selector(loc_dealloc)
                    error:NULL];
}

-(void)loc_awakeFromNib
{
   [self loc_awakeFromNib];
   [self loc_initCommon];
}

-(void)loc_initCommon
{
   @synchronized(self)
   {
      if ([self conformsToProtocol:@protocol(LocalizableComponent)])
      {
         if (![objc_getAssociatedObject(self, @selector(loc_initCommon)) boolValue])
         {
            objc_setAssociatedObject(self, @selector(loc_initCommon), @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (self.localizingKey && self.languageFileName)
            {
               [[NSNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(localeChangeNotification:)
                                                            name:LocaleChangeNotification
                                                          object:nil];
               
               [(id<LocalizableComponent>)self setupLocalization];
               NSString* locale = [[NSLocale localeForUserInterface] localeIdentifier];
               if (locale)
                  [(id<LocalizableComponent>)self localeChange:locale
                                                         isRtl:[NSLocale characterDirectionForLanguage:locale] == NSLocaleLanguageDirectionRightToLeft];
            }
         }
      }
   }
}

-(void)loc_dealloc
{
   [[NSNotificationCenter defaultCenter] removeObserver:self];
   objc_setAssociatedObject(self, @selector(localizationTableKeys), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
   [self loc_dealloc];
}

-(NSMutableArray*)localizationTableKeys
{
   id retval = objc_getAssociatedObject(self, @selector(localizationTableKeys));
   if (!retval)
   {
      retval = [[NSMutableArray alloc] init];
      objc_setAssociatedObject(self, @selector(localizationTableKeys), retval, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
      [retval release];
   }
   return retval;
}

-(void)localeChangeNotification:(NSNotification*)notification
{
   if (self.localizationTableKeys.count)
   {
      NSString* locale = [notification.object localeIdentifier];
      if (locale)
         [(id<LocalizableComponent>)self localeChange:locale
                                                isRtl:[NSLocale characterDirectionForLanguage:locale] == NSLocaleLanguageDirectionRightToLeft];
   }
}

-(NSString*)localizedValueForKey:(NSString *)key andLocale:(NSString*)locale
{
   NSString* table = [NSString stringWithFormat:@"%@.lproj/%@", locale, self.languageFileName];
   NSString* txt = NSLocalizedStringFromTable(key, table, nil);
   if (![txt isEqualToString:key])
      return txt;
   return nil;
}

-(void)setLanguageFileName:(NSString *)languageFileName
{
   [super setLanguageFileName:languageFileName];
   if ([self conformsToProtocol:@protocol(LocalizableComponent)])
   {
      [self.localizationTableKeys removeAllObjects];
      [[NSNotificationCenter defaultCenter] removeObserver:self];
      if (self.languageFileName && self.localizingKey)
         [self re_loc_initCommon];
   }
}

-(void)setLocalizingKey:(NSString *)localizingKey
{
   [super setLocalizingKey:localizingKey];
   if ([self conformsToProtocol:@protocol(LocalizableComponent)])
   {
      [self.localizationTableKeys removeAllObjects];
      [[NSNotificationCenter defaultCenter] removeObserver:self];
      if (self.languageFileName && self.localizingKey)
         [self re_loc_initCommon];
   }
}

-(void)re_loc_initCommon
{
   objc_setAssociatedObject(self, @selector(loc_initCommon), @(NO), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
   [self loc_initCommon];
}

@end
