//
//  IKObjectRequestOperation.m
//  iconick-lib
//
//  Created by Federico Gasperini on 11/06/15.
//  Copyright (c) 2015 accenture. All rights reserved.
//

#import "IKObjectRequestOperation.h"

@implementation IKObjectRequestOperation

-(void)start
{
    [self.ikOperationDelegate operationWillStart:self];
    [super start];
}

@end
