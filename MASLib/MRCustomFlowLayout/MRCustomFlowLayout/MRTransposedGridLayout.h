//
//  MRTransposedGridLayout.h
//  CollectionTest
//
//  Created by Federico Gasperini on 22/05/17.
//  Copyright © 2017 -. All rights reserved.
//

#import "MRBaseGridLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface MRTransposedGridLayout : MRBaseGridLayout

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath*)indexPath;

-(BOOL)indexPathIsEmpty:(NSIndexPath*)indexPath;

@end

NS_ASSUME_NONNULL_END
