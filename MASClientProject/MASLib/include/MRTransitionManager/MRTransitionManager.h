//
//  PopUpAnimationController.h
//  dpr
//
//  Created by Gai, Fabio on 21/01/16.
//  Copyright © 2016 Federico Gasperini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+nonModalBehaviour.h"
#import "UIViewController+Transition.h"

@class MRTransitionObject;
@interface MRTransitionManager : UIPercentDrivenInteractiveTransition <UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>

@property (weak, nonatomic) IBOutlet MRTransitionObject *transitionObject;
@property (nonatomic) IBInspectable BOOL panToDismiss;

@property (weak, nonatomic) IBOutlet UIViewController* mainViewController;
@property (weak, nonatomic) IBOutlet UIViewController* modalViewController;

@end


