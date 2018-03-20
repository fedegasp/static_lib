//
//  HTTPHeaderHandler.m
//  dpr
//
//  Created by Federico Gasperini on 15/03/16.
//  Copyright © 2016 Accenture. All rights reserved.
//

#import "HTTPHeaderHandler.h"
#import "IKCommon.h"


static __strong HTTPHeaderHandler* _instance;

@interface HTTPHeaderHandler ()

@property (readonly) NSString* webClient;
@property (strong) NSString* token;

@end


@implementation HTTPHeaderHandler

+(void)load
{
   _instance = [[self alloc] init];
   [[NSNotificationCenter defaultCenter] addObserver:_instance
                                            selector:@selector(objectRequestOperationDidStartNotification:)
                                                name:RKObjectRequestOperationDidStartNotification
                                              object:nil];
}

+(void)setToken:(NSString*)token
{
   _instance.token = token;
}

-(instancetype)init
{
   if (_instance)
      return self = _instance;
   self = _instance = [super init];
   return self;
}

-(void)dealloc
{
   [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)objectRequestOperationDidStartNotification:(NSNotification*)notification
{
   NSMutableURLRequest* request = (id)[[(id)notification.object HTTPRequestOperation] request];
   
   if (([request.HTTPMethod containsString:@"POST"] || [request.HTTPMethod containsString:@"PUT"])
       && self.token.length )
   {
      [request setValue:self.token forHTTPHeaderField:@"X-CSRF-Token"];
   }
}

-(NSString*)webClient
{
   return [NSString stringWithFormat:@"EXAMPLE-iOS-%@",[[[NSBundle mainBundle] infoDictionary] valueForKey:(__bridge NSString *)kCFBundleVersionKey]];
}

@end
