//
//  PopUpTransition.m
//  dpr
//
//  Created by Gai, Fabio on 21/01/16.
//  Copyright © 2016 Federico Gasperini. All rights reserved.
//

#import "MRSplashTransition.h"

@implementation MRSplashTransition

-(void)presentViewController:(UIViewController*)presented
          fromViewController:(UIViewController*)mainViewController
           transitionContext:(id <UIViewControllerContextTransitioning>)transitionContext
{
  
    CGFloat x = 16.0;
    CGFloat y = 32.0;
    
    self.splashView = [[UIView alloc] initWithFrame:CGRectMake(x, y, 20, 20)];
    
    if (self.startButton) {
        self.splashView.center = self.startButton.center;
    }
    
    self.splashView.backgroundColor = [UIColor blackColor];
    self.splashView.clipsToBounds = YES;
    self.splashView.layer.cornerRadius = self.splashView.frame.size.width/2;
    
    [transitionContext.containerView addSubview:self.splashView];
    [transitionContext.containerView addSubview:presented.view];
    [presented.view setMaskView:self.splashView];
    
    [UIView animateWithDuration:0.35
                     animations:^{
                         self.splashView.transform = CGAffineTransformMakeScale(200, 200);
                     } completion:^(BOOL finished){
                         [transitionContext completeTransition:YES];
                     }];
    
}

-(void)dismissViewController:(UIViewController*)presented
         popToViewController:(UIViewController*)mainViewController
           transitionContext:(id <UIViewControllerContextTransitioning>)transitionContext
{
    [transitionContext.containerView addSubview:presented.view];
    [presented.view setMaskView:self.splashView];
    
    [UIView animateWithDuration:.7
                     animations:^{
                         self.splashView.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         
                         [self.splashView removeFromSuperview];
                         [transitionContext completeTransition:YES];
                     }];
    
}
@end
