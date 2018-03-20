//
//  UIView+languageSupport.h
//  ikframework
//
//  Created by Federico Gasperini on 30/10/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+storyboarObjectId.h"

extern NSNotificationName LocaleChangeNotification;

@protocol LocalizableComponent <NSObject>

-(void)setupLocalization;
-(void)localeChange:(NSString*)locale isRtl:(BOOL)rtl;

@end

@interface UIResponder (languageSupport)

@property (readonly) NSMutableArray* localizationTableKeys;

-(NSString*)localizedValueForKey:(NSString*)key andLocale:(NSString*)locale;

@end
