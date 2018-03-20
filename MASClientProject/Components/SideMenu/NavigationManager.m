//
//  NavigationManager.m
//  MASClient
//
//  Created by Gai, Fabio on 26/12/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import "NavigationManager.h"

@implementation NavigationManager

+ (id)sharedInstance
{
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        
        _sharedObject = [[self alloc] init];
        [_sharedObject setDefault];
        //[_sharedObject startMonitoringRechability];
    });
    return _sharedObject;
}

-(void)setDefault{
//    [self.sideViewController.dismissButton addTarget:self
//                                             action:@selector(closeMenu)
//                                   forControlEvents:UIControlEventTouchUpInside];
}

NavigationManager* navigationManager()
{
    return [NavigationManager sharedInstance];
}

-(void)openMenu{
    [self.sideViewController.dismissButton setHidden:NO];
    [[self menuController] beginAppearanceTransition:YES
                                            animated:YES];
    [UIView animateWithDuration:.25
                     animations:^{
                         [self.sideViewController.dismissButton setAlpha:1];
                         if (!IS_IPAD) {
                             [self.sideViewController.dismissButton setBackgroundColor:[UIColor whiteColor]];
                         }
                         [self.sideViewController.mainConstraint setConstant:300];
                         [self.sideViewController.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         [[self menuController] endAppearanceTransition];
                     }];
}

-(void)closeMenu{
   
   [[self menuController] beginAppearanceTransition:NO
                                           animated:YES];
    [UIView animateWithDuration:.25
                     animations:^{
                         [self.sideViewController.dismissButton setAlpha:0];
                         [self.sideViewController.mainConstraint setConstant:0];
                         [self.sideViewController.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         [self.sideViewController.dismissButton setHidden:YES];
                         [[self menuController] endAppearanceTransition];
                     }];
}

-(void)navigateTo:(NSString*)identifier
     withPostData:(id)postData{
    [self closeMenu];
    [self.sideViewController executeMenuAction:identifier
                        onNavigationController:self.mainNavigationController
                                 withModelData:nil
                                   andPostData:postData];
}

-(void)navigateTo:(NSString*)identifier{
    [self closeMenu];
    [self.sideViewController executeMenuAction:identifier
                        onNavigationController:self.mainNavigationController
                                 withModelData:nil
                                   andPostData:nil];
}

@end
