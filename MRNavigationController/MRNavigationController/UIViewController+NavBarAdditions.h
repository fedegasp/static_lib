//
//  UIViewController+NavBarAdditions.h
//  MRNavigationController
//
//  Created by Enrico Cupellini on 02/02/18.
//  Copyright © 2018 Accenture - MAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRNavBarAdditions.h"
#import "MRToolBarAdditions.h"

@interface UIViewController (NavBarAdditions)

@property (weak, nonatomic) IBOutlet MRNavBarAdditions* navBarAdditions;
@property (weak, nonatomic) IBOutlet MRToolBarAdditions* toolBarAdditions;

@end
