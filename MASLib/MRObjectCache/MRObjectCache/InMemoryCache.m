//
//  InMemoryCache.m
//  iconick-lib
//
//  Created by Federico Gasperini on 07/04/16.
//  Copyright © 2016 accenture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "InMemoryCache.h"


NSString* EvictNotification = @"EvictNotification";
NSString* EvictIfAnyOfTagsNotification = @"EvictIfAnyOfTagsNotification";
NSString* EvictIfAllTagsNotification = @"EvictIfAllTagsNotification";
NSString* EvictIfNotInTagsNotification = @"EvictIfNotInTagsNotification";

@interface ObjectWrapper : NSObject

+(instancetype)objectWrapperForObject:(id)object withIdentifier:(id<NSCopying>)identifier timeToLive:(NSTimeInterval)ttl andTags:(NSSet*)tags objectCache:(id<CacheInterface>)oc;

-(instancetype)initWithObject:(id)object identifier:(id<NSCopying>)identifier timeToLive:(NSTimeInterval)ttl andTags:(NSSet*)tags objectCache:(id<CacheInterface>)oc;

@property (strong, nonatomic) NSSet* tags;
@property (strong, nonatomic) id identifier;
@property (assign) NSTimeInterval ttl;
@property (strong, nonatomic) id object;

@property (readwrite, nonatomic) id selfRetainer;

@end


@implementation InMemoryCache
{
   __strong NSMapTable* _cacheTable;
}

-(instancetype) init
{
   self = [super init];
   if (self)
      _cacheTable = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory
                                              valueOptions:NSMapTableWeakMemory
                                                  capacity:100];
   return self;
}

-(void)putObject:(id)object withTimeToLive:(NSTimeInterval)ttl identifier:(id<NSCopying>)identifier andTags:(NSArray*)tags
{
   [self invalidateObjectsByIdentifier:identifier];
   ObjectWrapper* ow = [ObjectWrapper objectWrapperForObject:object
                                              withIdentifier:[identifier copyWithZone:NULL]
                                                  timeToLive:ttl
                                                     andTags:[NSSet setWithArray:tags]
                                                 objectCache:self];
   [_cacheTable setObject:ow forKey:identifier];
}

-(void)storeObject:(id)object withIdentifier:(id<NSCopying>)identifier andTags:(NSArray*)tags
{
   [self invalidateObjectsByIdentifier:identifier];
   ObjectWrapper* ow = [ObjectWrapper objectWrapperForObject:object
                                              withIdentifier:[identifier copyWithZone:NULL]
                                                  timeToLive:0
                                                     andTags:[NSSet setWithArray:tags]
                                                 objectCache:self];
   [_cacheTable setObject:ow forKey:identifier];
}

-(id)getObjectWithIdentifier:(id<NSCopying>)identifier
{
   return [[_cacheTable objectForKey:identifier] object];
}

-(void)invalidateObjectsByTags:(NSArray*)tags
{
   if (tags)
      [[NSNotificationCenter defaultCenter] postNotificationName:EvictIfAnyOfTagsNotification
                                                          object:self
                                                        userInfo:@{@"tags":tags}];
}

-(void)invalidateObjectsHavingTags:(NSArray*)tags
{
   if (tags)
      [[NSNotificationCenter defaultCenter] postNotificationName:EvictIfAllTagsNotification
                                                          object:self
                                                        userInfo:@{@"tags":tags}];
}

-(void)invalidateObjectsNotInTags:(NSArray<NSString*>*)tags
{
   if (tags.count)
      [[NSNotificationCenter defaultCenter] postNotificationName:EvictIfNotInTagsNotification
                                                          object:self
                                                        userInfo:@{@"tags":tags}];
}

-(void)invalidateObjectsByIdentifier:(id<NSCopying>)identifier
{
   if (identifier)
      [[NSNotificationCenter defaultCenter] postNotificationName:EvictNotification
                                                          object:self
                                                        userInfo:@{@"identifier":identifier}];
}

@end


@implementation ObjectWrapper
{
   __strong id _selfRetainer;
   NSTimeInterval _timestamp;
}

-(void)setSelfRetainer:(id)selfRetainer
{
   _selfRetainer = selfRetainer;
}

-(id)selfRetainer
{
   return _selfRetainer;
}

+(instancetype)objectWrapperForObject:(id)object
                       withIdentifier:(id<NSCopying>)identifier
                           timeToLive:(NSTimeInterval)ttl
                              andTags:(NSSet*)tags
                          objectCache:(id<CacheInterface>)oc
{
   return [[self.class alloc] initWithObject:object
                                  identifier:identifier
                                  timeToLive:ttl
                                     andTags:tags
                                 objectCache:oc];
}

-(instancetype)initWithObject:(id)object
                   identifier:(id<NSCopying>)identifier
                   timeToLive:(NSTimeInterval)ttl
                      andTags:(NSSet*)tags
                  objectCache:(id<CacheInterface>)oc
{
   self = [super init];
   if (self)
   {
      _object = object;
      _identifier = identifier;
      _ttl = ttl;
      _tags = tags;
      
      _selfRetainer = self;
      
      _timestamp = [NSDate timeIntervalSinceReferenceDate];
      
      __weak typeof(self) _self = self;
      
      if (ttl > 0)
      {
         double delayInSeconds = ttl;
         dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
         dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            _self.selfRetainer = nil;
         });
      }
      
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(testTimestamp:)
                                                   name:UIApplicationDidBecomeActiveNotification
                                                 object:nil];
      
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(evictIfAllTagsNotification:)
                                                   name:EvictIfAllTagsNotification
                                                 object:oc];
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(evictIfAnyOfTagsNotification:)
                                                   name:EvictIfAnyOfTagsNotification
                                                 object:oc];
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(evictIfNotInTagsNotification:)
                                                   name:EvictIfNotInTagsNotification
                                                 object:oc];
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(evictNotification:)
                                                   name:EvictNotification
                                                 object:oc];
   }
   return self;
}

-(void)testTimestamp:(NSNotification*)notification
{
   if (self.ttl > .0)
   {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
      id _tempSelf = self;
#pragma clang diagnostic pop
      
      NSTimeInterval delta = [NSDate timeIntervalSinceReferenceDate] - (_timestamp + self.ttl);
      if (delta >= 0)
         _selfRetainer = nil;
      else
      {
         __weak typeof(self) _self = self;
         double delayInSeconds = -delta;
         dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
         dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            _self.selfRetainer = nil;
         });
      }
   }
}

-(void)evictNotification:(NSNotification*)notification
{
   id identifier = notification.userInfo[@"identifier"];
   if ([self.identifier isEqual:identifier])
      _selfRetainer = nil;
}

-(void)evictIfAllTagsNotification:(NSNotification*)notification
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
   id _tempSelf = self;
#pragma clang diagnostic pop
   
   NSArray* tags = notification.userInfo[@"tags"];
   if ([tags containsObject:@"*"])
      _selfRetainer = nil;
   else if ([self.tags count] >= tags.count)
   {
      for (id obj in self.tags)
         if (![tags containsObject:obj])
            return;
      _selfRetainer = nil;
   }
}

-(void)evictIfAnyOfTagsNotification:(NSNotification*)notification
{
   NSArray* tags = notification.userInfo[@"tags"];
   for (id obj in self.tags)
      if ([tags containsObject:obj] || [tags containsObject:@"*"])
      {
         _selfRetainer = nil;
         break;
      }
}

-(void)evictIfNotInTagsNotification:(NSNotification*)notification
{
   NSArray* tags = notification.userInfo[@"tags"];
   BOOL tagFound = NO;
   for (id obj in self.tags)
      if ([tags containsObject:obj] || [tags containsObject:@"*"])
      {
         tagFound = YES;
         break;
      }
   if (!tagFound)
      _selfRetainer = nil;
}

-(void)dealloc
{
   NSLog(@"%@ out of cache", [_object description]);
   [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


@implementation MRObjectCache (in_memory_impl)

// InMemoryCache is the default implemetation, other
// implementations  MUST NOT  call SetDefaultCache()
// in +(void)load method of ObjectCache category.

+(void)load
{
   [self useInMemoryImplementation];
}

+(void)useInMemoryImplementation
{
   SetDefaultCache([[InMemoryCache alloc] init]);
}

@end


