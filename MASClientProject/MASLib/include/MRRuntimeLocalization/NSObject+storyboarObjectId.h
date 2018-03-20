//
//  NSObject+storyboarObjectId.h
//  ikframework
//
//  Created by Federico Gasperini on 10/02/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (storyboarObjectId)

@property (nonatomic, strong) IBInspectable NSString* languageFileName;

@property (strong, nonatomic) IBInspectable NSString* localizingKey;

@end
