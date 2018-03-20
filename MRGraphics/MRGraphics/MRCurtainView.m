//
//  UIView+curtain.m
//  MRGraphics
//
//  Created by Federico Gasperini on 06/10/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "MRCurtainView.h"
#import <MRBase/lib.h>

#pragma -- mark MRCurtainView implementation

@implementation MRCurtainView
{
    __weak UIViewController* _viewController;
    BOOL _run;
}

-(void)didMoveToWindow
{
    [self unregisterNotifications];
    [super didMoveToWindow];
    _viewController = self.viewController;
    if (!self.disableAutomaticAppearance)
        [self registerNotifications];
}

-(void)setDisableAutomaticAppearance:(BOOL)disableAutomaticAppearance
{
    _disableAutomaticAppearance = disableAutomaticAppearance;
    if (disableAutomaticAppearance)
        [self unregisterNotifications];
    else
        [self registerNotifications];
}

-(void)registerNotifications
{
    if (_viewController)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(willAppear:)
                                                     name:UIViewControllerWillAppear
                                                   object:_viewController];
        if ([_viewController viewWillAppearPassed])
            [self willAppear:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didAppear:)
                                                     name:UIViewControllerDidAppear
                                                   object:_viewController];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(willDisappear:)
                                                     name:UIViewControllerWillDisappear
                                                   object:_viewController];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didDisappear:)
                                                     name:UIViewControllerDidDisappear
                                                   object:_viewController];
    }
}

-(void)unregisterNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIViewControllerWillAppear
                                                  object:_viewController];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIViewControllerDidAppear
                                                  object:_viewController];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIViewControllerWillDisappear
                                                  object:_viewController];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIViewControllerDidDisappear
                                                  object:_viewController];
}

-(void)willAppear:(NSNotification*)notification
{
    if (self.reversable || !_run)
    {
        self.userInteractionEnabled = self.startsVisible;
        self.hidden = !self.startsVisible;
    }
}

-(void)didAppear:(NSNotification*)notification
{
    if (self.reversable || !_run)
        [self show];
}

-(void)willDisappear:(NSNotification*)notification
{
    if (self.reversable)
        [self hide];
}

-(void)didDisappear:(NSNotification*)notification
{
}


-(void)hideWithAnimation:(BOOL)animated
{
    
    NSTimeInterval duration = DEFAULT_ANIMATION_DURATION;
    
    if (!animated){
        
        duration = 0;
    }
    
    WEAK_REF(self);
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if (_self.fading)
                             _self.alpha = 0.0;
                         _self.transform = [_self translatedTransform];
                     }
                     completion:nil];
}

-(void)hide
{
    
    
    WEAK_REF(self);
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:DEFAULT_ANIMATION_DURATION
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if (_self.fading)
                             _self.alpha = 0.0;
                         _self.transform = [_self translatedTransform];
                     }
                     completion:nil];
}



-(void)showWithAnimation:(BOOL)animated
{
    
    NSTimeInterval duration = DEFAULT_ANIMATION_DURATION;
    
    if (!animated){
        
        duration = 0;
    }
    
    if (!self.userInteractionEnabled)
    {
        self.transform = [self translatedTransform];
        if (self.fading)
            self.alpha = .0;
        self.userInteractionEnabled = YES;
        self.hidden = NO;
        WEAK_REF(self);
        [UIView animateWithDuration:duration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             _self.alpha = 1.0;
                             _self.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {
                             _run = finished;
                         }];
    }
}

-(void)show
{
    
   
    if (!self.userInteractionEnabled)
    {
        self.transform = [self translatedTransform];
        if (self.fading)
            self.alpha = .0;
        self.userInteractionEnabled = YES;
        self.hidden = NO;
        WEAK_REF(self);
        [UIView animateWithDuration:DEFAULT_ANIMATION_DURATION
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             _self.alpha = 1.0;
                             _self.transform = CGAffineTransformIdentity;
                         }
                         completion:^(BOOL finished) {
                             _run = finished;
                         }];
    }
}


- (CGAffineTransform)translatedTransform
{
    
    CGPoint offset = CGPointZero;
    UIView *w = self.viewController.view;
    CGRect space = w.frame;
    CGRect absoluteBounds = [self convertRect:self.bounds toView:w];
    switch (self.origin)
    {
        case CourtainBottom:
            offset.y = space.size.height - absoluteBounds.origin.y;
            break;
            
        case CourtainLeft:
            offset.x = -(absoluteBounds.origin.x + absoluteBounds.size.width);
            break;
            
        case CourtainRight:
            offset.x = space.size.width - absoluteBounds.origin.x;
            break;

        case CourtainTop:
        default:
            offset.y = -(absoluteBounds.origin.y + absoluteBounds.size.height);
            break;
    }
    return CGAffineTransformTranslate(self.transform, offset.x, offset.y);
}

-(BOOL)fading
{
    if ([[UIDevice getDeviceHardware] isEqualToString:@"iPhone X"])
        return YES;
    return _fading;
}

@end

#pragma -- mark MRCurtainView (ibinspectable) implemetation

@implementation MRCurtainView (ibinspectable)

@dynamic origin;

@end

