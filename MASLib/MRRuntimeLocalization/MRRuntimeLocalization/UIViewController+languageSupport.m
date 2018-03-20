//
//  UIViewController+languageSupport.m
//  MASClient
//
//  Created by Enrico Cupellini on 27/07/2017.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "UIViewController+languageSupport.h"

@implementation UIViewController (languageSupport)

-(void)setupLocalization
{
    [self.localizationTableKeys removeAllObjects];
    [self.localizationTableKeys addObject:self.localizingKey];
    [self.localizationTableKeys addObject:[self.localizingKey stringByAppendingString:@".title"]];
}

-(void)localeChange:(NSString*)locale isRtl:(BOOL)rtl
{
    NSString* text = [self localizedValueForKey:self.localizationTableKeys.firstObject
                                      andLocale:locale];
    if (text.length == 0)
        text = [self localizedValueForKey:self.localizationTableKeys.lastObject
                                andLocale:locale];
    
    if (text)
    {
        self.title = text;
        self.navigationItem.title = text;
    }
}

@end
