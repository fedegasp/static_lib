//
//  MRSegueTabbarController.m
//  CustomContainer
//
//  Created by Federico Gasperini on 20/04/16.
//  Copyright © 2016 Accenture. All rights reserved.
//

#import "MRSegueTabbarController.h"

@interface MRSegueTabbarController ()


@end

@implementation MRSegueTabbarController
{
   NSArray* _viewControllersSegue;
}

-(void)setSegues:(NSString *)segues
{
   [super setSegues:segues];
   _viewControllersSegue = [segues componentsSeparatedByString:@";"];
}

-(void)loadViewControllerAtIndex:(NSUInteger)idx
{
   [self performSegueWithIdentifier:_viewControllersSegue[idx]
                             sender:nil];
}

@end
