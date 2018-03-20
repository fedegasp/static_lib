//
//  MKenBurns.m
//  Mobily
//
//  Created by Gai, Fabio on 14/10/15.
//  Copyright © 2015 accenture. All rights reserved.
//

#import "MRKenBurns.h"

@implementation MRKenBurns

-(void)awakeFromNib{
    [super awakeFromNib];
}

-(void)layoutSubviews{
    if (!self.firstTime) {
        UIImage *patternImage = [UIImage imageNamed:self.imageName];
        self.layer.contents = (id)patternImage.CGImage;
        self.layer.contentsGravity = [self gravityForContentMode];
        self.layer.geometryFlipped = true;
        [self.layer addAnimation:[self createLayerAnimation] forKey:nil];
        [self setFirstTime:YES];
    }
}

-(NSString *)gravityForContentMode{
    
    switch (self.contentMode) {
        case UIViewContentModeTop:
            return kCAGravityTop;
            break;
        case UIViewContentModeLeft:
            return kCAGravityLeft;
            break;
        case UIViewContentModeRight:
            return kCAGravityRight;
            break;
        case UIViewContentModeBottom:
            return kCAGravityBottom;
            break;
        case UIViewContentModeCenter:
            return kCAGravityCenter;
            break;
        case UIViewContentModeRedraw:
            return kCAGravityResize;
            break;
        case UIViewContentModeTopLeft:
            return kCAGravityTopLeft;
            break;
        case UIViewContentModeTopRight:
            return kCAGravityTopRight;
            break;
        case UIViewContentModeBottomLeft:
            return kCAGravityBottomLeft;
            break;
        case UIViewContentModeBottomRight:
            return kCAGravityBottomRight;
            break;
        case UIViewContentModeScaleToFill:
            return kCAGravityResizeAspect;
            break;
        case UIViewContentModeScaleAspectFit:
            return kCAGravityResizeAspect;
            break;
        default:
            return kCAGravityResizeAspectFill;
            break;
    }
}

-(void)reverse{
    [self.layer setAffineTransform:CGAffineTransformMakeScale(1, -1)];
}

-(void)straighten{
    [self.layer setAffineTransform:CGAffineTransformMakeScale(1, 1)];
}


- (CAAnimationGroup *)createLayerAnimation {
    
    CABasicAnimation* translateY = [CABasicAnimation animationWithKeyPath:@"position.y"];
    translateY.toValue = [NSNumber numberWithFloat:self.center.y-(self.frame.size.height/6)];
    translateY.repeatCount = HUGE_VALF;
    translateY.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    translateY.removedOnCompletion = NO;
    translateY.autoreverses = YES;
    translateY.fillMode = kCAFillModeForwards;
    translateY.beginTime = 6;
    translateY.duration = 18;
    [translateY setDelegate:(id)self];
    
    CABasicAnimation* translateX = [CABasicAnimation animationWithKeyPath:@"position.x"];
    CGFloat width = self.frame.size.width;
    CGFloat widthPercent = (width/100)*15;
    translateX.toValue = [NSNumber numberWithFloat:self.center.x+widthPercent];
    translateX.repeatCount = HUGE_VALF;
    translateX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    translateX.removedOnCompletion = NO;
    translateX.autoreverses = YES;
    translateX.fillMode = kCAFillModeForwards;
    translateX.beginTime = 6;
    translateX.duration = 18;
    
    CABasicAnimation* zoomOut = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    zoomOut.fromValue = [NSNumber numberWithFloat:1.0];
    zoomOut.toValue = [NSNumber numberWithFloat:1.6];
    zoomOut.repeatCount = HUGE_VALF;
    zoomOut.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    zoomOut.removedOnCompletion = NO;
    zoomOut.autoreverses = YES;
    zoomOut.fillMode = kCAFillModeForwards;
    zoomOut.duration = 24;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    [group setDuration:24.0];
    [group setRepeatCount:HUGE_VALF];
    [group setRemovedOnCompletion:NO];
    [group setAutoreverses:YES];
    [group setAnimations:[NSArray arrayWithObjects:translateX,translateY,zoomOut, nil]];
    
    return group;
}

@end
