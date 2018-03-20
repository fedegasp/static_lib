//
//  UIImage+mask.m
//  test
//
//  Created by Federico Gasperini on 17/02/17.
//  Copyright © 2017 Federico Gasperini. All rights reserved.
//

#import "UIImage+mask.h"
#define ROUND_UP(N, S) ((((N) + (S) - 1) / (S)) * (S))

static inline UIImage* MTDContextCreateRoundedMask(CGSize size,
                                     CGFloat radius_tl, CGFloat radius_tr,
                                     CGFloat radius_bl, CGFloat radius_br );

@implementation UIImage (mask)

-(UIImage*)mask
{
   float width = CGImageGetWidth(self.CGImage);
   float height = CGImageGetHeight(self.CGImage);
   
   // Make a bitmap context that's only 1 alpha channel
   // WARNING: the bytes per row probably needs to be a multiple of 4
   int strideLength = ROUND_UP(width * 1, 4);
   unsigned char * alphaData = calloc(strideLength * height, sizeof(unsigned char));
   CGContextRef alphaOnlyContext = CGBitmapContextCreate(alphaData,
                                                         width,
                                                         height,
                                                         8,
                                                         strideLength,
                                                         NULL,
                                                         kCGImageAlphaOnly);
   
   // Draw the RGBA image into the alpha-only context.
   CGContextDrawImage(alphaOnlyContext, CGRectMake(0, 0, width, height), self.CGImage);
   
   // Walk the pixels and invert the alpha value. This lets you colorize the opaque shapes in the original image.
   // If you want to do a traditional mask (where the opaque values block) just get rid of these loops.
   for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
         unsigned char val = alphaData[y*strideLength + x];
         val = 255 - val;
         alphaData[y*strideLength + x] = val;
      }
   }
   
   CGImageRef alphaMaskImage = CGBitmapContextCreateImage(alphaOnlyContext);
   CGContextRelease(alphaOnlyContext);
   free(alphaData);
   
   // Make a mask
   CGImageRef finalMaskImage = CGImageMaskCreate(CGImageGetWidth(alphaMaskImage),
                                                 CGImageGetHeight(alphaMaskImage),
                                                 CGImageGetBitsPerComponent(alphaMaskImage),
                                                 CGImageGetBitsPerPixel(alphaMaskImage),
                                                 CGImageGetBytesPerRow(alphaMaskImage),
                                                 CGImageGetDataProvider(alphaMaskImage), NULL, false);
   UIImage* ret = [UIImage imageWithCGImage:finalMaskImage];
//   ret = [ret imageWithColor:[UIColor lightGrayColor]];
   CGImageRelease(finalMaskImage);
   CGImageRelease(alphaMaskImage);
   
   return ret;
}

+(UIImage*)maskImageWithRoundedCorners:(UIRectCorner)maskCorners
                                  size:(CGSize)size
                             andRadius:(CGFloat)radius
{
   CGFloat radius_tl = maskCorners & UIRectCornerTopLeft ? radius : 0;
   CGFloat radius_tr = maskCorners & UIRectCornerTopRight ? radius : 0;
   CGFloat radius_bl = maskCorners & UIRectCornerBottomLeft ? radius : 0;
   CGFloat radius_br = maskCorners & UIRectCornerBottomRight ? radius : 0;
   return MTDContextCreateRoundedMask(size, radius_tl,
                                      radius_tr,
                                      radius_bl,
                                      radius_br);
}

@end



//as far as I know, if you also need to mask the subviews, you could use CALayer masking. There are 2 ways to do this. The first one is a bit more elegant, the second one is a workaround :-) but it's also fast. Both are based on CALayer masking. I've used both methods in a couple of projects last year then I hope you can find something useful.
//
//Solution 1
//
//First of all, I created this function to generate an image mask on the fly (UIImage) with the rounded corner I need. This function essentially needs 5 parameters: the bounds of the image and 4 corner radius (top-left, top-right, bottom-left and bottom-right).


UIImage* MTDContextCreateRoundedMask(CGSize size,
                                     CGFloat radius_tl, CGFloat radius_tr,
                                     CGFloat radius_bl, CGFloat radius_br )
{   
   CGContextRef context;
   CGColorSpaceRef colorSpace;
   CGRect rect = (CGRect){.origin = (CGPoint){0,0},
                          .size = size};
   colorSpace = CGColorSpaceCreateDeviceRGB();
   
   // create a bitmap graphics context the size of the image
   context = CGBitmapContextCreate( NULL, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast );
   
   // free the rgb colorspace
   CGColorSpaceRelease(colorSpace);
   
   if ( context == NULL ) {
      return NULL;
   }
   
   // cerate mask
   
   CGFloat minx = CGRectGetMinX( rect ), midx = CGRectGetMidX( rect ), maxx = CGRectGetMaxX( rect );
   CGFloat miny = CGRectGetMinY( rect ), midy = CGRectGetMidY( rect ), maxy = CGRectGetMaxY( rect );
   
   CGContextBeginPath( context );
   CGContextSetGrayFillColor( context, 1.0, 0.0 );
   CGContextAddRect( context, rect );
   CGContextClosePath( context );
   CGContextDrawPath( context, kCGPathFill );
   
   CGContextSetGrayFillColor( context, 1.0, 1.0 );
   CGContextBeginPath( context );
   CGContextMoveToPoint( context, minx, midy );
   CGContextAddArcToPoint( context, minx, miny, midx, miny, radius_bl );
   CGContextAddArcToPoint( context, maxx, miny, maxx, midy, radius_br );
   CGContextAddArcToPoint( context, maxx, maxy, midx, maxy, radius_tr );
   CGContextAddArcToPoint( context, minx, maxy, minx, midy, radius_tl );
   CGContextClosePath( context );
   CGContextDrawPath( context, kCGPathFill );
   
   // Create CGImageRef of the main view bitmap content, and then
   // release that bitmap context
   CGImageRef bitmapContext = CGBitmapContextCreateImage( context );
   CGContextRelease( context );
   
   // convert the finished resized image to a UIImage
   UIImage *theImage = [UIImage imageWithCGImage:bitmapContext];
   // image is retained by the property setting above, so we can
   // release the original
   CGImageRelease(bitmapContext);
   
   // return the image
   return theImage;
}
