//
//  MRParallaxLayoutAttributes.m
//  MRCustomFlowLayoutExample
//
//  Created by Federico Gasperini on 01/06/17.
//  Copyright © 2017 -. All rights reserved.
//

#import "MRParallaxLayoutAttributes.h"

@implementation MRParallaxLayoutAttributes

-(instancetype)copyWithZone:(NSZone *)zone
{
   MRParallaxLayoutAttributes* ret = [super copyWithZone:zone];
   
   ret.percentage = self.percentage;
   ret.parallax = self.parallax;
   ret.antiParallax = self.antiParallax;
   ret.counterParallax = self.counterParallax;
   ret.isTopItem = self.isTopItem;
   
   return ret;
}

-(BOOL)isEqual:(id)object
{
   return NO;
}

@end
