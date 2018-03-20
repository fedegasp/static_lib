//
//  MRRouterChainedDelegate.m
//  MRBase
//
//  Created by Federico Gasperini on 01/06/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "MRRouterChainedDelegate.h"
#import <objc/runtime.h>

@interface MRRouterChainedDelegate ()

@property (readonly, nonatomic) SEL selector;
@property (strong, nonatomic) NSHashTable* hashTable;

@end

@implementation MRRouterChainedDelegate

-(void)setDestination:(NSArray *)destination
{
   _hashTable = [NSHashTable weakObjectsHashTable];
   for (NSObject* o in destination)
      [_hashTable addObject:o];
}

-(NSArray*)destination
{
   return [self.hashTable allObjects];
}

-(BOOL)respondsToSelector:(SEL)aSelector
{
   //NSLog(@"-[%@ %@%@]", NSStringFromClass(self.class), NSStringFromSelector(_cmd),NSStringFromSelector(aSelector));
   BOOL superRespondsToSelectorRet = [super respondsToSelector:aSelector];
   return superRespondsToSelectorRet ||
          sel_isEqual(aSelector, self.selector);
}

-(SEL)selector
{
   //NSLog(@"-[%@ %@]", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
   return NSSelectorFromString(self.selectorName);
}

-(id)forwardingTargetForSelector:(SEL)aSelector
{
   //NSLog(@"-[%@ %@]", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
   if (sel_isEqual(aSelector, self.selector))
      return nil;
   return [super forwardingTargetForSelector:aSelector];
}

-(NSMethodSignature*)methodSignatureForSelector:(SEL)aSelector
{
   //NSLog(@"-[%@ %@]", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
   if (sel_isEqual(aSelector, self.selector))
      return [self.hashTable.anyObject
              methodSignatureForSelector:aSelector];
   return nil;
}

-(void)forwardInvocation:(NSInvocation *)anInvocation
{
   //NSLog(@"-[%@ %@]", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
   for (NSObject* o in self.hashTable)
      [anInvocation invokeWithTarget:o];
   
   if ([self.nextDelegate respondsToSelector:anInvocation.selector])
      [anInvocation invokeWithTarget:self.nextDelegate];
}

@end
