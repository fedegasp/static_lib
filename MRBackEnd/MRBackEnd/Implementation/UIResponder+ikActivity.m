//
//  UIResponder+ikActivity.m
//  MRBackEnd
//
//  Created by Federico Gasperini on 02/08/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "UIResponder+ikActivity.h"
#import <objc/runtime.h>
#import <MRBase/MRWeakWrapper.h>

__strong static UINib* __nib = nil;

@implementation UIResponder (ikActivity)

+(void)setActivityIndicatorNibName:(NSString *)nibName
{
   __nib = [UINib nibWithNibName:nibName
                          bundle:nil];
}

-(void)startIkActivity
{
   self.ikActivityIndicatorView.hidden = NO;
}

-(void)stopIkActivity
{
   [self.ikActivityIndicatorView removeFromSuperview];
}

-(void)setIkActivityIndicatorView:(UIView *)ikActivityIndicatorView
{
   ikActivityIndicatorView.hidden = YES;
   objc_setAssociatedObject(self,
                            @selector(ikActivityIndicatorView),
                            [MRWeakWrapper weakWrapperWithObject:ikActivityIndicatorView],
                            OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setupActivityIndicatorViewFromNib:(UIView*)v
{
   
}

-(UIView*)ikActivityIndicatorView
{
   UIView* v = [objc_getAssociatedObject(self, @selector(ikActivityIndicatorView)) object];
   if (nil == v && nil !=__nib)
   {
      v = [__nib instantiateWithOwner:nil
                              options:nil].firstObject;
      [self setIkActivityIndicatorView:v];
      [self setupActivityIndicatorViewFromNib:v];
   }
   return v;
}

@end


@implementation UIView (ikActivity)

-(void)setupActivityIndicatorViewFromNib:(UIView*)v
{
   v.center = CGPointMake(self.bounds.size.width / 2.0,
                          self.bounds.size.height / 2.0);
   v.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|
                        UIViewAutoresizingFlexibleRightMargin|
                        UIViewAutoresizingFlexibleTopMargin|
                        UIViewAutoresizingFlexibleBottomMargin;
    if ([self isKindOfClass:UIScrollView.class]) {
      [self.superview addSubview:v];
    
    NSLog(@"");
    }
    else {
      [self addSubview:v];
    NSLog(@"");
    }
}

@end


@implementation UIViewController (ikActivity)

-(void)setupActivityIndicatorViewFromNib:(UIView*)v
{
   [self.view setupActivityIndicatorViewFromNib:v];
}

@end
