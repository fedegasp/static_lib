//
//  UIImage+IKInterface.m
//  
//
//  Created by Dario Trisciuoglio on 04/09/13.
//  Copyright (c) 2013 Dario Trisciuoglio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct {
	CGFloat h;
	CGFloat s;
	CGFloat v;
} COLOR_HSV;

typedef struct {
	CGFloat r;
	CGFloat g;
	CGFloat b;
} COLOR_RGB;

typedef struct {
	CGFloat r;
	CGFloat g;
	CGFloat b;
	CGFloat a;
} COLOR_RGBA;

#import <QuartzCore/QuartzCore.h>
#import "UIImage+IKInterface.h"
#if DEBUG
#import <MRBase/JRSwizzle.h>
#endif

@implementation UIImage (Interface)

//#if DEBUG
//
//+(void)load
//{
//   [self jr_swizzleClassMethod:@selector(imageNamed:inBundle:compatibleWithTraitCollection:)
//               withClassMethod:@selector(_debugImageNamed:inBundle:compatibleWithTraitCollection:)
//                         error:NULL];
//}
//
//+(UIImage*)_debugImageNamed:(NSString*)imageName
//                   inBundle:(NSBundle*)b
//compatibleWithTraitCollection:(UITraitCollection*)t
//{
//   UIImage* ret = 
//   [self _debugImageNamed:imageName
//                 inBundle:b
//compatibleWithTraitCollection:t];
//   
//   if (!ret)
//   {
//      NSString* text = [NSString stringWithFormat:@"missing\n%@\nimage",imageName];
//      UIFont *font = [UIFont systemFontOfSize:13.0];
//      CGSize size  = [text sizeWithAttributes:@{NSFontAttributeName:font}];
//      UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
//      
//      // draw in context, you can use also drawInRect:withFont:
//      [text drawAtPoint:CGPointMake(0.0, 0.0) withAttributes:@{NSFontAttributeName:font}];
//      
//      // transfer image
//      ret = UIGraphicsGetImageFromCurrentImageContext();
//      UIGraphicsEndImageContext();
//   }
//   return ret;
//}
//
//#endif

+(COLOR_RGBA)rgbaFromUIColor:(UIColor *)color
{
	const CGFloat *components = CGColorGetComponents([color CGColor]);
   
	COLOR_RGBA ret;
	ret.r = components[0];
	ret.g = components[1];
	ret.b = components[2];
	ret.a = components[3];
   
	return ret;
}

- (UIImage *)imageWithColor:(UIColor *)color1
{
   UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
   CGContextRef context = UIGraphicsGetCurrentContext();
   CGContextTranslateCTM(context, 0, self.size.height);
   CGContextScaleCTM(context, 1.0, -1.0);
   CGContextSetBlendMode(context, kCGBlendModeNormal);
   CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
   CGContextClipToMask(context, rect, self.CGImage);
   [color1 setFill];
   CGContextFillRect(context, rect);
   UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();
   return [newImage resizableImageWithCapInsets:self.capInsets resizingMode:UIImageResizingModeStretch];
}

+(UIImage *)imageWithColor:(UIColor *)color;
{
   CGRect rect = CGRectMake(0, 0, 20, 20);
   UIGraphicsBeginImageContextWithOptions(rect.size, YES, 1);
   [color setFill];
   CGContextFillRect(UIGraphicsGetCurrentContext(), rect);
   UIImage* backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();
   
   return backgroundImage;
}

+(UIImage *)imageGradientWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor size:(CGSize)size orientation:(UIGradientOption)option
{
   UIImage* image = nil;
   switch (option)
   {
      case 0:
      {
         image = [UIImage imageGradientWithStartColor:startColor endColor:endColor size:size startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, size.height)];
      }
      break;
      
      case 1:
      {
         image = [UIImage imageGradientWithStartColor:startColor endColor:endColor size:size startPoint:CGPointMake(0, 0) endPoint:CGPointMake(size.width, 0)];
      }
      break;
   }
   return image;
}

+(UIImage *)imageGradientWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor orientation:(UIGradientOption)option
{
   CGSize size = CGSizeMake(44, 44);
   return [[UIImage imageGradientWithStartColor:startColor endColor:endColor size:size orientation:option] resizableImageWithCapInsets:UIEdgeInsetsMake(22, 22, 22, 22)];
}

+(UIImage *)imageWithColor:(UIColor *)color andCorner:(CGFloat)radius
{
   return [[UIImage imageWithColor:color] setCorner:radius];
}

-(UIImage *)setCorner:(CGFloat)radius
{
   return [self setCornerWithOption:UIRectCornerAllCorners andRadius:radius];
}

-(UIImage *)setCornerWithOption:(UIRectCorner)option andRadius:(CGFloat)radius
{
   UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
   CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
   
   if(option != UIRectCornerAllCorners)
   {
      [[UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:option cornerRadii:(CGSize){radius, radius}] addClip];
   }
   else
   {
      [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
   }
   [self drawInRect:rect];
   
   UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();

   return [roundedImage resizableImageWithCapInsets:UIEdgeInsetsMake(self.size.width/2, self.size.height/2, self.size.width/2, self.size.height/2)];
}

+(UIImage *)imageGradientWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor size:(CGSize)size startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
   CGFloat locations[2] = { 0.0f, 1.0f };
   COLOR_RGBA startRgba = [UIImage rgbaFromUIColor:startColor];
   COLOR_RGBA endRgba = [UIImage rgbaFromUIColor:endColor];
   CGFloat components[8] = {endRgba.r, endRgba.g, endRgba.b, endRgba.a, startRgba.r, startRgba.g, startRgba.b, startRgba.a};

   CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
   CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 4 * size.width, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
   //CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 4 * size.width, colorSpace, kCGBitmapAlphaInfoMask);
   CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
   CGContextDrawLinearGradient (context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation);

   CGImageRef cgImage = CGBitmapContextCreateImage(context);
   UIImage* imageGradient = [UIImage imageWithCGImage:cgImage];
   
   CGGradientRelease(gradient);
   CGImageRelease(cgImage);
   CGContextRelease(context);
   CGColorSpaceRelease(colorSpace);
   
   return imageGradient;
}


+(UIImage*)imageNamed:(NSString *)name andMaskColor:(UIColor *)color
{
   UIImage* image = [UIImage imageNamed:name];
   return [image setMaskColor:color];
}

- (UIImage*)setMaskColor:(UIColor *)color
{
   CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);

   UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
   
   [self drawInRect:rect];
   
   CGContextRef context = UIGraphicsGetCurrentContext();
   CGContextSetBlendMode(context, kCGBlendModeSourceIn);
   
   CGContextSetFillColorWithColor(context, color.CGColor);
   CGContextFillRect(context, rect);
   
   UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();
   
   return image;
}

+(UIImage*)imageWithSize:(CGSize)size
{
   UIImage* image = [[self alloc] init];
   UIGraphicsBeginImageContext(size);
   [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
   UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();
   return scaledImage;
}

- (UIImage *)imageScaledToSize:(CGSize)size
{
   CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
   CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
   CGContextClearRect(context, CGRectMake(0, 0, size.width, size.height));
   
   if (self.imageOrientation == UIImageOrientationRight) {
      CGContextRotateCTM(context, -M_PI_2);
      CGContextTranslateCTM(context, -size.height, 0.0f);
      CGContextDrawImage(context, CGRectMake(0, 0, size.height, size.width), self.CGImage);
   } else {
      CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), self.CGImage);
   }
   
   CGImageRef scaledImage = CGBitmapContextCreateImage(context);
   CGColorSpaceRelease(colorSpace);
   CGContextRelease(context);
   
   UIImage *image = [UIImage imageWithCGImage:scaledImage];
   CGImageRelease(scaledImage);
   
   return image;
}

@end
