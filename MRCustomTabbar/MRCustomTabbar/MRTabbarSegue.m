//
//  IKTabbarSegue.m
//  CustomContainer
//
//  Created by Federico Gasperini on 20/04/16.
//  Copyright © 2016 Accenture. All rights reserved.
//

#import "MRTabbarSegue.h"
#import "MRAbstractCustomTabbarController.h"

@implementation MRTabbarSegue

-(void)perform
{
   MRAbstractCustomTabbarController *sourceViewController = self.sourceViewController;
   UIViewController* t = [sourceViewController currentLoadedAtIndex:sourceViewController.selectedIndex];
   if (![t isKindOfClass:UIViewController.class])
      t = self.destinationViewController;
      
   [sourceViewController setViewController:t
                                   atIndex:sourceViewController.selectedIndex];
}

@end
