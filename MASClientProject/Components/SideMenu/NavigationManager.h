//
//  NavigationManager.h
//  MASClient
//
//  Created by Gai, Fabio on 26/12/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SideMenuViewController.h"

@class NavigationManager;
extern NavigationManager* navigationManager();

@interface NavigationManager : NSObject
+ (id)sharedInstance;
@property (weak, nonatomic) SideMenuViewController *sideViewController;
@property (weak, nonatomic) UINavigationController *mainNavigationController;
@property (weak, nonatomic) UIViewController *menuController;
@property (weak, nonatomic) UIView *mainView;
@property IBInspectable CGFloat sideOffset;
-(void)openMenu;
-(void)closeMenu;
-(void)navigateTo:(NSString*)identifier;
-(void)navigateTo:(NSString*)identifier
     withPostData:(id)postData;
@end
