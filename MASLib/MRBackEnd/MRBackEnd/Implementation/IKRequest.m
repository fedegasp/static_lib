//
//  ETRequest.m
//  ikframework
//
//  Created by Giovanni Castiglioni on 09/01/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import "IKRequest.h"
#import "NSError+ikFacility.h"

#ifdef IK_ACTIVITY_WINDOW
#import <MRBase/MRActivityWindow.h>
#endif //IK_ACTIVITY_WINDOW

@interface NSObject ()

-(void)putCurrentRequest:(IKRequest*)currentRequest;

@end

@implementation IKRequest
{
   BOOL _notifyEnd;
   id _cid;
   NSTimeInterval _timeStamp;
   __weak id _errorUserContext;
   __weak id<IKActivityContext> _activityContext;
}

-(id)constantResponse
{
   return nil;
}

-(NSMutableURLRequest*)resourceRequest
{
   return nil;
}

+(IKEnvironment*)defaultEnvironment
{
   return [IKEnvironment defaultEnvironment];
}

+(NSString*)defaultMethod
{
   return @"POST";
}

+(id<BackEndProviderProtocol>)defaultBackEndProvider
{
   return BackEnd();
}

-(IKEnvironment*)environment
{
   if (self.ikEnvironment)
      return [IKEnvironment environmentWithName:self.ikEnvironment];
   return [self.class defaultEnvironment];
}

-(NSString*)method
{
   return self.environment.httpMethod ?: [self.class defaultMethod];
}

-(id<BackEndProviderProtocol>)backEndProvider
{
   if (self.configuration[@"provider-key"])
      return [[BackEndFactory sharedInstance] backEndForKey:self.configuration[@"provider-key"]];
   return [self.class defaultBackEndProvider];
}

-(NSString*)endPoint
{
   return [self.environment mangledEndPoind:[self endPointForAction:self.ikAction]];
}

-(NSString*)endPointForAction:(NSString*)action
{
   return action;
}

-(BOOL)checkParameters:(NSError* __autoreleasing*)error
{
   return YES;
}

-(instancetype)setNotifyPerformingWithControllerId:(NSString*)cid
{
   _cid = cid;
   _notifyPerforming = YES;
   _notifyEnd = YES;
   _activityContext = nil;
   return self;
}

-(instancetype)setNotifyPerforming
{
   _notifyPerforming = YES;
   _notifyEnd = YES;
   _activityContext = nil;
   return self;
}

-(instancetype)notifyPerformingOn:(id)context
{
   [self setNotifyPerforming];
   _activityContext = context;
   return self;
}

-(void)notifyPerformingActivity
{
#ifdef IK_ACTIVITY_WINDOW
   if (self.notifyPerforming)
   {
      if (_activityContext)
         [_activityContext startIkActivity];
      else
         [[NSNotificationCenter defaultCenter] postNotificationName:ShowLoadingView
                                                             object:self];
   }
#endif
}

-(instancetype)setRequestErrorUserContext:(id)errorUserContext
{
   _errorUserContext = errorUserContext;
   if ([_errorUserContext respondsToSelector:@selector(putCurrentRequest:)])
      [_errorUserContext putCurrentRequest:self];
   return self;
}

-(BOOL)preOperation:(id<BackEndProviderProtocol>)requestManager
{

   return YES;
}

-(void)postSuccess:(id<BackEndProviderProtocol>)requestManager
{
#ifdef IK_ACTIVITY_WINDOW
   if (self.notifyPerforming)
   {
      if (_activityContext)
         [_activityContext stopIkActivity];
      else
         [[NSNotificationCenter defaultCenter] postNotificationName:HideLoadingView
                                                             object:self];
   }
#endif
   _notifyEnd = NO;
}

-(void)postError:(id<BackEndProviderProtocol>)requestManager
{
   [self postError:requestManager
         withError:nil];
}

-(void)postError:(id<BackEndProviderProtocol>)requestManager withError:(NSError*)error
{
   error.errorUserContext = self.errorUserContext;
#ifdef IK_ACTIVITY_WINDOW
   if (self.notifyPerforming)// && (error != nil)) // se error == nil, non è stato chiamato Show
   {
      if (_activityContext)
         [_activityContext stopIkActivity];
      else
         [[NSNotificationCenter defaultCenter] postNotificationName:HideLoadingView
                                                             object:self];
   }
#endif
   _notifyEnd = NO;
}

-(NSTimeInterval)lifeTime
{
   return [NSDate timeIntervalSinceReferenceDate] - _timeStamp;
}

-(NSTimeInterval)nextDelay
{
   return 5.0;
   //   NSTimeInterval age = self.lifeTime; // stop time to now
   //   NSTimeInterval pNext = age * 1.5;
   //   if ((age + pNext) > self.maxPollingTime)
   //      pNext = self.maxPollingTime - age; // last try
   //   return pNext;
}

-(BOOL)performCustomWithManager:(id)manager onFinish:(FinishBlock)finishBlock
{
   return NO;
}

-(PollingAction)pollingActionWithResponse:(id)response error:(NSError*)error andPoller:(id)poller
{
//   if (self.lifeTime < self.maxPollingTime)
//      return PollingActionContinue;
//   
//#ifdef IK_ACTIVITY_WINDOW
//   NSError* err = [NSError errorWithDomain:@"PollingFailure"
//                                      code:12300
//                                  userInfo:nil];
//   [[NSNotificationCenter defaultCenter] postNotificationName:PollingFailure
//                                                       object:self
//                                                     userInfo:@{ErrorKey:err}];
//#endif
   
   return PollingActionFail;
}

-(void)pollingEnd:(id<BackEndProviderProtocol>)requestManager
{
#ifdef IK_ACTIVITY_WINDOW
   if (self.notifyPerforming)
   {
      if (_activityContext)
         [_activityContext stopIkActivity];
      else
         [[NSNotificationCenter defaultCenter] postNotificationName:HideLoadingView
                                                             object:self];
   }
#endif
   _notifyEnd = NO;
}

-(BOOL)isEqual:(id)object
{
   return [object isMemberOfClass:self.class];
}

-(NSUInteger)hash
{
   return [self.class hash];
}

-(BOOL)isCachable
{
   return self.ttl > 0;
}

-(NSString*)requestIdentifier
{
   NSMutableString* _id = [[NSMutableString alloc] initWithFormat:@"%@-%@", NSStringFromClass(self.class), self.ikAction];
   NSArray* keys = [self.class requestMapping].allKeys;
   keys = [keys sortedArrayUsingSelector:@selector(compare:)];
   for (NSString* k in keys)
      if (!([[k lowercaseString] isEqualToString:@"transactionid"] ||
            [[k lowercaseString] isEqualToString:@"appid"]))
         [_id appendFormat:@"-%@", [self valueForKey:k]];
   return [_id copy];
}

-(void)dealloc
{
   NSLog(@"[%@ dealloc] - %@", NSStringFromClass(self.class), self.requestIdentifier);
#ifdef IK_ACTIVITY_WINDOW
   if (_notifyEnd)
   {
      if (_activityContext)
         [_activityContext stopIkActivity];
      else
         [[NSNotificationCenter defaultCenter] postNotificationName:HideLoadingView
                                                             object:self];
   }
#endif
}

-(NSArray*)invalidatesTags
{
   return @[];
}

-(NSArray*)tags
{
   return @[];
}

-(NSTimeInterval)ttl
{
   return -1;
}

-(RequestType)requestInterfaceType
{
   return RequestTypeService;
}

-(BOOL)cancel
{
   return [self.backEndProvider cancelRequest:self];
}

-(BOOL)perform
{
   return [self.backEndProvider performRequest:self
                                         force:NO
                                      onFinish:nil];
}

-(BOOL)performOnFinish:(FinishBlock)finishBlock
{
   return [self.backEndProvider performRequest:self
                                         force:NO
                                      onFinish:finishBlock];
}

-(BOOL)performForce:(BOOL)force onFinish:(FinishBlock)finishBlock
{
   return [self.backEndProvider performRequest:self
                                         force:force
                                      onFinish:finishBlock];
}

-(void)ikRegisterRequest
{
   [[self backEndProvider] registerRequest:self];
}

+(NSDictionary*)requestMapping
{
   return @{};
}

-(void)setDefaults
{
   
}

-(NSDictionary*)parameters
{
   return nil;
}

-(NSDictionary*)requestHeaderParameters {
   return @{};
}

-(NSURLRequest*)urlRequest
{
   return nil;
}

@end
