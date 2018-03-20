//
//  AnimatingView.h
//  SplashAnimation
//
//  Created by Gai, Fabio on 29/02/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRAnimatingView : UIView
@property (nonatomic) IBInspectable NSString *image;
@property (nonatomic) UIImage *patternImage;
@property (nonatomic) IBInspectable CGFloat duration;
@property IBInspectable BOOL reverse;
@end
