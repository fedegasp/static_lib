//
//  IKRKResponse.h
//  MRRestKit
//
//  Created by Federico Gasperini on 06/12/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import <MRBackEnd/IKResponse.h>
#import "RestKit.h"


@interface IKRKResponse : IKResponse

+(RKMapping*)responseMapping;

@end
