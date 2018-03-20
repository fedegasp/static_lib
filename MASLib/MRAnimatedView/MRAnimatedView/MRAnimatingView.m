//
//  AnimatingView.m
//  SplashAnimation
//
//  Created by Gai, Fabio on 29/02/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import "MRAnimatingView.h"

@implementation MRAnimatingView

-(UIImage *)patternImage{
    return [UIImage imageNamed:self.image];
}

-(void)layoutSubviews{
    
    [self.superview layoutIfNeeded];
    UIColor *Pattern = [self createPatterFromImage:self.patternImage];
    CALayer *ImageLayer = [self createLayerWithPattern:Pattern];
    [self.layer addSublayer:ImageLayer];
    
    CABasicAnimation *LayerAnimation = [self createLayerAnimation];
    [ImageLayer addAnimation:LayerAnimation forKey:@"position"];
    
    self.clipsToBounds = NO;
}


- (UIColor *)createPatterFromImage:(UIImage *)image{
    
    return [UIColor colorWithPatternImage:image];
}

- (CALayer *)createLayerWithPattern:(UIColor *)pattern {
    
    CALayer *tmpLayer = [CALayer layer];
    tmpLayer.backgroundColor = pattern.CGColor;
    tmpLayer.transform = CATransform3DMakeScale(1, -1, 1);
    tmpLayer.anchorPoint = CGPointMake(0, 1);
    CGSize viewSize = self.bounds.size;
    tmpLayer.frame = CGRectMake(0, 0, self.patternImage.size.width + viewSize.width, self.patternImage.size.height);
    return tmpLayer;
}

- (CABasicAnimation *)createLayerAnimation {
    
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointMake(-self.patternImage.size.width, 0);
    CABasicAnimation *Animation = [CABasicAnimation animationWithKeyPath:@"position"];
    Animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    if (self.reverse) {
        Animation.fromValue = [NSValue valueWithCGPoint:endPoint];
        Animation.toValue = [NSValue valueWithCGPoint:startPoint];
    }else{
        Animation.fromValue = [NSValue valueWithCGPoint:startPoint];
        Animation.toValue = [NSValue valueWithCGPoint:endPoint];
    }
    Animation.repeatCount = HUGE_VALF;
    Animation.duration = self.duration;
    return Animation;
}

@end
