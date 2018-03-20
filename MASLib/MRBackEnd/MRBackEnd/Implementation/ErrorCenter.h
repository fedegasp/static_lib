//
//  ErrorCenter.h
//  ikframework
//
//  Created by Federico Gasperini on 14/02/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//


#import <UIKit/UIKit.h>

extern NSString* StopErrorCenter;
extern NSString* StartErrorCenter;

extern NSString* UserContextNetworkCheck;
extern NSString* EventType;
extern NSString* EventTypeLoad;
extern NSString* EventTypeServiceCall;

extern NSString* Info;
extern NSString* UnknownError;
extern NSString* ParameterError;
extern NSString* NetworkLack;
extern NSString* ServerTimeout;
extern NSString* HTTPError;
extern NSString* JSONMalformation;
extern NSString* ApplicationError;
extern NSString* VoidSectionError;
extern NSString* PollingFailure;
extern NSString* ErrorKey;
extern NSString* MessageKey;
extern NSString* FormatParamsKey;

extern NSString* ForceLogout;

@class MRAlertView;

//// errorManager defines
#import "IKEnvironment.h"
//#ifndef TABLE
//#define TABLE(X) [NSString stringWithFormat:@"%@.lproj/%@", [BackEnd() localeIdentifierForLocalization], (X)]
//#endif
#define ERROR_TABLE @"ErrorTable" 
//TABLE(@"ErrorTable")

#define ALERT_EMPTY_TITLE(x) (x && [(id)x length]) ? (x) : @" "

#define TITLE_CODE_FORMAT @"TITLE_%@"
#define MESSAGE_CODE_FORMAT @"MSG_%@"

#define VOID_ACCESS_ACTION_LOGIN    @"VOID_ACCESS_ACTION_LOGIN"
#define VOID_ACCESS_ACTION_CONTINUE @"VOID_ACCESS_ACTION_CONTINUE"

typedef NS_ENUM(NSInteger, ErrorType)
{
	InfoType,
   UnknownErrorType,
   ParameterErrorType,
   NetworkLackType,
   ServerTimeoutType,
   HTTPErrorType,
   JSONMalformationType,
   ApplicationErrorType,
   PollingFailureErrorType,
   ApplicationErrorChoice,
   VoidSectionErrorType
};

@protocol ErrorUserContext <NSObject>

@optional

-(void)setNetworkDown:(BOOL)down;
-(BOOL)networkDown;

-(NSString*)codeForUnknownError:(NSError*)error;
-(NSString*)codeForParameterError:(NSError*)error;

-(BOOL)networkCheckOnLoad;
-(BOOL)networkCheckOnEvent;
-(NSString*)codeForNetworkLack:(NSString*)eventType;

-(NSString*)codeForServerTimeout:(NSError*)error;
-(NSString*)codeForHTTPError:(NSError*)error;
-(NSString*)codeForApplicationError:(NSError*)error;
-(NSString*)codeForVoidSectionError:(NSError*)error;
-(NSString*)codeForJSONMalformation:(NSError*)error;

-(void)alert:(MRAlertView*)alert forError:(NSError*)error;
-(void)infoAlert:(MRAlertView*)alert forError:(NSError*)error;

-(BOOL)shouldShowPositiveMessage;
-(NSString*)codeForPositiveMessage;

-(BOOL)dismissOnAllErrors;

-(BOOL)dismissOnPositive;
-(BOOL)dismissOnUnknownError:(NSError*)error;
-(BOOL)dismissOnParameterError:(NSError*)error;
-(BOOL)dismissOnNetworkLack;
-(BOOL)dismissOnServerTimeout;
-(BOOL)dismissOnHTTPError:(NSError*)error;
-(BOOL)dismissOnJSONMalformation:(NSError*)error;
-(BOOL)dismissOnApplicationError:(NSError*)error;

-(UINavigationController*)navigationController;

-(void)userChoose:(NSString*)choice;
-(void)voidAccessAction:(NSString*)choice;

@end



@class ErrorCenter;

@protocol ErrorCenterDelegate <NSObject>

@optional
-(id)showMessage:(NSString*)message withTitle:(NSString*)title tag:(NSInteger)tag andError:(NSError*)error;

@end



@interface ErrorCenter : NSObject

@property (weak, nonatomic) id<ErrorCenterDelegate> errorCenterDelegate;

@property (strong, nonatomic) NSDictionary* interfaceErrorMapping;
@property (strong, nonatomic) NSDictionary* interfaceActionsMapping;
@property (strong, nonatomic) NSDictionary* interfaceNotificationsMapping;

@property (strong, nonatomic) NSString* suppressAlert;
@property (strong, nonatomic) NSString* sessionExpiredMapping;
@property (assign, nonatomic) BOOL useErrorDescription;
@property (strong, nonatomic) NSString* hostName;

@property (copy, nonatomic) BOOL (^showDebugInfo)(void);

@end
