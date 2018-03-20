//
//  UIViewController+Transition.h
//  TransitionManager
//
//  Created by Gai, Fabio on 12/09/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRTransitionObject.h"
@class MRTransitionObject;
@interface UIViewController (Transition)
@property (readwrite) IBOutlet id <UIViewControllerTransitioningDelegate> transitioningDelegate;
@property (weak, nonatomic) IBOutlet MRTransitionObject *passingTansitionObject;
@property (strong, nonatomic) IBOutletCollection(MRTransitionObject) NSArray<MRTransitionObject*>* passingTansitionObjects;
@property (unsafe_unretained) IBOutlet UIView* closePanningView;
@end
