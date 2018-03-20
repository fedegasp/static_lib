//
//  UIImage+qrCode.m
//  dpr
//
//  Created by Federico Gasperini on 15/02/16.
//  Copyright © 2016 Accenture. All rights reserved.
//

#import "UIImage+qrCode.h"
#import "ZXQRCodeWriter.h"

@implementation UIImage (qrCode)

+(UIImage*)qrCodeWithString:(NSString *)inputString andSize:(CGSize)size
{
   return [self qrCodeWithString:inputString redoundancy:@"L" andSize:size];
}

+(UIImage*)qrCodeWithString:(NSString *)inputString redoundancy:(NSString*)r andSize:(CGSize)size
{
   static NSDictionary* correctionLevels = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      correctionLevels = @{@"L":[ZXQRCodeErrorCorrectionLevel errorCorrectionLevelL],
                           @"M":[ZXQRCodeErrorCorrectionLevel errorCorrectionLevelM],
                           @"Q":[ZXQRCodeErrorCorrectionLevel errorCorrectionLevelQ],
                           @"H":[ZXQRCodeErrorCorrectionLevel errorCorrectionLevelH]};
   });
   
   
   int bigEnough = MIN((int)size.width, (int)size.height);
   ZXEncodeHints* h = [ZXEncodeHints hints];
   h.errorCorrectionLevel = correctionLevels[r];
   h.margin = @1;
   ZXQRCodeWriter *writer = [[ZXQRCodeWriter alloc] init];
   ZXBitMatrix *matrix = [writer encode:inputString
                                  width:bigEnough
                                 height:bigEnough
                                  hints:h
                                  error:nil];
   
   ZXImage* img = [ZXImage imageWithMatrix:matrix];
   
   if (img.cgimage)
      return  [UIImage imageWithCGImage:img.cgimage];
   
   return nil;
}

//   NSData* data = [inputString dataUsingEncoding:NSISOLatin1StringEncoding];
//   return [self qrCodeWithData:data redoundancy:r andSize:size];
//}
//
//+(UIImage*)qrCodeWithData:(NSData*)inputData redoundancy:(NSString*)r andSize:(CGSize)size
//{
//   UIImage *scaledImage = nil;
//   if (inputData.length)
//   {
//      CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
//      // Set the message content and error-correction level
//      [qrFilter setValue:inputData forKey:@"inputMessage"];
//      if (r)
//         [qrFilter setValue:r forKey:@"inputCorrectionLevel"];
//      else
//         [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
//      
//      // Send the image back
//      CIImage* image = qrFilter.outputImage;
//      
//      // Render the CIImage into a CGImage
//      CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:image fromRect:image.extent];
//      
//      // Now we'll rescale using CoreGraphics
//      CGFloat minSize = MIN(size.width, size.height) * [[UIScreen mainScreen] nativeScale];
//      UIGraphicsBeginImageContext(CGSizeMake(minSize, minSize));
//      CGContextRef context = UIGraphicsGetCurrentContext();
//      // We don't want to interpolate (since we've got a pixel-correct image)
//      CGContextSetInterpolationQuality(context, kCGInterpolationNone);
//      CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
//      // Get the image out
//      scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//      // Tidy up
//      UIGraphicsEndImageContext();
//      CGImageRelease(cgImage);
//   }
//   return scaledImage;
//}

@end
