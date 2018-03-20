//
//  ETRequest.h
//  ikframework
//
//  Created by Giovanni Castiglioni on 09/01/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MRBackEnd/IKRequest.h>
#import "RestKit.h"

@interface IKRequest ()

@property (readonly) BOOL isCachable;

-(NSArray*)invalidatesTags;
-(NSArray*)tags;
-(NSTimeInterval)ttl;

-(BOOL)performCustomWithManager:(id)manager onFinish:(FinishBlock)finishBlock;

-(void)pollingEnd:(id<BackEndProviderProtocol>)requestManager;
-(PollingAction)pollingActionWithResponse:(id)response error:(NSError*)error andPoller:(id)poller;

@property (readonly) NSTimeInterval lifeTime;
@property (readonly) NSTimeInterval nextDelay;
@property (assign) NSTimeInterval maxPollingTime;

-(id)constantResponse;
-(NSMutableURLRequest*)resourceRequest;

@end
