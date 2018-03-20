//
//  IKRKResponse.m
//  MRRestKit
//
//  Created by Federico Gasperini on 06/12/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import "IKRKResponse.h"

@implementation IKRKResponse

+(RKMapping*)responseMapping
{
   RKObjectMapping* mapping = [RKObjectMapping mappingForClass:self];
   [mapping addAttributeMappingsFromDictionary:[self mapping]];
   
   NSDictionary* responseRelationships = [self relationships];
   for (NSString* k in responseRelationships.allKeys)
   {
      if ([responseRelationships[k] respondsToSelector:@selector(allValues)] &&
          [[responseRelationships[k] allValues] firstObject])
      {
         NSArray* tokens = [[[responseRelationships[k] allKeys] firstObject] componentsSeparatedByString:@"."];
         NSString* className = tokens.firstObject;
         NSString* propertyName = tokens.lastObject;
         Class r = NSClassFromString(className);
         
         RKMapping* relMapping = nil;
         if (r == self)
             relMapping = mapping;
         else
             relMapping = [r responseMapping];
          
         NSString* keyPath = k;
         if ([k isEqualToString:@"nil"])
            keyPath = nil;
         [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:keyPath
                                                                                 toKeyPath:propertyName
                                                                               withMapping:relMapping]];
         
      }
   }
   return mapping;
}

+(instancetype)objectByMapping:(NSDictionary*)dict error:(NSError**)error
{
   id o = nil;
   if (dict)
   {
      o = [[self alloc] init];
      RKMappingOperation *mappingOperation = [[RKMappingOperation alloc] initWithSourceObject:dict
                                                                            destinationObject:o
                                                                                      mapping:[self responseMapping]
                                                                                 metadataList:nil];
      [mappingOperation start];
      if (error)
         *error = mappingOperation.error;
   }
   return o;
}

-(void)updateByMapping:(NSDictionary*)dict error:(NSError**)error
{
   if (dict)
   {
      RKMappingOperation *mappingOperation = [[RKMappingOperation alloc] initWithSourceObject:dict
                                                                            destinationObject:self
                                                                                      mapping:[[self class] responseMapping]
                                                                                 metadataList:nil];
      [mappingOperation start];
      if (error)
         *error = mappingOperation.error;
   }
}

@end
