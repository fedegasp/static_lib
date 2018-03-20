//
//  IKRestKitProvider.m
//  iconick-lib
//
//  Created by Federico Gasperini on 16/09/15.
//  Copyright (c) 2015 accenture. All rights reserved.
//

#import <MRBase/MRMacros.h>
#import <MRBackEnd/IKImport.h>
#import <MRBase/MRActivityWindow.h>
#import "IKRestKitProvider.h"
#import "IKObjectRequestOperation.h"
#import "IKObjectManager.h"
#import "RestKit.h"
#import "IKRequest_private.h"
#import "IKRKRequest.h"
#import "IKRKResponse.h"
#import <MRBackEnd/ErrorCenter.h>

#define OBJECT_CACHE

#ifdef OBJECT_CACHE
#import <MRObjectCache/MRObjectCache.h>
#define CACHE_RESULT [MRObjectCache getObjectWithIdentifier:_request.requestIdentifier],\
[MRObjectCache getObjectWithIdentifier:_request.requestIdentifier] != nil
#else
#define CACHE_RESULT nil, NO
#endif

#ifndef CACHE_ENABLED
#define CACHE_ENABLED [[NSUserDefaults standardUserDefaults] boolForKey:@"USE_CACHE"]
#endif

#ifndef REST_KIT_LOG_LEVEL
#define REST_KIT_LOG_LEVEL RKLogLevelTrace
#endif

NSString* IKRestKitProviderKey = @"restkit-provider-key";


@interface IKRestKitProvider () <IKObjectManagerDelegate>

@end


@implementation IKRestKitProvider
{
   IKObjectManager* manager;
   NSMutableSet* registeredRequests;
   NSString* currentLocaleIdentifier;
}

+(void)load
{
   static dispatch_once_t onceToken = 0;
   dispatch_once(&onceToken, ^{
      NSDateFormatter* f = [[NSDateFormatter alloc] init];
      f.dateFormat = @"dd/MM/yyyy HH:mm:ss";
      [[RKValueTransformer defaultValueTransformer] insertValueTransformer:f atIndex:0];

      f = [[NSDateFormatter alloc] init];
      f.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
      [[RKValueTransformer defaultValueTransformer] insertValueTransformer:f atIndex:0];
      
      f = [[NSDateFormatter alloc] init];
      f.dateFormat = @"yyyy-MM-dd HH:mm:ss";
      [[RKValueTransformer defaultValueTransformer] insertValueTransformer:f atIndex:0];
      
      f = [[NSDateFormatter alloc] init];
      f.dateFormat = @"yyyy-MM-dd HH:mm:ssZ";
      [[RKValueTransformer defaultValueTransformer] insertValueTransformer:f atIndex:0];
      
      f = [[NSDateFormatter alloc] init];
      f.dateFormat = @"yyyy-MM-ddTHH:mm:ss.SSS";
      [[RKValueTransformer defaultValueTransformer] insertValueTransformer:f atIndex:0];
      
      f = [[NSDateFormatter alloc] init];
      f.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
      [[RKValueTransformer defaultValueTransformer] insertValueTransformer:f atIndex:0];
      
      f = [[NSDateFormatter alloc] init];
      f.dateFormat = @"yyyy-MM-ddTHH:mm:ss";
      [[RKValueTransformer defaultValueTransformer] insertValueTransformer:f atIndex:0];
      
      f = [[NSDateFormatter alloc] init];
      f.dateFormat = @"yyyy-MM-ddTHH:mm:ssZ";
      [[RKValueTransformer defaultValueTransformer] insertValueTransformer:f atIndex:0];
      
      f = [[NSDateFormatter alloc] init];
      f.dateFormat = @"dd/MM/yyyy";
      [[RKValueTransformer defaultValueTransformer] insertValueTransformer:f atIndex:0];
   });
}

-(NSString*)key
{
   return IKRestKitProviderKey;
}

-(void)setLogLevel:(IKLogLevel)logLevel
{
   [super setLogLevel:logLevel];
   switch (logLevel)
   {
      default:
      case IKLogLevelOff:
         RKLogConfigureByName("RestKit/Network", RKLogLevelOff);
         RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelOff);
         break;
         
      case IKLogLevelError:
         RKLogConfigureByName("RestKit/Network", RKLogLevelError);
         RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelOff);
         break;
         
      case IKLogLevelDebug:
         RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
         RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelOff);
         break;
         
      case IKLogLevelBloat:
         RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
         RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelDebug);
         break;
   }
}

-(void)configure
{
   manager = [IKObjectManager managerWithBaseURL:[[IKEnvironment defaultEnvironment] url]];
   [manager registerRequestOperationClass:[IKObjectRequestOperation class]];
   manager.mObjectManagerDelegate = self;
   manager.acceptHeaderWithMIMEType = RKMIMETypeJSON;
   manager.requestSerializationMIMEType = RKMIMETypeJSON;
   manager.operationQueue.suspended = NO;
   manager.suspendable = YES;
   [IKObjectManager setSharedManager:manager];
   registeredRequests = [[NSMutableSet alloc] init];
   RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
   RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
//   [[NSNotificationCenter defaultCenter] addObserver:self
//                                            selector:@selector(localeChangeNotification:)
//                                                name:LocaleChangeNotification
//                                              object:nil];
//}
//
//-(void)localeChangeNotification:(NSNotification*)notification
//{
//   currentLocaleIdentifier = [(NSLocale*)notification.userInfo[kLocaleKey] localeIdentifier];
}

-(NSString*)localeIdentifierForLocalization
{
   if (currentLocaleIdentifier)
      return currentLocaleIdentifier;
   return [super localeIdentifierForLocalization];
}

-(void)dealloc
{
   [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)registerRequest:(IKRequest*)request
{
   if (![registeredRequests containsObject:request.ikAction])
   {
      [registeredRequests addObject:request.ikAction];
      IKObjectManager* lmanager = [IKObjectManager managerForUrl:[[request.environment url] absoluteString]
                                                      withMethod:[request.environment httpMethod]
                                                  acceptMimeType:[request.environment contentType]
                                        andSerializationMimeType:[request.environment serializationContentType]
                                                            name:request.environment.name
                                                     suspendable:YES];
      lmanager.mObjectManagerDelegate = self;
      //lmanager.operationQueue.suspended = NO;
      
      [lmanager addRequestDescriptorsFromArray:[request.class requestDescriptors]];
      
      Class responseClass = NSClassFromString(request.responseClass);

      RKMapping* mapping = [responseClass responseMapping];
      
      if (mapping)
      {
         NSString* endpoint = [request endPoint];
         NSInteger qm = [endpoint rangeOfString:@"?"].location;
         if (qm != NSNotFound)
         {
            endpoint = [endpoint substringToIndex:qm];
         }
         //if ([request.method isEqualToString:@"GET"])
         //   endpoint = nil;
         //   endpoint = [NSString stringWithFormat:@"%@/", endpoint];

         RKResponseDescriptor* desc = [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                   method:RKRequestMethodAny
                                                                              pathPattern:endpoint
                                                                                  keyPath:nil
                                                                              statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
         [lmanager addResponseDescriptor:desc];
      }
   }
}

-(BOOL)cancelRequest:(IKRequest *)request
{
   if ([request isKindOfClass:IKRequest.class])
   {
      //[request.requestOperation setCompletionBlockWithSuccess:nil failure:nil];
      [(NSOperation*)request.requestOperation cancel];
      return YES;
   }
   return YES;
}

-(BOOL)performRequest:(IKRequest*)request
{
   return [self performRequest:request
                         force:NO
                      onFinish:nil];
}

-(BOOL)performRequest:(IKRequest*)request force:(BOOL)force onFinish:(FinishBlock)finishBlock
{
#ifdef OBJECT_CACHE
   if (CACHE_ENABLED && !force)
   {
      NSString* identifier = request.requestIdentifier;
      id response = [MRObjectCache getObjectWithIdentifier:identifier];
      if (response)
      {
         [request setNotifyPerforming:NO];
         if (![request preOperation:self])
            return NO;
         request.serviceResponse = response;
         [request postSuccess:self];
         if (finishBlock)
            finishBlock(response, YES, nil, 0);
         return YES;
      }
   }
#endif
   switch (request.requestInterfaceType)
   {
      case RequestTypeConstant:
         return [self performConstantRequest:request
                                    onFinish:finishBlock];
         
      case RequestTypeResource:
         return [self performResourceRequest:request
                                    onFinish:finishBlock];
         
      case RequestTypeService:
         return [self performServiceRequest:request
                                   onFinish:finishBlock];
         
      case RequestTypePolling:
         return NO;//[self performPollingRequest:request
         //               onFinish:finishBlock];
         
      case RequestTypeCustom:
         return [self performCustomRequest:request
                                  onFinish:finishBlock];
         
      default:
         break;
   }
   return NO;
}

-(BOOL)performCustomRequest:(IKRequest *)request onFinish:(FinishBlock)finishBlock
{
   if ([request respondsToSelector:@selector(performCustomWithManager:onFinish:)])
      return [request performCustomWithManager:self
                                      onFinish:finishBlock];
   
   return NO;
}

-(BOOL)performConstantRequest:(IKRequest *)request onFinish:(FinishBlock)finishBlock
{
   if (![request preOperation:self])
      return NO;
   request.serviceResponse = request.constantResponse;
   [request postSuccess:self];
   if (finishBlock)
      finishBlock(request.serviceResponse, NO, nil, 0);
   return YES;
}

-(BOOL)performResourceRequest:(IKRequest *)request onFinish:(FinishBlock)finishBlock
{
   
   //   NSMutableURLRequest *downloadRequest = [request resourceRequest];
   //   if (downloadRequest)
   //   {
   //      RKObjectManager *manager = [IKObjectManager sharedManager];
   //      AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:downloadRequest];
   //
   //      __block SuccessBlock succ_b = [successBlock copy];
   //      __block ErrorBlock app_err_b = [appErrBlock copy];
   //      __block ErrorBlock env_err_b = [envErrBlock copy];
   //      WEAK_REF(self);
   //      __block ETRequest* _request = request;
   //      [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
   //
   //      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
   //
   //      }];
   //      [manager.HTTPClient enqueueHTTPRequestOperation:requestOperation];
   //      return YES;
   //   }
   return NO;
}

-(BOOL)performServiceRequest:(IKRequest *)request onFinish:(FinishBlock)finishBlock
{
   __block FinishBlock _finishBlock = [finishBlock copy];
   WEAK_REF(self);
   __block IKRequest* _request = request;
   
   [request notifyPerformingActivity];
   
   [[NSNotificationCenter defaultCenter] postNotificationName:UserContextNetworkCheck
                                                       object:request.errorUserContext
                                                     userInfo:@{EventType:EventTypeServiceCall}];
   
   if ( ! ([request.errorUserContext respondsToSelector:@selector(networkDown)]
           &&
           [request.errorUserContext networkDown]) )
   {
      if (![request preOperation:self])
         return NO;
      
      // libero il main thread per far gestire il blocco dell'interfaccia
      double delayInSeconds = .01;
      dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
      dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
         IKObjectManager* objManager = [IKObjectManager managerForUrl:[[_request.environment url] absoluteString]
                                                           withMethod:_request.method
                                                       acceptMimeType:RKMIMETypeJSON
                                             andSerializationMimeType:[_request.environment serializationContentType]
                                                                 name:_request.environment.name
                                                          suspendable:YES];
         
         _request.requestOperation = [objManager appropriateObjectRequestOperationWithObject:_request
                                                                                      method:RKRequestMethodFromString([_request method])
                                                                                        path:[_request endPoint]
                                                                                  parameters:[_request parameters]];
         
         [_request.requestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            IKResponse *resp = [mappingResult firstObject];
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)[[operation HTTPRequestOperation] response];
            NSData* responseData = [[operation HTTPRequestOperation] responseData];
            if ([_self checkResponse:httpResponse andResponseData:responseData])
            {
               if ([_request.environment buildStub])
               {
                  NSURL* reqUrl = [[[operation HTTPRequestOperation] request] URL];
                  [_self builStubWithRequestUrl:reqUrl
                              requestIdentifier:[_request requestIdentifier]
                                andResponseData:responseData];
               }
               _request.serviceResponse = resp;
               if ([resp.statusCode isEqualToString:@"0"])
               {
                  NSError* error = nil;
#ifdef OBJECT_CACHE
                  if (_request.isCachable && CACHE_ENABLED)
                     if (CACHE_ENABLED)
                        [MRObjectCache putObject:resp
                                withTimeToLive:[_request ttl]
                                    identifier:[_request requestIdentifier]
                                       andTags:[_request tags]];
                  [MRObjectCache invalidateObjectsByTags:[_request invalidatesTags]];
#endif
                  [_request postSuccess:_self];
                  if (_finishBlock)
                     _finishBlock(resp, NO, nil, 0);
                  if (resp.errorDescription.length)
                  {
                     error = [NSError errorWithDomain:@"InfoAlert"
                                                 code:10000
                                             userInfo:@{NSLocalizedDescriptionKey:resp.errorDescription}];
                     
                     [[NSNotificationCenter defaultCenter] postNotificationName:Info
                                                                         object:_self
                                                                       userInfo:@{ErrorKey:error}];
                  }
                  else if ([_request.errorUserContext respondsToSelector:@selector(shouldShowPositiveMessage)]
                           &&
                           [_request.errorUserContext shouldShowPositiveMessage])
                  {
                     [[NSNotificationCenter defaultCenter] postNotificationName:Info
                                                                         object:_self
                                                                       userInfo:nil];
                  }
               }
               else
               {
                  NSError* error = nil;
                  NSString* notificationName = nil;
                  if (resp)
                  {
                     error = [NSError errorWithDomain:resp.errorCode ?: @"malformed"
                                                 code:[resp.statusCode integerValue]
                                             userInfo:@{NSLocalizedDescriptionKey:resp.errorDescription
                                                        ?   resp.errorDescription : @"",
                                                        IKErrorResponseKey: resp}];
                     notificationName = ApplicationError;
                  }
                  else
                  {
                     error = [NSError errorWithDomain:@"json parsing"
                                                 code:1
                                             userInfo:@{NSLocalizedDescriptionKey:@"not json"}];
                     notificationName = JSONMalformation;
                  }
                  [_request postError:_self withError:error];
                  [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                                                                      object:_self
                                                                    userInfo:@{ErrorKey:error}];
                  if (_finishBlock)
                     _finishBlock(CACHE_RESULT,
                                  error, YES);
               }
            }
            else
            {
               NSError* error = [NSError errorWithDomain:resp.statusCode code:[resp.statusCode integerValue] userInfo:@{NSLocalizedDescriptionKey:resp.errorDescription ? resp.errorDescription : @""}];
               [_request postError:_self withError:error];
               if (_finishBlock)
                  _finishBlock(CACHE_RESULT,
                               error, NO);
               [[NSNotificationCenter defaultCenter] postNotificationName:JSONMalformation object:_self userInfo:@{ErrorKey:error}];
            }
         } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            [_request postError:_self withError:error];
            if (_finishBlock)
               _finishBlock(CACHE_RESULT,
                            error, NO);
            if (error.code == NSURLErrorTimedOut)
               [[NSNotificationCenter defaultCenter] postNotificationName:ServerTimeout object:_self userInfo:@{ErrorKey:error}];
            else if (operation.HTTPRequestOperation.response.statusCode == 401)
            {
               //if (AccessLevelIsQualified(_self.accessLevel))
               [[NSNotificationCenter defaultCenter] postNotificationName:ForceLogout
                                                                   object:_self
                                                                 userInfo:@{ErrorKey:error,
                                                                            MessageKey:@"SESSION_EXPIRED_MSG"}];
            }
            else if (operation.HTTPRequestOperation.response.statusCode > 300)
               [[NSNotificationCenter defaultCenter] postNotificationName:HTTPError object:_self userInfo:@{ErrorKey:error}];
            else if (error.code < -1000)
               [[NSNotificationCenter defaultCenter] postNotificationName:NetworkLack object:_self userInfo:@{ErrorKey:error}];
            else if ([error.domain isEqualToString:@"org.restkit.RestKit.ErrorDomain"])
               [[NSNotificationCenter defaultCenter] postNotificationName:JSONMalformation object:_self userInfo:@{ErrorKey:error}];
            else
               [[NSNotificationCenter defaultCenter] postNotificationName:UnknownError object:_self userInfo:@{ErrorKey:error}];
         }];
         [objManager enqueueObjectRequestOperation:_request.requestOperation];
      });
      return YES;
   }
   else
   {
      [request postError:self withError:nil];
      if (_finishBlock)
         _finishBlock(CACHE_RESULT,
                      nil, NO);
   }
   return NO;
}

-(void)builStubWithRequestUrl:(NSURL*)reqUrl
            requestIdentifier:(NSString*)ri
              andResponseData:(NSData*)data
{
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      NSLog(@"WRITING STUB: %@", DocumentsDirectory());
   });
   @synchronized (self)
   {
      NSURLComponents* uc = [NSURLComponents componentsWithURL:reqUrl
                                       resolvingAgainstBaseURL:YES];
      NSString* path = [uc path];
      NSMutableString* finalPath = [DocumentsDirectory() mutableCopy];
      [finalPath appendString:path];
      [[NSFileManager defaultManager] createDirectoryAtPath:finalPath
                                withIntermediateDirectories:YES
                                                 attributes:nil
                                                      error:NULL];
      [finalPath appendFormat:@"/%@",@"resp"];//ri];
      [finalPath appendString:@".json"];
      NSLog(@"WRITING STUB: %@", path);
      [data writeToFile:finalPath atomically:YES];
   }
}

-(BOOL)checkResponse:(NSHTTPURLResponse *)response andResponseData:(NSData*)responseData
{
   return YES;
}

-(void)urlRequestWillStart:(NSMutableURLRequest*)request
{
   
}

@end
