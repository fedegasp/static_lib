//
//  ErrorCenter.m
//  ikframework
//
//  Created by Federico Gasperini on 14/02/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import "ErrorCenter.h"
//#import "Reachability.h"
#import "NSError+ikFacility.h"
#import <objc/runtime.h>
#import <MRBase/NSString+formatUtil.h>
#import <MRBase/MRAlertView.h>

NSString* StopErrorCenter = @"StopErrorCenter";
NSString* StartErrorCenter = @"StartErrorCenter";

NSString* UserContextNetworkCheck = @"UserContextNetworkCheck";
NSString* EventType = @"EventType";
NSString* EventTypeLoad = @"EventTypeLoad";
NSString* EventTypeServiceCall = @"EventTypeServiceCall";

NSString* Info = @"Info";
NSString* UnknownError = @"UnknownError";
NSString* ParameterError = @"ParameterError";
NSString* NetworkLack = @"NetworkLack";
NSString* ServerTimeout = @"ServerTimeout";
NSString* HTTPError = @"HTTPError";
NSString* JSONMalformation = @"JSONMalformation";

NSString* VoidSectionError = @"VoidSectionError";
NSString* PollingFailure = @"PollingFailure";

NSString* MessageKey = @"MessageKey";
NSString* FormatParamsKey = @"FormatParamsKey";

NSString* ForceLogout = @"ForceLogout";

void* _error_key_ = &_error_key_;
void* _actions_key_ = &_actions_key_;


#define GENERIC_ERROR_CODE @"00"

#define NUM_SELECTOR PollingFailureErrorType+1

#define SUPPRESS_ALERT self.suppressAlert
#define SESSION_EXPIRED_MAPPING self.sessionExpiredMapping

SEL selectorsDismiss[NUM_SELECTOR];

@interface ErrorCenter () <MRAlertViewDelegate>

@property (atomic, weak) id<NSObject> currentAlert;
-(MRAlertView*)alertWithCode:(NSString*)code tag:(NSInteger)tag andError:(NSError*)error;

@end

id<ErrorUserContext> GetCurrentUserContext(NSError*);

id<ErrorUserContext> GetCurrentUserContext(NSError* error)
{
    return error.errorUserContext;
}

@implementation ErrorCenter
{
    BOOL started;
    BOOL networkOk;
    __strong NSObject* lock;
    //   __strong Reachability* _hostReachability;
}

@synthesize interfaceErrorMapping = ifErrorMapping;
@synthesize interfaceActionsMapping = ifActionsMapping;
@synthesize interfaceNotificationsMapping = ifNotificationsMapping;

-(id)init
{
    self = [super init];
    if (self)
    {
        //      _hostReachability = [Reachability reachabilityForInternetConnection];
        
        lock = [[NSObject alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(start) name:StartErrorCenter object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stop) name:StopErrorCenter object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(start) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stop) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        selectorsDismiss[InfoType]                = @selector(dismissOnPositive);
        selectorsDismiss[UnknownErrorType]        = @selector(dismissOnUnknownError:);
        selectorsDismiss[ParameterErrorType]      = @selector(dismissOnParameterError:);
        selectorsDismiss[NetworkLackType]         = @selector(dismissOnNetworkLack);
        selectorsDismiss[ServerTimeoutType]       = @selector(dismissOnServerTimeout);
        selectorsDismiss[HTTPErrorType]           = @selector(dismissOnHTTPError:);
        selectorsDismiss[JSONMalformationType]    = @selector(dismissOnJSONMalformation:);
        selectorsDismiss[ApplicationErrorType]    = @selector(dismissOnApplicationError:);
        selectorsDismiss[PollingFailureErrorType] = @selector(dismissOnApplicationError:);
    }
    return self;
}

-(void)start
{
    @synchronized(lock)
    {
        if (!started)
        {
            //#warning WEBSERVICE_BASE_URL customizzabile
            //         _hostName = [[NSURL URLWithString:WEBSERVICE_BASE_URL] host];
            //         _hostReachability = [Reachability reachabilityWithHostName:_hostName];
            _hostName = [[NSURL URLWithString:@"https://www.google.com"] host];
            //         _hostReachability = [Reachability reachabilityWithHostName:_hostName];
            //         _hostReachability = [Reachability reachabilityForInternetConnection];
            
            //         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextLoaded:) name:UserContextNetworkCheck object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(info:) name:Info object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unknownError:) name:UnknownError object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(parameterError:) name:ParameterError object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serverTimeout:) name:ServerTimeout object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkLack:) name:NetworkLack object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HTTPError:) name:HTTPError object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JSONMalformation:) name:JSONMalformation object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationError:) name:ApplicationError object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voidSectionError:) name:VoidSectionError object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationError:) name:PollingFailure object:nil];
            
            //         [_hostReachability startNotifier];
            networkOk = YES;
            //         switch (_hostReachability.currentReachabilityStatus)
            //         {
            //            case NotReachable:
            //               networkOk = NO;
            //               break;
            //
            //            case ReachableViaWWAN:
            //               networkOk = YES;
            //               break;
            //
            //            case ReachableViaWiFi:
            //               networkOk = YES;
            //               break;
            //         }
            
            started = YES;
        }
    }
}

-(void)stop
{
    @synchronized(lock)
    {
        if (started)
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(start) name:StartErrorCenter object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stop) name:StopErrorCenter object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(start) name:UIApplicationDidBecomeActiveNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stop) name:UIApplicationDidEnterBackgroundNotification object:nil];
            
            //         [_hostReachability stopNotifier];
            //         _hostReachability = nil;
            started = NO;
        }
    }
}

-(void)dealloc
{
    //   [_hostReachability stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//-(void)reachabilityChanged:(NSNotification*)notification
//{
//   NetworkStatus netStatus = [notification.object currentReachabilityStatus];
//   
//   switch (netStatus)
//   {
//      case NotReachable:
//         networkOk = NO;
//         break;
//         
//      case ReachableViaWWAN:
//         networkOk = YES;
//         break;
//         
//      case ReachableViaWiFi:
//         networkOk = YES;
//         break;
//   }
//   
//   id<ErrorUserContext> userContext = notification.object;
//   if ([userContext respondsToSelector:@selector(setNetworkDown:)])
//      if ([userContext respondsToSelector:@selector(codeForNetworkLack:)])
//         [userContext setNetworkDown:!networkOk];
//}

-(void)contextLoaded:(NSNotification*)notification
{
    if (self.currentAlert) return;
    id<ErrorUserContext> userContext = notification.object;
    if ([userContext respondsToSelector:@selector(setNetworkDown:)])
        [userContext setNetworkDown:!networkOk];
    BOOL handle = NO;
    if ([notification.userInfo[EventType] isEqualToString:EventTypeLoad])
    {
        if ([userContext respondsToSelector:@selector(networkCheckOnLoad)])
        {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                        [[userContext class] instanceMethodSignatureForSelector:@selector(networkCheckOnLoad)]];
            [invocation setSelector:@selector(networkCheckOnLoad)];
            [invocation setTarget:userContext];
            [invocation invoke];
            [invocation getReturnValue:&handle];
        }
    }
    else if ([notification.userInfo[EventType] isEqualToString:EventTypeServiceCall])
    {
        if ([userContext respondsToSelector:@selector(networkCheckOnEvent)])
        {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                        [[userContext class] instanceMethodSignatureForSelector:@selector(networkCheckOnEvent)]];
            [invocation setSelector:@selector(networkCheckOnEvent)];
            [invocation setTarget:userContext];
            [invocation invoke];
            [invocation getReturnValue:&handle];
        }
    }
    if (handle)
        [self handleNetworkLack:userContext onEvent:notification.userInfo[EventType]];
}

-(MRAlertView*)alertWithCode:(NSString*)code tag:(NSInteger)tag andError:(NSError*)error
{
    NSString* titleKey = [NSString stringWithFormat:TITLE_CODE_FORMAT, code];
    NSString* msgKey = [NSString stringWithFormat:MESSAGE_CODE_FORMAT, code];
    
    NSString* title = NSLocalizedStringFromTable(titleKey, ERROR_TABLE, nil);
    if ([title isEqualToString:titleKey])
        title = @"";
    
    NSMutableString* message = [[NSMutableString alloc] initWithString:NSLocalizedStringFromTable(msgKey, ERROR_TABLE, nil)];
    if ([message isEqualToString:msgKey])
        message = [[NSMutableString alloc] initWithString:NSLocalizedStringFromTable(@"MSG_002", ERROR_TABLE, nil)];;
    
    if (self.showDebugInfo && self.showDebugInfo())
        [message appendFormat:@"\n\n%@",[error description]];
    
    if ([self.errorCenterDelegate respondsToSelector:@selector(showMessage:withTitle:tag:andError:)])
    {
        [self.errorCenterDelegate showMessage:message
                                    withTitle:ALERT_EMPTY_TITLE(title)
                                          tag:tag
                                     andError:error];
    }
    else
    {
        MRAlertView* alert = [[MRAlertView alloc] initWithTitle:ALERT_EMPTY_TITLE(title)
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"Close", @"close alert")
                                              otherButtonTitles:nil];
        alert.tag = tag;
        alert.error = error;
        
        return alert;
    }
    return nil;
}

-(void)handleNetworkLack:(id<ErrorUserContext>)userContext onEvent:(NSString*)eventType
{
    if (self.currentAlert) return;
    
    if ([userContext respondsToSelector:@selector(setNetworkDown:)])
    {
        if ([userContext respondsToSelector:@selector(codeForNetworkLack:)])
        {
            [userContext setNetworkDown:!networkOk];
            if (!networkOk)
            {
                NSString* code = [userContext codeForNetworkLack:eventType];
                
                if (!code)
                    return;
                
                MRAlertView* alert = [self alertWithCode:code tag:NetworkLackType andError:nil];
                self.currentAlert = alert;
                
                if ([userContext respondsToSelector:@selector(alert:forError:)])
                    [userContext alert:alert forError:nil];
                else
                    alert.delegate = self;
                [alert show];
                if (alert.delegate != self)
                    self.currentAlert = nil;
            }
        }
    }
}

-(void)info:(NSNotification*)notification
{
    if (self.currentAlert || !GetCurrentUserContext(notification.userInfo[ErrorKey])) return;
    
    
    NSError* error = notification.userInfo[ErrorKey];
    id<ErrorUserContext> userContext = GetCurrentUserContext(error);
    
    if ([userContext respondsToSelector:@selector(shouldShowPositiveMessage)])
    {
        if ([userContext shouldShowPositiveMessage])
        {
            if ([userContext respondsToSelector:@selector(codeForPositiveMessage)])
            {
                NSString* code = [userContext codeForPositiveMessage];
                
                MRAlertView* alert = [self alertWithCode:code
                                                     tag:InfoType
                                                andError:notification.userInfo[ErrorKey]];
                self.currentAlert = alert;
                
                if ([userContext respondsToSelector:@selector(infoAlert:forError:)])
                    [userContext infoAlert:alert forError:nil];
                else
                    alert.delegate = self;
                
                [alert show];
                if (alert.delegate != self)
                    self.currentAlert = nil;
                
            }
            else if (error)
            {
                MRAlertView* alert = [[MRAlertView alloc] initWithTitle:ALERT_EMPTY_TITLE(nil)
                                                                message:error.localizedDescription
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"Close", @"close alert")
                                                      otherButtonTitles:nil];
                alert.error = notification.userInfo[ErrorKey];
                self.currentAlert = alert;
                alert.tag = InfoType;
                
                if ([userContext respondsToSelector:@selector(infoAlert:forError:)])
                    [userContext infoAlert:alert forError:error];
                else
                    alert.delegate = self;
                
                
                [alert show];
                if (alert.delegate != self)
                    self.currentAlert = nil;
                
            }
        }
    }
}

-(void)unknownError:(NSNotification*)notification
{
    if (self.currentAlert || !GetCurrentUserContext(notification.userInfo[ErrorKey])) return;
    
    NSError* error = notification.userInfo[ErrorKey];
    NSString* code = GENERIC_ERROR_CODE;
    id<ErrorUserContext> userContext = GetCurrentUserContext(error);
    if ([userContext respondsToSelector:@selector(codeForUnknownError:)])
        code = [userContext codeForUnknownError:error];
    
    MRAlertView* alert = [self alertWithCode:code
                                         tag:UnknownErrorType
                                    andError:error];
    self.currentAlert = alert;
    
    if ([userContext respondsToSelector:@selector(alert:forError:)])
        [userContext alert:alert forError:nil];
    else
        alert.delegate = self;
    [alert show];
    if (alert.delegate != self)
        self.currentAlert = nil;
    
}

-(void)parameterError:(NSNotification*)notification
{
    if (self.currentAlert || !GetCurrentUserContext(notification.userInfo[ErrorKey])) return;
    
    NSError* error = notification.userInfo[ErrorKey];
    NSString* code = nil;
    NSString* msg = nil;
    NSString* title = nil;
    NSString* titleKey = nil;
    id<ErrorUserContext> userContext = GetCurrentUserContext(error);
    if ([userContext respondsToSelector:@selector(codeForParameterError:)])
        code = [userContext codeForParameterError:error];
    if (!code.length)
    {
        code = [NSString stringWithFormat:@"%03ld", (long)error.code];
        titleKey = [NSString stringWithFormat:TITLE_CODE_FORMAT, code];
        msg = error.localizedDescription;
        if (!msg.length)
        {
            NSString* msgKey = [NSString stringWithFormat:MESSAGE_CODE_FORMAT, code];
            msg = NSLocalizedStringFromTable(msgKey, ERROR_TABLE, nil);
        }
    }
    else
    {
        NSString* msgKey = [NSString stringWithFormat:MESSAGE_CODE_FORMAT, code];
        msg = NSLocalizedStringFromTable(msgKey, ERROR_TABLE, nil);
        titleKey = [NSString stringWithFormat:TITLE_CODE_FORMAT, code];
    }
    
    title = NSLocalizedStringFromTable(titleKey, ERROR_TABLE, nil);
    
    MRAlertView* alert = [[MRAlertView alloc] initWithTitle:ALERT_EMPTY_TITLE(title)
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"Close", @"close alert")
                                          otherButtonTitles:nil];
    alert.error = error;
    self.currentAlert = alert;
    
    alert.tag = ParameterErrorType;
    if ([userContext respondsToSelector:@selector(alert:forError:)])
        [userContext alert:alert forError:error];
    
    [alert show];
    if (alert.delegate != self)
        self.currentAlert = nil;
    
}

-(void)networkLack:(NSNotification*)notification
{
    if (self.currentAlert || !GetCurrentUserContext(notification.userInfo[ErrorKey])) return;
    
    NSString* code = @"001";
    NSError* error = notification.userInfo[ErrorKey];
    id<ErrorUserContext> userContext = GetCurrentUserContext(error);
    if ([userContext respondsToSelector:@selector(codeForNetworkLack:)])
        code = [userContext codeForNetworkLack:EventTypeServiceCall];//notification.userInfo[ErrorKey]];
    
    if (!code)
        return;
    if ([code isEqualToString:SUPPRESS_ALERT])
        return;
    
    MRAlertView* alert = [self alertWithCode:code
                                         tag:NetworkLackType
                                    andError:error];
    self.currentAlert = alert;
    
    if ([userContext respondsToSelector:@selector(alert:forError:)])
        [userContext alert:alert forError:nil];
    else if (notification.object == userContext)
        alert.delegate = self;
    [alert show];
    if (alert.delegate != self)
        self.currentAlert = nil;
}

-(void)serverTimeout:(NSNotification*)notification
{
    if (self.currentAlert || !GetCurrentUserContext(notification.userInfo[ErrorKey])) return;
    
    NSString* code = nil;
    NSError* error = notification.userInfo[ErrorKey];
    id<ErrorUserContext> userContext = GetCurrentUserContext(error);
    if ([userContext respondsToSelector:@selector(codeForServerTimeout:)])
        code = [userContext codeForServerTimeout:notification.userInfo[ErrorKey]];
    
    if ([code isEqualToString:SUPPRESS_ALERT])
        return;
    
    if (!code)
        code = @"002";
    
    MRAlertView* alert = [self alertWithCode:code
                                         tag:ServerTimeoutType
                                    andError:error];
    self.currentAlert = alert;
    
    if ([userContext respondsToSelector:@selector(alert:forError:)])
        [userContext alert:alert forError:nil];
    else
        alert.delegate = self;
    [alert show];
    if (alert.delegate != self)
        self.currentAlert = nil;
    
}

-(void)HTTPError:(NSNotification*)notification
{
    if (self.currentAlert || !GetCurrentUserContext(notification.userInfo[ErrorKey])) return;
    
    NSString* code = nil;
    NSError* error = notification.userInfo[ErrorKey];
    id<ErrorUserContext> userContext = GetCurrentUserContext(error);
    if ([userContext respondsToSelector:@selector(codeForHTTPError:)])
        code = [userContext codeForHTTPError:notification.userInfo[ErrorKey]];
    
    //   if (!code)
    //      return;
    
    if ([code isEqualToString:SUPPRESS_ALERT])
        return;
    
    MRAlertView* alert = [self alertWithCode:code
                                         tag:HTTPErrorType
                                    andError:notification.userInfo[ErrorKey]];
    self.currentAlert = alert;
    
    if ([userContext respondsToSelector:@selector(alert:forError:)])
        [userContext alert:alert forError:nil];
    else
        alert.delegate = self;
    [alert show];
    if (alert.delegate != self)
        self.currentAlert = nil;
    
}

-(void)JSONMalformation:(NSNotification*)notification 
{
    if (self.currentAlert || !GetCurrentUserContext(notification.userInfo[ErrorKey])) return;
    
    NSString* code = nil;
    NSError* error = notification.userInfo[ErrorKey];
    id<ErrorUserContext> userContext = GetCurrentUserContext(error);
    if ([userContext respondsToSelector:@selector(codeForJSONMalformation:)])
        code = [userContext codeForJSONMalformation:error];
    
    if (!code)
        return;
    
    if ([code isEqualToString:SUPPRESS_ALERT])
        return;
    
    
    MRAlertView* alert = [self alertWithCode:code
                                         tag:JSONMalformationType
                                    andError:error];
    self.currentAlert = alert;
    
    if ([userContext respondsToSelector:@selector(alert:forError:)])
        [userContext alert:alert forError:nil];
    else
        alert.delegate = self;
    [alert show];
    if (alert.delegate != self)
        self.currentAlert = nil;
}

-(void)applicationError:(NSNotification*)notification
{
    if (self.currentAlert || !GetCurrentUserContext(notification.userInfo[ErrorKey])) return;
    
    NSError* error = notification.userInfo[ErrorKey];
    NSString* code = nil;
    id<ErrorUserContext> userContext = GetCurrentUserContext(error);
    if ([userContext respondsToSelector:@selector(codeForApplicationError:)])
        code = [userContext codeForApplicationError:notification.userInfo[ErrorKey]];
    if (code == nil)
        code = ifErrorMapping[error.domain];
    
    if (code == nil) // && error.codeSameAsDomain)
        code = error.domain;
    
    if ([code isEqualToString:SUPPRESS_ALERT])
        return;
    
    if ([code isEqualToString:SESSION_EXPIRED_MAPPING])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:ForceLogout object:nil];
        });
        return;
    }
    
    // giovedì 20 marzo su richiesta del backend
    if (!code && !self.useErrorDescription)
        code = GENERIC_ERROR_CODE;
    
    NSString* title = nil;
    NSString* msg = nil;
    NSString* message = nil;
    
    if (code)
    {
        NSString* titleKey = [NSString stringWithFormat:TITLE_CODE_FORMAT, code];
        NSString* msgKey = [NSString stringWithFormat:MESSAGE_CODE_FORMAT, code];
        
        title = NSLocalizedStringFromTable(titleKey, ERROR_TABLE, nil);
        message = NSLocalizedStringFromTable(msgKey, ERROR_TABLE, nil);
        msg = [NSString stringWithFormat:message
                            andArguments:notification.userInfo[FormatParamsKey]];
    }
    
    if (![msg length])
        msg = error.localizedDescription;
    //   if (!title)
    //      title = NSLocalizedString(@"Error", @"error alert title");
    
    NSMutableArray* actions = nil;
    NSArray* acts = ifActionsMapping[error.domain];
    
    if (acts)
    {
        actions = [[NSMutableArray alloc] initWithCapacity:acts.count];
        for (NSString* actCode in acts)
            [actions addObject:NSLocalizedStringFromTable(actCode, ERROR_TABLE, nil)];
    }
    
    if (self.showDebugInfo && self.showDebugInfo())
        msg = [msg stringByAppendingFormat:@"\n\n%@",[error description]];
    
    if ([self.errorCenterDelegate respondsToSelector:@selector(showMessage:withTitle:tag:andError:)])
    {
        [self alertWithCode:code
                        tag:ApplicationErrorType
                   andError:error];
    }
    else
    {
        MRAlertView* alert = nil;
        if (actions.count)
        {
            alert = [[MRAlertView alloc] initWithTitle:ALERT_EMPTY_TITLE(title)
                                               message:msg
                                              delegate:nil
                                     cancelButtonTitle:nil
                                     otherButtonTitles:nil];
            for (NSString* s in actions)
                [alert addButtonWithTitle:s];
            alert.error = notification.userInfo[ErrorKey];
            self.currentAlert = alert;
            
            alert.tag = ApplicationErrorChoice;
            alert.actionTitles = acts;
            alert.delegate = self;
        }
        else
        {
            alert = [[MRAlertView alloc] initWithTitle:ALERT_EMPTY_TITLE(title)
                                               message:msg
                                              delegate:nil
                                     cancelButtonTitle:NSLocalizedString(@"Close", @"close alert")
                                     otherButtonTitles:nil];
            alert.error = notification.userInfo[ErrorKey];
            self.currentAlert = alert;
            
            alert.tag = ApplicationErrorType;
            if ([userContext respondsToSelector:@selector(alert:forError:)])
                [userContext alert:alert forError:error];
            else
                alert.delegate = self;
        }
        [alert show];
        if (alert.delegate != self)
            self.currentAlert = nil;
    }
}

-(void)voidSectionError:(NSNotification*)notification
{
    if (self.currentAlert || !GetCurrentUserContext(notification.userInfo[ErrorKey])) return;
    
    NSError* error = notification.userInfo[ErrorKey];
    NSString* code = nil;
    id<ErrorUserContext> userContext = GetCurrentUserContext(error);
    if ([userContext respondsToSelector:@selector(codeForVoidSectionError:)])
        code = [userContext codeForVoidSectionError:notification.userInfo[ErrorKey]];
    if (code == nil)
        code = ifErrorMapping[error.domain];
    
    if (code == nil && error.codeSameAsDomain)
        code = error.domain;
    
    if ([code isEqualToString:SUPPRESS_ALERT])
        return;
    
    // giovedì 20 marzo su richiesta del backend
    if (!code && !self.useErrorDescription)
        code = GENERIC_ERROR_CODE;
    
    NSString* title = nil;
    NSString* msg = nil;
    NSString* message = nil;
    
    if (code)
    {
        NSString* titleKey = [NSString stringWithFormat:TITLE_CODE_FORMAT, code];
        NSString* msgKey = [NSString stringWithFormat:MESSAGE_CODE_FORMAT, code];
        
        title = NSLocalizedStringFromTable(titleKey, ERROR_TABLE, nil);
        message = NSLocalizedStringFromTable(msgKey, ERROR_TABLE, nil);
        msg = [NSString stringWithFormat:message
                            andArguments:notification.userInfo[FormatParamsKey]];
    }
    
    if (![msg length])
        msg = error.localizedDescription;
    //   if (!title)
    //      title = NSLocalizedString(@"Error", @"error alert title");
    
    MRAlertView* alert = nil;
    alert = [[MRAlertView alloc] initWithTitle:ALERT_EMPTY_TITLE(title)
                                       message:msg
                                      delegate:self
                             cancelButtonTitle:NSLocalizedString(VOID_ACCESS_ACTION_CONTINUE, @"close alert")
                             otherButtonTitles:NSLocalizedString(VOID_ACCESS_ACTION_LOGIN, @"goto registration"),nil];
    alert.error = notification.userInfo[ErrorKey];
    self.currentAlert = alert;
    alert.tag = VoidSectionErrorType;
    [alert show];
}

-(void)alertView:(MRAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    id<ErrorUserContext> userContext = GetCurrentUserContext(alertView.error);
    if (alertView.tag == ApplicationErrorChoice)
    {
        if (userContext && [userContext respondsToSelector:@selector(userChoose:)])
            [userContext userChoose:alertView.actionTitles[buttonIndex]];
    }
    else if (alertView.tag == VoidSectionErrorType)
    {
        if (userContext && [userContext respondsToSelector:@selector(voidAccessAction:)])
            [userContext voidAccessAction:alertView.cancelButtonIndex == buttonIndex ?
              VOID_ACCESS_ACTION_CONTINUE:
             VOID_ACCESS_ACTION_LOGIN];
    }
    else if (userContext && [userContext respondsToSelector:@selector(navigationController)])
    {
        SEL selector = selectorsDismiss[alertView.tag];
        BOOL dismiss = NO;
        BOOL respondsToDismissOnError = [userContext respondsToSelector:selector];
        
        if (respondsToDismissOnError)
        {
            NSMethodSignature* ms = [[userContext class] instanceMethodSignatureForSelector:selector];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:ms];
            [invocation setSelector:selector];
            [invocation setTarget:userContext];
            if ([ms numberOfArguments] > 2)
            {
                NSError* error = alertView.error;
                [invocation setArgument:&error atIndex:2];
            }
            [invocation invoke];
            [invocation getReturnValue:&dismiss];
        }
        else
        {
            SEL selector = @selector(dismissOnAllErrors);
            if ([userContext respondsToSelector:selector])
            {
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                            [[userContext class] instanceMethodSignatureForSelector:selector]];
                [invocation setSelector:selector];
                [invocation setTarget:userContext];
                [invocation invoke];
                [invocation getReturnValue:&dismiss];
            }
        }
        
        if (dismiss)
            [[userContext navigationController] popViewControllerAnimated:YES];
        
        NSString* errorDomain = alertView.error.domain;
        if (errorDomain)
        {
            NSArray* notifications = ifNotificationsMapping[errorDomain];
            for (NSDictionary* n in notifications)
                for (NSString* notification in n.allKeys)
                    [[NSNotificationCenter defaultCenter] postNotificationName:notification
                                                                        object:self
                                                                      userInfo:n[notification]];
        }
    }
    self.currentAlert = nil;
}

@end
