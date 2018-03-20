//
//  NSError+appFacility.h
//  ikframework
//
//  Created by Federico Gasperini on 18/07/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* ApplicationError;
extern NSString* ErrorKey;

@interface NSError (ikFacility)

@property (readwrite) BOOL codeSameAsDomain;

@property (weak, nonatomic) id errorUserContext;

//+(void)postErrorGuestHomepage:(id)sender;
//+(void)postErrorVoidSection:(id)sender;
//+(NSError*)errorVoidSection;
//-(BOOL)isVoidSection;

+(void)postGenericErrorWithSender:(id)sender;
+(NSError*)errorGeneric;
-(BOOL)isGenericError;

@end
