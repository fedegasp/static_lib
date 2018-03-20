//
//  IKCurrentLocationManager.h
//  TelcoApp
//
//  Created by Giovanni Castiglioni on 05/06/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

extern NSString* const MRLocationUpdateNotification;

@interface MRCurrentLocationManager : NSObject

+(instancetype)sharedInstance;

@property (strong,nonatomic) CLLocation *currentLocation;

-(NSNumber *)distanceToOtherLocation:(CLLocation *)otherLocation;

-(BOOL)startUpdatingLocation;
-(void)stopUpdatingLocation;

@end
