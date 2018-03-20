//
//  NSError+appFacility.m
//  ikframework
//
//  Created by Federico Gasperini on 18/07/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import "NSError+ikFacility.h"
#import <MRBase/MRWeakWrapper.h>

#import <objc/runtime.h>

NSString* ApplicationError = @"ApplicationError";
NSString* ErrorKey = @"ErrorKey";

NSString* const GenericError = @"00";
NSString* const VoidSection = @"999";
NSString* const GuestSection = @"99999";

@implementation NSError (ikFacility)
static const void* _domain_is_code_ = &_domain_is_code_;

-(void)setCodeSameAsDomain:(BOOL)codeSameAsDomain
{
   objc_setAssociatedObject(self, _domain_is_code_, @(codeSameAsDomain), OBJC_ASSOCIATION_RETAIN);
}

-(BOOL)codeSameAsDomain
{
   return [objc_getAssociatedObject(self, _domain_is_code_) boolValue];
}

//+(void)postErrorGuestHomepage:(id)sender
//{
//   [[NSNotificationCenter defaultCenter] postNotificationName:VoidSectionError
//                                                       object:sender
//                                                     userInfo:@{ErrorKey:[NSError errorGuestSection]}];
//}
//
//+(NSError*)errorGuestSection
//{
//   NSError* err = [[NSError alloc] initWithDomain:GuestSection
//                                             code:99999
//                                         userInfo:nil];
//   err.codeSameAsDomain = YES;
//   return err;
//}

-(void)setErrorUserContext:(id)errorUserContext
{
   MRWeakWrapper* ww = [[MRWeakWrapper alloc] initWithObject:errorUserContext];
   objc_setAssociatedObject(self, @selector(errorUserContext), ww, OBJC_ASSOCIATION_RETAIN);
}

-(id)errorUserContext
{
   MRWeakWrapper* ww = objc_getAssociatedObject(self, @selector(errorUserContext));
   return ww.object;
}

//+(void)postErrorVoidSection:(id)sender
//{
//   [[NSNotificationCenter defaultCenter] postNotificationName:VoidSectionError
//                                                       object:sender
//                                                     userInfo:@{ErrorKey:[NSError errorGuestSection]}];
//}

+(NSError*)errorVoidSection
{
   NSError* err = [[NSError alloc] initWithDomain:VoidSection
                                             code:999
                                         userInfo:nil];
   err.codeSameAsDomain = YES;
   return err;
}

-(BOOL)isVoidSection
{
   return [self.domain isEqualToString:VoidSection];
}

+(void)postGenericErrorWithSender:(id)sender
{
   [[NSNotificationCenter defaultCenter] postNotificationName:ApplicationError
                                                       object:sender
                                                     userInfo:@{ErrorKey:[NSError errorGeneric]}];
}

+(NSError*)errorGeneric
{
   NSError* err = [[NSError alloc] initWithDomain:GenericError
                                             code:[GenericError integerValue]
                                         userInfo:nil];
   err.codeSameAsDomain = YES;
   return err;
}

-(BOOL)isGenericError
{
   return [self.domain isEqualToString:GenericError];
}

@end
