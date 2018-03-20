//
//  MRPaginationViewController
//
//  Created by Giovanni Castiglioni on 12/03/15.
//  Copyright (c) 2015 Accenture. All rights reserved.
//

#import "MRPaginationController.h"
#import <objc/runtime.h>

@interface UIViewController (MRPaginationControllerIndex_private)

-(void)setPaginationControllerIndex:(NSUInteger)index;

@end


@interface MRPaginationController ()

@property NSInteger proposedPageIndex;
@property (nonatomic,strong) NSMutableArray *viewControllersArray;

- (void) goToPage:(NSInteger)nPage completion:(void (^)(void))completion;

@end

@implementation MRPaginationController
{
   BOOL isChangingPage;
}

-(BOOL)respondsToSelector:(SEL)aSelector
{
   if (![super respondsToSelector:aSelector])
   {
      for (UIViewController* c in self.viewControllersArray)
         if ([c respondsToSelector:aSelector])
            return YES;
      return NO;
   }
   return YES;
}


-(id)forwardingTargetForSelector:(SEL)aSelector
{
   for (UIViewController* c in self.viewControllersArray)
      if ([c respondsToSelector:aSelector])
         return c;
   return nil;
}

- (void)viewDidLoad
{
   [super viewDidLoad];
   
   self.delegate = self;
   self.dataSource = self;
   
   self.viewControllersArray = [NSMutableArray arrayWithCapacity:self.viewControllersObjects.count];
   
   if (!self.drivenPopulation)
   {
      [self instantiateViewControllers];
      
      if([self.menuView respondsToSelector:@selector(setCurrentItemIndex:)])
         [self.menuView setCurrentItemIndex:self.pageIndex];
      
      [self setViewControllers:@[self.viewControllersArray[self.pageIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
      
   }
}

-(UIViewController*) currentViewController
{
    if(self.pageIndex< self.pageCount)
        return self.viewControllersArray[self.pageIndex];
    else return nil;
}

-(UIViewController*)addPage
{
   MRPageObject *obj = self.viewControllersObjects.lastObject;
   
   UIStoryboard *storyboard = nil;
   
   if (obj.StoriboardRef) {
      storyboard = [UIStoryboard storyboardWithName:obj.StoriboardRef bundle:nil];
   }else{
      storyboard = self.storyboard;
   }
   id item = [storyboard instantiateViewControllerWithIdentifier:obj.controllerID];
   [item setPaginationControllerIndex:self.viewControllersArray.count];
   [self.viewControllersArray addObject:item];
   
   if (self.viewControllersArray.count == 1)
   {
      if([self.menuView respondsToSelector:@selector(setCurrentItemIndex:)])
         [self.menuView setCurrentItemIndex:self.pageIndex];
      
      [self setViewControllers:@[self.viewControllersArray[self.pageIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
   }
   
   return item;
}

-(NSInteger)pageCount
{
   return self.viewControllersArray.count;
}

- (void) instantiateViewControllers
{
   for(MRPageObject *obj in self.viewControllersObjects)
   {
      
      UIStoryboard *storyboard = nil;
      
      if (obj.StoriboardRef) {
         storyboard = [UIStoryboard storyboardWithName:obj.StoriboardRef bundle:nil];
      }else{
         storyboard = self.storyboard;
      }
      id item = [storyboard instantiateViewControllerWithIdentifier:obj.controllerID];
      [item setPaginationControllerIndex:self.viewControllersArray.count];
      [self.viewControllersArray addObject:item];
   }
   
}

- (void)pageChanged:(NSInteger)newPageIndex
{
   //	NSLog(@"page changed %ld",self.pageIndex);
   if (self.viewControllersArray.count == 0)
      return;
   
   if([self.menuView respondsToSelector:@selector(pageChanged:)]){
      [self.menuView pageChanged:newPageIndex] ;
   }
   if ([self.viewControllersArray[newPageIndex] respondsToSelector:@selector(reloadData)])
      [self.viewControllersArray[newPageIndex] reloadData];
}


- (void) goToPage:(NSInteger)nPage completion:(void (^)(void))completion
{
   
   if (self.viewControllersArray.count == 0)
      return;
   
   if (nPage > (self.viewControllersArray.count - 1) ||
       nPage == self.pageIndex ||
       isChangingPage)
      return;
   
   //	isGoingToAPage = YES;
   self.proposedPageIndex = nPage;
   BOOL setGoinPage = NO;
   
   __weak MRPaginationController *wself = self;
   if(nPage > self.pageIndex)
   {
      isChangingPage = YES;
      for(NSInteger i = self.pageIndex+1;i <= nPage;i++)
      {
         if(i == nPage)
            setGoinPage = YES;
         
         [self setViewControllers:@[self.viewControllersArray[i]]
                        direction:UIPageViewControllerNavigationDirectionForward
                         animated:YES
                       completion:^(BOOL finished)
          {
             if(setGoinPage)
             {
                wself.pageIndex = wself.proposedPageIndex;
                [wself pageChanged:wself.pageIndex];
                isChangingPage = NO;
             }
             if(completion)
                completion();
          }];
      }
      return;
   }
   else if (nPage < self.pageIndex)
   {
      isChangingPage = YES;
      setGoinPage = NO;
      for(NSInteger i = self.pageIndex-1;i >= nPage;i--)
      {
         if(i == nPage)
            setGoinPage = YES;
         [self setViewControllers:@[self.viewControllersArray[i]]
                        direction:UIPageViewControllerNavigationDirectionReverse
                         animated:YES
                       completion:^(BOOL finished)
          {
             if(setGoinPage)
             {
                wself.pageIndex = wself.proposedPageIndex;
                [wself pageChanged:wself.pageIndex];
                isChangingPage = NO;
             }
             if(completion)
                completion();
          }];
      }
      return;
   }
}

#pragma mark - PageViewController
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
	NSInteger index = [self.viewControllersArray indexOfObject:viewController];
	if (index > 0)
		return self.viewControllersArray[index - 1];
	
	return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
	NSInteger index = [self.viewControllersArray indexOfObject:viewController];
	if (index < self.viewControllersArray.count - 1)
		return self.viewControllersArray[index + 1];
	
	return nil;
}

- (void) pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
	
}

- (void) pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
	UIViewController *viewController = pageViewController.viewControllers[0];
	self.pageIndex = [self.viewControllersArray indexOfObject:viewController];
	[self pageChanged:self.pageIndex];
	isChangingPage = NO;
}


@end


@implementation UIViewController (MRPaginationControllerIndex)

-(NSUInteger)paginationControllerIndex
{
    id parent = self.parentViewController;
    if (parent)
    {
        if ([parent isKindOfClass:MRPaginationController.class])
            return [objc_getAssociatedObject(self, @selector(paginationControllerIndex)) unsignedIntegerValue];
    }
    else
    {
        return NSNotFound;
    }
    
    return [parent paginationControllerIndex];
}

@end

@implementation UIViewController (MRPaginationControllerIndex_private)

-(void)setPaginationControllerIndex:(NSUInteger)index
{
    objc_setAssociatedObject(self, @selector(paginationControllerIndex),
                             @(index), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

