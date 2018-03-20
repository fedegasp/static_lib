//
//  UIColor+ETIColor.m
//  Iconick
//
//  Created by Giovanni Castiglioni on 16/01/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import "UIColor+colorWithName.h"
#import <objc/runtime.h>

@implementation UIColor (colorWithName)

+(UIColor*)colorWithName:(NSString*)name
{
   if (name)
   {
      SEL selector = NSSelectorFromString(name);
      if (selector)
      {
         Method method = class_getClassMethod(self, selector);
         struct objc_method_description* desc = method_getDescription(method);
         if (desc == NULL || desc->name == NULL)
            return nil;
         
         NSMethodSignature* sig = [NSMethodSignature signatureWithObjCTypes:desc->types];
         NSInvocation* inv = [NSInvocation invocationWithMethodSignature:sig];
         [inv setSelector:selector];
         [inv invokeWithTarget:self];
         __unsafe_unretained UIColor* retVal = nil;
         [inv getReturnValue:(&retVal)];
         return retVal;
      }
   }
   return nil;
}


+ (NSString*)hexStringFromUIColor:(UIColor*)color
{
   NSString* webColor = nil;
   
   if (color && CGColorGetNumberOfComponents(color.CGColor) == 4)
   {
      const CGFloat *components = CGColorGetComponents(color.CGColor);
      CGFloat red, green, blue;
      red = roundf(components[0] * 255.0);
      green = roundf(components[1] * 255.0);
      blue = roundf(components[2] * 255.0);
      webColor = [[NSString alloc]initWithFormat:@"#%02x%02x%02x", (int)red, (int)green, (int)blue];
   }
   return webColor;
}

+ (UIColor *)colorWithHexString:(NSString *)hexString
{
   NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
   CGFloat alpha = 0.0f, red = 0.0f, blue = 0.0f, green = 0.0f;
   switch ([colorString length])
   {
      case 3: // #RGB
         alpha = 1.0f;
         red   = [self colorComponentFrom:colorString start:0 length:1];
         green = [self colorComponentFrom:colorString start:1 length:1];
         blue  = [self colorComponentFrom:colorString start:2 length:1];
         break;
      case 4: // #ARGB
         alpha = [self colorComponentFrom:colorString start:0 length:1];
         red   = [self colorComponentFrom:colorString start:1 length:1];
         green = [self colorComponentFrom:colorString start:2 length:1];
         blue  = [self colorComponentFrom:colorString start:3 length:1];
         break;
      case 6: // #RRGGBB
         alpha = 1.0f;
         red   = [self colorComponentFrom:colorString start:0 length:2];
         green = [self colorComponentFrom:colorString start:2 length:2];
         blue  = [self colorComponentFrom:colorString start:4 length:2];
         break;
      case 8: // #AARRGGBB
         alpha = [self colorComponentFrom:colorString start:0 length:2];
         red   = [self colorComponentFrom:colorString start:2 length:2];
         green = [self colorComponentFrom:colorString start:4 length:2];
         blue  = [self colorComponentFrom:colorString start:6 length:2];
         break;
         //      default:
         //         [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid. It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
         //         break;
   }
   return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length
{
   NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
   NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
   unsigned hexComponent;
   [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
   return hexComponent / 255.0;
}

-(UIColor*)grayScaleColor
{
   const CGFloat *components = CGColorGetComponents(self.CGColor);
   CGFloat w = (components[0] * 0.2126 + components[1] * 0.7152 + components[2] * 0.0722);
   return [UIColor colorWithRed:w green:w blue:w alpha:components[3]];
}

@end
