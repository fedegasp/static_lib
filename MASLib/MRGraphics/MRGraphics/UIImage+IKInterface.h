//
//  UIImage+IKInterface.h
//
//
//  Created by Dario Trisciuoglio on 04/09/13.
//  Copyright (c) 2013 Dario Trisciuoglio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, UIGradientOption)
{
   UIGradientOptionVertical,
   UIGradientOptionHorizontal
};

@interface UIImage (Interface)

+ (UIImage*)imageWithColor:(UIColor *)color;
+ (UIImage*)imageNamed:(NSString *)name andMaskColor:(UIColor *)color;
+ (UIImage*)imageWithColor:(UIColor *)color andCorner:(CGFloat)radius;

- (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage*)imageWithSize:(CGSize)size;

- (UIImage*)setCorner:(CGFloat)radius;
- (UIImage*)setCornerWithOption:(UIRectCorner)option andRadius:(CGFloat)radius;

+ (UIImage*)imageGradientWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor orientation:(UIGradientOption)option;
+ (UIImage*)imageGradientWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor size:(CGSize)size orientation:(UIGradientOption)option;
- (UIImage*)setMaskColor:(UIColor *)color;

- (UIImage *)imageScaledToSize:(CGSize)size;

@end
