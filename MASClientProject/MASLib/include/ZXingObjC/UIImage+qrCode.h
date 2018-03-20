//
//  UIImage+qrCode.h
//  dpr
//
//  Created by Federico Gasperini on 15/02/16.
//  Copyright © 2016 Accenture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (qrCode)

+(UIImage*)qrCodeWithString:(NSString*)inputString andSize:(CGSize)size;
+(UIImage*)qrCodeWithString:(NSString *)inputString redoundancy:(NSString*)r andSize:(CGSize)size;
//+(UIImage*)qrCodeWithData:(NSData*)inputData redoundancy:(NSString*)r andSize:(CGSize)size;

@end
