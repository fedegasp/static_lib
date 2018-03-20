//
//  MRCollectionViewHeader.h
//  ParallaxCollectionView
//
//  Created by Gai, Fabio on 10/02/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import "MRCollectionView.h"
#import <UIKit/UIKit.h>

@interface MRCollectionViewHeader : UICollectionReusableView
@property id modelData;
@property MRCollectionView *parentCollectionView;
@end
