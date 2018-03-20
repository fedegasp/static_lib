//
//  MRWeakWrapper.h
//  iconick-lib
//
//  Created by Federico Gasperini on 14/04/16.
//  Copyright © 2016 accenture. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRWeakWrapper<__covariant ObjectType> : NSObject

+(instancetype)weakWrapperWithObject:(__kindof ObjectType)object;
-(instancetype)initWithObject:(__kindof ObjectType)object;
@property (readonly) ObjectType object;

@end
