//
//  MRHeaderScrollChainedDelegate.m
//  Notif
//
//  Created by Federico Gasperini on 09/08/16.
//  Copyright © 2016 Federico Gasperini. All rights reserved.
//

#import "MRHeaderScrollChainedDelegate.h"
#import <objc/runtime.h>

@interface MRHeaderScrollChainedDelegate ()

@property (assign) CGPoint lastOffset;

@end

@implementation MRHeaderScrollChainedDelegate
{
   BOOL firstTime;
   CGFloat initialBottom;
}

-(void)setScrollView:(UIScrollView *)scrollView
{
   firstTime = YES;
   _scrollView = scrollView;
   _lastOffset = scrollView.contentOffset;
   _scrollView.contentOffset = CGPointZero;
   _scrollView.bounces = YES;
   _scrollView.alwaysBounceVertical = YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   CGPoint co = scrollView.contentOffset;
   if (co.y <= scrollView.contentSize.height - scrollView.bounds.size.height)
   {
      CGFloat delta = co.y - self.lastOffset.y;
      if (delta < 0)
      {
         if ([self.headerOwner draggingDown:scrollView withOffset:delta])
            scrollView.contentOffset = self.lastOffset;
         else
            self.lastOffset = co;
      }
      else if (delta > 0 && co.y > 0)
      {
         if ([self.headerOwner draggingUp:scrollView withOffset:delta])
            scrollView.contentOffset = self.lastOffset;
         else
            self.lastOffset = co;
      }
      else
         self.lastOffset = co;
   }
   else
      self.lastOffset = co;

   if ([self.nextDelegate respondsToSelector:_cmd])
      [self.nextDelegate scrollViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   if ([self.headerOwner respondsToSelector:@selector(endDragging:)])
      [self.headerOwner endDragging:scrollView];
   if ([self.nextDelegate respondsToSelector:_cmd])
      [self.nextDelegate scrollViewDidEndDecelerating:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
   if (!decelerate && [self.headerOwner respondsToSelector:@selector(endDragging:)])
      [self.headerOwner endDragging:scrollView];
   if ([self.nextDelegate respondsToSelector:_cmd])
      [self.nextDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

-(NSObject<HeaderOwner>*)headerOwner
{
   if (_headerOwner)
      return _headerOwner;
   return self.scrollView.headerOwner;
}

@end

@implementation UIScrollView (dragHeader)

-(NSObject<HeaderOwner>*)headerOwner
{
   id r = objc_getAssociatedObject(self, @selector(headerOwner));
   if (!r)
   {
      r = self.nextResponder;
      while (r && ![r respondsToSelector:@selector(draggingUp:withOffset:)])
         r = [r nextResponder];
      if (r != nil)
         objc_setAssociatedObject(self, @selector(headerOwner), r, OBJC_ASSOCIATION_ASSIGN);
   }
   return r;
}

-(CGFloat)maxVerticalOffsetNotBouncing
{
   return self.contentSize.height
   +self.contentInset.bottom
   -self.contentInset.top    // SIGN NOT TESTED
   -self.frame.size.height;
}

@end
