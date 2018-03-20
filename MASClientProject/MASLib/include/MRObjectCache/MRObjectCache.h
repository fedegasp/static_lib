//
//  ObjectCache.h
//  test
//
//  Created by Federico Gasperini on 24/03/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MRObjectCache : NSObject

+(instancetype)defaultCache;

+(void)putObject:(id)object withTimeToLive:(NSTimeInterval)ttl identifier:(id<NSCopying>)identifier andTags:(NSArray*)tags;
+(void)storeObject:(id)object withIdentifier:(id<NSCopying>)identifier andTags:(NSArray*)tags;
+(id)getObjectWithIdentifier:(id<NSCopying>)identifier;
+(void)invalidateObjectsNotInTags:(NSArray*)tags;
+(void)invalidateObjectsByTags:(NSArray*)tags;
+(void)invalidateObjectsHavingTags:(NSArray*)tags;
+(void)invalidateObjectsByIdentifier:(id<NSCopying>)identifier;

@end
