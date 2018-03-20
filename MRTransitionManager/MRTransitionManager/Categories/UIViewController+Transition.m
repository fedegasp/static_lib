//
//  UIViewController+Transition.m
//  TransitionManager
//
//  Created by Gai, Fabio on 12/09/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import "UIViewController+Transition.h"
#import <objc/runtime.h>

NSString const *transition_key =  @"unique.transition_key";
NSString const *transitions_key =  @"unique.transitions_key";

@implementation UIViewController (Transition)
@dynamic transitioningDelegate;

-(MRTransitionObject *)passingTansitionObject{
    return objc_getAssociatedObject(self, &transition_key);
}
-(void)setPassingTansitionObject:(MRTransitionObject *)passingTansitionObject{
    objc_setAssociatedObject(self, &transition_key, passingTansitionObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSArray<MRTransitionObject *> *)passingTansitionObjects{
    return objc_getAssociatedObject(self, &transitions_key);
}
-(void)setPassingTansitionObjects:(NSArray<MRTransitionObject *> *)passingTansitionObjects
{
    objc_setAssociatedObject(self, &transitions_key, passingTansitionObjects, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setClosePanningView:(UIView *)closePanningView
{
    objc_setAssociatedObject(self, @selector(closePanningView), closePanningView, OBJC_ASSOCIATION_ASSIGN);
}

-(UIView*)closePanningView
{
    return objc_getAssociatedObject(self, @selector(closePanningView)) ?: self.view;
}

@end
