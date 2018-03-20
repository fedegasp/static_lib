//
//  MRChainedDelegate.m
//  MRBase
//
//  Created by Federico Gasperini on 07/10/15.
//  Copyright © 2015 Federico Gasperini. All rights reserved.
//

#import "MRChainedDelegate.h"
#import <objc/message.h>

@implementation MRChainedDelegate

-(void)setNextDelegate:(MRChainedDelegate *)nextDelegate
{
   if (self == nextDelegate)
      @throw [NSException exceptionWithName:NSInvalidArgumentException
                                     reason:@"next delegate cannot be itself"
                                   userInfo:nil];
   _nextDelegate = nextDelegate;
}

-(void)appendToObject:(NSObject *)obj
{
   [self appendToObject:obj forKey:@"delegate"];
}

-(void)appendToObject:(NSObject *)obj forKey:(NSString *)key
{
   id d = [obj valueForKey:key];
   while ([d isKindOfClass:[MRChainedDelegate class]] && d != self)
   {
      key = @"nextDelegate";
      obj = d;
      d = [(id)obj nextDelegate];
   }
   if (d != self)
   {
      self.nextDelegate = d;
      [obj setValue:self forKey:key];
   }
}

-(BOOL)respondsToSelector:(SEL)aSelector
{
   BOOL superRespondsToSelectorRet = [super respondsToSelector:aSelector];
   return superRespondsToSelectorRet ||
          [self.nextDelegate respondsToSelector:aSelector];
}

-(id)forwardingTargetForSelector:(SEL)aSelector
{
   if (self.nextDelegate)
      return self.nextDelegate;

   return [super forwardingTargetForSelector:aSelector];
}

@end
