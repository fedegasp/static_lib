//
//  BaseFactory.h
//  ikframework
//
//  Created by Federico Gasperini on 28/01/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AbstractProvider

-(instancetype)factoryInit __attribute__((objc_method_family( init )));
-(NSString*)key;

@end

@interface BaseFactory : NSObject

-(instancetype)initForClass:(Class)cl;

@property (readonly) NSDictionary* providers;

@end
