//
//  TransitionAnimatorObject.h
//  dpr
//
//  Created by Gai, Fabio on 21/01/16.
//  Copyright © 2016 Federico Gasperini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIViewController+Transition.h"

@protocol MRTransitionObjectProtocol <NSObject>
@optional
-(void)prepareForPresentation;
-(void)prepareForDismission;

-(void)presentViewController:(UIViewController*)modalViewController
    fromViewController:(UIViewController*)mainViewController
           transitionContext:(id <UIViewControllerContextTransitioning>)transitionContext;

-(void)dismissViewController:(UIViewController*)modalViewController
    popToViewController:(UIViewController*)mainViewController
           transitionContext:(id <UIViewControllerContextTransitioning>)transitionContext;

-(void)panToDismissViewController:(UIViewController*)modalViewController
                    onPanningView:(UIView *)panningView
         popToViewController:(UIViewController*)mainViewController
           recognizer:(UIPanGestureRecognizer*)recognizer;

@end

@interface MRTransitionObject : NSObject<MRTransitionObjectProtocol>
@property (nonatomic, strong) NSMutableSet *keys;
@property (assign) IBInspectable CGFloat duration;
@property (assign) IBInspectable CGFloat tag;
@property (nonatomic, weak) id parent;
@property (nonatomic, weak) UIViewController *modalViewController;
@property (nonatomic, weak) UIViewController *mainViewController;
@end
