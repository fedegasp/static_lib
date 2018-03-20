//
//  UIView+Utils.h
//  MRBase
//
//  Created by Enrico Luciano on 31/07/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utils)

@property (readonly, nonatomic) UIViewController* viewController;
-(void)showErrorMessage:(NSString*)message withOffset:(CGFloat)offset;
-(void)showCenteredErrorMessage:(NSString*)message;
-(void)removeErrorView ;
-(void)removeActivityIndicator ;
-(void)showActivityIndicator;
-(void)fadeErrorView:(float)alpha;
@end
