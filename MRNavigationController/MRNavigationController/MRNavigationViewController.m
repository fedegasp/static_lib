//
//  MRNavigationViewController.m
//  MASClient
//
//  Created by Gai, Fabio on 27/10/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import "MRNavigationViewController.h"
#import <MRBase/lib.h>
#import "NSObject+scrollDelegate.h"
#import "UIViewController+NavBarAdditions.h"
#import <objc/runtime.h>

@interface MRNavigationViewController () <UINavigationControllerDelegate>

@property (nonatomic, strong) UIColor *navBarColor;
@property (nonatomic, readonly) NSMapTable* dictionary;

@end


@implementation MRNavigationViewController
{
    CALayer* _backgroundLayer;
    UIImage* barShadowImage;
    NSMapTable* _dictionary;
    __weak NSObject<UINavigationControllerDelegate>* _extDelegate;
    __weak UIViewController* _interactiveDisposableViewController;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.translucent = YES;
    barShadowImage = self.navigationBar.shadowImage;
    self.navigationBar.shadowImage = [UIImage new];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    
    self.backgroundLayer.opacity = 0.0;
    [self.navigationBar.layer insertSublayer:self.backgroundLayer atIndex:0];
    [self configureWithController:self];
}

-(void)propertyOfMRNavBarAdditionsDidChange:(MRNavBarAdditions *)obj
{
    [self configureWithController:obj.viewController];
}

-(void)propertyOfMRToolBarAdditionsDidChange:(MRToolBarAdditions *)obj
{
    [self configureWithController:obj.toolBarOwner];
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if (viewController.navBarAdditions) {
        [viewController.navBarAdditions notifyOnChange:self suppressOnRegistration:YES];
        [self configureWithController:viewController];
    }
    if (viewController.toolBarAdditions) {
        [viewController.toolBarAdditions notifyOnChange:self suppressOnRegistration:YES];
        [self configureWithController:viewController];
    }
    if (self.backButtonText)
    {
        if (viewController.navBarAdditions && !viewController.navBarAdditions.customLeftIcon) {
            viewController.navigationItem.backBarButtonItem =
            [[UIBarButtonItem alloc] initWithTitle:self.backButtonText
                                             style:UIBarButtonItemStylePlain
                                            target:nil action:nil];
        }
    }
    
    UIViewController* prevViewController = _interactiveDisposableViewController;
    _interactiveDisposableViewController = viewController;
//    [self configureWithController:viewController];

    id <UIViewControllerTransitionCoordinator> transitionCoordinator = [self transitionCoordinator];
    if ([transitionCoordinator isInteractive])
        [transitionCoordinator
         notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context)
         {
             if ([context isCancelled])
                 [self configureWithController:prevViewController];
             _interactiveDisposableViewController = prevViewController;
         }];

    if ([_extDelegate respondsToSelector:_cmd])
        [_extDelegate navigationController:navigationController
                    willShowViewController:viewController
                                  animated:animated];
}

-(UIViewController*)topAddictedViewController
{
    UIViewController* top = [self topViewController];
    if (top.navBarAdditions)
        return (id)top;
    return nil;
}

-(NSMapTable*)dictionary
{
    if (_dictionary)
        return _dictionary;
    
    _dictionary = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsWeakMemory|
                                                     NSPointerFunctionsObjectPointerPersonality
                                        valueOptions:NSPointerFunctionsStrongMemory];
    return _dictionary;
}

-(CALayer*)backgroundLayer
{
    if (_backgroundLayer == nil)
    {
        _backgroundLayer = [CAGradientLayer layer];
        _backgroundLayer.zPosition = -.1;
    }
    
    CGRect navbarRect =
    [self.navigationBar convertRect:self.navigationBar.bounds
                             toView:nil];
    _backgroundLayer.frame = CGRectMake(0,
                                        -navbarRect.origin.y,
                                        self.navigationBar.frame.size.width,
                                        self.navigationBar.frame.size.height+navbarRect.origin.y);

    return _backgroundLayer;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGRect navbarRect =
    [self.navigationBar convertRect:self.navigationBar.bounds
                             toView:nil];
    self.backgroundLayer.frame = CGRectMake(0,
                                            -navbarRect.origin.y,
                                            self.navigationBar.frame.size.width,
                                            self.navigationBar.frame.size.height+navbarRect.origin.y);
}

//-(void)configureWithController:(UIViewController*)v
//{
//    if ([v conformsToProtocol:@protocol(MRNavBarAdditions)])
//        [self _configureWithController:(id)v];
//}

-(void)configureWithController:(UIViewController/*<MRNavBarAdditions>*/ *)v
{
    if (v.navBarAdditions.navBarHidden)
        [self setNavigationBarHidden:YES animated:YES];
    else
    {
        [self setNavigationBarHidden:NO animated:YES];
        
        if (self.firstColor && self.secondColor && self.gradientDirection != GradientDirectionDisabled)
        {
            self.backgroundLayer.colors = @[(id)self.firstColor.CGColor,
                                            (id)self.secondColor.CGColor];
            if (self.gradientDirection == GradientDirectionHorizontal)
            {
                self.backgroundLayer.startPoint = CGPointMake(0.0, 0.5);
                self.backgroundLayer.endPoint = CGPointMake(1.0, 0.5);
            }
            else
            {
                self.backgroundLayer.startPoint = CGPointMake(0.5, 0.0);
                self.backgroundLayer.endPoint = CGPointMake(0.5, 1.0);
            }
        }
        else
        {
            self.backgroundLayer.backgroundColor = (v.navBarAdditions.navbarColor ?: self.navBarAdditions.navbarColor).CGColor;
        }
        
        UIColor* color = v.navBarAdditions.navbarTintColor ?: (self.navBarAdditions.navbarTintColor ?: [UIColor blackColor]);
        [self.navigationBar setTintColor:color];
        NSMutableDictionary* attr = [self.navigationBar.titleTextAttributes mutableCopy];
        if(!attr)
        {
            attr = @{}.mutableCopy;
        }
        attr[NSForegroundColorAttributeName] = color;
        [self.navigationBar setTitleTextAttributes:attr];
        
        if (v.navBarAdditions.transparentNavbar)
        {
            NSNumber* barWasVisible = [self.dictionary objectForKey:v];
            if ([barWasVisible boolValue])
                [self addNavigationBar];
            else
                [self removeNavigationBar];

            if (v.navBarAdditions.navBarShouldScroll)
                v.scrollDelegate = self;
        }
        else
        {
            [self addNavigationBar];
        }
        if (v.title) {
            v.navigationItem.title = NSLocalizedString(v.title, @"");
        }
    }
    [[self navigationBar] setNeedsLayout];
    
    if (v.toolBarAdditions.showToolBar) {
        [self setToolbarHidden:NO];
    }
    else{
        [self setToolbarHidden:YES];
    }
    [[self toolbar] setNeedsLayout];
}

-(void)fgDidScroll:(CGPoint)offset
{
    UIViewController* addVc = [self topAddictedViewController];
    if (addVc)
    {
        CGFloat a = offset.y;
        CGFloat b = [addVc.navBarAdditions navbarOffset];
        
        if (a > b) {
            [self addNavigationBar];
            [self notifyNavigationBarAppear:YES];
        }else{
            [self removeNavigationBar];
            [self notifyNavigationBarAppear:NO];
        }
    }
}

-(void)notifyNavigationBarAppear:(BOOL)appeared
{
    if ([self.topViewController respondsToSelector:@selector(navigationBarAppear:)])
        [self.topViewController navigationBarAppear:appeared];
}

-(void)addNavigationBar
{
    [self.dictionary setObject:@YES forKey:self.topViewController];
    self.backgroundLayer.opacity = 1;
    
    if (self.restoreShadow)
        self.navigationBar.shadowImage = barShadowImage;
}

-(void)removeNavigationBar
{
    [self.dictionary setObject:@NO forKey:self.topViewController];
    self.backgroundLayer.opacity = 0.0;
    self.navigationBar.shadowImage = [UIImage new];
}

-(UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}

-(BOOL)respondsToSelector:(SEL)aSelector
{
    if (sel_isEqual(aSelector, @selector(navigationController:willShowViewController:animated:)))
        return YES;
    
    struct objc_method_description hasMethod;
    hasMethod = protocol_getMethodDescription(@protocol(UINavigationControllerDelegate),
                                              aSelector, NO, YES);
    if ( hasMethod.name != NULL )
        return [_extDelegate respondsToSelector:aSelector];
    
    return [super respondsToSelector:aSelector];
}

-(id)forwardingTargetForSelector:(SEL)aSelector
{
    struct objc_method_description hasMethod;
    hasMethod = protocol_getMethodDescription(@protocol(UINavigationControllerDelegate),
                                              aSelector, NO, YES);
    if ( hasMethod.name != NULL )
        return _extDelegate;
    
    return [super forwardingTargetForSelector:aSelector];
}

-(void)setDelegate:(id<UINavigationControllerDelegate>)delegate
{
    _extDelegate = delegate;
}

-(id)delegate
{
    return self;
}


-(void)setController{}

@end


@implementation MRNavigationViewController (ibinspectable)

@dynamic gradientDirection;

@end
