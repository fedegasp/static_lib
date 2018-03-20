//
//  UIColor+ETIColor.h
//  Iconick
//
//  Created by Giovanni Castiglioni on 16/01/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (colorWithName)

+(UIColor*)colorWithName:(NSString*)name;
+ (NSString*)hexStringFromUIColor:(UIColor*)color;
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length;

-(UIColor*)grayScaleColor;

@end
