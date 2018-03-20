//
//  MRBaseGridLayout.h
//  CollectionTest
//
//  Created by Federico Gasperini on 14/05/17.
//  Copyright © 2017 -. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRLayout.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MRGridLayoutDelegate < MRLayoutDelegate,
UICollectionViewDelegate >

@optional
-(void)collectionView:(UICollectionView*)collectionView
       didShowSection:(NSInteger)section;

@end


@interface MRBaseGridLayout : MRCollectionFlowLayout
                            < UICollectionViewDelegate,
                              UICollectionViewDataSource >
{
   NSInteger _currentSection;
}

@property (weak, nonatomic, nullable) id<MRGridLayoutDelegate> collectionViewDelegate;

@property (assign, nonatomic) NSInteger rows;
@property (assign, nonatomic) NSInteger cols;

-(void)setCurrentSection:(NSInteger)section;
-(void)updateCurrentSection;

-(BOOL)scrollToNextSection;

@property (readonly, nonatomic) NSInteger currentSection;

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath*)indexPath;

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
