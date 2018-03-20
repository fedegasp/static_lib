//
//  IKObjectRequestOperation.h
//  iconick-lib
//
//  Created by Federico Gasperini on 11/06/15.
//  Copyright (c) 2015 accenture. All rights reserved.
//

#import "RestKit.h"

@class IKObjectRequestOperation;

@protocol IKObjectRequestOperationDelegate <NSObject>

-(void)operationWillStart:(IKObjectRequestOperation*)operation;

@end

@interface IKObjectRequestOperation : RKObjectRequestOperation

@property (weak) id<IKObjectRequestOperationDelegate> ikOperationDelegate;

@end
