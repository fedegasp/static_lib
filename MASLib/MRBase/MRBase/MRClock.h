//
//  MRClock.h
//  MRBase
//
//  Created by Federico Gasperini on 11/07/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MRClock)

-(void)clockFired;

@end

@interface MRClock : NSObject

+(void)addTarget:(NSObject*)target;
+(void)removeTarget:(NSObject*)target;

@end
