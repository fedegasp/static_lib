//
//  IKLButton.m
//  ikframework
//
//  Created by Federico Gasperini on 30/10/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import "UIButton+languageSupport.h"

@implementation UIButton (languageSupport)

-(void)setupLocalization
{
   [self.localizationTableKeys removeAllObjects];
   [self.localizationTableKeys addObject:self.localizingKey];
   [self.localizationTableKeys addObject:[NSString stringWithFormat:@"%@.normalTitle", self.localizingKey]];
   [self.localizationTableKeys addObject:[NSString stringWithFormat:@"%@.selectedTitle", self.localizingKey]];
   [self.localizationTableKeys addObject:[NSString stringWithFormat:@"%@.disabledTitle", self.localizingKey]];
}

-(void)localeChange:(NSString *)locale isRtl:(BOOL)rtl
{
   NSString* normal = [self localizedValueForKey:self.localizationTableKeys[0]
                                       andLocale:locale];
   if (normal.length == 0)
      normal = [self localizedValueForKey:self.localizationTableKeys[1]
                                andLocale:locale];
   
   NSString* selected = [self localizedValueForKey:self.localizationTableKeys[2]
                                         andLocale:locale];
   NSString* disabled = [self localizedValueForKey:self.localizationTableKeys[3]
                                         andLocale:locale];
   
   if (normal)
      [self setTitle:normal forState:UIControlStateNormal];

   if (selected.length)
      [self setTitle:selected
            forState:UIControlStateSelected];
   
   if (disabled.length)
      [self setTitle:disabled
            forState:UIControlStateDisabled];
}

@end
