//
//  NSLocale+languageSupport.m
//  MASClient
//
//  Created by Federico Gasperini on 21/07/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "NSLocale+languageSupport.h"
#import "UIResponder+languageSupport.h"

NSLocale* (^_localeForUserInterface)(void) = nil;

@implementation NSLocale (languageSupport)

-(void)notifyUserInterfaceLocaleChange
{
   [[NSNotificationCenter defaultCenter] postNotificationName:LocaleChangeNotification
                                                       object:self];
}

+(instancetype __nonnull)localeForUserInterface
{
   static NSArray* a = nil;
   if (!a)
      a = [[NSBundle mainBundle] localizations];

   NSLocale* lid = _localeForUserInterface
                   ? _localeForUserInterface()
                   : [self currentLocale];
   NSDictionary *languageDic = [NSLocale componentsFromLocaleIdentifier:lid.localeIdentifier];
   NSString *languageCode = [languageDic objectForKey:@"kCFLocaleLanguageCodeKey"];


   for (NSString* l in a)
      if ([languageCode isEqualToString:l])
         return [NSLocale localeWithLocaleIdentifier:languageCode];

   return [NSLocale localeWithLocaleIdentifier:@"en"];
}

+(void)setLocaleForUserInterfaceBlock:(NSLocale* __nonnull (^__nullable)(void))block
{
   _localeForUserInterface = [block copy];
   [[NSLocale localeForUserInterface] notifyUserInterfaceLocaleChange];
}

@end
