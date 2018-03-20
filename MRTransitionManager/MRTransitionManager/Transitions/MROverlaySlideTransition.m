//
//  OverlaySlideTransition.m
//  Giruland
//
//  Created by Gai, Fabio on 04/10/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import "MROverlaySlideTransition.h"

@interface MROverlaySlideTransition ()
@property CGRect originalContainerFrame;
@property CGRect hiddenContainerFrame;
@property CGPoint oldDisplacement;
@property BOOL negativeTraslation;
@end

@implementation MROverlaySlideTransition

-(void)presentViewController:(UIViewController *)modalViewController
          fromViewController:(UIViewController *)mainViewController
           transitionContext:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    if (self.tapToDismiss) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self.overlayView addGestureRecognizer:tap];
    }
    
    [transitionContext.containerView addSubview:modalViewController.view];
    [modalViewController.view setBackgroundColor:[self.overlayColor colorWithAlphaComponent:0]];
    [modalViewController.view layoutIfNeeded];
    [self.container layoutIfNeeded];
    [self setOriginalContainerFrame:self.container.frame];
    [self hiddenFrame];
    
    
//    [UIView animateWithDuration:0.45 animations:^{
//        mainViewController.view.alpha = 0.2;
//        mainViewController.view.transform = CGAffineTransformMakeScale(0.96, 0.96);
//    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        modalViewController.view.backgroundColor = [self.overlayColor colorWithAlphaComponent:self.overlayAlpha];
    }completion:nil];
    
    [UIView animateWithDuration: .55
                          delay: 0
         usingSpringWithDamping: 10
          initialSpringVelocity: 1
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.container.frame = self.originalContainerFrame;
                     }completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
    
}

-(void)tap:(UIGestureRecognizer*)recognizer{
    [self.modalViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)dismissViewController:(UIViewController *)modalViewController
         popToViewController:(UIViewController *)mainViewController
           transitionContext:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    [UIView animateWithDuration:0.25 animations:^{
//        mainViewController.view.transform = CGAffineTransformIdentity;
//        mainViewController.view.alpha = 1;
        [modalViewController.view setBackgroundColor:[self.overlayColor colorWithAlphaComponent:0]];
        [self.container setFrame:self.hiddenContainerFrame];
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

-(void)panToDismissViewController:(UIViewController *)modalViewController
                    onPanningView:(UIView *)panningView
              popToViewController:(UIViewController *)mainViewController
                       recognizer:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:modalViewController.view];
    CGFloat percentage = translation.y/panningView.frame.size.height;
    CGPoint displacement = CGPointMake(translation.x, translation.y);
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            break;
            
        case UIGestureRecognizerStateChanged:
            
            if ([self canPan:displacement]) {
                [self setAlpha:percentage];
                [self pan:displacement];
                [self negativeTranslation:displacement];
                [self setOldDisplacement:displacement];
            }
            break;
            
        case UIGestureRecognizerStateEnded:
            if (self.negativeTraslation) {
                [modalViewController dismissViewControllerAnimated:YES completion:nil];
            }else{
                [UIView animateWithDuration: .5
                                      delay: 0
                     usingSpringWithDamping: .8
                      initialSpringVelocity: 2
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     modalViewController.view.backgroundColor = [self.overlayColor colorWithAlphaComponent:self.overlayAlpha];
                                     self.container.transform = CGAffineTransformIdentity;
                                 } completion:nil];
            }
            
            break;
            
        default:
            break;
    }
}

-(void)hiddenFrame{
    
    CGRect  pf = self.modalViewController.view.frame;
    CGSize  ps = pf.size;
    CGRect  cf = self.originalContainerFrame;
    CGPoint co = cf.origin;
    CGSize  cs = cf.size;
    
    switch (self.direction) {
        case slideUp:
            self.hiddenContainerFrame = CGRectMake(co.x,
                                                   co.y+ps.height,
                                                   cs.width,
                                                   cs.height);
            break;
        case slideDown:
            self.hiddenContainerFrame = CGRectMake(co.x,
                                                   -ps.height,
                                                   cs.width,
                                                   cs.height);
            break;
        case slideLeft:
            self.hiddenContainerFrame = CGRectMake(-ps.width,
                                                   co.y,
                                                   cs.width,
                                                   cs.height);
            break;
        case slideRight:
            self.hiddenContainerFrame = CGRectMake(co.x+ps.width,
                                                   co.y,
                                                   cs.width,
                                                   cs.height);
            break;
        default:
            break;
    }
    
    [self.container setFrame:self.hiddenContainerFrame];
}

-(BOOL)canPan:(CGPoint)displacement{
    switch (self.direction) {
        case slideUp:
            return displacement.y > 0;
            break;
        case slideDown:
            return displacement.y < 0;
            break;
        case slideLeft:
            return displacement.x < 0;
            break;
        case slideRight:
            return displacement.x > 0;
            break;
        default:
            return NO;
            break;
    }
}

-(void)setAlpha:(CGFloat)percentage{
    CGFloat alpha = self.overlayAlpha - ((percentage < 0 ? -percentage : percentage));
    self.modalViewController.view.backgroundColor = [self.overlayColor colorWithAlphaComponent:alpha];
}

-(void)pan:(CGPoint)displacement{
    CGAffineTransform transform;
    switch (self.direction) {
        case slideUp:
            transform = CGAffineTransformMakeTranslation(0, displacement.y);
            break;
        case slideDown:
            transform = CGAffineTransformMakeTranslation(0, displacement.y);
            break;
        case slideLeft:
            transform = CGAffineTransformMakeTranslation(displacement.x, 0);
            break;
        case slideRight:
            transform = CGAffineTransformMakeTranslation(displacement.x, 0);
            break;
        default:
            transform = CGAffineTransformIdentity;
            break;
    }
    self.container.transform = transform;
}

-(CGFloat)displacementForSlideDirection:(CGPoint)displacement{
    switch (self.direction) {
        case slideUp:
            return displacement.y;
            break;
        case slideDown:
            return -displacement.y;
            break;
        case slideLeft:
            return -displacement.x;
            break;
        case slideRight:
            return displacement.x;
            break;

        default:
            return 0;
            break;
    }
}

-(void)negativeTranslation:(CGPoint)displacement{
    CGFloat d = [self displacementForSlideDirection:displacement];
    CGFloat oldD = [self displacementForSlideDirection:self.oldDisplacement];
    BOOL ng =  d > oldD;
    [self setNegativeTraslation:ng];
}

@end
