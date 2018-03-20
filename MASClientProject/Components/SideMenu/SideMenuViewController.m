//
//  SideMenuViewController.m
//  MASClient
//
//  Created by Gai, Fabio on 26/12/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import "SideMenuViewController.h"
#import "NavigationManager.h"

@interface SideMenuViewController ()<UINavigationControllerDelegate>

@end

@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    navigationManager().sideViewController = self;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"main"]) {
        navigationManager().mainNavigationController = segue.destinationViewController;
        navigationManager().mainNavigationController.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"menu"])
    {
        navigationManager().menuController = segue.destinationViewController;
    }
}

-(IBAction)closeMenu:(id)sender{
    [navigationManager() closeMenu];
}

-(UIViewController*)executeMenuAction:(NSString *)menuAction
                         withPostData:(id)postData
{
   return
   [navigationManager().mainNavigationController.topViewController executeMenuAction:menuAction
                                                                        withPostData:postData];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    if (self.lightStatusBar) {
        return  UIStatusBarStyleLightContent;
    }else{
        return UIStatusBarStyleDefault;
    }
}

-(void)navigationController:(UINavigationController *)navigationController
     willShowViewController:(UIViewController *)viewController
                   animated:(BOOL)animated {
    
    self.lightStatusBar = (viewController.preferredStatusBarStyle == UIStatusBarStyleLightContent);
    [self setNeedsStatusBarAppearanceUpdate];
}

@end
