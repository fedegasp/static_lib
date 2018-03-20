//
//  MMRParallaxLayoutAttributes.h
//  MRCustomFlowLayoutExample
//
//  Created by Federico Gasperini on 01/06/17.
//  Copyright © 2017 -. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRParallaxLayoutAttributes : UICollectionViewLayoutAttributes

@property (assign, nonatomic) CGFloat percentage;
@property (assign, nonatomic) CGAffineTransform antiParallax;
@property (assign, nonatomic) CGAffineTransform parallax;
@property (assign, nonatomic) CGAffineTransform counterParallax;
@property (assign, nonatomic) BOOL isTopItem;

@end
