//
//  MRGridParallaxLayout.h
//  MRCustomFlowLayoutExample
//
//  Created by Federico Gasperini on 01/06/17.
//  Copyright © 2017 -. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRGridLayout.h"
#import "MRParallaxLayoutAttributes.h"

@interface MRGridParallaxLayout : MRGridLayout

@property (nonatomic, assign) IBInspectable CGFloat parallaxMultiplier;

@end
