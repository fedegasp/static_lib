//
//  MRConfigurableTabbarController.m
//  iconick-lib
//
//  Created by Federico Gasperini on 14/10/16.
//  Copyright © 2016 accenture. All rights reserved.
//

#import "MRConfigurableTabbarController.h"

@implementation MRConfigurableTabbarController

-(void)setConfiguration:(MRTabbarConfiguration *)configuration
{
   _configuration = configuration;
   _configuration.tabbarController = self;
}

-(void)loadViewControllerAtIndex:(NSUInteger)idx
{
   UIViewController* v = [self currentLoadedAtIndex:idx];
   if (!v)
      v = [self.configuration loadViewControllerAtIndex:idx];
   if (v)
      [self setViewController:v
                      atIndex:idx];
}

-(void)animationFinished:(UIViewController *)childController
{
    [super animationFinished:childController];
    if ([self.configuration isTransientAtIndex:self.lastSelectedIndex] &&
        self.viewControllerContainers[self.lastSelectedIndex] != [NSNull null])
    {
        [[self.viewControllerContainers[self.lastSelectedIndex] view] removeFromSuperview];
        [self.viewControllerContainers[self.lastSelectedIndex] removeFromParentViewController];
        [self.viewControllerContainers[self.lastSelectedIndex] didMoveToParentViewController:nil];
        self.viewControllerContainers[self.lastSelectedIndex] = [NSNull null];
    }
}

@end
