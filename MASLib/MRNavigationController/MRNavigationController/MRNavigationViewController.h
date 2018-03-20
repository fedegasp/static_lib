//
//  FGNavigationViewController.h
//  MASClient
//
//  Created by Gai, Fabio on 27/10/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MRGraphics/lib.h>
#import "MRScrollViewDelegate.h"
#import "MRNavBarAdditions.h"

@interface MRNavigationViewController : UINavigationController <MRScrollViewDelegate>

@property (nonatomic, readonly) CAGradientLayer *backgroundLayer;
@property (assign, nonatomic) IBInspectable BOOL restoreShadow;

@property (nonatomic, assign) GradientDirection gradientDirection;
@property (nonatomic, strong) IBInspectable UIColor* firstColor;
@property (nonatomic, strong) IBInspectable UIColor* secondColor;

@property (nonatomic, strong) IBInspectable NSString* backButtonText;

-(void)configureWithController:(UIViewController*)v;

@end


@interface MRNavigationViewController (ibinspectable)

@property (nonatomic, assign) IBInspectable NSInteger gradientDirection;

@end


@interface UIViewController ()

-(void)navigationBarAppear:(BOOL)appeared;

@end
