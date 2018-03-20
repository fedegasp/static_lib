//
//  IKCarousel.h
//  IKCarousel
//
//  Created by Gai, Fabio on 22/05/15.
//  Copyright (c) 2015 Gai, Fabio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCollectionViewCard.h"

@interface MRCollectionView : MRCollectionViewCard
@property id modelData;
@property (nonatomic, strong) IBOutlet UICollectionViewFlowLayout *customLayout;
@property IBInspectable BOOL isCustomLayout;
@end

