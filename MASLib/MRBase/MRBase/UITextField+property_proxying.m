//
//  UITextField+property_proxying.m
//  iconick-lib
//
//  Created by Federico Gasperini on 21/12/15.
//  Copyright © 2015 accenture. All rights reserved.
//

#import "UITextField+property_proxying.h"

@import CoreGraphics;
@import QuartzCore;

@implementation UITextField (property_proxying)

@dynamic rightView;
@dynamic rightViewMode;

-(void)setVerticalAdjustment:(CGFloat)verticalAdjustment
{
   self.layer.sublayerTransform = CATransform3DMakeTranslation(0, verticalAdjustment, 0);
}

-(CGFloat)verticalAdjustment
{
   return self.layer.sublayerTransform.m42;
}

-(void)setLeftInset:(CGFloat)leftInset
{
   UIView* li = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                         leftInset,
                                                         self.frame.size.height)];
   li.autoresizingMask = UIViewAutoresizingFlexibleHeight;
   li.backgroundColor = [UIColor clearColor];
   self.leftViewMode = UITextFieldViewModeAlways;
   self.leftView = li;
}

-(CGFloat)leftInset
{
   return self.leftView.frame.size.width;
}

-(void)setRightInset:(CGFloat)rightInset
{
   UIView* li = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                         rightInset,
                                                         self.frame.size.height)];
   li.autoresizingMask = UIViewAutoresizingFlexibleHeight;
   li.backgroundColor = [UIColor clearColor];
   self.rightViewMode = UITextFieldViewModeAlways;
   self.rightView = li;
}

-(CGFloat)rightInset
{
   return self.rightView.frame.size.width;
}

-(IBAction)toggleSecureField:(id)sender
{
   self.secureTextEntry = !self.secureTextEntry;
   self.text = self.text;
//   UIFont *f = self.font;
//   self.font = nil;
//   self.font = f;
   UITextRange* trange = self.selectedTextRange;
   self.selectedTextRange = nil;
   self.selectedTextRange = trange;
}

@end
