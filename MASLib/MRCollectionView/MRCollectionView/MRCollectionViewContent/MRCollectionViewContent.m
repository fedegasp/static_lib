//
//  MRCollectionSliderCell.m
//  CollectionSlider
//
//  Created by Gai, Fabio on 20/04/15.
//  Copyright (c) 2015 Gai, Fabio. All rights reserved.
//

#import "MRCollectionViewContent.h"

@implementation MRCollectionViewContent

-(void)setContent:(id)content{
    
    self.modelData = content;
    if (self.selectedState) {
        [self setSelectedState];
    }else{
        [self setDeselectedState];
    }
}

-(void)didSelect:(BOOL)select{
    if (select) {
        [self setSelectedState];
    }else{
        [self setDeselectedState];
    }
}

-(void)setSelectedState{
    [self setSelectedState:YES];
}

-(void)setDeselectedState{
    [self setSelectedState:NO];
}

@end
