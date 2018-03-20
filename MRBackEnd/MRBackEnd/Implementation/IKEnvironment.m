//
//  IKEnvironment.m
//  iconick-lib
//
//  Created by Federico Gasperini on 15/09/15.
//  Copyright (c) 2015 accenture. All rights reserved.
//

#import "IKEnvironment.h"

NSString* IKErrorResponseKey = @"IKErrorResponseKey";

static __strong NSMutableDictionary* _environments = nil;
static IKLogLevel _logLevel = 0;

static __strong NSArray* _logLevels = nil;
static __strong NSString* _configurationName = nil;

@interface IKEnvironment ()

@property (strong, nonatomic) NSString* endpointMangling;

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* webServiceUrl;
@property (nonatomic, strong) NSString* port;
@property (nonatomic, strong) NSString* backendProviderKey;
@property (nonatomic, strong) NSString* contentType;
@property (nonatomic, strong) NSString* basicAuth;

@property (nonatomic, strong) NSString* httpMethod;
@property (nonatomic, strong) NSString* serializationContentType;

@property (nonatomic, assign) BOOL buildStub;

@end


IKLogLevel IKLogLevelFromNSString(NSString* logLevel)
{
   if (!_logLevel)
      _logLevels = @[@"off",
                     @"error",
                     @"debug",
                     @"bloat"];
   if (logLevel)
   {
      NSInteger idx = [_logLevels indexOfObject:logLevel.lowercaseString];
      if (idx != NSNotFound)
         return idx;
   }
   return IKLogLevelOff;
}


@implementation IKEnvironment

+(void)load
{
   _environments = [[NSMutableDictionary alloc] init];
}

+(BOOL)loadConfiguration:(NSString*)jsonFile withName:(NSString*)name
{
   NSLog(@"\nIK ==================\n Loading configuration with name: %@\n================== KI", name);
   NSData* data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:jsonFile
                                                                                 ofType:@"json"]];
   NSDictionary* confDict = data ? [NSJSONSerialization JSONObjectWithData:data
                                                                   options:0
                                                                     error:NULL] : nil;
   
   NSDictionary* dict = [[confDict[@"configurations"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name=%@",name]] firstObject];
   if (dict)
      _configurationName = [name copy];
   
   for (NSDictionary* conf in dict[@"environments"])
   {
      IKEnvironment* env = [[self alloc] initWithDictionary:conf];
      env.buildStub = [dict[@"build-stub"] boolValue];
      if (env)
         _environments[conf[@"name"]] = env;
   }
   
   [self setDefaultEnvironment:dict[@"default-environment"]];
   
   [self setLogLevel:IKLogLevelFromNSString(dict[@"log-level"])];
   
   return data != nil;
}

+(NSString*)configurationName
{
   return _configurationName;
}

+(NSArray*)allEnvironments
{
   return _environments.allValues;
}

+(void)setDefaultEnvironment:(NSString*)name
{
   if (name)
      [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"IKDefaultEnvironment"];
}

+(instancetype)defaultEnvironment
{
   NSString* defName = [[NSUserDefaults standardUserDefaults] objectForKey:@"IKDefaultEnvironment"];
   if (defName)
      return [self environmentWithName:defName];
   return nil;
}

+(id<BackEndProviderProtocol>)defaultProvider
{
   return [[self defaultEnvironment] backendProvider];
}

+(instancetype)environmentWithName:(NSString*)name
{
	return _environments[name];
}

+(void)setLogLevel:(IKLogLevel)logLevel
{
   _logLevel = logLevel;
   for (IKEnvironment* env in [self allEnvironments])
      [[env backendProvider] setLogLevel:_logLevel];
}

+(BOOL)loadAppConf
{
   return [self loadConfiguration:[self jsonConfFile]
                         withName:[self currentEnvironment]];
}

+(NSDictionary*)appSettings
{
   return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"IKSettings"];
}

+(id __nullable)valueForCurrentConfigurationWithKey:(NSString* __nonnull)key
{
   return [[[self appSettings] valueForKey:
            [self currentEnvironment]]
           valueForKey:key];
}

+(NSString*)currentEnvironment
{
    NSString* env = [[NSUserDefaults standardUserDefaults] valueForKey:@"IKEnvironment"];
    return env ?: [[self appSettings] valueForKey:@"IKEnvironment"];
}

+(NSString*)jsonConfFile
{
   return [[self appSettings] valueForKey:@"JsonConfFile"];
}

-(instancetype)initWithDictionary:(NSDictionary*)dictionary
{
   self = [super init];
   if (self)
   {
      self.name = dictionary[@"name"];
      self.port = [dictionary[@"port"] description] ?: @"80";
      self.webServiceUrl = dictionary[@"web-server"];
      self.webServiceUrl = [self.webServiceUrl stringByReplacingOccurrencesOfString:@"127.0.0.1" withString:@"localhost"];
      self.backendProviderKey = dictionary[@"backend-provider"];
      self.endpointMangling = dictionary[@"endpoint-mangling"] ?: @"%@";
      self.httpMethod = dictionary[@"http-method"];
      self.contentType = dictionary[@"content-type"];
      self.basicAuth = dictionary[@"basic-auth"];
      self.serializationContentType = dictionary[@"serialization-content-type"];
   }
   return self;
}

-(NSString*)endpointMangling
{
   return _endpointMangling ?: @"%@";
}

-(NSString*)mangledEndPoind:(NSString*)endPoint
{
   return [NSString stringWithFormat:self.endpointMangling,endPoint];
}

-(id<BackEndProviderProtocol>)backendProvider
{
   return [[BackEndFactory sharedInstance] backEndForKey:self.backendProviderKey];
}

-(NSURL*)url
{
   NSURLComponents* urlComponents = [[NSURLComponents alloc] initWithString:self.webServiceUrl];
   NSInteger port = [self.port integerValue];
   if (port != 80 && port != 443)
      [urlComponents setPort:@([self.port integerValue])];
   return [urlComponents URL];
}

-(NSString*)httpMethod
{
   if (_httpMethod == nil)
      return @"POST";
   return _httpMethod;
}

-(NSString*)contentType
{
   if (_contentType == nil)
      return @"application/json";
   return _contentType;
}

-(NSString*)serializationContentType
{
   if (_serializationContentType == nil)
   {
      if ([self.httpMethod isEqualToString:@"POST"])
         return @"application/json";
      return @"application/x-www-form-urlencoded";
   }
   return _serializationContentType;
}

@end

NSObject<BackEndProviderProtocol>* BackEnd()
{
   return [IKEnvironment defaultProvider];
}

