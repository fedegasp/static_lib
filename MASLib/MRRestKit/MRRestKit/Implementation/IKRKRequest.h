//
//  IKRKRequest.h
//  MRRestKit
//
//  Created by Federico Gasperini on 28/10/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import <MRBackEnd/IKRequest.h>
#import "RestKit.h"

@interface IKRKRequest : IKRequest

@property (nonatomic, readonly) RKRoute* route;

+(NSArray<RKRequestDescriptor*>*)requestDescriptors;

-(NSURLRequest*)urlRequest;

@end
