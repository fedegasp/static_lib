//
//  IKRequest+token.m
//  restkit-bind
//
//  Created by Federico Gasperini on 24/07/17.
//  Copyright © 2017 Federico Gasperini. All rights reserved.
//

#import "IKRequest+token.h"
#import "Token.h"

@implementation IKRequest (token)

+(instancetype)getToken
{
   return [Token getToken];
}

@end
