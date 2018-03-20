//
//  UIImage+mask.h
//  test
//
//  Created by Federico Gasperini on 17/02/17.
//  Copyright © 2017 Federico Gasperini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (mask)

-(UIImage*)mask;
+(UIImage*)maskImageWithRoundedCorners:(UIRectCorner)maskCorners
                                  size:(CGSize)size
                             andRadius:(CGFloat)radius;

@end
