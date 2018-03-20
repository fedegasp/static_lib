//
//  PopUpAnimationController.m
//  dpr
//
//  Created by Gai, Fabio on 21/01/16.
//  Copyright © 2016 Federico Gasperini. All rights reserved.
//

#import "MRTransitionManager.h"
#import <objc/runtime.h>

@interface MRTransitionManager ()

@property (assign) BOOL isPresenting;
@end

@implementation MRTransitionManager

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController*)presented
                                                                 presentingController:(UIViewController*)presenting
                                                                     sourceController:(UIViewController*)source
{
    self.isPresenting = YES;
    self.mainViewController =presenting;
    self.modalViewController =presented;
    [self setTransitionObjectControllers];
    
    UIView* viewForPan = [self.modalViewController closePanningView];
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(panToDismiss:)];
    pan.delaysTouchesBegan = YES;
    [viewForPan addGestureRecognizer:pan];
    
    [self mixPropertyOfTransitionObject];
    if ([self.transitionObject respondsToSelector:@selector(prepareForPresentation)]) {
        [self.transitionObject prepareForPresentation];
    }
    return self;
}

-(void)mixPropertyOfTransitionObject{
    
    if ([self.mainViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)self.mainViewController;
        self.mainViewController = [nav.viewControllers lastObject];
    }
    MRTransitionObject *passingTransitionObject = self.mainViewController.passingTansitionObject;
    for (MRTransitionObject *pto in self.mainViewController.passingTansitionObjects) {
        if ([pto isKindOfClass:[self.transitionObject class]]) {
            passingTransitionObject = pto;
        }
    }
    
    unsigned int numberOfProperties = 0;
    objc_property_t *passingPropertyArray = class_copyPropertyList([passingTransitionObject class], &numberOfProperties);
    
    for (NSUInteger i = 0; i < numberOfProperties; i++) {
        objc_property_t passedProperty = passingPropertyArray[i];
        NSString *name = [[NSString alloc] initWithUTF8String:property_getName(passedProperty)];
        NSValue *v = [passingTransitionObject valueForKey:name];
        if ([self.transitionObject valueForKey:name] == nil) {
            [self.transitionObject setValue:v forKey:name];
        }
    }
    passingTransitionObject.parent = self.transitionObject;
    free(passingPropertyArray);
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.isPresenting = NO;
    [self setTransitionObjectControllers];
    if ([self.transitionObject respondsToSelector:@selector(prepareForDismission)]) {
         [self.transitionObject prepareForDismission];
    }
    return self;
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}

-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return self.transitionObject.duration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    [[transitionContext containerView] setNonModal:YES];
    [self setTransitionObjectControllers];
    
    if (self.isPresenting) {
        if ([self.transitionObject respondsToSelector:@selector(presentViewController:fromViewController:transitionContext:)]) {
            [self.transitionObject presentViewController:self.modalViewController
                                      fromViewController:self.mainViewController
                                       transitionContext:transitionContext];
        }
    }else{
        if ([self.transitionObject respondsToSelector:@selector(dismissViewController:popToViewController:transitionContext:)]) {
            //[self.mainViewController viewWillAppear:YES];
            [self.transitionObject dismissViewController:self.modalViewController
                                     popToViewController:self.mainViewController
                                       transitionContext:transitionContext];
        }
    }
}

-(void)panToDismiss:(UIPanGestureRecognizer*)recognizer
{
    if (self.panToDismiss) {
        [self setTransitionObjectControllers];
        if ([self.transitionObject respondsToSelector:@selector(panToDismissViewController:onPanningView:popToViewController:recognizer:)]) {
            [self.transitionObject panToDismissViewController:self.modalViewController
                                                onPanningView:self.modalViewController.closePanningView
                                          popToViewController:self.mainViewController
                                                   recognizer:recognizer];
        }
    }
}

-(void)setTransitionObjectControllers{
    self.transitionObject.modalViewController = _modalViewController;
    self.transitionObject.mainViewController = _mainViewController;
}

@end
