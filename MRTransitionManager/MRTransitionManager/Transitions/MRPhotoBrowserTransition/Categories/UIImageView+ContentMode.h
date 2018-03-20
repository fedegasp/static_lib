//
//  UIImageView+ContentMode.h
//  TransitionManager
//
//  Created by Gai, Fabio on 31/08/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ContentMode)
-(CGSize)aspectFillInController:(UIViewController *)controller;
-(CGSize)aspectFillInView:(UIView *)view;
-(CGSize)aspectFitInController:(UIViewController *)controller;
-(CGSize)aspectFitInView:(UIView *)view;
-(void)animateSize:(CGSize)size;
@end
