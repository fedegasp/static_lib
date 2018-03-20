//
//  MRNavBarAdditions.m
//  MRNavigationController
//
//  Created by Federico Gasperini on 20/10/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "MRNavBarAdditions.h"
#import "MRViewController.h"
#import "MRNavigationViewController.h"

@interface MRNavBarAdditions ()

-(UIBarButtonItem *_Nullable)generateBarButtonItemWithImage:(NSString *_Nullable)image andAction:(NSString *_Nullable)action;

@end


@implementation MRNavBarAdditions

-(instancetype)initWithViewController:(UIViewController*)controller
{
    self = [super init];
    if (self)
    {
        _viewController = controller;
    }
    return self;
}

-(void)setController
{
    if (self.leftMenu)
    {
        NSString *icon = @"menu_icon";
        if (self.leftMenuIcon)
            icon = self.leftMenuIcon;
        
        NSString *sel = @"menuButtonTapped:";
        if (self.leftMenuAction)
            sel = self.leftMenuAction;
        self.viewController.navigationItem.leftBarButtonItem=[self generateBarButtonItemWithImage:icon andAction:sel];
    }
    
    if (self.rightMenu == YES)
    {
        NSString *icon = @"";
        if (self.rightMenuIcon)
            icon = self.rightMenuIcon;
        
        NSString *sel = @"";
        if (self.rightMenuAction)
            sel = self.rightMenuAction;
        self.viewController.navigationItem.rightBarButtonItem=[self generateBarButtonItemWithImage:icon andAction:sel];
    }
}

-(UIBarButtonItem *)generateBarButtonItemWithImage:(NSString *)image andAction:(NSString *)action
{
    UIImage *img = [UIImage imageNamed:image];
    SEL selector = NSSelectorFromString(action);
    
    NSAssert([self.viewController respondsToSelector:selector], @"%@ does not responds to selector %@", self, action);
    
    CGRect frameimg = CGRectMake(0, 0, img.size.width, img.size.height);
    UIButton *btn = [[UIButton alloc]initWithFrame:frameimg];
//    [btn setTintColor:((MRNavigationViewController*)self.viewController.navigationController).navbarTintColor];
    [btn setImage:img forState:UIControlStateNormal];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    if (action.length)
        [btn addTarget:self.viewController
                action:selector
      forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:btn];
    return barButton;
}

@end
