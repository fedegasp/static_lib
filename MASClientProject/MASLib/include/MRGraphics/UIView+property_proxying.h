//
//  UIView+property_proxying.h
//  iconick-lib
//
//  Created by Federico Gasperini on 21/12/15.
//  Copyright © 2015 accenture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (property_proxying)

@property (nonatomic, unsafe_unretained) IBInspectable UIColor* layerShadowColor;

@end
