//
//  UIView+Screenshot.m
//  MASClient
//
//  Created by Gai, Fabio on 19/12/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import "UIView+Screenshot.h"

@implementation UIView (Screenshot)

+ (UIImage *)renderImageFromLayer:(UIView *)view withRect:(CGRect)frame
{
        UIGraphicsBeginImageContext(view.layer.bounds.size);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGImageRef img = [viewImage CGImage];
        img = CGImageCreateWithImageInRect(img, frame);
        return [UIImage imageWithCGImage:img];
}

- (UIImage *)renderImageWithRect:(CGRect)frame
{
    return [UIView renderImageFromLayer:self withRect:frame];
}

- (UIImage *)renderImage
{
   UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0f);
   //UIGraphicsBeginImageContext(self.bounds.size);
   CGContextRef context = UIGraphicsGetCurrentContext();
   if (context != NULL)
   {
      [self.layer renderInContext:UIGraphicsGetCurrentContext()];
      UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
      UIGraphicsEndImageContext();
      return viewImage;
   }
   return nil;
}

@end
