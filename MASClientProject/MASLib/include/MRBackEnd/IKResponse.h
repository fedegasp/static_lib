//
//  IKResponse.h
//  iconick-lib
//
//  Created by Federico Gasperini on 15/09/15.
//  Copyright (c) 2015 accenture. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IKResponse : NSObject <NSCoding>

@property (strong, nonatomic) NSString* errorCode;
@property (strong, nonatomic) NSString* errorDescription;
@property (strong, nonatomic) NSString* statusCode;

+(NSDictionary*)mapping;
+(NSDictionary*)relationships;

+(instancetype)objectByMapping:(NSDictionary*)dict error:(NSError**)error;
-(void)updateByMapping:(NSDictionary*)dict error:(NSError**)error;

@end
