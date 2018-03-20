//
//  AbstractCustomTabbarController.m
//  dpr
//
//  Created by Federico Gasperini on 13/10/16.
//  Copyright © 2016 Accenture. All rights reserved.
//

#import "MRAbstractCustomTabbarController.h"
#import <MRBase/MRWeakWrapper.h>
#import <objc/runtime.h>


@class MRAbstractCustomTabbarController;


@interface CustomTabbarControllerContainer : UIViewController

@property (readonly, nonatomic) UIViewController* content;

@end


@implementation UIViewController (customTabbar)

-(void)setCustomTabbarController:(MRAbstractCustomTabbarController *)customTabbarController
{
   MRWeakWrapper* ww = [[MRWeakWrapper alloc] initWithObject:customTabbarController];
   objc_setAssociatedObject(self, @selector(customTabbarController), ww, OBJC_ASSOCIATION_RETAIN);
}

-(MRAbstractCustomTabbarController *)customTabbarController
{
    id parent = self;
    while (parent) {
        MRWeakWrapper* ww = objc_getAssociatedObject(parent, @selector(customTabbarController));
        if (ww.object)
            return ww.object;
        parent = [parent parentViewController];
    }
    return nil;
}

-(NSObject<CustomTabbarControllerAnimationDelegate>*)customTabbarAnimationDelegateFromIndex:(NSUInteger)from toIndex:(NSUInteger)to
{
    return nil;
}

@end


@implementation UINavigationController (customTabbar)

-(NSObject<CustomTabbarControllerAnimationDelegate>*)customTabbarAnimationDelegateFromIndex:(NSUInteger)from toIndex:(NSUInteger)to
{
    return [self.topViewController customTabbarAnimationDelegateFromIndex:from toIndex:to];
}

@end

@interface MRAbstractCustomTabbarController ()

-(void)prepareAnimation:(UIViewController *)childController;
-(void)animateToViewController:(UIViewController *)childController;

@property (nonatomic) BOOL beginAppearanceTransitionIsAppearingCalled;

@end



@implementation MRAbstractCustomTabbarController
{
   NSMutableArray* _viewControllerContainers;
    NSObject<CustomTabbarControllerAnimationDelegate>* _transitionDelegate;
}

@synthesize selectedViewController = _selectedViewController;

- (void)viewDidLoad
{
   [super viewDidLoad];
   self.lastSelectedIndex = -1;
   _selectedIndex = -1;
}

-(BOOL)shouldAutomaticallyForwardAppearanceMethods
{
   return NO;
}

-(void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:animated];
   self.beginAppearanceTransitionIsAppearingCalled = (self.selectedViewController != nil);
   
   [self.selectedViewController beginAppearanceTransition:YES
                                                 animated:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
   [super viewDidAppear:animated];
   if (self.beginAppearanceTransitionIsAppearingCalled) {
      [self.selectedViewController endAppearanceTransition];
   }
}

-(void)viewWillDisappear:(BOOL)animated
{
   [super viewWillDisappear:animated];
   [self.selectedViewController beginAppearanceTransition:NO
                                                 animated:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
   [super viewDidDisappear:animated];
   [self.selectedViewController endAppearanceTransition];
}

-(NSMutableArray*)viewControllerContainers
{
   if (!_viewControllerContainers)
      _viewControllerContainers = [[NSMutableArray alloc] init];
    return _viewControllerContainers;
}

-(NSMutableArray*)viewControllers
{
   return [self.viewControllerContainers valueForKey:@"content"];
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex
{
   if (_selectedIndex != selectedIndex)
   {
       self.view.userInteractionEnabled = NO;
       self.lastSelectedIndex = _selectedIndex;
       _selectedIndex = selectedIndex;
      if (self.viewControllerContainers.count <= selectedIndex)
         for (NSInteger i = self.viewControllerContainers.count; i <= selectedIndex + 1; i++)
            [self.viewControllerContainers addObject:[NSNull null]];
      
      if (self.viewControllerContainers[selectedIndex] != [NSNull null])
      {
         UIViewController *vc = self.viewControllerContainers[selectedIndex];
         [self addChildViewController:vc];
      }
      else
      {
         [self loadViewControllerAtIndex:selectedIndex];
      }
   }
}

-(id)currentLoadedAtIndex:(NSUInteger)index
{
   if (self.viewControllerContainers.count > index)
      if (self.viewControllerContainers[index] != [NSNull null])
         return self.viewControllerContainers[index];
   return nil;
}

-(void)loadViewControllerAtIndex:(NSUInteger)index
{
   @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                  reason:@"Must override loadViewControllerAtIndex:"
                                userInfo:nil];
}

-(NSUInteger)addViewController:(UIViewController *)viewController
{
   UIViewController* v = viewController;
   UIViewController* c = [[CustomTabbarControllerContainer alloc] init];
   [c.view addSubview:v.view];
   [c addChildViewController:v];
   [v didMoveToParentViewController:c];
   [self.viewControllerContainers addObject:c];
   return _viewControllerContainers.count - 1;
}

-(void)setViewController:(UIViewController*)vc atIndex:(NSUInteger)index
{
   NSInteger i = ((NSInteger)self.viewControllerContainers.count) - 1;
   for (; i < (NSInteger)index; i++)
      [self.viewControllerContainers addObject:[NSNull null]];
   
   if (self.viewControllers[index] != vc)
   {
      UIViewController* v = vc;
      v.customTabbarController = self;
      CustomTabbarControllerContainer* c = [[CustomTabbarControllerContainer alloc] init];
      [c.view addSubview:v.view];
      [c addChildViewController:v];
      [v didMoveToParentViewController:c];
      [_viewControllerContainers replaceObjectAtIndex:index withObject:c];
      [self addChildViewController:c];
   }
   else
      [self addChildViewController:vc];
}

-(void)prepareAddChildViewController:(CustomTabbarControllerContainer *)childController
{
   [super addChildViewController:childController];
   [self.containerView addSubview:childController.view];
   [self.containerView bringSubviewToFront:childController.view];
}

-(CGFloat)animationDuration
{
#ifdef DEFAULT_ANIMATION_DURATION
   return DEFAULT_ANIMATION_DURATION;
#else
   return .3;
#endif
}

-(void)prepareAnimation:(CustomTabbarControllerContainer *)childController
{
   [childController beginAppearanceTransition:YES animated:YES];
   [self.selectedViewController beginAppearanceTransition:NO animated:YES];
   _transitionDelegate = [childController customTabbarAnimationDelegateFromIndex:self.lastSelectedIndex
                                                                         toIndex:self.selectedIndex];
   if (_transitionDelegate)
      [_transitionDelegate initialStateFrom:self.selectedViewController to:childController.content];
   else
      [self initialStateFrom:self.selectedViewController to:childController.content];
}

-(void)initialStateFrom:(UIViewController*)fromVc to:(UIViewController*)toVc
{
   toVc.view.alpha = 0;
}

-(void)animateToViewController:(CustomTabbarControllerContainer *)childController
{
    if (_transitionDelegate)
        [_transitionDelegate finalStateFrom:self.selectedViewController to:childController.content];
    else
        [self finalStateFrom:self.selectedViewController to:childController.content];
    _transitionDelegate = nil;
}

-(void)finalStateFrom:(UIViewController*)fromVc to:(UIViewController*)toVc
{
   toVc.view.alpha = 1;
}

-(void)animationFinished:(CustomTabbarControllerContainer *)childController
{
   [childController endAppearanceTransition];
   [self.selectedViewController endAppearanceTransition];
   _selectedViewController = [childController content];
   if (self.lastSelectedIndex < self.viewControllerContainers.count)
   {
       CustomTabbarControllerContainer* c = self.viewControllerContainers[self.lastSelectedIndex];
       if ((id)c != [NSNull null] && c.view.superview)
       {
           [c.view removeFromSuperview];
           [c removeFromParentViewController];
           [c didMoveToParentViewController:nil];
       }
   }
   [self setNeedsStatusBarAppearanceUpdate];
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       self.view.userInteractionEnabled = YES;
                   });
}

-(void)addChildViewController:(CustomTabbarControllerContainer *)childController
{
   childController.customTabbarController = self;
   [self prepareAddChildViewController:childController];
   [self prepareAnimation:childController];
    __weak id _childController = childController;
    dispatch_async(dispatch_get_main_queue(), ^{
        [CATransaction begin];
        
        [CATransaction setCompletionBlock:^{
            [self animationFinished:_childController];
        }];
        
        [UIView animateWithDuration:self.animationDuration animations:^{
            [self animateToViewController:childController];
        }];
        
        [CATransaction commit];

    });
}

-(UIView*)containerView
{
   return _containerView ?: self.view;
}

-(UIViewController *)childViewControllerForStatusBarStyle
{
    return self.selectedViewController;
}

@end

@implementation NSNull (customTabbar)

-(id)content
{
    return self;
}

-(void)setCustomTabbarController:(id)d
{
    
}

@end

@implementation CustomTabbarControllerContainer

-(void)loadView
{
    [super loadView];
    self.view.clipsToBounds = YES;
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
}

-(void)viewWillLayoutSubviews
{
   self.view.frame = self.view.superview.bounds;
   [super viewWillLayoutSubviews];
}

-(UIViewController*)content
{
    return self.childViewControllers.firstObject;
}

-(UIViewController *)childViewControllerForStatusBarStyle
{
    return self.childViewControllers.firstObject;
}

-(void)setCustomTabbarController:(MRAbstractCustomTabbarController *)customTabbarController
{
    [super setCustomTabbarController:customTabbarController];
    self.content.customTabbarController = customTabbarController;
}

-(NSObject<CustomTabbarControllerAnimationDelegate> *)customTabbarAnimationDelegateFromIndex:(NSUInteger)from toIndex:(NSUInteger)to
{
    return [self.content customTabbarAnimationDelegateFromIndex:from toIndex:to];
}

-(void)dealloc
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    [self didMoveToParentViewController:nil];
    NSLog(@"dealloc");
}

@end
