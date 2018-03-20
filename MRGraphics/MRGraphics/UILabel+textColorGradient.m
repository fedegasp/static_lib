//
//  UILabel+textColorGradient.m
//  MRGraphics
//
//  Created by Federico Gasperini on 13/06/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "UILabel+textColorGradient.h"
#import <MRBase/JRSwizzle.h>
#import <MRBase/MRMacros.h>
#import <objc/runtime.h>

@implementation UILabel (textColorGradient)

+(void)load
{
   [self  jr_swizzleMethod:@selector(layoutSubviews)
                withMethod:@selector(textColorGradient_layoutSubviews)
                     error:NULL];
}

-(void)textColorGradient_layoutSubviews
{
   [self textColorGradient_layoutSubviews];
   if (self.textFirstColor && self.textSecondColor)
      [self _setGradientColor];
}

-(UIColor*)_gradientColor
{
   CGRect currentBounds = self.bounds;
   CGPoint startPoint = CGPointZero;
   CGPoint endPoint = CGPointZero;
   if (self.textGradientDirection == GradientDirectionHorizontal)
   {
      startPoint = CGPointMake(0.0, 0.5 * currentBounds.size.height);
      endPoint = CGPointMake(currentBounds.size.width, 0.5 * currentBounds.size.height);
   }
   else if (self.textGradientDirection == GradientDirectionVertical)
   {
      startPoint = CGPointMake(0.5 * currentBounds.size.width, 0.0);
      endPoint = CGPointMake(0.5 * currentBounds.size.width, currentBounds.size.height);
   }
   else if (self.textGradientDirection == GradientDirectionCustom)
   {
      startPoint = CGPointMake(self.textStartPoint.x * currentBounds.size.width,
                               self.textStartPoint.y * currentBounds.size.height);
      endPoint = CGPointMake(self.textEndPoint.x * currentBounds.size.width,
                             self.textEndPoint.y * currentBounds.size.height);
   }
   
   UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 2.0);
   CGContextRef currentContext = UIGraphicsGetCurrentContext();
   
   CGGradientRef glossGradient = NULL;
   CGColorSpaceRef rgbColorspace = NULL;
   size_t num_locations = 2;
   CGFloat locations[2] = { 0.0, 1.0 };
   CGFloat components[8] = { .0 };
   
   [self.textFirstColor getRed:&(components[0])
                         green:&(components[1])
                          blue:&(components[2])
                         alpha:&(components[3])];
   [self.textSecondColor getRed:&(components[4])
                          green:&(components[5])
                           blue:&(components[6])
                          alpha:&(components[7])];
   
   rgbColorspace = CGColorSpaceCreateDeviceRGB();
   glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
   
   CGContextDrawLinearGradient(currentContext, glossGradient,
                               startPoint, endPoint, 0);
   
   CGGradientRelease(glossGradient);
   CGColorSpaceRelease(rgbColorspace);
   
   UIColor* color = nil;
   UIImage* i = UIGraphicsGetImageFromCurrentImageContext();
   if (i)
      color = [UIColor colorWithPatternImage:i];
   
   UIGraphicsEndImageContext();
   
   return color ?: self.textColor;
}

-(void)_setGradientColor
{
   self.textColor = [self _gradientColor];
}

-(void)setTextFirstColor:(UIColor *)textFirstColor
{
   objc_setAssociatedObject(self, @selector(textFirstColor),
                            textFirstColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
   if (self.textSecondColor && textFirstColor)
      [self _setGradientColor];
}

-(UIColor*)textFirstColor
{
   return objc_getAssociatedObject(self, @selector(textFirstColor));
}

-(void)setTextSecondColor:(UIColor *)textSecondColor
{
   objc_setAssociatedObject(self, @selector(textSecondColor),
                            textSecondColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
   if (self.textFirstColor && textSecondColor)
      [self _setGradientColor];
}

-(UIColor*)textSecondColor
{
   return objc_getAssociatedObject(self, @selector(textSecondColor));
}

-(void)setTextGradientDirection:(GradientDirection)textGradientDirection
{
   objc_setAssociatedObject(self, @selector(textGradientDirection),
                            @(textGradientDirection),
                            OBJC_ASSOCIATION_RETAIN_NONATOMIC);
   if (self.textFirstColor && self.textSecondColor)
      [self _setGradientColor];
}

-(GradientDirection)textGradientDirection
{
   return [objc_getAssociatedObject(self, @selector(textGradientDirection)) integerValue];
}

-(void)setTextStartPoint:(CGPoint)textStartPoint
{
   objc_setAssociatedObject(self, @selector(textStartPoint),
                            [NSValue valueWithCGPoint:textStartPoint],
                            OBJC_ASSOCIATION_RETAIN_NONATOMIC);
   if (self.textFirstColor && self.textSecondColor)
      [self _setGradientColor];
}

-(CGPoint)textStartPoint
{
   return [objc_getAssociatedObject(self, @selector(textStartPoint)) CGPointValue];
}

-(void)setTextEndPoint:(CGPoint)textEndPoint
{
   objc_setAssociatedObject(self, @selector(textEndPoint),
                            [NSValue valueWithCGPoint:textEndPoint],
                            OBJC_ASSOCIATION_RETAIN_NONATOMIC);
   if (self.textFirstColor && self.textSecondColor)
      [self _setGradientColor];
}

-(CGPoint)textEndPoint
{
   return [objc_getAssociatedObject(self, @selector(textEndPoint)) CGPointValue];
}

-(void)setTextAnimated:(NSString *)text
{
   [UIView transitionWithView:self
                     duration:DEFAULT_ANIMATION_DURATION
                      options:UIViewAnimationOptionCurveEaseInOut |
    UIViewAnimationOptionTransitionCrossDissolve
                   animations:^{
                      self.text = text;
                   } completion:nil];
}

@end


@implementation UILabel (textColorGradient_ibinspectable)

@dynamic textGradientDirection;

@end

