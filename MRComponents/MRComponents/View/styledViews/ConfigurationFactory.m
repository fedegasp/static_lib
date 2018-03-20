//
//  ConfigurationFactory.m
//  MRComponents
//
//  Created by Enrico Cupellini on 13/03/18.
//  Copyright © 2018 Accenture - MAS. All rights reserved.
//

#import "ConfigurationFactory.h"

static NSDictionary *_configurationDict;

@interface ConfigurationFactory ()

@end

@implementation ConfigurationFactory

-(void)setConfigurationDict:(NSDictionary *)configurationDict
{
    _configurationDict = configurationDict;
}

+ (instancetype) sharedInstance
{
    static dispatch_once_t pred= 0;
    __strong static ConfigurationFactory *singletonObj = nil;
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

-(instancetype)init
{
    self=[super init];
    if (self)
    {
        ;
    }
    return self;
}

+(DisplayableItem*)itemWithStyle:(NSString *)style andStatus:(NSString *)status
{
    if (_configurationDict) {
        if (status) {
            style = [NSString stringWithFormat:@"%@@%@",style, status];
        }
        DisplayableItem *display = [DisplayableItem itemWithDictionary:[_configurationDict valueForKey:style]];
        return display;
    }
    return nil;
}

@end
