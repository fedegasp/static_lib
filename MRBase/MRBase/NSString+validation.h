//
//  NSString+URLValidate.h
//  ikframework
//
//  Created by Giovanni Castiglioni on 29/05/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (validation)

-(BOOL)isValidUrl;
-(BOOL)isValidEmail;
-(BOOL)isValidPassword;
-(BOOL)isValidPhoneNumber;

@end
