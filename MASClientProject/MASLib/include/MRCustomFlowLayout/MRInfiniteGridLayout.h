//
//  MRInfiniteGridLayout.h
//  CollectionTest
//
//  Created by Federico Gasperini on 22/05/17.
//  Copyright © 2017 -. All rights reserved.
//

#import "MRTransposedGridLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface MRInfiniteGridLayout : MRTransposedGridLayout

@property (weak, nonatomic, nullable) IBOutlet UIPageControl* pageControl;
@property (strong, nonatomic, nullable) NSArray* data;

@property (strong, nonatomic, nullable) IBInspectable NSString* json;

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath*)indexPath;

-(void)scrollToNearestIndex:(NSInteger)item;
-(void)scrollToNearestItem:(id)item;

@end

NS_ASSUME_NONNULL_END
