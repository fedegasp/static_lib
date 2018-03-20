//
//  UIView+SOFViewInterface.m
//  SOFLibrary
//
//  Created by Dario Trisciuoglio on 11/08/13.
//  Copyright (c) 2013 Dario Trisciuoglio. All rights reserved.
//

#import "UIView+IKInterface.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

#define HORIZONTAL_START_POINT  CGPointMake(0, 0.5)
#define HORIZONTAL_END_POINT    CGPointMake(1, 0.5)
#define VERTICAL_START_POINT    CGPointMake(0.5, 0)
#define VERTICAL_END_POINT      CGPointMake(0.5, 1)

@implementation UIView (IKInterface)

static char _et_view_delegate_key_;
static char _identifier_segue_;

-(void)setEtViewDelegate:(id<ETViewDelegate>)etViewDelegate
{
   objc_setAssociatedObject(self, &_et_view_delegate_key_, etViewDelegate, OBJC_ASSOCIATION_ASSIGN);
}

-(id)etViewDelegate
{
   return objc_getAssociatedObject(self, &_et_view_delegate_key_);
}



+(id)viewWithNib:(NSString*)nibName
{
   UIView* view = [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] lastObject];
   if (view)
   {
   }
   return view;
}

+(id)viewWithNibName:(NSString *)nibName
{
   UIView* view =  [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] lastObject];
   view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   return view;
}


+(id)viewWithColor:(UIColor*)color
{
   UIView* view = [[self alloc] init];
   view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   view.autoresizesSubviews = YES;
   view.backgroundColor = color;
   return view;
}

//+(id)viewWithGradientAndFrame:(CGRect)frame andStartColor:(UIColor *)startColor endColor:(UIColor *)endColor orientation:(UIGradientOption)option
//{
//   UIView* view = [[self alloc] initWithFrame:frame];
//   view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//   view.autoresizesSubviews = YES;
//   [view setGradientWithStartColor:startColor endColor:endColor orientation:option];
//   return view;
//}
//
//-(void)setGradientWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor orientation:(UIGradientOption)option
//{
//   CAGradientLayer* gradientLayer = [CAGradientLayer layer];
//   gradientLayer.colors = @[(id)[startColor CGColor],(id)[endColor CGColor]];
//   gradientLayer.startPoint = option ? HORIZONTAL_START_POINT : VERTICAL_START_POINT;
//   gradientLayer.endPoint = option ? HORIZONTAL_END_POINT : VERTICAL_END_POINT;
//   gradientLayer.bounds = self.bounds;
//   gradientLayer.anchorPoint = CGPointZero;
//   [[self layer] insertSublayer:gradientLayer atIndex:0];
//}

-(void)setCornerRadius:(CGFloat)radius
{
   [self setCornerWithOption:UIRectCornerAllCorners andRadius:radius];
}

-(void)setCornerWithOption:(UIRectCorner)option andRadius:(CGFloat)radius
{
   CAShapeLayer *maskLayer = [CAShapeLayer layer];
   CALayer* layerView = [self layer];
   if(option != UIRectCornerAllCorners)
   {
      maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:option cornerRadii:(CGSize){radius, radius}].CGPath;
   }
   else
   {
      maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radius].CGPath;
   }
   [layerView setMasksToBounds:YES];
   [layerView setMask:maskLayer];
   
}

- (void)setAllCornerRadius:(CGFloat)radius
{
   CALayer* layerView = [self layer];
   layerView.cornerRadius = radius;
}

-(void)setBorderWithColor:(UIColor*)color width:(CGFloat)width
{
   CALayer* layerView = [self layer];
   [layerView setBorderWidth:width];
   [layerView setBorderColor:[color CGColor]];
}

-(void)setBorderMaskWithColor:(UIColor*)color width:(CGFloat)width
{
   CALayer* maskLayer = self.layer.mask;
   [maskLayer setBorderWidth:width];
   [maskLayer setBorderColor:[color CGColor]];
}

-(void)setShadowWithColor:(UIColor*)color radius:(CGFloat)radius opacity:(CGFloat)opacity offset:(CGSize)size
{
   CALayer* layerView = [self layer];
   [layerView setShadowColor:[color CGColor]];
   [layerView setShadowOpacity:opacity];
   [layerView setShadowRadius:radius];
   [layerView setShadowOffset:size];
}

+(void)fadeInView:(UIView *)view withAnimationDuration:(NSTimeInterval)animationDuration completion:(void (^)(BOOL finished))completion
{
   if (view)
   {
      view.alpha = 0;
      [UIView animateWithDuration:animationDuration
                       animations:^{
                          view.alpha = 1;
                       }
                       completion:completion];
   }
}

+(void)fadeOutView:(UIView *)view withAnimationDuration:(NSTimeInterval)animationDuration completion:(void (^)(BOOL finished))completion
{
   if (view)
   {
      [UIView animateWithDuration:animationDuration
                       animations:^{
                          view.alpha = 0;
                       }
                       completion:completion];
   }
}

+(void)verticalTranslationView:(UIView *)view withAnimationDuration:(NSTimeInterval)animationDuration andOffset:(CGFloat)offset completion:(void (^)(BOOL finished))completion
{
   if (view)
   {
      [UIView animateWithDuration:animationDuration
                       animations:^{
                          view.transform = CGAffineTransformMakeTranslation(0, offset);
                       }
                       completion:completion];
   }
}

-(void)setSegueIdentifier:(NSString *)segueIdentifier
{
   objc_setAssociatedObject(self, &_identifier_segue_, segueIdentifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString*)segueIdentifier
{
   return objc_getAssociatedObject(self, &_identifier_segue_);
}

- (id)findFirstResponder
{
   if (self.isFirstResponder)
   {
      return self;
   }
   for (UIView *subView in self.subviews)
   {
      id responder = [subView findFirstResponder];
      if (responder) return responder;
   }
   return nil;
}

-(NSInteger)length
{
   //For Bug in IKCollapseTableView when use autoLayout
   return 0;
}


@end

