//
//  ETObjectManager.m
//  iconick-lib
//
//  Created by Federico Gasperini on 29/05/15.
//  Copyright (c) 2015 accenture. All rights reserved.
//

#import "IKObjectManager.h"
#import "IKObjectRequestOperation.h"
#import "IKRKRequest.h"

#ifndef DEFAULT_TIMEOUT
#define DEFAULT_TIMEOUT 30.0f
#endif

@interface IKObjectManager () <IKObjectRequestOperationDelegate>

@end

@implementation IKObjectManager

static __strong NSMutableDictionary* _managers = nil;

+(void)load
{
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      _managers = [[NSMutableDictionary alloc] initWithCapacity:1];
   });
}

+(void)unsuspendAll
{
   for (IKObjectManager* om in [_managers allValues])
      om.operationQueue.suspended = NO;
   [[[self sharedManager] operationQueue] setSuspended:NO];
}

+(void)suspendAll
{
   for (IKObjectManager* om in [_managers allValues])
      om.operationQueue.suspended = om.suspendable;
   [[[self sharedManager] operationQueue] setSuspended:[[self sharedManager] suspendable]];
}

+(IKObjectManager*)managerForUrl:(NSString*)baseUrl
                      withMethod:(NSString*)method
                  acceptMimeType:(NSString*)accept
        andSerializationMimeType:(NSString*)serial
                            name:(NSString*)name
                     suspendable:(BOOL)suspendable
{
   NSString* key = [NSString stringWithFormat:@"%@-%@-%@-%@-%@-%@",baseUrl,method,accept,serial,name,@(suspendable)];
   if (baseUrl && [NSURL URLWithString:baseUrl])
   {
      IKObjectManager* manager = _managers[key];
      if (!manager)
      {
         manager = [IKObjectManager managerWithBaseURL:[NSURL URLWithString:baseUrl]];
         [manager registerRequestOperationClass:IKObjectRequestOperation.class];
         manager.operationQueue.suspended = NO;
         manager.suspendable = suspendable;
         if (accept)
            manager.acceptHeaderWithMIMEType = accept;
         if (serial)
            manager.requestSerializationMIMEType = serial;
         _managers[key] = manager;
      }
      return manager;
   }
   return [IKObjectManager sharedManager];
}

+(IKObjectManager*)managerForUrl:(NSString*)baseUrl
              withAcceptMimeType:(NSString*)accept
        andSerializationMimeType:(NSString*)serial
                            name:(NSString*)name
                     suspendable:(BOOL)suspendable
{
   return [self managerForUrl:baseUrl
                   withMethod:@"POST"
               acceptMimeType:RKMIMETypeJSON
     andSerializationMimeType:RKMIMETypeJSON
                         name:name
                  suspendable:YES];
}

+(IKObjectManager*)managerForUrl:(NSString*)baseUrl andName:(NSString*)name
{
   return [self managerForUrl:baseUrl
           withAcceptMimeType:RKMIMETypeJSON
     andSerializationMimeType:RKMIMETypeJSON
                         name:name
                  suspendable:YES];
}

-(void)operationWillStart:(IKObjectRequestOperation*)operation
{
   [self.mObjectManagerDelegate urlRequestWillStart:(id)operation.HTTPRequestOperation.request];
}

-(NSMutableURLRequest *)requestWithObject:(IKRKRequest*)object
                                   method:(RKRequestMethod)method
                                     path:(NSString *)path
                               parameters:(NSDictionary *)parameters
{
   RKRoute* route = [object route];
   if (route)
   {
      RKPathMatcher *pathMatcher = [RKPathMatcher pathMatcherWithPattern:route.pathPattern];
      path = [pathMatcher pathFromObject:object addingEscapes:route.shouldEscapePath interpolatedParameters:nil];
      path = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
   }
   NSMutableURLRequest *request = [super requestWithObject:object
                                                    method:method
                                                      path:path
                                                parameters:parameters];
   request.timeoutInterval = (NSTimeInterval)DEFAULT_TIMEOUT;
   
   for (NSString *field in object.requestHeaderParameters.allKeys)
      [request addValue:object.requestHeaderParameters[field]
     forHTTPHeaderField:field];
   
   NSArray<NSHTTPCookie*>* cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:request.URL];
   if ([cookies count])
   {
      NSDictionary* cookieHeader = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
      for (NSString* field in cookieHeader.allKeys)
         [request addValue:cookieHeader[field]
        forHTTPHeaderField:field];
   }
   
   return request;
}

- (id)appropriateObjectRequestOperationWithObject:(id)object
                                           method:(RKRequestMethod)method
                                             path:(NSString *)path
                                       parameters:(NSDictionary *)parameters
{
   IKObjectRequestOperation* op = [super appropriateObjectRequestOperationWithObject:object
                                                                              method:method
                                                                                path:path
                                                                          parameters:parameters];
   op.ikOperationDelegate = self;
   return op;
}

@end
