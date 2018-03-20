//
//  IKResponse.m
//  iconick-lib
//
//  Created by Federico Gasperini on 15/09/15.
//  Copyright (c) 2015 accenture. All rights reserved.
//

#import "IKResponse.h"

@implementation IKResponse

+(NSDictionary*)mapping
{
   return @{};
}

+(NSDictionary*)relationships
{
   return @{};
}

-(id)initWithCoder:(NSCoder *)decoder
{
   self = [super init];
   if (!self)
      return nil;
   
   self.errorCode = [decoder decodeObjectForKey:@"errorCode"];
   self.errorDescription = [decoder decodeObjectForKey:@"errorDescription"];
   self.statusCode = [decoder decodeObjectForKey:@"statusCode"];
   return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
   [encoder encodeObject:self.errorCode forKey:@"errorCode"];
   [encoder encodeObject:self.errorDescription forKey:@"errorDescription"];
   [encoder encodeObject:self.statusCode forKey:@"statusCode"];
}

+(instancetype)objectByMapping:(NSDictionary*)dict error:(NSError**)error
{
   if (error) {
      *error = [NSError errorWithDomain:@"Unimplemented"
                                   code:1
                               userInfo:nil];
   }
   return nil;
}

-(void)updateByMapping:(NSDictionary*)dict error:(NSError**)error
{
   if (error) {
      *error = [NSError errorWithDomain:@"Unimplemented"
                                   code:1
                               userInfo:nil];
   }
}

@end
