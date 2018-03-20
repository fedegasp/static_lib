//
//  IKRKRequest.m
//  MRRestKit
//
//  Created by Federico Gasperini on 28/10/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import "IKRKRequest.h"
#import "RestKit.h"
#import "IKObjectManager.h"
#import "IKObjectRequestOperation.h"

@interface IKRKRequest ()

@property (readwrite) RKObjectRequestOperation* requestOperation;
   
@end

@implementation IKRKRequest
{
   RKRoute* _route;
}

@dynamic requestOperation;

-(void)setRequestOperation:(RKObjectRequestOperation *)requestOperation
{
   [super setRequestOperation:requestOperation];
   if (self.environment.basicAuth.length)
   {
      NSMutableURLRequest* mutReq = (NSMutableURLRequest*)self.requestOperation.HTTPRequestOperation.request;
      [mutReq setValue:[NSString stringWithFormat:@"Basic %@", self.environment.basicAuth]
    forHTTPHeaderField:@"Authorization"];
   }
}

-(NSDictionary*)parameters
{
   NSArray* allKeys = self.mapping.allKeys;
   NSMutableSet* keys = [NSMutableSet setWithArray:allKeys];
   
   if (self.route.pathPattern) {
      
      // remove keys that are not in the route path
      
      for (NSString *aKey in allKeys) {
         NSString *search = [NSString stringWithFormat:@":%@", aKey];
         if ([self.route.pathPattern containsString:search]) {
            [keys removeObject:aKey];
         }
      }
   }
   
   NSMutableDictionary* ret = [[NSMutableDictionary alloc] init];
   for (NSString* k in keys) {
      id value = [self valueForKey:k];
      if (value)
      ret[[self mapping][k]] = value;
   }
   
   if (ret.count > 0) {
      return ret;
   }
   
   return nil;
}

-(RKRoute*)route
{
   if (_route)
      return _route;

   if ([self.endPoint containsString:@":"])
      _route = [RKRoute routeWithClass:self.class
                           pathPattern:self.endPoint
                                method:RKRequestMethodAny];

   return _route;
}

+(NSArray<RKRequestDescriptor*>*)requestDescriptors
{
   RKObjectMapping *reqMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
   [reqMapping addAttributeMappingsFromDictionary:[self requestMapping]];
   
   RKRequestDescriptor* requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:reqMapping
                                                                                  objectClass:self
                                                                                  rootKeyPath:nil
                                                                                       method:RKRequestMethodAny];
   return requestDescriptor ? @[requestDescriptor] : @[];
}

-(NSURLRequest*)urlRequest
{
   IKObjectManager* objManager = [IKObjectManager managerForUrl:[[self.environment url] absoluteString]
                                                     withMethod:self.method
                                                 acceptMimeType:nil
                                       andSerializationMimeType:[self.environment serializationContentType]
                                                           name:self.environment.name
                                                    suspendable:YES];
   
   IKObjectRequestOperation* rop = [objManager appropriateObjectRequestOperationWithObject:self
                                                                                    method:RKRequestMethodFromString([self method])
                                                                                      path:[self endPoint]
                                                                                parameters:[self parameters]];
   return rop.HTTPRequestOperation.request;
}

@end
