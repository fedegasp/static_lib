//
//  BackEndInterface.m
//  ikframework
//
//  Created by Federico Gasperini on 17/01/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import "IKImport.h"
#import "BackEndInterface.h"

BOOL AccessLevelIsPendig(AccessLevel al)
{
    return (al == AccessLevelPendinPolling
            ||
            al == AccessLevelPendig
            ||
            al == AccessLevelWaitingAccess);
}

BOOL AccessLevelIsQualified(AccessLevel al)
{
    return (al == AccessLevelFull
            ||
            al == AccessLevelSubscriber);
}

BOOL AccessLevelIsFullyQualified(AccessLevel al)
{
    return (al == AccessLevelFull);
}

BOOL AccessLevelIsGuest(AccessLevel al)
{
    return (al == AccessLevelGuest
            ||
            al == AccessLevelPendinPolling
            ||
            al == AccessLevelPendig
            ||
            al == AccessLevelWaitingAccess);
}

@implementation BackEndFactory

+ (instancetype)sharedInstance
{
    static dispatch_once_t predicate = 0;
    __strong static id instance = nil;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] initForClass:[BackEndProvider class]];
    });
    
    return instance;
}

-(id<BackEndProviderProtocol>)backEndForKey:(NSString *)key
{
    id<BackEndProviderProtocol> retVal = [self.providers objectForKey:key];
#if __EXCEPTIONS
    if (!retVal)
        @throw [NSException exceptionWithName:@"Bad configuration"
                                       reason:[NSString stringWithFormat:@"BackEnd %@ not available", key]
                                     userInfo:nil];
#endif
    return retVal;
}

@end

@class IKRequest;

@implementation BackEndProvider

@synthesize termsAndConditionsApproved;
@synthesize globalLocale;
@synthesize currentLocale;
@synthesize currentAlias;
@synthesize accessLevel;
@synthesize userName;
@synthesize deviceToken;
@synthesize pendingNotification;
@synthesize facebookID;
@synthesize twitterID;
@synthesize socialInfo;
@synthesize isTutorial;
@synthesize logLevel;

-(BOOL)termsAndConditionsApproved
{
    return YES;
}

-(NSString*)editAlias
{
    return nil;
}

-(NSString*)convertText:(NSString*)text
{
    return text;
}

-(void)testSessionId:(SessionIdStateBlock)blk
{
    
}

-(BOOL)sessionIsPresent
{
    return NO;
}

-(void)configure
{
    
}

-(void)registerRequest:(id)request
{
    
}

-(instancetype)factoryInit
{
    self = [super init];
    if (self)
        [self configure];
    return self;
}

-(id)init
{
#if __EXCEPTIONS
    @throw [NSException exceptionWithName:@"Bad usage" reason:@"Init by Factory" userInfo:nil];
#endif
    return nil;
}

-(NSString*)key
{
#if __EXCEPTIONS
    @throw [NSException exceptionWithName:@"Bad usage" reason:@"Override in subclass" userInfo:nil];
#endif
    return @"";
}

-(NSString*)localeIdentifierForLocalization
{
    //   static NSArray* a = nil;
    //   if (!a)
    //      a = [[NSBundle mainBundle] localizations];
    //   NSString* lid = [self.currentLocale localeIdentifier];
    //   for (NSString* l in a)
    //      if ([lid containsString:l])
    //         return l;
    //return [[NSLocale preferredLanguages] objectAtIndex:0];
    
    // FIXME
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString * language=  [languages objectAtIndex:0];
    NSDictionary *languageDic = [NSLocale componentsFromLocaleIdentifier:language];
    NSString *languageCode = [languageDic objectForKey:@"kCFLocaleLanguageCodeKey"];
    

    return languageCode;
}


-(BOOL)cancelRequest:(id)request
{
    return NO;
}

-(BOOL)performRequest:(IKRequest*)request
{
    return [self performRequest:request
                          force:NO
                       onFinish:nil];
}

-(BOOL)performRequest:(IKRequest*)request force:(BOOL)force onFinish:(FinishBlock)finishBlock
{
    return NO;
}

@end

