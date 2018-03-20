//
//  PopUpTransition.m
//  dpr
//
//  Created by Gai, Fabio on 20/09/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import "MRPopUpTransition.h"

@implementation MRPopUpTransition

-(void)presentViewController:(UIViewController *)modalViewController
          fromViewController:(UIViewController *)mainViewController
           transitionContext:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    [transitionContext.containerView addSubview:modalViewController.view];
    modalViewController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    self.popUpView.center = modalViewController.view.center;
    self.popUpView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    
    [UIView animateWithDuration:0.5 animations:^{
        modalViewController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }completion:nil];
    
    [UIView animateWithDuration: .35
                          delay: 0
         usingSpringWithDamping: 10
          initialSpringVelocity: 10
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.popUpView.transform = CGAffineTransformIdentity;
                     }completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
    
}


-(void)dismissViewController:(UIViewController *)modalViewController
         popToViewController:(UIViewController *)mainViewController
           transitionContext:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    [UIView animateWithDuration:0.25 animations:^{
        modalViewController.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        self.popUpView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}



@end
