//
//  MRCircleView.m
//  MRCircleLoader
//
//  Created by Gai, Fabio on 24/04/15.
//  Copyright (c) 2015 Gai, Fabio. All rights reserved.
//

#import "MRCircleLoader.h"

@interface MRCircleLoader (){
    
    CAShapeLayer *layer;
    BOOL terminateAnimation;
}

@end

@implementation MRCircleLoader

- (void)drawRect:(CGRect)rect {
    
    //self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 50, 50);
    self.clipsToBounds = YES;
    self.layer.cornerRadius = self.frame.size.width/2;
    
    layer = [[CAShapeLayer alloc] init];
    layer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.bounds, 4, 4)].CGPath;
    if (!self.strokeColor)
        layer.strokeColor = [UIColor magentaColor].CGColor;
    else
        layer.strokeColor = self.strokeColor.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth   = 1.0;
    layer.strokeStart = 0.0 ;
    layer.strokeEnd = .6;
    layer.shouldRasterize = NO;
    layer.speed=.05;
    layer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:layer];
    self.backgroundColor = [UIColor clearColor];
    [self startAnimation];
}

-(void)startAnimation{
    
    CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.byValue = @(2 * M_PI);
    spinAnimation.duration = .65;
    spinAnimation.repeatCount = INFINITY;
    
    [self.layer addAnimation:spinAnimation forKey:@"indeterminateAnimation"];
}


@end
