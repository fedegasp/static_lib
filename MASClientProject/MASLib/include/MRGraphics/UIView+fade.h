//
//  UIView+fade.h
//  test
//
//  Created by Federico Gasperini on 16/02/17.
//  Copyright © 2017 Federico Gasperini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (fade)

@property (readwrite) IBInspectable BOOL avoidFading;
-(void)fadeEffect:(BOOL)addEffect;

@end
