//
//  CustomFlowLayout.h
//  CollectionTest
//
//  Created by Federico Gasperini on 14/05/17.
//  Copyright © 2017 -. All rights reserved.
//

#import "MRTransposedGridLayout.h"

@interface MRGridLayout : MRTransposedGridLayout

@property (weak, nonatomic, nullable) IBOutlet UIPageControl* pageControl;

@property (assign, nonatomic) IBInspectable NSInteger rows;
@property (assign, nonatomic) IBInspectable NSInteger cols;

@property (strong, nonatomic, nullable) NSArray* data;

@property (strong, nonatomic, nullable) IBInspectable NSString* json;

@end
