//
//  UIView+property_proxying.m
//  iconick-lib
//
//  Created by Federico Gasperini on 21/12/15.
//  Copyright © 2015 accenture. All rights reserved.
//

#import "UIView+property_proxying.h"

@import CoreGraphics;
@import QuartzCore;

@implementation UIView (property_proxying)

-(void)setLayerShadowColor:(UIColor *)layerShadowColor
{
   self.layer.shadowColor = layerShadowColor.CGColor;

   if (CGSizeEqualToSize(CGSizeMake(0, -3), self.layer.shadowOffset))
       self.layer.shadowOffset = CGSizeMake(0, 0);
   if (self.layer.shadowOpacity == 0)
      self.layer.shadowOpacity = .5;
   
   self.layer.masksToBounds = NO;
}

-(UIColor*)layerShadowColor
{
   if (self.layer.shadowColor)
      return [UIColor colorWithCGColor:self.layer.shadowColor];
   return nil;
}

@end
