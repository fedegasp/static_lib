//
//  Token.m
//  restkit-bind
//
//  Created by Federico Gasperini on 24/07/17.
//  Copyright © 2017 Federico Gasperini. All rights reserved.
//

#import "Token.h"
#import "IKCommon.h"
#import "HTTPHeaderHandler.h"
#import <AFNetworking/lib.h>

#ifndef kEnvironmentBE_GET
#define kEnvironmentBE_GET @""
#endif

@implementation Token
{
   id _selfRetain;
}

+(instancetype)getToken
{
   Token* instance = [[self alloc] init];
   instance.ikAction = @"token";
   [instance setDefaults];
   
   instance.ikEnvironment = kEnvironmentBE_GET;
      
   //[instance ikRegisterRequest];
   instance->_selfRetain = self;

   return instance;
}

-(RequestType)requestInterfaceType
{
   return RequestTypeCustom;
}

-(BOOL)performCustomWithManager:(id)manager onFinish:(FinishBlock)finishBlock
{
   AFHTTPSessionManager *afmanager = [AFHTTPSessionManager manager];
   NSMutableString* urlString = [self.environment.url.absoluteString mutableCopy];
   afmanager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
   [urlString appendString:[self endPointForAction:nil]];
   [afmanager GET:urlString
     parameters:nil
       progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, NSData*  _Nullable responseObject) {
           NSString* token = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
           self.serviceResponse = token;
           [HTTPHeaderHandler setToken:token];
           [self postSuccess:manager];
           if (finishBlock)
              finishBlock(token, NO, nil, NO);
           self->_selfRetain = nil;
       }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           [self postError:manager withError:error];
           if (finishBlock)
              finishBlock(nil, NO, error, NO);
        }];
   self->_selfRetain = nil;
   return YES;
}

-(NSString*)endPointForAction:(NSString *)action
{
   return @"/rest/session/token";
}

@end
