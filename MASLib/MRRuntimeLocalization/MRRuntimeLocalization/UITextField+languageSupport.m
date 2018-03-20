//
//  UITextField+languageSupport.m
//  ikframework
//
//  Created by Federico Gasperini on 30/10/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import "UITextField+languageSupport.h"
#import <objc/runtime.h>


@implementation UITextField (languageSupport)

-(void)setupLocalization
{
   [self.localizationTableKeys removeAllObjects];
   [self.localizationTableKeys addObject:self.localizingKey];
   [self.localizationTableKeys addObject:[NSString stringWithFormat:@"%@.placeholder", self.localizingKey]];
}

-(void)localeChange:(NSString*)locale isRtl:(BOOL)rtl
{
   NSString* placehodler = [self localizedValueForKey:self.localizationTableKeys.firstObject
                                            andLocale:locale];
   if (placehodler.length == 0)
      [self localizedValueForKey:self.localizationTableKeys.lastObject
                       andLocale:locale];

   if (placehodler)
      self.placeholder = placehodler;
}

@end
