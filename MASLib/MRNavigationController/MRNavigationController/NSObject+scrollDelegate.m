//
//  NSObject+scrollDelegate.m
//  MASClient
//
//  Created by Gai, Fabio on 04/11/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import "NSObject+scrollDelegate.h"
#import <MRBase/MRWeakWrapper.h>
#import <objc/runtime.h>

@implementation NSObject (scrollDelegate)

-(id<MRScrollViewDelegate>)scrollDelegate
{
    return [objc_getAssociatedObject(self, @selector(scrollDelegate)) object];
}

-(void)setScrollDelegate:(id<MRScrollViewDelegate>)scrollDelegate
{
    objc_setAssociatedObject(self, @selector(scrollDelegate),
                             [MRWeakWrapper weakWrapperWithObject:scrollDelegate],
                             OBJC_ASSOCIATION_RETAIN);
}

@end
