//
//  MRCurrentLocationManager.m
//  TelcoApp
//
//  Created by Giovanni Castiglioni on 05/06/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import "MRCurrentLocationManager.h"

NSString* const MRLocationUpdateNotification = @"MRLocationUpdateNotification";

@interface MRCurrentLocationManager ()	<CLLocationManagerDelegate>

@property (strong,nonatomic) CLLocationManager *locationManager;

@end

@implementation MRCurrentLocationManager
{
   BOOL _gpsActive;
}

+(instancetype)sharedInstance
{
   static dispatch_once_t predicate = 0;
   __strong static id instance = nil;
   dispatch_once(&predicate, ^{
      instance = [[self alloc] init];
   });
   
   return instance;
}

-(BOOL)startUpdatingLocation
{
   if([self checkGPS])
   {
      [self didStartLocationTracking];
      return YES;
   }
   return NO;
}

-(void)stopUpdatingLocation
{
   [self.locationManager stopUpdatingLocation];
   self.locationManager.delegate = nil;
   self.locationManager = nil;
}

-(void)didStartLocationTracking
{
   if(!self.locationManager)
   {
      self.locationManager = [CLLocationManager new];
#ifdef __IPHONE_8_0
      CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
      if (status == kCLAuthorizationStatusNotDetermined)
      {
         if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            [self.locationManager requestWhenInUseAuthorization];
      }
      else if (status == kCLAuthorizationStatusDenied)
      {
         NSLog(@"Location services denied");
      }
#endif
      self.locationManager.delegate = self;
      self.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
      self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
      [self.locationManager startUpdatingLocation];
   }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
   self.currentLocation = [locations lastObject];
   [[NSNotificationCenter defaultCenter] postNotificationName:MRLocationUpdateNotification object:self.currentLocation];
}

-(BOOL)checkGPS
{
   if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
   {
      _gpsActive = YES;
      return YES;
   }
   else
   {
      _gpsActive = NO;
      return NO;
   }
}

-(NSNumber *)distanceToOtherLocation:(CLLocation *)otherLocation
{
   CLLocationDistance locationDistance = [otherLocation distanceFromLocation:self.currentLocation];
   NSNumber* distance = [NSNumber numberWithFloat:locationDistance/1000];
   return distance;
}

@end

