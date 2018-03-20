//
//  MRHeaderOwnerPluginResponder.h
//  MRUXFacilities
//
//  Created by Federico Gasperini on 09/08/16.
//  Copyright © 2016 Accenture. All rights reserved.
//

#import "MRHeaderOwnerPluginResponder.h"
#import <MRBase/MRMacros.h>

@interface PlugInResponder ()

@property (weak, nonatomic) UIViewController* pluggedViewController;

@end

@implementation MRHeaderOwnerPluginResponder
{
   CGFloat startValue;
   BOOL directionUp;
   BOOL notifyPercentage;
}

-(instancetype)init
{
   self = [super init];
   if (self)
      _enabled = YES;
   return self;
}

-(void)setPluggedViewController:(UIViewController*)viewController
{
   [super setPluggedViewController:viewController];
   notifyPercentage = [viewController respondsToSelector:@selector(headerScrollingPercentage:)];
}

-(void)setHeaderHeightConstraint:(NSLayoutConstraint *)headerHeightConstraint
{
   _headerHeightConstraint = headerHeightConstraint;
   startValue = headerHeightConstraint.constant;
}

-(void)setEnabled:(BOOL)enabled
{
   _enabled = enabled;
   if (!enabled)
   {
      self.headerHeightConstraint.constant = startValue;
      [self.pluggedViewController.view updateConstraints];
   }
}

-(BOOL)draggingUp:(UIScrollView*)scrollView withOffset:(CGFloat)offset
{
   if (self.enabled)
   {
      directionUp = YES;
      self.headerHeightConstraint.constant = MAX(0, self.headerHeightConstraint.constant - offset);
      [self.pluggedViewController.view updateConstraints];
      if (self.adjustContentOffset)
         return self.headerHeightConstraint.constant > 0;
      if (notifyPercentage)
         [self.pluggedViewController headerScrollingPercentage:self.headerHeightConstraint.constant/startValue];
   }
   return NO;
}

-(BOOL)draggingDown:(UIScrollView*)scrollView withOffset:(CGFloat)offset
{
   if (self.enabled && (self.scrollDownImmediatly || scrollView.contentOffset.y <= startValue))
   {
      directionUp = NO;
      
      self.headerHeightConstraint.constant = MIN(startValue, self.headerHeightConstraint.constant - offset);
      [self.pluggedViewController.view updateConstraints];
      if (self.adjustContentOffset)
         return self.headerHeightConstraint.constant < startValue;
      if (notifyPercentage)
         [self.pluggedViewController headerScrollingPercentage:self.headerHeightConstraint.constant/startValue];
   }
   return NO;
}

-(CGFloat)headerHeight
{
   return startValue;
}

-(void)endDragging:(UIScrollView *)scrollView
{
   if (self.enabled && self.magneticEdges)
   {
      [self.pluggedViewController.view layoutIfNeeded];
      CGFloat targetValue = startValue;
      if (self.headerHeightConstraint.constant < startValue / 4.0 ||
          (self.headerHeightConstraint.constant < startValue / 1.33 &&
           directionUp))
         targetValue = .0;
      
      self.headerHeightConstraint.constant = targetValue;
      [UIView animateWithDuration:SPEEDY_ANIMATION_DURATION
                       animations:^{
                          [self.pluggedViewController.view layoutIfNeeded];
                          if (notifyPercentage)
                             [self.pluggedViewController headerScrollingPercentage:self.headerHeightConstraint.constant/startValue];
                       }];
   }
}

@end
