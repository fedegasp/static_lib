//
//  UIView+Screenshot.h
//  MASClient
//
//  Created by Gai, Fabio on 19/12/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Screenshot)

+(UIImage *)renderImageFromLayer:(UIView *)view withRect:(CGRect)frame;
-(UIImage *)renderImageWithRect:(CGRect)frame;
-(UIImage *)renderImage;

@end
