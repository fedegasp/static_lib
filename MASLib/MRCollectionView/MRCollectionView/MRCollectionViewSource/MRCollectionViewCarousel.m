//
//  MRCollectionViewCarousel.m
//  Card
//
//  Created by Gai, Fabio on 11/02/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import "MRCollectionViewCarousel.h"

@implementation MRCollectionViewCarousel

-(void)setGridDataArray{
    
    if (!self.disableGrid &&
        self.isPaginated &&
        self.horizontalItemsInGrid &&
        self.verticalItemsInGrid &&
        self.dataArray.count > 0) {
        
        NSInteger totalCellsInPage =self.horizontalItemsInGrid * self.verticalItemsInGrid;
        [self setNumberOfPages:ceil(self.dataArray.count/totalCellsInPage)];
        NSInteger remnantCells = [self.dataArray count]%totalCellsInPage;
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:self.dataArray];
        
        if (remnantCells > 0) {
            do {
                [tempArray addObject:[NSNull null]];
                remnantCells +=1;
            } while (remnantCells < totalCellsInPage);
        }
        self.dataArray = tempArray;
    }
}

-(void)initCollectionView{
    [super initCollectionView];
    
    [self setGridDataArray];
    
    if (self.slideHorizontal) {
        [self.standardflowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    }else{
        [self.standardflowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    }
    
    [self setNumberOfItems:[self.dataArray count]];
    [self setNumberOfPages:ceil(self.numberOfItems/self.itemsPerView)];
    
    [self.pageControl setNumberOfPages:self.numberOfPages];
    [self.pageControl setCurrentPage:0];
    [self.pageControl setHidesForSinglePage:!self.showPagerForSinglePage];
    
    [self setCurrentPage:0];
    [self.backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.forwardBtn addTarget:self action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
    [self updateButtons];
}

-(CGSize)collectionView:(UICollectionView *)collectionView
                 layout:(UICollectionViewLayout *)collectionViewLayout
 sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.disableGrid) {
        if (self.slideHorizontal) {
            if (self.horizontalLayout) {
                return CGSizeMake((self.collectionView.frame.size.width/self.itemsPerView),
                                  self.collectionView.frame.size.height);
            }else{
                return CGSizeMake(self.collectionView.frame.size.width,
                                  (self.collectionView.frame.size.height/self.itemsPerView));
            }
        }else{
            if (self.horizontalLayout) {
                return CGSizeMake((self.collectionView.frame.size.width/self.itemsPerView),
                                  self.collectionView.frame.size.height);
            }else{
                return CGSizeMake(self.collectionView.frame.size.width,
                                  (self.collectionView.frame.size.height/self.itemsPerView));
            }
        }
    }else{
        return [super itemSize];
    }
    
}

#pragma mark update pages

-(void)updateCarousel:(NSTimer *)theTimer {
    
    self.currentPage = [self nextPage];
    [self scrollToPage:@(self.currentPage) animated:YES];
    [self updatePageControl];
    [self notifyUpdatedPage];
}

-(void)updatePageControl{
    
    [self.pageControl setCurrentPage:self.currentPage];
    [self updateButtons];
}

- (NSInteger)nextPage {
    
    if ([self numberOfPages] == 0) {
        return 0;
    }
    
    NSInteger nextPage;
    if (_directionReverse) {
        nextPage = 0;
        self.currentPage = 0;
        _directionReverse = !_directionReverse;
    }
    else {
        nextPage = self.currentPage + 1;
        self.currentPage += 1;
    }
    
    if (nextPage >= 0 && nextPage < [self numberOfPages]) {
        return nextPage;
    }
    else {
        _directionReverse = !_directionReverse;
        return [self nextPage];
    }
}

- (void)scrollToPage:(NSNumber *)pageNumber {
    [self scrollToPage:pageNumber animated:NO];
    
}

- (void)scrollToPage:(NSNumber *)pageNumber animated: (BOOL)animated{
   
    NSLog(@"page numver %@", pageNumber);
    
    @try {
        if ([pageNumber integerValue] >= 0) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:pageNumber.integerValue*self.itemsPerView inSection:0];
            
            if (self.slideHorizontal == YES) {
                
                [self iphone4Handle:^{
                    self.collectionView.contentOffset = CGPointMake(self.collectionView.frame.size.width*pageNumber.integerValue,
                                                                    self.collectionView.frame.origin.y);
                } else:^(BOOL iPhone5, BOOL iPhone6, BOOL iPhone6Plus) {
                    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:animated];
                }];
                
            }else{
                if (self.horizontalLayout) {
                    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:animated];
                }else{
                    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:animated];
                }
            }
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"exc %@", exception);
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    
    if (self.centerCellOnTap) {
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    
    if (self.slideOnTap){
        [self updateCarousel:nil];
    }
}

-(void)goBack{
    self.currentPage -= 1;
    [self scrollToPage:[NSNumber numberWithInteger:self.currentPage] animated:YES];
    [self updatePageControl];
    [self notifyUpdatedPage];
    
}

-(void)goForward{
    self.currentPage += 1;
    [self scrollToPage:[NSNumber numberWithInteger:self.currentPage] animated:YES];
    [self updatePageControl];
    [self notifyUpdatedPage];
}



-(void)updateButtons{
    
    if (self.dataArray.count <=1) {
        self.forwardBtn.hidden= YES;
        self.backBtn.hidden = YES;
    }else{
        if (self.currentPage == [self numberOfPages]-1) {
            self.forwardBtn.hidden= YES;
            self.backBtn.hidden = NO;
            
        }else if (self.currentPage == 0) {
            self.forwardBtn.hidden= NO;
            self.backBtn.hidden = YES;
        }
        else{
            self.forwardBtn.hidden= NO;
            self.backBtn.hidden = NO;
        }
    }
}

-(void)notifyUpdatedPage{
    if ([self.delegate respondsToSelector:@selector(MRCollectionView:DidScrollPage:)]) {
        [self.delegate MRCollectionView:self DidScrollPage:(int)self.currentPage];
    }
}

@end
