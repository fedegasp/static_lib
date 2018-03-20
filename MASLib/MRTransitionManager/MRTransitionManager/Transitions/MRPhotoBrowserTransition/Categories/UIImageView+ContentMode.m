//
//  UIImageView+ContentMode.m
//  TransitionManager
//
//  Created by Gai, Fabio on 31/08/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import "UIImageView+ContentMode.h"

@implementation UIImageView (ContentMode)

-(CGSize)aspectFillInView:(UIView *)view
{
    CGSize imageSize = CGSizeMake(self.image.size.width / self.image.scale,
                                  self.image.size.height / self.image.scale);
    
    CGFloat widthRatio = imageSize.width / view.bounds.size.width;
    CGFloat heightRatio = imageSize.height / view.bounds.size.height;
    
    if (widthRatio > heightRatio) {
        imageSize = CGSizeMake(imageSize.width / heightRatio, imageSize.height / heightRatio);
    } else {
        imageSize = CGSizeMake(imageSize.width / widthRatio, imageSize.height / widthRatio);
    }
    
    return imageSize;
}


-(CGSize)aspectFillInController:(UIViewController *)controller
{
    CGSize imageSize = CGSizeMake(self.image.size.width / self.image.scale,
                                  self.image.size.height / self.image.scale);
    
    CGFloat widthRatio = imageSize.width / controller.view.bounds.size.width;
    CGFloat heightRatio = imageSize.height / controller.view.bounds.size.height;
    
    if (widthRatio > heightRatio) {
        imageSize = CGSizeMake(imageSize.width / heightRatio, imageSize.height / heightRatio);
    } else {
        imageSize = CGSizeMake(imageSize.width / widthRatio, imageSize.height / widthRatio);
    }
    
    return imageSize;
}

-(CGSize)aspectFitInView:(UIView *)view
{
    CGSize imageSize = CGSizeMake(self.image.size.width / self.image.scale,
                                  self.image.size.height / self.image.scale);
    
    CGFloat widthRatio = imageSize.width / view.bounds.size.width;
    CGFloat heightRatio = imageSize.height / view.bounds.size.height;
    
    if (widthRatio > heightRatio) {
        imageSize = CGSizeMake(imageSize.width / widthRatio, imageSize.height / widthRatio);
    } else {
        imageSize = CGSizeMake(imageSize.width / heightRatio, imageSize.height / heightRatio);
    }
    
    return imageSize;
}

-(CGSize)aspectFitInController:(UIViewController *)controller{
    
    CGSize imageSize = CGSizeMake(self.image.size.width / self.image.scale,
                                  self.image.size.height / self.image.scale);
    
    CGFloat widthRatio = imageSize.width / controller.view.bounds.size.width;
    CGFloat heightRatio = imageSize.height / controller.view.bounds.size.height;
    
    if (widthRatio > heightRatio) {
        imageSize = CGSizeMake(imageSize.width / widthRatio, imageSize.height / widthRatio);
    } else {
        imageSize = CGSizeMake(imageSize.width / heightRatio, imageSize.height / heightRatio);
    }

    return imageSize;
}


-(void)animateSize:(CGSize)size{
    
    [UIView animateWithDuration:.45
                          delay:0.0
         usingSpringWithDamping:1.5
          initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.bounds = CGRectMake(0, 0, size.width, size.height);
                     } completion:nil];
}

@end
