//
//  MRCollectionSliderCell.h
//  CollectionSlider
//
//  Created by Gai, Fabio on 20/04/15.
//  Copyright (c) 2015 Gai, Fabio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICollectionViewCell+MRCarouselContent.h"
@class MRCollectionView;

@interface MRCollectionViewContent : UICollectionViewCell
@property (assign) BOOL selectedState;
@property (nonatomic) id modelData;
@property (nonatomic) id parentCollectionView;
-(void)didSelect:(BOOL)select;
-(void)setSelectedState;
-(void)setDeselectedState;
@end


