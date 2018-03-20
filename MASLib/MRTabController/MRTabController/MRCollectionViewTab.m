//
//  MRCollectionViewTab.m
//  MRTabController
//
//  Created by Gai, Fabio on 20/10/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import "MRCollectionViewTab.h"

@implementation MRCollectionViewTab

-(void)layoutSubviews{
    [super layoutSubviews];
    [self layoutIfNeeded];
    
    if (!self.viewLoaded) {
        [self setTabCarousel];
        [self setContentCarousel];
        [self addSubview:self.tabCarousel];
        [self addSubview:self.contentCarousel];
        [self setViewLoaded:YES];
    }
}

-(void)MRCollectionView:(id)collectionView isInitialized:(BOOL)initialized{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.position inSection:0];
    [self scrollTabCarousel:indexPath];
}

-(void)setTabCarousel{
    
    CGRect f = CGRectMake(0,
                          0,
                          self.frame.size.width,
                          self.tabHeight);
    
    self.tabCarousel = [[MRCollectionView alloc] initWithFrame:f];
    self.tabCarousel.backgroundColor = self.tabBackground;
    self.tabCarousel.tag = 1;
    self.tabCarousel.plist = self.tabPlist;
    self.tabCarousel.json = self.tabJson;
    self.tabCarousel.jsonKey = self.tabJsonKey;
    self.tabCarousel.customCell = self.tabCustomCell;
    self.tabCarousel.isPaginated = NO;
    self.tabCarousel.horizontalItemsInGrid = self.tabItemsInGrid;
    self.tabCarousel.verticalItemsInGrid = 1;
    self.tabCarousel.slideHorizontal = YES;
    self.tabCarousel.horizontalLayout= YES;
    self.tabCarousel.delegate = self;
}

-(void)setContentCarousel{
    
    CGRect f = CGRectMake(0,
                          self.tabHeight,
                          self.frame.size.width,
                          self.frame.size.height);
    
    self.contentCarousel = [[MRCollectionView alloc] initWithFrame:f];
    self.contentCarousel.backgroundColor = self.contentBackground;
    self.contentCarousel.tag = 2;
    self.contentCarousel.plist = self.contentPlist;
    self.contentCarousel.json = self.contentJson;
    self.contentCarousel.jsonKey = self.contentJsonKey;
    self.contentCarousel.customCell = self.contentCustomCell;
    self.contentCarousel.slideOnTap = self.contentSlideOnTap;
    self.contentCarousel.itemsPerView = 1;
    self.contentCarousel.disableGrid = YES;
    self.contentCarousel.isPaginated = YES;
    self.contentCarousel.slideHorizontal = YES;
    self.contentCarousel.horizontalLayout= YES;
    self.contentCarousel.delegate = self;
}

-(void)MRCollectionView:(MRCollectionView *)collectionView DidTapItem:(NSInteger)item withContent:(id)content{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
    
    if (collectionView == self.tabCarousel) {
        [self scrollTabCarousel:indexPath];
        [self.contentCarousel scrollToPage:@(item) animated:YES];
    }

}

-(void)scrollTabCarousel:(NSIndexPath *)indexPath{
        [self.tabCarousel.collectionView selectItemAtIndexPath:indexPath
                                                      animated:YES
                                                scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

-(void)MRCollectionView:(id)collectionView DidScrollPage:(NSInteger)page{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:page inSection:0];
    if (collectionView == self.contentCarousel){
        [self.tabCarousel.collectionView selectItemAtIndexPath:indexPath
                                                      animated:YES
                                                scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
}

@end
