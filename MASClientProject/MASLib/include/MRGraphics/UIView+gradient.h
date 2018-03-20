//
//  UIView+gradient.h
//  MASClient
//
//  Created by Federico Gasperini on 16/05/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GradientDirection) {
   GradientDirectionDisabled,
   GradientDirectionHorizontal,
   GradientDirectionVertical,
   GradientDirectionCustom
};

@interface UIView (gradient)

@property (nonatomic, assign) GradientDirection gradientDirection;

@property (nonatomic, strong) IBInspectable UIColor* firstColor;
@property (nonatomic, strong) IBInspectable UIColor* secondColor;

@property (nonatomic, assign) IBInspectable CGPoint startPoint;
@property (nonatomic, assign) IBInspectable CGPoint endPoint;

@property (readonly) CAGradientLayer* gradientLayer;

@end


@interface UIView (gradient_ibinspectable)

@property (assign, nonatomic) IBInspectable NSInteger gradientDirection;

@end
