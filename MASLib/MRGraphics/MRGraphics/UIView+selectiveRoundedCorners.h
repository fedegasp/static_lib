//
//  UIView+selectiveRoundedCorners.h
//  test
//
//  Created by Federico Gasperini on 16/02/17.
//  Copyright © 2017 Federico Gasperini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (selectiveRoundedCorners)

@property (nonatomic, unsafe_unretained) IBInspectable BOOL circularBounds;

@property (nonatomic, unsafe_unretained) IBInspectable UIColor* layerBorderColor;

@property(nonatomic, assign) IBInspectable CGFloat borderWidth;

@property (nonatomic, assign) UIRectCorner cornerMask;

@property(nonatomic, assign) IBInspectable CGFloat borderRadius;

@end

@interface UIView (selectiveRoundedCorners_ibinspectable)

@property (assign, nonatomic) IBInspectable NSInteger cornerMask;

@end
