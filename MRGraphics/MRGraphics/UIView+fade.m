//
//  UIView+fade.m
//  test
//
//  Created by Federico Gasperini on 16/02/17.
//  Copyright © 2017 Federico Gasperini. All rights reserved.
//

#import "UIView+fade.h"
#import "UIView+Screenshot.h"
#import "UIImage+mask.h"
#import "UIImage+IKInterface.h"
#import <objc/runtime.h>
#import <MRBase/JRSwizzle.h>

@implementation UIView (fade)

+(void)load
{
   [self jr_swizzleMethod:@selector(layoutSubviews)
               withMethod:@selector(_fade_layoutSubviews)
                    error:NULL];
}

-(void)fadeEffect:(BOOL)addEffect
{
   for (UIView* v in self.subviews)
      if (!v.avoidFading && !v.isHidden)
      {
         if (addEffect)
            [v _addFadeEffectWithOpacity:.5];
         else
            [v _removeFadeEffect];
      }
}

-(void)_addFadeEffectWithOpacity:(CGFloat)opacity
{
   NSLog(@"_addFadeEffectWithOpacity %@", self);
   CALayer* layer = [[CALayer alloc] init];
   
   layer.frame = self.frame;
   
   layer.cornerRadius = self.layer.cornerRadius;
   layer.masksToBounds = self.layer.masksToBounds;
   
   layer.shadowPath = self.layer.shadowPath;
   layer.shadowColor = self.layer.shadowColor;
   layer.shadowOffset = self.layer.shadowOffset;
   layer.shadowRadius = self.layer.shadowRadius;
   layer.shadowOpacity = self.layer.shadowOpacity;
   
   UIImage* m = [[[self renderImage] mask] imageWithColor:[UIColor lightGrayColor]];
   layer.contents = (id)m.CGImage;
   
   self.maskView = [[UIView alloc] initWithFrame:self.bounds];
   self.maskView.backgroundColor = [UIColor whiteColor];
   self.maskView.alpha = opacity;
   
   [self.layer.superlayer insertSublayer:layer
                                   below:self.layer];
   
   objc_setAssociatedObject(self, @selector(fadeEffect:),
                            layer, OBJC_ASSOCIATION_ASSIGN);
}

-(void)_removeFadeEffect
{
   CALayer* layer = objc_getAssociatedObject(self, @selector(fadeEffect:));
   objc_setAssociatedObject(self, @selector(fadeEffect:),
                            nil, OBJC_ASSOCIATION_ASSIGN);
   [layer removeFromSuperlayer];
   self.maskView = nil;
}

-(void)_fade_layoutSubviews
{
   [self _fade_layoutSubviews];
   CALayer* layer = objc_getAssociatedObject(self, @selector(fadeEffect:));
   if (![self avoidFading])
   {
      if (layer)
      {
         [layer removeFromSuperlayer];
         id tmp = self.maskView;
         self.maskView = nil;
         UIImage* m = [[[self renderImage] mask] imageWithColor:[UIColor lightGrayColor]];
         
         self.maskView = tmp;
         self.maskView.frame = self.bounds;
         [layer setFrame:self.frame];
         layer.contents = (id)m.CGImage;
         [self.layer.superlayer insertSublayer:layer
                                         below:self.layer];
      }
   }
   else
      [layer removeFromSuperlayer];
}

-(BOOL)avoidFading
{
    id ret = objc_getAssociatedObject(self, @selector(avoidFading));
    return ret ? [ret boolValue] : YES;
}

-(void)setAvoidFading:(BOOL)avoidFading
{
   objc_setAssociatedObject(self, @selector(avoidFading),
                            @(avoidFading),
                            OBJC_ASSOCIATION_RETAIN);
   [self setNeedsLayout];
}

@end
