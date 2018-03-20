//
//  MRActivityWindow.h
//  MRBase
//
//  Created by Federico Gasperini on 20/03/14.
//  Copyright (c) 2013 Accenture. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* ShowLoadingView;
extern NSString* HideLoadingView;
extern NSString* ActivityController;


@interface UIViewController ()

-(UIWindowLevel)windowLevel;

@end

@interface MRActivityWindow : UIWindow

+ (instancetype)defaultActivityWindow;
+ (instancetype)activityWindowWithController:(UIViewController*)controller;
+ (void)show;
+ (void)showOnWindow:(UIWindow*)window;
+ (void)hide;

- (void)show;
- (void)showOnWindow:(UIWindow*)window;
- (void)hide;

@end
