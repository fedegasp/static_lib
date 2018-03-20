//
//  UIView+selectiveRoundedCorners.m
//  test
//
//  Created by Federico Gasperini on 16/02/17.
//  Copyright © 2017 Federico Gasperini. All rights reserved.
//

#import "UIView+selectiveRoundedCorners.h"
#import "UIView+Screenshot.h"
#import "UIImage+mask.h"
#import "UIImage+IKInterface.h"
#import <objc/message.h>

@implementation UIView (selectiveRoundedCorners)

static const char * prefix = "selective_rounded_corners_";

-(BOOL)selective_rounded_corners_subclassed
{
   NSString* className = NSStringFromClass([self class]);
   return [className containsString:@(prefix)];
}

-(Class)selective_rounded_corners_baseclass
{
   return objc_getAssociatedObject(self, @selector(selective_rounded_corners_baseclass));
}

-(void)selective_rounded_corners_subclass
{
   if (self.selective_rounded_corners_subclassed)
      return;
   
   NSString * subclassName = [NSString stringWithFormat:@"%s%s", prefix, object_getClassName(self)];
   Class subclass = NSClassFromString(subclassName);
   
   if (subclass == nil)
   {
      subclass = objc_allocateClassPair(object_getClass(self), [subclassName UTF8String], 0);
      if (subclass != nil)
      {
         IMP gradient_method = class_getMethodImplementation([self class],
                                                             @selector(_selective_rounded_corners_layoutSubviews));
         class_addMethod(subclass, @selector(layoutSubviews), gradient_method, "v@:");
         
         objc_registerClassPair(subclass);
      }
   }
   
   if (subclass != nil)
   {
      objc_setAssociatedObject(self, @selector(selective_rounded_corners_baseclass),
                               self.class, OBJC_ASSOCIATION_ASSIGN);
      object_setClass(self, subclass);
   }
}

typedef void(*SuperLayoutSubviews)(struct objc_super*, SEL);
static SuperLayoutSubviews superLayoutSubviews = (SuperLayoutSubviews)objc_msgSendSuper;

-(void)_selective_rounded_corners_layoutSubviews
{
   struct objc_super superInfo =  {
      self,
      [self selective_rounded_corners_baseclass]
   };
   superLayoutSubviews(&superInfo, @selector(layoutSubviews));
   UIRectCorner mask = [self cornerMask];
   self.layer.masksToBounds = NO;
   if (self.circularBounds && self.borderWidth == 0)
   {
      self.layer.mask = nil;
      self.layer.cornerRadius = self.borderRadius;
      self.layer.masksToBounds = YES;
   }
   else if (mask != 0)
   {
      CALayer *layerMask = [self _layerMask];
      layerMask.frame = self.bounds;
      
      layerMask.contents = (id)[UIImage maskImageWithRoundedCorners:[self cornerMask]
                                                               size:self.bounds.size
                                                          andRadius:self.borderRadius].CGImage;
      // set the mask layer as mask of the view layer
      self.layer.mask = layerMask;
   }
   else
      self.layer.mask = nil;
   
   if (self.borderWidth > 0)
   {
      CAShapeLayer* borderLayer = [self _borderLayer];
      UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                 byRoundingCorners:(UIRectCorner)[self cornerMask]
                                                       cornerRadii:CGSizeMake(self.borderRadius,
                                                                              self.borderRadius)];
      
      [CATransaction begin];
      [CATransaction setDisableActions:YES];
      borderLayer.path = path.CGPath;
      borderLayer.fillColor = [UIColor clearColor].CGColor;
      borderLayer.strokeColor = self.layerBorderColor.CGColor;
      borderLayer.lineWidth = self.borderWidth;
      borderLayer.frame = self.bounds;
      [CATransaction commit];
      if (borderLayer.superlayer != self.layer)
         [self.layer addSublayer:borderLayer];
   }
   else
      [[self _borderLayer] removeFromSuperlayer];
}

-(CALayer*)_layerMask
{
   CALayer* l = objc_getAssociatedObject(self, @selector(_layerMask));
   if (!l)
   {
      l = [CALayer layer];
      objc_setAssociatedObject(self, @selector(_layerMask),
                               l, OBJC_ASSOCIATION_RETAIN);
   }
   return l;
}

-(CAShapeLayer*)_borderLayer
{
   CAShapeLayer* l = objc_getAssociatedObject(self, @selector(_borderLayer));
   if (!l)
   {
      l = [CAShapeLayer layer];
      objc_setAssociatedObject(self, @selector(_borderLayer),
                               l, OBJC_ASSOCIATION_RETAIN);
   }
   return l;
}

-(void)setCornerMask:(UIRectCorner)cornerMask
{
   objc_setAssociatedObject(self, @selector(cornerMask),
                            @(cornerMask), OBJC_ASSOCIATION_RETAIN);
   [self selective_rounded_corners_subclass];
   [self setNeedsLayout];
}

-(UIRectCorner)cornerMask
{
   UIRectCorner mask = [objc_getAssociatedObject(self, @selector(cornerMask)) integerValue];
   if (mask == 0 && self.borderRadius > 0)
      mask = UIRectCornerAllCorners;
   return mask;
}

-(void)setLayerBorderColor:(UIColor*)borderColor
{
   self.layer.borderColor = borderColor.CGColor;
   [self selective_rounded_corners_subclass];
   [self setNeedsLayout];
}

-(UIColor*)layerBorderColor
{
   if (self.layer.borderColor)
      return [UIColor colorWithCGColor:self.layer.borderColor];
   return nil;
}

-(void)setCircularBounds:(BOOL)circularBounds
{
   if (!circularBounds)
   {
      self.layer.cornerRadius = 0;
      self.cornerMask = 0;
   }
   else
      self.cornerMask = UIRectCornerAllCorners;
   objc_setAssociatedObject(self, @selector(circularBounds),
                            @(circularBounds),
                            OBJC_ASSOCIATION_RETAIN);
   [self setNeedsLayout];
}

-(BOOL)circularBounds
{
   return [objc_getAssociatedObject(self, @selector(circularBounds)) boolValue];
}

-(void)setBorderWidth:(CGFloat)borderWidth
{
   objc_setAssociatedObject(self, @selector(borderWidth),
                            @(borderWidth), OBJC_ASSOCIATION_RETAIN);
   [self selective_rounded_corners_subclass];
   [self setNeedsLayout];
}

-(CGFloat)borderWidth
{
   return [objc_getAssociatedObject(self, @selector(borderWidth)) floatValue];
}

-(void)setBorderRadius:(CGFloat)borderRadius
{
   objc_setAssociatedObject(self, @selector(borderRadius),
                            @(borderRadius), OBJC_ASSOCIATION_RETAIN);
   [self selective_rounded_corners_subclass];
   [self setNeedsLayout];
}

-(CGFloat)borderRadius
{
   if (self.circularBounds)
      return MIN(self.bounds.size.height, self.bounds.size.width) / 2.0;

   return [objc_getAssociatedObject(self, @selector(borderRadius)) floatValue];
}

@end

@implementation UIView (selectiveRoundedCorners_ibinspectable)

@dynamic cornerMask;

@end

