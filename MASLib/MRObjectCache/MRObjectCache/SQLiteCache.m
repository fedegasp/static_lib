//
//  SQLiteCache.m
//  iconick-lib
//
//  Created by Federico Gasperini on 07/04/16.
//  Copyright © 2016 accenture. All rights reserved.
//

#import "SQLiteCache.h"
#import "FMDB.h"
#import <sqlite3.h>

static NSString * const DBFileName = @"SQLiteCache.sqlite";
static NSString * const CacheTableName = @"cached_object";

static NSString * const CreateCachedObjectStatement = @""
"CREATE TABLE cached_object ("
"identifier varchar(1024) NOT NULL,"
"timestamp numeric DEFAULT CURRENT_TIMESTAMP NOT NULL,"
"ttl numeric DEFAULT 0 NOT NULL,"
"object blob NOT NULL,"
"tags text NOT NULL,"
"PRIMARY KEY (identifier)"
");";

static NSString * const CreateValidObjectStatement = @""
"CREATE VIEW valid_object "
"AS "
"SELECT identifier, object, tags, datetime(ttl + strftime('%s',timestamp), 'unixepoch') as expiration "
"FROM cached_object "
"WHERE expiration > datetime('now');";

static NSString * const InsertOrUpdate = @""
"INSERT OR REPLACE "
"INTO cached_object (identifier, ttl, object, tags) "
"VALUES (?,?,?,?);";

static NSString * const NotExpiredObjectWithIdentifier = @""
"SELECT object "
"FROM valid_object "
"WHERE identifier == ?;";

static NSString * const EvictObjectsWithAnyOfTags = @""
"UPDATE cached_object "
"SET ttl = 0 "
"WHERE NotEmptyIntersection(tags, ?);";

static NSString * const EvictObjectsNotInTags = @""
"UPDATE cached_object "
"SET ttl = 0 "
"WHERE NOT NotEmptyIntersection(tags, ?);";

static NSString * const EvictObjectsWithAllTags = @""
"UPDATE cached_object "
"SET ttl = 0 "
"WHERE SetIsContained(tags, ?);";

static NSString * const EvictObjectsWithIdentifier = @""
"UPDATE cached_object "
"SET ttl = 0 "
"WHERE identifier == ?;";

static NSString * const EvictAllObjects = @""
"UPDATE cached_object "
"SET ttl = 0 ;";


@implementation SQLiteCache
{
   FMDatabaseQueue* _dbQueue;
}

-(instancetype)init
{
   self = [super init];
   if (self)
      [self setup];
   return self;
}

-(void)setup
{
   NSString* path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                         NSUserDomainMask,
                                                         YES) firstObject];
   
   if (path)
   {
      NSString* filePath = [path stringByAppendingPathComponent:DBFileName];
      _dbQueue = [FMDatabaseQueue databaseQueueWithPath:filePath];
      if (!_dbQueue)
      {
         [[NSFileManager defaultManager] removeItemAtPath:filePath
                                                    error:NULL];
         _dbQueue = [FMDatabaseQueue databaseQueueWithPath:filePath];
      }
   }
   
   [_dbQueue inDatabase:^(FMDatabase *db) {
      if (![db tableExists:CacheTableName])
      {
         [db executeUpdate:CreateCachedObjectStatement];
         [db executeUpdate:CreateValidObjectStatement];
      }
      
       [db makeFunctionNamed:@"NotEmptyIntersection"
                   arguments:2
                       block:^(/*sqlite3_context*/ void *context,
                              int aargc,
                              /*sqlite3_value*/ void **aargv)
       {
          if (aargc >= 2 &&
              sqlite3_value_type(aargv[0]) == SQLITE3_TEXT &&
              sqlite3_value_type(aargv[1]) == SQLITE3_TEXT)
          {
             @autoreleasepool
             {
                const char *c2 = (const char *)sqlite3_value_text(aargv[1]);
                NSString *list2 = [NSString stringWithUTF8String:c2];
                if ([list2 isEqualToString:@"*"])
                   sqlite3_result_int(context, YES);
                else
                {
                   const char *c1 = (const char *)sqlite3_value_text(aargv[0]);
                   NSString *list1 = [NSString stringWithUTF8String:c1];
                   NSSet* set1 = [NSSet setWithArray:[list1 componentsSeparatedByString:@","]];
                   NSSet* set2 = [NSSet setWithArray:[list2 componentsSeparatedByString:@","]];
                   sqlite3_result_int(context, [set1 intersectsSet:set2]);
                }
             }
          }
          else
          {
             NSLog(@"Unknown formart for NotEmptyIntersection (%d, %d) %s:%d", sqlite3_value_type(aargv[0]), sqlite3_value_type(aargv[1]), __FUNCTION__, __LINE__);
             sqlite3_result_null(context);
          }
       }];

      [db makeFunctionNamed:@"SetIsContained"
                  arguments:2
                      block:^(/*sqlite3_context*/ void *context,
                              int aargc,
                              /*sqlite3_value*/ void **aargv)
       {
          if (aargc >= 2 &&
              sqlite3_value_type(aargv[0]) == SQLITE3_TEXT &&
              sqlite3_value_type(aargv[1]) == SQLITE3_TEXT)
          {
             @autoreleasepool
             {
                const char *c1 = (const char *)sqlite3_value_text(aargv[0]);
                NSString *list1 = [NSString stringWithUTF8String:c1];
                NSMutableSet* set1 = [NSMutableSet setWithArray:[list1 componentsSeparatedByString:@","]];
                NSInteger count1 = set1.count;
                
                const char *c2 = (const char *)sqlite3_value_text(aargv[1]);
                NSString *list2 = [NSString stringWithUTF8String:c2];
                NSSet* set2 = [NSSet setWithArray:[list2 componentsSeparatedByString:@","]];
                
                [set1 intersectSet:set2];
                sqlite3_result_int(context, set1.count == count1);
             }
          }
          else
          {
             NSLog(@"Unknown formart for SetIsContained (%d, %d) %s:%d", sqlite3_value_type(aargv[0]), sqlite3_value_type(aargv[1]), __FUNCTION__, __LINE__);
             sqlite3_result_null(context);
          }
       }];
   }];
}

-(void)dealloc
{
   [_dbQueue close];
}

-(void)putObject:(id)object
  withTimeToLive:(NSTimeInterval)ttl
      identifier:(id<NSCopying>)identifier
         andTags:(NSArray<NSString*>*)tags
{
   __block NSData* _obj = [NSKeyedArchiver archivedDataWithRootObject:object];
   __block NSString* _tags = [tags componentsJoinedByString:@","];
   [_dbQueue inDatabase:^(FMDatabase *db) {
      if (![db executeUpdate:InsertOrUpdate, identifier, @(ttl), _obj, _tags])
         NSLog(@"%@", [db lastError]);
   }];
}

-(void)storeObject:(id)object
    withIdentifier:(id<NSCopying>)identifier
           andTags:(NSArray*)tags
{
   [self putObject:object
    withTimeToLive:[[NSDate distantFuture] timeIntervalSinceNow] - 1.0
        identifier:identifier
           andTags:tags];
}

-(id)getObjectWithIdentifier:(id<NSCopying>)identifier
{
   __block id _arch_obj = nil;
   __block id<NSCopying> _identifier = identifier;
   [_dbQueue inDatabase:^(FMDatabase *db) {
      FMResultSet* rs = [db executeQuery:NotExpiredObjectWithIdentifier, _identifier];
      while ([rs next])
         _arch_obj = [rs dataForColumn:@"object"];
      [rs close];
   }];
   id obj = _arch_obj ? [NSKeyedUnarchiver unarchiveObjectWithData:_arch_obj] : nil;
   return obj;
}

-(void)invalidateObjectsByTags:(NSArray<NSString*>*)tags
{
   __block NSString* _evictTags = [tags componentsJoinedByString:@","];
   [_dbQueue inDatabase:^(FMDatabase *db) {
      if (![db executeUpdate:EvictObjectsWithAnyOfTags,_evictTags])
          NSLog(@"%@", [db lastError]);
   }];
}

-(void)invalidateObjectsNotInTags:(NSArray<NSString *> *)tags
{
   __block NSString* _evictTags = [tags componentsJoinedByString:@","];
   [_dbQueue inDatabase:^(FMDatabase *db) {
      if (![db executeUpdate:EvictObjectsNotInTags,_evictTags])
         NSLog(@"%@", [db lastError]);
   }];
}

-(void)invalidateObjectsHavingTags:(NSArray<NSString*>*)tags
{
   __block NSString* _evictTags = [tags componentsJoinedByString:@","];
   [_dbQueue inDatabase:^(FMDatabase *db) {
      if (![db executeUpdate:EvictObjectsWithAllTags,_evictTags])
         NSLog(@"%@", [db lastError]);
   }];
}

-(void)invalidateObjectsByIdentifier:(id<NSCopying>)identifier
{
   __block NSString* _evictId = (id)identifier;
   if ([(id)identifier isEqualToString:@"*"])
   {
      [_dbQueue inDatabase:^(FMDatabase *db) {
         if (![db executeUpdate:EvictAllObjects,_evictId])
            NSLog(@"%@", [db lastError]);
      }];
   }
   else
   {
      [_dbQueue inDatabase:^(FMDatabase *db) {
         if (![db executeUpdate:EvictObjectsWithIdentifier,_evictId])
            NSLog(@"%@", [db lastError]);
      }];
   }
}

@end


@implementation MRObjectCache (persistent_impl)

// InMemoryCache is the default implemetation, other
// implementations  MUST NOT  call SetDefaultCache()
// in +(void)load method of ObjectCache category.

+(void)usePersistentImplementation
{
   SetDefaultCache([[SQLiteCache alloc] init]);
}

@end
