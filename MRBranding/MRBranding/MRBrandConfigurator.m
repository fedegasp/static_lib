//
//  MKenBurns.m
//  Mobily
//
//  Created by Gai, Fabio on 14/10/15.
//  Copyright © 2015 accenture. All rights reserved.
//

#import "MRBrandConfigurator.h"

@implementation MRBrandConfigurator

+ (instancetype) sharedInstance
{
    static dispatch_once_t pred= 0;
    __strong static MRBrandConfigurator *singletonObj = nil;
    dispatch_once (&pred, ^{
        singletonObj = [[super allocWithZone:NULL]init];
    });
    return singletonObj;
}

+(id) allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

-(id)copyWithZone:(NSZone *)zone
{
    return self;
}

-(NSDictionary *)configurationDict
{
    if (!_configurationDict) {
        return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ExampleConfig" ofType:@"plist"]];
    }
    return _configurationDict;
}

-(NSString *)configurationKey
{
    if (!_configurationDict) {
        return @"def";
    }
    return _configurationKey;
}

@end
