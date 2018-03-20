//
//  IKCarousel.m
//  IKCarousel
//
//  Created by Gai, Fabio on 22/05/15.
//  Copyright (c) 2015 Gai, Fabio. All rights reserved.
//

#import "MRCollectionView.h"

@implementation MRCollectionView

-(void)initCollectionView{
    [super initCollectionView];
    
    if (self.isCustomLayout) {
        [self.collectionView setCollectionViewLayout:self.customLayout];
        [self.customLayout setParent:self];
    }
}

@end
