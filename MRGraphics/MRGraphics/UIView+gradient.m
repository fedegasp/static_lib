//
//  UIView+gradient.m
//  MASClient
//
//  Created by Federico Gasperini on 16/05/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "UIView+gradient.h"
#import <MRBase/MRWeakWrapper.h>
#import <objc/message.h>

@import QuartzCore;

@implementation UIView (gradient)

static const char * prefix = "gradient_runtime_extension_";

-(BOOL)gradient_subclassed
{
   NSString* className = NSStringFromClass([self class]);
   return [className containsString:@(prefix)];
}

-(Class)gradient_baseclass
{
   return objc_getAssociatedObject(self, @selector(gradient_baseclass));
}

-(void)gradient_subclass
{
   if (self.gradient_subclassed)
      return;
   
   NSString * subclassName = [NSString stringWithFormat:@"%s%s", prefix, object_getClassName(self)];
   Class subclass = NSClassFromString(subclassName);
   
   if (subclass == nil)
   {
      subclass = objc_allocateClassPair(object_getClass(self), [subclassName UTF8String], 0);
      if (subclass != nil)
      {
         IMP gradient_method = class_getMethodImplementation([self class],
                                                             @selector(_gradient_layoutSubviews));
         class_addMethod(subclass, @selector(layoutSubviews), gradient_method, "v@:");
         
         objc_registerClassPair(subclass);
      }
   }
   
   if (subclass != nil)
   {
      objc_setAssociatedObject(self, @selector(gradient_baseclass),
                               self.class, OBJC_ASSOCIATION_ASSIGN);
      object_setClass(self, subclass);
   }
}

typedef void(*SuperLayoutSubviews)(struct objc_super*, SEL);
static SuperLayoutSubviews superLayoutSubviews = (SuperLayoutSubviews)objc_msgSendSuper;

-(void)_gradient_layoutSubviews
{
   struct objc_super superInfo =  {
      self,
      [self gradient_baseclass]
   };
   superLayoutSubviews(&superInfo, @selector(layoutSubviews));

   [CATransaction begin];
   [CATransaction setDisableActions:YES];

   if (self.firstColor && self.secondColor && self.gradientDirection != GradientDirectionDisabled)
   {
      CAGradientLayer* gradientLayer = [self gradientLayer];
      if (!gradientLayer)
      {
         gradientLayer = [CAGradientLayer layer];
         [self setGradientLayer:gradientLayer];
      }
      [[self gradientLayer] setFrame:self.bounds];
      
      gradientLayer.colors = @[(id)self.firstColor.CGColor,
                               (id)self.secondColor.CGColor];
      if (self.gradientDirection == GradientDirectionHorizontal)
      {
         gradientLayer.startPoint = CGPointMake(0.0, 0.5);
         gradientLayer.endPoint = CGPointMake(1.0, 0.5);
      }
      else if (self.gradientDirection == GradientDirectionVertical)
      {
         gradientLayer.startPoint = CGPointMake(0.5, 0.0);
         gradientLayer.endPoint = CGPointMake(0.5, 1.0);
      }
      else if (self.gradientDirection == GradientDirectionCustom)
      {
         gradientLayer.startPoint = [self startPoint];
         gradientLayer.endPoint = [self endPoint];
      }
   }
   else
      self.gradientLayer = nil;
   
   [CATransaction commit];
}

-(void)setGradientLayer:(CAGradientLayer*)gradientLayer
{
    if (gradientLayer.superlayer != self.layer)
    {
        [[self gradientLayer] removeFromSuperlayer];
        if (gradientLayer)
            [self.layer insertSublayer:gradientLayer
                               atIndex:0];
        objc_setAssociatedObject(self, @selector(gradientLayer),
                                 [MRWeakWrapper weakWrapperWithObject:gradientLayer], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

-(CAGradientLayer*)gradientLayer
{
   return [objc_getAssociatedObject(self, @selector(gradientLayer)) object];
}

-(void)setFirstColor:(UIColor *)firstColor
{
   objc_setAssociatedObject(self, @selector(firstColor),
                            firstColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
   if (self.secondColor && firstColor)
   {
      [self gradient_subclass];
      [self setNeedsLayout];
   }
}

-(UIColor*)firstColor
{
   return objc_getAssociatedObject(self, @selector(firstColor));
}

-(void)setSecondColor:(UIColor *)secondColor
{
   objc_setAssociatedObject(self, @selector(secondColor),
                            secondColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
   if (self.firstColor && secondColor)
   {
      [self gradient_subclass];
      [self setNeedsLayout];
   }
}

-(UIColor*)secondColor
{
   return objc_getAssociatedObject(self, @selector(secondColor));
}

-(void)setGradientDirection:(GradientDirection)gradientDirection
{
   objc_setAssociatedObject(self, @selector(gradientDirection),
                            @(gradientDirection),
                            OBJC_ASSOCIATION_RETAIN_NONATOMIC);
   if (self.firstColor && self.secondColor)
   {
      [self gradient_subclass];
      [self setNeedsLayout];
   }
}

-(GradientDirection)gradientDirection
{
   return [objc_getAssociatedObject(self, @selector(gradientDirection)) integerValue];
}

-(void)setStartPoint:(CGPoint)startPoint
{
   objc_setAssociatedObject(self, @selector(startPoint),
                            [NSValue valueWithCGPoint:startPoint],
                            OBJC_ASSOCIATION_RETAIN_NONATOMIC);
   if (self.firstColor && self.secondColor)
   {
      [self gradient_subclass];
      [self setNeedsLayout];
   }
}

-(CGPoint)startPoint
{
   return [objc_getAssociatedObject(self, @selector(startPoint)) CGPointValue];
}

-(void)setEndPoint:(CGPoint)endPoint
{
   objc_setAssociatedObject(self, @selector(endPoint),
                            [NSValue valueWithCGPoint:endPoint],
                            OBJC_ASSOCIATION_RETAIN_NONATOMIC);
   if (self.firstColor && self.secondColor)
   {
      [self gradient_subclass];
      [self setNeedsLayout];
   }
}

-(CGPoint)endPoint
{
   return [objc_getAssociatedObject(self, @selector(endPoint)) CGPointValue];
}

@end


@implementation UIView (gradient_ibinspectable)

@dynamic gradientDirection;

@end

