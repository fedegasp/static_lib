//
//  CacheInterface.h
//  iconick-lib
//
//  Created by Federico Gasperini on 07/04/16.
//  Copyright © 2016 accenture. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CacheInterface <NSObject>

-(void)putObject:(id)object withTimeToLive:(NSTimeInterval)ttl identifier:(id<NSCopying>)identifier andTags:(NSArray<NSString*>*)tags;
-(void)storeObject:(id)object withIdentifier:(id<NSCopying>)identifier andTags:(NSArray*)tags;
-(id)getObjectWithIdentifier:(id<NSCopying>)identifier;
-(void)invalidateObjectsByTags:(NSArray<NSString*>*)tags;
-(void)invalidateObjectsHavingTags:(NSArray<NSString*>*)tags;
-(void)invalidateObjectsNotInTags:(NSArray<NSString*>*)tags;
-(void)invalidateObjectsByIdentifier:(id<NSCopying>)identifier;

@end

void SetDefaultCache(id<CacheInterface> cacheImplInstance);
