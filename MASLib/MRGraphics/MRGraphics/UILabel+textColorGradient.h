//
//  UILabel+textColorGradient.h
//  MRGraphics
//
//  Created by Federico Gasperini on 13/06/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+gradient.h"

@interface UILabel (textColorGradient)

#if TARGET_INTERFACE_BUILDER
@property (assign, nonatomic) IBInspectable NSInteger textGradientDirection;
#else
@property (nonatomic, assign) GradientDirection textGradientDirection;
#endif

@property (nonatomic, strong) IBInspectable UIColor* textFirstColor;
@property (nonatomic, strong) IBInspectable UIColor* textSecondColor;

@property (nonatomic, assign) IBInspectable CGPoint textStartPoint;
@property (nonatomic, assign) IBInspectable CGPoint textEndPoint;

-(void)setTextAnimated:(NSString*)text;

@end


@interface UILabel (textColorGradient_ibinspectable)

@property (assign, nonatomic) IBInspectable NSInteger textGradientDirection;

@end
