//
//  UIView+errorStateView.m
//  MRUXFacilities
//
//  Created by Sattar Falahati on 14/06/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "UIView+errorStateView.h"

@implementation UIView (errorStateView)

- (void)setErrorState
{
    NSArray *arr = self.subviews;
    
    if (arr.count != 0) {
        
        for (UIView *v in arr) {
            v.hidden = NO;
        }
    }
    self.hidden = NO;
}

- (void)clearErrorState
{
    NSArray *arr = self.subviews;
    
    if (arr.count != 0) {
        
        for (UIView *v in arr) {
            v.hidden = YES;
        }
    }
    
    self.hidden = YES;
}


@end
