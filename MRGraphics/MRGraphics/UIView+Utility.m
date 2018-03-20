//
//  UIView+Utility.m
//
//  Created by fabio on 04/08/15.
//  Copyright (c) 2015 fabio. All rights reserved.
//

#import "UIView+Utility.h"

@implementation UIView (Utility)
-(void)setContent:(id)content{
    
}
- (id) findNextResponder{
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder findNextResponder];
    } else {
        return nil;
    }
}

-(CGFloat)fractionVisible
{
    if (self.window)
    {
        CGFloat tot = self.frame.size.width * self.frame.size.height;
        CGRect displayed = [self convertRect:self.bounds toView:self.window];
        CGRect superview = self.window.bounds;
        CGRect visible = CGRectIntersection(superview, displayed);
        return (visible.size.width * visible.size.height) / tot;
    }
    return .0;
}

@end
