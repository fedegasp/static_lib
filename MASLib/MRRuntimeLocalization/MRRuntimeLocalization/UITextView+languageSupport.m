//
//  UITextView+languageSupport.m
//  ikframework
//
//  Created by Federico Gasperini on 30/10/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import "UITextView+languageSupport.h"

@implementation UITextView (languageSupport)

-(void)setupLocalization
{
   [self.localizationTableKeys removeAllObjects];
   [self.localizationTableKeys addObject:self.localizingKey];
   [self.localizationTableKeys addObject:[NSString stringWithFormat:@"%@.text", self.localizingKey]];
}

-(void)localeChange:(NSString*)locale isRtl:(BOOL)rtl
{
   NSString* text = [self localizedValueForKey:self.localizationTableKeys.firstObject
                                            andLocale:locale];
   if (text.length == 0)
      [self localizedValueForKey:self.localizationTableKeys.lastObject
                       andLocale:locale];
   
   if (text)
      self.text = text;
}

@end
