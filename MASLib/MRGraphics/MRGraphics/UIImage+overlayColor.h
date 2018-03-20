//
//  UIImage+overlayColor.h
//  ikframework
//
//  Created by Federico Gasperini on 14/03/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (overlayColor)

-(CGRect)bound;

- (UIImage *)imageWithColor:(UIColor *)color1;

-(UIImage*)imageByDrawingImage:(UIImage*)image
                        inRect:(CGRect)rect
                     withColor:(UIColor*)color;

@end
