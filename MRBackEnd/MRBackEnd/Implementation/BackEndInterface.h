//
//  BackEndInterface.h
//  ikframework
//
//  Created by Federico Gasperini on 17/01/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import "IKImport.h"
#import <MRBase/BaseFactory.h>

@protocol BackEndProviderProtocol;

/** 
 BackEndFactory provides factory method to gain access to real instances of BackEndProviderProtocol classes. BackEndFactory is a singleton.
 */

@interface BackEndFactory : BaseFactory

/**
 The BackEndFactory instance
 */
+(instancetype)sharedInstance;

/**
 @return the instance for the 'key' key
 */
-(id<BackEndProviderProtocol>)backEndForKey:(NSString*)key;

@end

typedef NS_ENUM(NSInteger, AccessLevel)
{
    AccessLevelOff,
    AccessLevelGuest,
    AccessLevelPendinPolling, // UNUSED
    AccessLevelPendig,        // UNUSED
    AccessLevelWaitingAccess, // UNUSED
    AccessLevelSubscriber,
    AccessLevelFull
};

//Utility functions for access level
BOOL AccessLevelIsPendig(AccessLevel al);
BOOL AccessLevelIsQualified(AccessLevel al);
BOOL AccessLevelIsFullyQualified(AccessLevel al);
BOOL AccessLevelIsGuest(AccessLevel al);

/**
 State for sessionid, it can be valid, invalid or absent
 */
typedef NS_ENUM(NSInteger, SessionIdState)
{
    SessionIdStatePending, // UNUSED
    SessionIdStateValid,
    SessionIdStateNotValid,
    SessionIdStateNull
};


typedef void(^SessionIdStateBlock)(SessionIdState sidState);

/**
 BackEndProviderProtocol defines a method for requests execution, the block executed in case of success has SuccessBlock signature
 */
typedef void(^FinishBlock)(id response, BOOL cached, NSError* error, BOOL errorIsApplicative);

@protocol BackEndProviderProtocol <NSObject,AbstractProvider>

/**
 It sets up the instance
 */
-(void)configure;

/**
 It sets up instance to work with the request
 */
-(void)registerRequest:(id)request;

/**
 The alias for the current line
 */
@property (readonly) NSString* currentAlias;

/**
 (Drop1: UNUSED)
 */
-(NSString*)editAlias;

/**
 It is yes if a session is already present
 */
@property (readonly) BOOL sessionIsPresent;

/**
 a boolean indicating if user accepted the usage conditions
 (Drop1: always YES)
 */
@property (assign, nonatomic) BOOL termsAndConditionsApproved;

/**
 the system locale
 */
@property (strong, nonatomic) NSLocale* globalLocale;

/**
 locale used in the application
 */
@property (strong, nonatomic) NSLocale* currentLocale;

@property (strong, nonatomic) NSDictionary* pendingNotification;

@property (strong, nonatomic) NSString* userName;

@property (strong, nonatomic) NSData* deviceToken;

@property (strong, nonatomic) NSString* facebookID;

@property (strong, nonatomic) NSString* twitterID;

@property (strong, nonatomic) id socialInfo;

@property (assign) BOOL isTutorial;

@property (assign, nonatomic) IKLogLevel logLevel;

-(BOOL)performRequest:(id)request
                force:(BOOL)force
             onFinish:(FinishBlock)finishBlock;
-(BOOL)performRequest:(id)request;

-(BOOL)cancelRequest:(id)request;

-(NSString*)convertText:(NSString*)text;

-(NSString*)localeIdentifierForLocalization;

-(void)testSessionId:(SessionIdStateBlock)blk;

@property (readwrite) AccessLevel accessLevel;

@end

/**
 BackEndProvider is a convenience base abstract like class, usefull for the Factory pattern
 */
@interface BackEndProvider : NSObject <BackEndProviderProtocol>


@end


