//
//  UIControl+currentFirstResponder.m
//  iconick-lib
//
//  Created by Federico Gasperini on 19/01/16.
//  Copyright © 2016 accenture. All rights reserved.
//

#import "UIControl+currentFirstResponder.h"

__weak static UIControl* __currentFirstResponderWeak = nil;

@implementation UIControl (currentFirstResponder)

+(UIControl*)currentFirstResponder
{
   __currentFirstResponderWeak = nil;
   [[UIApplication sharedApplication] sendAction:@selector(setCurrentFirstResponder)
                                              to:nil
                                            from:nil
                                        forEvent:nil];
   return __currentFirstResponderWeak;
}

-(void)setCurrentFirstResponder
{
   __currentFirstResponderWeak = self;
}

-(IBAction)becomeFirstResponder:(id)sender
{
   [self becomeFirstResponder];
}

@end
