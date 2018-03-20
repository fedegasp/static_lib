//
//  MRClock.m
//  MRBase
//
//  Created by Federico Gasperini on 11/07/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "MRClock.h"

static MRClock* _instance = nil;

@interface MRClock ()

@property (atomic, weak) NSTimer* timer;

@end


@implementation MRClock
{
   NSHashTable* _map;
}

+(void)load
{
   _instance = [[self alloc] init];
}

-(instancetype)init
{
   self = [super init];
   if (self)
   {
      _map = [NSHashTable hashTableWithOptions:NSHashTableWeakMemory];
   }
   return self;
}

+(void)addTarget:(NSObject *)target
{
   if (!target)
      return;
   
   [_instance->_map addObject:target];
   if (_instance.timer == nil)
   {
      NSLog(@"MRClock firing up");
      NSTimer* t = [NSTimer timerWithTimeInterval:1
                                           target:_instance
                                         selector:@selector(fire)
                                         userInfo:nil
                                          repeats:YES];
      _instance.timer = t;
      [[NSRunLoop mainRunLoop] addTimer:t
                                forMode:NSDefaultRunLoopMode];
   }
}

-(void)dealloc
{
   [self eventuallyStop];
}

-(void)fire
{
   for (NSObject* o in [_map copy])
      [o clockFired];
   [_instance eventuallyStop];
}

+(void)removeTarget:(NSObject *)target
{
   [_instance->_map removeObject:target];
   [_instance eventuallyStop];
}

-(void)eventuallyStop
{
   if (_instance->_map.anyObject == nil)
   {
      NSLog(@"MRClock shuting down");
      [_instance.timer invalidate];
      _instance.timer = nil;
   }
}

@end


@implementation NSObject (MRClock)

-(void)clockFired
{
   NSLog(@"%@ clockFired", self);
}

@end
