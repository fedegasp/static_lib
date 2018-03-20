//
//  NSMutableURLRequest+NSURLRequestWithIgnoreSSL.m
//  ikframework
//
//  Created by Giovanni Castiglioni on 14/03/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//


#import "NSURLRequest+NSURLRequestWithIgnoreSSL.h"


#if UNSECURE_SSL

#import "JRSwizzle.h"

#define SECURE_SSL_SWITCH @"SECURE_SSL_SWITCH"

@interface NSURLRequest ()

+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host;

@end


@implementation NSURLRequest (NSURLRequestWithIgnoreSSL)

+(void)load
{
   NSError* error = nil;
   [self jr_swizzleClassMethod:@selector(allowsAnyHTTPSCertificateForHost:)
               withClassMethod:@selector(NSURLRequestWithIgnoreSSL_allowsAnyHTTPSCertificateForHost:)
                         error:&error];
   if (!error) {
      printf("!!!!!!!!    WARNING    !!!!!!!!\n This application will ignore\n any issue with SSL certificates\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
   }
}

+(BOOL)NSURLRequestWithIgnoreSSL_allowsAnyHTTPSCertificateForHost:(NSString *)host
{
   if (![[NSUserDefaults standardUserDefaults] boolForKey:SECURE_SSL_SWITCH])
      return YES;
   
   return [self NSURLRequestWithIgnoreSSL_allowsAnyHTTPSCertificateForHost:host];
}

@end

#endif
