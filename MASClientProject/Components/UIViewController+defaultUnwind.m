//
//  UIViewController+defaultUnwind.m
//  MASClient
//
//  Created by Federico Gasperini on 04/11/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import "UIViewController+defaultUnwind.h"

BOOL _portraitLocked = YES;

#import <MRBase/JRSwizzle.h>

@implementation UIViewController (defaultUnwind)

+(void)load
{
    [self jr_swizzleMethod:@selector(viewWillAppear:)
                withMethod:@selector(sbs_viewWillAppear:)
                     error:NULL];
    [self jr_swizzleMethod:@selector(preferredStatusBarStyle)
                withMethod:@selector(sbs_preferredStatusBarStyle)
                     error:NULL];
}

-(void)sbs_viewWillAppear:(BOOL)animated
{
   [self sbs_viewWillAppear:animated];
    
    if (self.lightStatusBar)
        self.preferredStatusBarStyle = UIStatusBarStyleLightContent;
    else
        self.preferredStatusBarStyle = UIStatusBarStyleDefault;
    
   [self setNeedsStatusBarAppearanceUpdate];
}

-(void)setPreferredStatusBarStyle:(UIStatusBarStyle)statusBarStyle
{
    objc_setAssociatedObject(self, @selector(preferredStatusBarStyle),
                             @(statusBarStyle), OBJC_ASSOCIATION_RETAIN);
}

-(UIStatusBarStyle)sbs_preferredStatusBarStyle
{
    return [objc_getAssociatedObject(self, @selector(preferredStatusBarStyle)) integerValue];
}

-(IBAction)defaultUnwind:(UIStoryboardSegue*)sender
{
   
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
   if (_portraitLocked)
      return UIInterfaceOrientationMaskPortrait;
   else
      return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end

void GoLandscape()
{
   _portraitLocked = NO;
}

void GoPortrait()
{
   _portraitLocked = YES;
}

