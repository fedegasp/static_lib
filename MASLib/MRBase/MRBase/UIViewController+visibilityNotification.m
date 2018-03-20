//
//  UIViewController+visibilityNotification.m
//  MRGraphics
//
//  Created by Federico Gasperini on 18/10/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "UIViewController+visibilityNotification.h"
#import "JRSwizzle.h"
#import <objc/runtime.h>

#pragma - mark NSNotificationNames

NSNotificationName UIViewControllerWillAppear = @"willAppear: called on %@";
NSNotificationName UIViewControllerDidAppear = @"didAppear: called on %@";
NSNotificationName UIViewControllerWillDisappear = @"willDisappear: called on %@";
NSNotificationName UIViewControllerDidDisappear = @"didDisappear: called on %@";


#pragma - mark UIViewController (visibilityNotification) implementation

@implementation UIViewController (visibilityNotification)

+(void)load
{
    [self jr_swizzleMethod:@selector(viewWillAppear:)
                withMethod:@selector(visibilityNotification_viewWillAppear:)
                     error:NULL];
    [self jr_swizzleMethod:@selector(viewDidAppear:)
                withMethod:@selector(visibilityNotification_viewDidAppear:)
                     error:NULL];
    [self jr_swizzleMethod:@selector(viewWillDisappear:)
                withMethod:@selector(visibilityNotification_viewWillDisappear:)
                     error:NULL];
    [self jr_swizzleMethod:@selector(viewDidDisappear:)
                withMethod:@selector(visibilityNotification_viewDidDisappear:)
                     error:NULL];
    
    [self jr_swizzleMethod:@selector(preferredStatusBarStyle)
                withMethod:@selector(visibilityNotification_preferredStatusBarStyle)
                     error:NULL];
}

-(BOOL)viewWillAppearPassed
{
    return [objc_getAssociatedObject(self, @selector(viewWillAppearPassed)) boolValue];
}

-(void)popAnimated:(BOOL)animated
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)hideKeyboard
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

-(IBAction)closeKeyboard:(id)sender
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

-(void)visibilityNotification_viewWillAppear:(BOOL)animated
{
    [self visibilityNotification_viewWillAppear:animated];
    objc_setAssociatedObject(self, @selector(viewWillAppearPassed),
                             @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setNeedsStatusBarAppearanceUpdate];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIViewControllerWillAppear object:self];
}

-(void)visibilityNotification_viewDidAppear:(BOOL)animated
{
    [self visibilityNotification_viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIViewControllerDidAppear object:self];
}

-(void)visibilityNotification_viewWillDisappear:(BOOL)animated
{
    [self visibilityNotification_viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIViewControllerWillDisappear object:self];
}

-(void)visibilityNotification_viewDidDisappear:(BOOL)animated
{
    [self visibilityNotification_viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIViewControllerDidDisappear object:self];
}

-(void)setPreferredStatusBarStyle:(UIStatusBarStyle)statusBarStyle
{
    objc_setAssociatedObject(self, @selector(preferredStatusBarStyle),
                             @(statusBarStyle), OBJC_ASSOCIATION_RETAIN);
}

-(UIStatusBarStyle)visibilityNotification_preferredStatusBarStyle
{
    return [objc_getAssociatedObject(self, @selector(preferredStatusBarStyle)) integerValue];
}

-(void)setLightStatusBar:(BOOL)lightStatusBar
{

    if (lightStatusBar)
        self.preferredStatusBarStyle = UIStatusBarStyleLightContent;
    else
        self.preferredStatusBarStyle = UIStatusBarStyleDefault;
    [self setNeedsStatusBarAppearanceUpdate];
    objc_setAssociatedObject(self, @selector(setLightStatusBar:),
                             @(lightStatusBar), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)lightStatusBar
{
    return [objc_getAssociatedObject(self, @selector(lightStatusBar)) boolValue];
}

@end
