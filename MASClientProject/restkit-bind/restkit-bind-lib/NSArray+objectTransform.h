//
//  NSArray+objectTransform.h
//  restkit-bind
//
//  Created by Federico Gasperini on 04/07/16.
//  Copyright © 2016 Federico Gasperini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (objectTransform)

-(instancetype)objectWithMapping:(NSDictionary*)mapping;

@end
