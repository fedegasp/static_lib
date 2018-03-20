//
//  IKEnvironment.h
//  iconick-lib
//
//  Created by Federico Gasperini on 15/09/15.
//  Copyright (c) 2015 accenture. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IKImport.h"

#import "BackEndInterface.h"

extern NSObject<BackEndProviderProtocol>* __nullable BackEnd(void);


@interface IKEnvironment : NSObject

+(BOOL)loadConfiguration:(NSString* __nonnull)jsonFile withName:(NSString* __nonnull)name;

+(NSString* __nullable)configurationName;

+(NSArray* __nullable)allEnvironments;

+(void)setDefaultEnvironment:(NSString* __nonnull)name;

+(instancetype __nullable)defaultEnvironment;

+(instancetype __nullable)environmentWithName:(NSString* __nonnull)name;

+(void)setLogLevel:(IKLogLevel)logLevel;

+(BOOL)loadAppConf;
+(NSDictionary* __nullable)appSettings;
+(id __nullable)valueForCurrentConfigurationWithKey:(NSString* __nonnull)key;
+(NSString* __nullable)currentEnvironment;
+(NSString* __nullable)jsonConfFile;


@property (nonatomic, readonly, nullable) NSString* name;
@property (nonatomic, readonly, nullable) NSString* webServiceUrl;
@property (nonatomic, readonly, nullable) NSString* port;
@property (nonatomic, readonly, nullable) NSString* basicAuth;

@property (nonatomic, readonly, nullable) NSString* httpMethod;
@property (nonatomic, readonly, nullable) NSString* serializationContentType;
@property (nonatomic, readonly, nullable) NSString* contentType;

//@property (nonatomic, strong) id httpClient;

@property (nonatomic, readonly, nullable) NSURL* url;

-(NSString* __nonnull)mangledEndPoind:(NSString* __nonnull)endPoint;

@property (nonatomic, readonly) BOOL buildStub;

@end
