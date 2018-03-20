//
//  MRActivityWindow.m
//  MRBase
//
//  Created by Federico Gasperini on 20/03/14.
//  Copyright (c) 2013 Accenture. All rights reserved.
//

#import "MRActivityWindow.h"
#import <QuartzCore/QuartzCore.h>
#import "MRMacros.h"

#define OnlyMainThread(X)    if (![[NSThread currentThread] isMainThread]) return X

#define ANIMATION_DURATION .18f

NSString* ShowLoadingView = @"ShowLoadingView";
NSString* HideLoadingView = @"HideLoadingView";
NSString* ActivityController = @"ActivityController";

__strong MRActivityWindow* _defaultActivityWindow = nil;

@interface MRActivityWindow ()

@property (atomic, assign) NSInteger counter;
@property (atomic, strong) NSObject* lock;
@property (weak, nonatomic) UIWindow* underlyingWindow;

@end

@interface  VC : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView* imageView;

@end

@implementation VC
{
   BOOL noRotation;
}

-(BOOL)shouldAutorotate
{
   if (!noRotation)
   {
      noRotation = YES;
      return YES;
   }
   return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
   return UIInterfaceOrientationMaskAll;
}

-(void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:animated];
   
   if (!self.imageView)
   {
      UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity"]];
      imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
      
      CGRect frame = CGRectMake(0, 0, 35, 35);
      
      frame.origin = CGPointMake(self.view.frame.size.width - 35-10,
                                 self.view.frame.size.height - 35-10);
      imageView.frame = frame;
      
      [self.view addSubview:imageView];
      self.imageView = imageView;
   }
   
   CABasicAnimation* an = [CABasicAnimation animationWithKeyPath:@"transform"];
   an.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, .75, -1.0/.75, 0)];
   an.duration = ANIMATION_DURATION * 6.0f;
   an.removedOnCompletion = NO;
   an.fillMode = kCAFillModeForwards;
   an.cumulative = YES;
   an.repeatCount = 2000;
   
   [self.imageView.layer addAnimation:an forKey:@""];
}

@end

@implementation MRActivityWindow

+ (void)show
{
   OnlyMainThread();
   [self showOnWindow:[[UIApplication sharedApplication] windows][0]];
}

+ (void)showOnWindow:(UIWindow*)window
{
   OnlyMainThread();
   [[self defaultActivityWindow] showOnWindow:window];
}

+ (void)hide
{
   OnlyMainThread();
   [[self defaultActivityWindow] hide];
}

+(instancetype)defaultActivityWindow
{
   OnlyMainThread(nil);
   if (_defaultActivityWindow == nil)
   {
      _defaultActivityWindow = [[MRActivityWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
      UIViewController* vc = [[VC alloc] init];
      UIView* instance = [[UIView alloc] initWithFrame:_defaultActivityWindow.bounds];
      vc.view = instance;
      instance.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      
      [_defaultActivityWindow setRootViewController:vc];
   }
   
   return _defaultActivityWindow;
}

+ (instancetype)activityWindowWithController:(UIViewController*)controller
{
   OnlyMainThread(nil);
   if (_defaultActivityWindow == nil)
      _defaultActivityWindow = [[MRActivityWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
   [_defaultActivityWindow setRootViewController:controller];
   return _defaultActivityWindow;
}

-(void)show
{
   OnlyMainThread();
   [self showOnWindow:[[UIApplication sharedApplication] windows][0]];
}

- (void)showOnWindow:(UIWindow *)window
{
   OnlyMainThread();
   self.counter ++;
   if (self.counter <= 1)
   {
      self.counter = 1;
      self.underlyingWindow = window;
      [self makeKeyAndVisible];
   }
}

-(void)becomeKeyWindow
{
   if (self.counter == 0)
      return;
   [super becomeKeyWindow];
   if (self.alpha != 1.0f)
   {
      WEAK_REF(self);
      [UIView animateWithDuration:ANIMATION_DURATION
                       animations:^{
                          _self.alpha = 1;
                       }];
   }
}

-(void)resignKeyWindow
{
   [super resignKeyWindow];
   if (self.counter == 0)
   {
      WEAK_REF(self);
      [UIView animateWithDuration:ANIMATION_DURATION
                       animations:^{
                          _self.alpha = 0;
                       }
                       completion:^(BOOL finished) {
                          _defaultActivityWindow = nil;
                       }];
   }
}

- (void)hide
{
   OnlyMainThread();
   self.counter --;
   if (self.counter <= 0)
   {
      self.counter = 0;
      if ([[[UIDevice currentDevice] systemVersion] hasPrefix:@"7."])
      {
         if (![self isKeyWindow])
         {
            WEAK_REF(self);
            [UIView animateWithDuration:ANIMATION_DURATION
                             animations:^{
                                _self.alpha = 0;
                             }
                             completion:^(BOOL finished) {
                                _defaultActivityWindow = nil;
                             }];
         }
         else
         {
            [self.underlyingWindow makeKeyAndVisible];
         }
      }
      else // 8.0 >>
      {
         WEAK_REF(self);
         [UIView animateWithDuration:ANIMATION_DURATION
                          animations:^{
                             _self.alpha = 0;
                          }
                          completion:^(BOOL finished) {
                             [_self.underlyingWindow makeKeyAndVisible];
                             _defaultActivityWindow = nil;
                          }];
      }
      self.underlyingWindow = nil;
   }
}

-(void)setRootViewController:(UIViewController *)rootViewController
{
   [super setRootViewController:rootViewController];
   if ([rootViewController respondsToSelector:@selector(windowLevel)])
      self.windowLevel = [rootViewController windowLevel];
   else
      self.windowLevel = UIWindowLevelAlert / 2.0;
   /* UIWindowLevelAlert - 1.0 rimane sopra l'alertview... */
}

@end
