//
//  WebServer.m
//  TelcoApp
//
//  Created by Federico Gasperini on 03/02/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import "StubServer.h"
#import <UIKit/UIKit.h>

@interface WebServer ()

@property (readonly, nonatomic) NSMutableDictionary* session;

@end


@implementation StubServer
{
   __strong NSMutableDictionary* _session;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.beginRequest = ^int(WSRequest * _Nonnull connection) {
            if ([connection.uri isEqualToString:@"/skip_callback"])
            {
                 return 0;
            }
            else if (!connection.isPost && !connection.isGet)
            {
                return 0;
            }
            else
            {
                NSData* retval = [(StubServer*)connection.webServer
                                  handleConnectionWithUri:connection.uri
                                  body:connection.body
                                  andQueryString:connection.queryString];
                
                if (retval)
                {
                    // Send HTTP reply to the client
                    [connection sendData:retval
                             withHeaders:@{@"Content-Type": @"application/json"}];

                    return 1;
                }
                return 0;
            }
        };
    }
    return self;
}

#pragma mark - WebServer lifecycle

-(NSMutableDictionary*)session
{
   if (!_session)
      _session = [[NSMutableDictionary alloc] init];
   return _session;
}

#pragma mark - Request hook

-(NSData*)handleConnectionWithUri:(NSString*)uri
                          body:(NSData*)body
                andQueryString:(NSString*)queryString
{
   @autoreleasepool {
      
      NSError* error = nil;
      NSDictionary* bodyJson = [NSJSONSerialization JSONObjectWithData:body
                                                               options:0
                                                                 error:&error];
      NSMutableDictionary* parsedBody = [self inputParams:bodyJson];
      
      if (queryString.length)
      {
         NSDictionary* qStringParams = [self parseQueryString:queryString];
         NSString* stateToStore = qStringParams[@"store"];
         NSArray* vars = [stateToStore componentsSeparatedByString:@";"];
         for (NSString* var in vars)
         {
            id obj = parsedBody[var];
            if (obj)
               self.session[var] = obj;
         }
         
         if (qStringParams)
            [parsedBody addEntriesFromDictionary:qStringParams];
      }

      NSString* mutUri = nil;
      NSString* initialUri = [uri copy];
      if ([[initialUri pathExtension] isEqualToString:@"jvp"])
      {
         initialUri = [initialUri stringByDeletingPathExtension]; // pops .jvp
         NSString* realPathExtension = [initialUri pathExtension];
         if (realPathExtension)
            initialUri = [initialUri stringByDeletingPathExtension]; // pops eventually extension
         
         NSMutableArray* pathComponents = [[initialUri pathComponents] mutableCopy];
         
         NSInteger i = 0;
         if ([[pathComponents firstObject] isEqualToString:@"/"])
            i = 1;
         
         for (; i < pathComponents.count; i++)
         {
            NSString* k = pathComponents[i];
            if ([k hasPrefix:@"!"])
            {
               [pathComponents replaceObjectAtIndex:i withObject:[k substringFromIndex:1]];
               continue;
            }
            //            if ([k rangeOfString:@"("].location == NSNotFound)
            //            {
            //               id v_a = parsedBody[k];
            //               NSString* v = [v_a isKindOfClass:NSArray.class] ? [v_a firstObject] : v_a;
            //               if (v.length)
            //                  [pathComponents replaceObjectAtIndex:i withObject:v];
            //            }
            //            else
            //            {
            NSString* v = k;
            do
            {
               NSString* prefix = nil;
               NSString* postfix = nil;
               NSArray* tokens = [v componentsSeparatedByString:@"("];
               if (tokens.count == 1)
                  tokens = [tokens arrayByAddingObject:@""];
               prefix = [tokens firstObject];
               tokens = [[tokens lastObject] componentsSeparatedByString:@")"];
               k =  [tokens firstObject];
               postfix = [tokens lastObject];
               id v_a = [parsedBody valueForKeyPath:k];
               v = [v_a isKindOfClass:NSArray.class] ? [v_a firstObject] : v_a;
               v = [NSString stringWithFormat:@"%@%@%@",
                    prefix,
                    v.length ? v : k,
                    postfix];
            }
            while ([v rangeOfString:@"("].location != NSNotFound);
            [pathComponents replaceObjectAtIndex:i withObject:v];
         }
         
         mutUri = [NSString pathWithComponents:pathComponents];
         if (realPathExtension.length)
            mutUri = [mutUri stringByAppendingPathExtension:realPathExtension];
         else
            mutUri = [mutUri stringByAppendingPathExtension:@"json"];
         
         if (mutUri.length)
         {
            NSLog(@"resolved uri: %@", mutUri);
            NSString* fPath = [self.documentRoot stringByAppendingPathComponent:mutUri];
            
            NSData* contentFile = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:fPath]];
            
            return contentFile;
         }
      }
   }
   return nil;
}

-(NSMutableDictionary*)inputParams:(NSDictionary*)body
{
   NSMutableDictionary* parsedBody = [self.session mutableCopy];
   
   if (body)
      [parsedBody addEntriesFromDictionary:body];
   
   return parsedBody;
}

-(NSDictionary*)parseQueryString:(NSString*)qString
{
   NSMutableDictionary *queryStringDictionary = nil;
   if (qString)
   {
      queryStringDictionary = [[NSMutableDictionary alloc] init];
      NSArray *urlComponents = [qString componentsSeparatedByString:@"&"];
      
      for (NSString *keyValuePair in urlComponents)
      {
         NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
         NSString *key = [[pairComponents firstObject] stringByRemovingPercentEncoding];
         NSString *value = [[pairComponents lastObject] stringByRemovingPercentEncoding];
         [queryStringDictionary setObject:value forKey:key];
      }
   }
   if (queryStringDictionary.count)
      return queryStringDictionary;
   return nil;
}

@end

