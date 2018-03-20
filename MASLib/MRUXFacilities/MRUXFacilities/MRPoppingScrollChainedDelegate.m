//
//  MRPoppingScrollChainedDelegate.m
//  MRUXFacilities
//
//  Created by Federico Gasperini on 31/05/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "MRPoppingScrollChainedDelegate.h"

#define PI 3.14159265
#define RAD(X) ((X)*(PI/180.0))

@interface MRPoppingScrollChainedDelegate () <UIScrollViewDelegate>

@property (readonly, getter=isOpened) BOOL opened;

@end


@implementation MRPoppingScrollChainedDelegate
{
   UIScrollView* _targetScrollView;
   CGPoint targetContentOffset;
   CGPoint CGPointOpened;
   CGFloat lastY;
   CGFloat spare;
}

-(CGFloat)treshold
{
   return _treshold ?: 80.0;
}

-(CGFloat)poppingSize
{
   return _poppingSize > 0
          ? MIN(_poppingSize, _targetScrollView.frame.size.height)
          : _targetScrollView.frame.size.height;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   if ([self.nextDelegate respondsToSelector:_cmd])
      [self.nextDelegate scrollViewDidScroll:scrollView];

   if (_targetScrollView == nil)
   {
      _targetScrollView = scrollView;
      CGPointOpened  = CGPointMake(0, self.poppingSize);
   }
   
   CGPoint co = scrollView.contentOffset;
   CGFloat delta = co.y - lastY;
   
   if (scrollView.panGestureRecognizer.enabled)
   {
      if (!self.isOpened)
      {
         if (co.y >= self.treshold)
         {
            targetContentOffset = CGPointOpened;
            scrollView.panGestureRecognizer.enabled = NO;
         }
         else
         {
            targetContentOffset = CGPointZero;
            
            if (scrollView.isDragging)
            {
               CGFloat a = self.treshold * 3;
               CGFloat b = pow(lastY, 2.0);
               scrollView.contentOffset = CGPointMake(0, lastY + delta * MAX(1.0 - sin(RAD(b/a)), .88));
            }
         }
      }
      else
      {
         if (co.y <= (self.poppingSize - self.treshold))
         {
            targetContentOffset = CGPointZero;
            scrollView.panGestureRecognizer.enabled = NO;
         }
         else if (co.y <= self.poppingSize)
         {
            targetContentOffset = CGPointOpened;
            if (scrollView.isDragging)
            {
               CGFloat a = self.treshold * 3;
               CGFloat b = pow(lastY - self.poppingSize, 2.0);
               scrollView.contentOffset = CGPointMake(0, lastY + delta * MAX(1.0 - sin(RAD(b/a)), .88));
            }
         }
         else
            targetContentOffset = co;
      }
   }
   else
   {
      if (scrollView.contentOffset.y == targetContentOffset.y)
      {
         scrollView.panGestureRecognizer.enabled = YES;
      }
   }
   lastY = scrollView.contentOffset.y;
   if (_opened)
      _opened = lastY != 0;
   else
      _opened = lastY >= self.poppingSize;
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                    withVelocity:(CGPoint)velocity
             targetContentOffset:(inout CGPoint *)targetContentOffsetRef
{
   if (scrollView.contentOffset.y < self.treshold)
   {
      if (velocity.y > 1.5)
      {
         scrollView.panGestureRecognizer.enabled = NO;
         targetContentOffset = CGPointOpened;
         targetContentOffsetRef->y = scrollView.contentOffset.y;
         [scrollView setContentOffset:scrollView.contentOffset
                             animated:NO];
      }
      else
      {
         scrollView.panGestureRecognizer.enabled = NO;
         [scrollView setContentOffset:scrollView.contentOffset
                             animated:NO];
         targetContentOffset = CGPointZero;
         targetContentOffsetRef->y = targetContentOffset.y;
      }
   }
   else if (self.isOpened)
   {
      if (velocity.y < -2.5)
      {
         scrollView.panGestureRecognizer.enabled = NO;
         targetContentOffset = CGPointZero;
         targetContentOffsetRef->y = scrollView.contentOffset.y;
         [scrollView setContentOffset:scrollView.contentOffset
                             animated:NO];
      }
      else if (velocity.y < 0)
         targetContentOffsetRef->y = MAX(targetContentOffsetRef->y, self.poppingSize);
   }

   if ([self.nextDelegate respondsToSelector:_cmd])
      [self.nextDelegate scrollViewWillEndDragging:scrollView
                                      withVelocity:velocity
                               targetContentOffset:targetContentOffsetRef];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
   scrollView.panGestureRecognizer.enabled = YES;
   [scrollView setContentOffset:targetContentOffset
                       animated:YES];
   if ([self.nextDelegate respondsToSelector:_cmd])
      [self.nextDelegate scrollViewDidEndScrollingAnimation:scrollView];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
   scrollView.panGestureRecognizer.enabled = YES;
   [scrollView setContentOffset:targetContentOffset
                       animated:YES];
   if ([self.nextDelegate respondsToSelector:_cmd])
      [self.nextDelegate scrollViewDidEndDecelerating:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
   if (!decelerate)
   {
      scrollView.panGestureRecognizer.enabled = YES;
      [scrollView setContentOffset:targetContentOffset
                          animated:YES];
   }
   
   if ([self.nextDelegate respondsToSelector:_cmd])
      [self.nextDelegate scrollViewDidEndDragging:scrollView
                                   willDecelerate:(BOOL)decelerate];
}

//-(BOOL)respondsToSelector:(SEL)aSelector
//{
//   NSLog(@"%@", NSStringFromSelector(aSelector));
//   return [super respondsToSelector:aSelector];
//}

@end
