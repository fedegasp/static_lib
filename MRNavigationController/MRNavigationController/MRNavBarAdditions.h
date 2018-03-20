//
//  MRNavBarAdditions.h
//  MRNavigationController
//
//  Created by Federico Gasperini on 20/10/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MRBase/lib.h>

@class MRViewController;
@interface MRNavBarAdditions : MRNotifyingObject

-(instancetype _Nonnull)init NS_UNAVAILABLE;
-(instancetype _Nonnull)initWithViewController:(UIViewController* _Nonnull)controller NS_DESIGNATED_INITIALIZER;

@property (nonatomic, weak)IBOutlet UIViewController* _Nullable viewController;

@property (nonatomic, assign) IBInspectable BOOL navbarLogo;
@property (nonatomic, assign) IBInspectable BOOL transparentNavbar;
@property (nonatomic, strong, nullable) IBInspectable UIColor *navbarColor;
@property (nonatomic, strong, nullable) IBInspectable UIColor *navbarTintColor;
@property (nonatomic, assign) IBInspectable BOOL navBarShouldScroll;
@property (nonatomic, assign) IBInspectable CGFloat navbarOffset;
@property (nonatomic, assign) IBInspectable BOOL disableEdgeGesture;
@property (nonatomic, assign) IBInspectable BOOL disableHideKeyboardOnTap;
@property (nonatomic, assign) IBInspectable BOOL navBarHidden;
@property (nonatomic, assign) IBInspectable BOOL customLeftIcon;
@property (nonatomic, assign) IBInspectable BOOL disableNotificationView;
@property (nonatomic, assign) IBInspectable BOOL leftMenu;
@property (nonatomic, strong, nullable) IBInspectable NSString *leftMenuIcon;
@property (nonatomic, strong, nullable) IBInspectable NSString *leftMenuAction;
@property (nonatomic, assign) IBInspectable BOOL rightMenu;
@property (nonatomic, strong, nullable) IBInspectable NSString *rightMenuIcon;
@property (nonatomic, strong, nullable) IBInspectable NSString *rightMenuAction;
@property (nonatomic, strong, nullable) id footerModelData;
@property (nonatomic, readonly) BOOL isKeyboardPresented;

-(void)setController;

@end
