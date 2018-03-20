//
// MRBadgeCounter.h
//  ikframework
//
//  Created by Federico Gasperini on 03/11/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const MRUpdateBadgeValue;
extern NSString* const MRBadgeTag;

typedef BOOL(^UpdateBlock)(id* value, id* tag);

@interface MRBadgeCounter : NSObject

+(instancetype)defaultCounter;

@property (readonly, nonatomic) NSMutableDictionary* badgeValues;
@property (readonly) id value;
@property (readonly) NSString* overallDescription;

-(void)updateBadge:(id)tag withValue:(id)value;
-(void)updateBadgeValueWithBlock:(UpdateBlock)block;

-(id)valueForBadge:(id)tag;

@end
