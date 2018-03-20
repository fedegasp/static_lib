//
//  UIImage+overlayColor.m
//  ikframework
//
//  Created by Federico Gasperini on 14/03/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import "UIImage+overlayColor.h"

@implementation UIImage (overlayColor)

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

-(UIImage*)imageByDrawingImage:(UIImage*)image
                        inRect:(CGRect)rect
                     withColor:(UIColor*)color
{
   UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
   
   CGContextRef context = UIGraphicsGetCurrentContext();
   
   CGContextConcatCTM(context, CGAffineTransformMakeRotation(M_PI));
   CGContextConcatCTM(context, CGAffineTransformMakeTranslation(-self.size.width,
                                                                -self.size.height));
   
   CGRect pinRect = self.bound;
   CGRect iconRect = rect;
   
   CGContextDrawImage(context,
                      iconRect,
                      image.CGImage);
   
   //UIImage* result1 = UIGraphicsGetImageFromCurrentImageContext();
   
   CGContextSetBlendMode(context, kCGBlendModeSourceIn);
   [color set];
   CGContextAddRect(context, iconRect);
   CGContextFillPath(context);
   
   UIImage* result1 = UIGraphicsGetImageFromCurrentImageContext();
   CGContextClearRect(context, iconRect);

   CGContextSetBlendMode(context, kCGBlendModeNormal);
   
   CGContextDrawImage(context,
                      pinRect,
                      self.CGImage);
   
   CGContextDrawImage(context,
                      pinRect,
                      result1.CGImage);
   
   UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
   
   UIGraphicsEndImageContext();

   return result;
}

-(CGRect)bound
{
   return (CGRect){.origin=CGPointZero,
                   .size=self.size};
}

@end
