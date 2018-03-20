//
//  AbstractCustomTabbarController.h
//  dpr
//
//  Created by Federico Gasperini on 13/10/16.
//  Copyright © 2016 Accenture. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@protocol CustomTabbarControllerAnimationDelegate

-(void)initialStateFrom:(UIViewController*)fromVc to:(UIViewController*)toVc;
-(void)finalStateFrom:(UIViewController*)fromVc to:(UIViewController*)toVc;

@end


@interface MRAbstractCustomTabbarController : UIViewController <CustomTabbarControllerAnimationDelegate>

@property (readonly) UIViewController * _Nullable selectedViewController;
@property (readonly, nonatomic) NSMutableArray* viewControllers;
@property (readonly, nonatomic) NSMutableArray* viewControllerContainers;

@property (nonatomic) NSUInteger selectedIndex;
@property (nonatomic) NSUInteger lastSelectedIndex;

@property (nonatomic, strong, nullable) IBInspectable NSString * segues;
@property (nonatomic, weak) IBOutlet UIView * containerView;
@property (nonatomic, weak) IBOutlet UIView * tabbarView;

-(void)setViewController:(UIViewController*)vc atIndex:(NSUInteger)index;
-(void)loadViewControllerAtIndex:(NSUInteger)index;
-(void)animationFinished:(UIViewController *)childController;

-(id)currentLoadedAtIndex:(NSUInteger)index;

@property (nonatomic) CGFloat animationDuration;

-(NSUInteger)addViewController:(UIViewController *)viewController;

@end


@interface UIViewController (customTabbar)

@property (readonly) MRAbstractCustomTabbarController * _Nullable customTabbarController;
-(NSObject<CustomTabbarControllerAnimationDelegate>* _Nullable) customTabbarAnimationDelegateFromIndex:(NSUInteger)from toIndex:(NSUInteger)to;

@end

NS_ASSUME_NONNULL_END
