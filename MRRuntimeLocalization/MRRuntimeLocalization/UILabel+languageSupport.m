//
//  IKLlabel.m
//  ikframework
//
//  Created by Federico Gasperini on 30/10/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import "UILabel+languageSupport.h"

@implementation UILabel (languageSupport)

-(void)setupLocalization
{
   [self.localizationTableKeys removeAllObjects];
   [self.localizationTableKeys addObject:self.localizingKey];
   [self.localizationTableKeys addObject:[self.localizingKey stringByAppendingString:@".text"]];
}

-(void)localeChange:(NSString*)locale isRtl:(BOOL)rtl
{
   NSString* text = [self localizedValueForKey:self.localizationTableKeys.firstObject
                                     andLocale:locale];
   if (text.length == 0)
      text = [self localizedValueForKey:self.localizationTableKeys.lastObject
                              andLocale:locale];
   
   if (text)
      self.text = text;
}


@end
