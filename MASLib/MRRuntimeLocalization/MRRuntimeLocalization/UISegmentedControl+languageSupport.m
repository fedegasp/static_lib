//
//  UISegmentedControl+languageSupport.m
//  ikframework
//
//  Created by Federico Gasperini on 30/10/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import "UISegmentedControl+languageSupport.h"

@implementation UISegmentedControl (languageSupport)

-(void)setupLocalization
{
   [self.localizationTableKeys removeAllObjects];
   for (NSUInteger i = 0; i < self.numberOfSegments; i++)
      [self.localizationTableKeys addObject:[NSString stringWithFormat:@"%@.segmentTitles[%lu]", self.localizingKey,(unsigned long)i]];
}

-(void)localeChange:(NSString*)locale isRtl:(BOOL)rtl
{
   for (NSUInteger i = 0; i < self.numberOfSegments; i++)
      [self setTitle:[self localizedValueForKey:self.localizationTableKeys[i]
                                      andLocale:locale]
   forSegmentAtIndex:i];
}


@end
