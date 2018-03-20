//
//  UIViewController+NavBarAdditions.m
//  MRNavigationController
//
//  Created by Enrico Cupellini on 02/02/18.
//  Copyright © 2018 Accenture - MAS. All rights reserved.
//

#import "UIViewController+NavBarAdditions.h"
#import <objc/runtime.h>

static char _navbarAdditions_;
static char _toolbarAdditions_;

@implementation UIViewController (NavBarAdditions)

-(void)setNavBarAdditions:(MRNavBarAdditions *)navBarAdditions
{
    objc_setAssociatedObject(self, &_navbarAdditions_, navBarAdditions, OBJC_ASSOCIATION_ASSIGN);
}

-(MRNavBarAdditions *)navBarAdditions
{
    return objc_getAssociatedObject(self, &_navbarAdditions_);
}

-(void)setToolBarAdditions:(MRToolBarAdditions *)toolBarAdditions
{
    objc_setAssociatedObject(self, &_toolbarAdditions_, toolBarAdditions, OBJC_ASSOCIATION_ASSIGN);
}

-(MRToolBarAdditions *)toolBarAdditions
{
    return objc_getAssociatedObject(self, &_toolbarAdditions_);
}

@end
