//
//  MRWeakWrapper.m
//  iconick-lib
//
//  Created by Federico Gasperini on 14/04/16.
//  Copyright © 2016 accenture. All rights reserved.
//

#import "MRWeakWrapper.h"
#import <objc/runtime.h>

@implementation MRWeakWrapper
{
   __weak id _object;
}

@synthesize object = _object;

+(instancetype)weakWrapperWithObject:(id)object
{
   id w = nil;
   if (object)
      w = [[self alloc] initWithObject:object];
   return w;
}

-(instancetype)initWithObject:(id)object
{
   self = [super init];
   if (self)
      _object = object;
   return self;
}

-(id)forwardingTargetForSelector:(SEL)aSelector
{
   return _object;
}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    return [super methodSignatureForSelector:@selector(sinkMethod)];
}

-(void)forwardInvocation:(NSInvocation *)anInvocation
{
    anInvocation.selector = @selector(sinkMethod);
    
    [anInvocation invokeWithTarget:self];
}

-(id)sinkMethod
{
    return nil;
}

@end
