//
//  UIView+Utils.m
//  MRBase
//
//  Created by Enrico Luciano on 31/07/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "UIView+Utils.h"

@implementation UIView (Utils)

-(UIViewController*)viewController
{
    id retval = self.nextResponder;
    while (retval && ![retval isKindOfClass:UIViewController.class])
        retval = [retval nextResponder];
    return retval;
}

-(void)showActivityIndicator {
    
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]init];
    spinner.color = [UIColor blackColor];
    spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    spinner.tag = 124;
    spinner.translatesAutoresizingMaskIntoConstraints = NO;

    [self addSubview:spinner];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:spinner attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:spinner attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];

    [self bringSubviewToFront:spinner];

    [spinner startAnimating];
    
}

-(void)removeActivityIndicator {
    
    for (UIActivityIndicatorView* spinner in self.subviews) {
        
        if (spinner.tag == 124 && [spinner isKindOfClass:UIActivityIndicatorView.class]) {
            
            [spinner removeFromSuperview];
            break;
        }
    }
    
}

-(void)showErrorMessage:(NSString*)message withOffset:(CGFloat)offset {
    
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text= message;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.tag = 123;
    label.font = [UIFont fontWithName:@"TitilliumWeb-SemiBold" size:20];
    label.textColor = [UIColor colorWithRed:102.0/255.0 green:111.0/255.0 blue:139.0/255.0 alpha:1];
    [self addSubview:label];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];

    
    
     [self addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:offset]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:20.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-20.0]];
    
    [self bringSubviewToFront:label];

}

-(void)showCenteredErrorMessage:(NSString*)message {
	UILabel *label = [[UILabel alloc]init];
	label.backgroundColor = [UIColor clearColor];
	label.translatesAutoresizingMaskIntoConstraints = NO;
	label.text= message;
	label.textAlignment = NSTextAlignmentCenter;
	label.numberOfLines = 0;
	label.tag = 123;
	label.font = [UIFont fontWithName:@"TitilliumWeb-SemiBold" size:20];
	label.textColor = [UIColor colorWithRed:102.0/255.0 green:111.0/255.0 blue:139.0/255.0 alpha:1];
	[self addSubview:label];
	
	[self addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
	
	[self addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];

	
	[self addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-30]];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0.7 constant:0]];

	
	[self bringSubviewToFront:label];
	

}


-(void)removeErrorView {
    
    for (UIView* label in self.subviews) {
        
        if (label.tag == 123 && [label isKindOfClass:UILabel.class]) {
            
            [label removeFromSuperview];
            break;
        }
    }
}

-(void)fadeErrorView:(float)alpha {
    
    for (UIView* label in self.subviews) {
        
        if (label.tag == 123 && [label isKindOfClass:UILabel.class]) {
            
            [UIView animateWithDuration:.15
                             animations:^{
                                 
                                 label.alpha = alpha;
                                 
                             }];
            break;
        }
    }
   
  
}



@end
