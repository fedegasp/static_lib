//
//  NSLocale+languageSupport.h
//  MASClient
//
//  Created by Federico Gasperini on 21/07/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSLocale (languageSupport)

+(instancetype __nonnull)localeForUserInterface;
+(void)setLocaleForUserInterfaceBlock:(NSLocale* __nonnull (^__nullable)(void))block;
-(void)notifyUserInterfaceLocaleChange;

@end

#define TABLE(X) [NSString stringWithFormat:@"%@.lproj/%@", [NSLocale localeForUserInterface].localeIdentifier, (X)]
#define ENGLISH_TABLE(X) [NSString stringWithFormat:@"%@.lproj/%@", @"en", (X)]

#define MRLocalizedString(key, file) \
[[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:TABLE(file)] stringByReplacingOccurrencesOfString:@"%s" withString:@"%@"]

#define MRLocalizedUIString(key) \
[[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:TABLE(@"StoryboardLabels")] stringByReplacingOccurrencesOfString:@"%s" withString:@"%@"]

#define MREnglishUIString(key) \
[[[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:ENGLISH_TABLE(@"StoryboardLabels")]  stringByReplacingOccurrencesOfString:@"%s" withString:@"%@"]
