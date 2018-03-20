//
//  ETRequest.h
//  ikframework
//
//  Created by Giovanni Castiglioni on 09/01/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IKEnvironment.h"
#import "BackEndInterface.h"

typedef NS_ENUM(NSInteger, RequestType)
{
   RequestTypeConstant,
   RequestTypeService,
   RequestTypePolling,
   RequestTypeResource,
   RequestTypeCustom
};

typedef NS_ENUM(NSUInteger, PollingAction)
{
    PollingActionContinue,
    PollingActionFail,
    PollingActionSuccess,
};

@protocol IKActivityContext <NSObject>

-(void)startIkActivity;
-(void)stopIkActivity;

@end

@interface IKRequest : NSObject

@property (weak, nonatomic) id requestOperation;
@property (strong, nonatomic) id serviceResponse;

@property (readonly) NSString* requestIdentifier;
@property (readonly) id errorUserContext;
@property (strong, nonatomic) NSString* ikAction;
@property (strong, nonatomic) NSString* ikEnvironment;
@property (strong, nonatomic) NSDictionary* configuration;
@property (assign) BOOL notifyPerforming;

@property (readonly) RequestType requestInterfaceType;

-(void)ikRegisterRequest;

-(void)setNotifyPerforming:(BOOL)notify;
-(instancetype)setNotifyPerformingWithControllerId:(NSString*)cid;
-(instancetype)setNotifyPerforming;
-(instancetype)notifyPerformingOn:(id<IKActivityContext>)context;
-(void)notifyPerformingActivity;
-(instancetype)setRequestErrorUserContext:(id)errorUserContext;

-(BOOL)cancel;
-(BOOL)perform;
-(BOOL)performOnFinish:(FinishBlock)finishBlock;
-(BOOL)performForce:(BOOL)force onFinish:(FinishBlock)finishBlock;

-(BOOL)checkParameters:(NSError* __autoreleasing*)error;
-(BOOL)preOperation:(id<BackEndProviderProtocol>)requestManager;
-(void)postSuccess:(id<BackEndProviderProtocol>)requestManager;
-(void)postError:(id<BackEndProviderProtocol>)requestManager withError:(NSError*)error;

+(IKEnvironment*)defaultEnvironment;
-(IKEnvironment*)environment;

+(id<BackEndProviderProtocol>)defaultBackEndProvider;
-(id<BackEndProviderProtocol>)backEndProvider;

+(NSString*)defaultMethod;
-(NSString*)method;

-(NSString*)endPoint;
-(NSString*)endPointForAction:(NSString*)action;

@property (readonly) NSString* responseClass;
@property (readonly) NSDictionary* mapping;
+(NSDictionary*)requestMapping;

-(void)setDefaults;

-(NSDictionary*)parameters;
-(NSDictionary*)requestHeaderParameters;

-(NSURLRequest*)urlRequest;

@end
