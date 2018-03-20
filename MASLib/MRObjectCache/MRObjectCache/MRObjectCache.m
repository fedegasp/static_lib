//
//  ObjectCache.m
//  test
//
//  Created by Federico Gasperini on 24/03/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import "MRObjectCache.h"
#import "CacheInterface.h"

__strong id<CacheInterface> _defaultCache = nil;


void SetDefaultCache(id<CacheInterface> cacheImplInstance)
{
   _defaultCache = cacheImplInstance;
}


@implementation MRObjectCache


+(instancetype)defaultCache
{
   return _defaultCache;
}

+(void)putObject:(id)object withTimeToLive:(NSTimeInterval)ttl identifier:(id<NSCopying>)identifier andTags:(NSArray*)tags
{
   [[self.class defaultCache] putObject:object
                         withTimeToLive:ttl
                             identifier:identifier
                                andTags:tags];
}

+(void)storeObject:(id)object withIdentifier:(id<NSCopying>)identifier andTags:(NSArray*)tags
{
   [[self.class defaultCache] storeObject:object
                           withIdentifier:identifier
                                  andTags:tags];
}

+(id)getObjectWithIdentifier:(id<NSCopying>)identifier
{
   NSLog(@"Cache request: %@", identifier);
   return [[self.class defaultCache] getObjectWithIdentifier:identifier];
}

+(void)invalidateObjectsNotInTags:(NSArray<NSString*>*)tags
{
   [[self.class defaultCache] invalidateObjectsNotInTags:tags];
}

+(void)invalidateObjectsByTags:(NSArray*)tags
{
   [[self.class defaultCache] invalidateObjectsByTags:tags];
}

+(void)invalidateObjectsHavingTags:(NSArray*)tags
{
   [[self.class defaultCache] invalidateObjectsHavingTags:tags];
}

+(void)invalidateObjectsByIdentifier:(id<NSCopying>)identifier
{
   [[self.class defaultCache] invalidateObjectsByIdentifier:identifier];
}

@end

