//
//  MRCollectionViewDelegate.h
//  Card
//
//  Created by Gai, Fabio on 11/02/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRCollectionViewBase.h"

@protocol MRCollectionViewDelegate <NSObject>
//@required
@optional
- (NSArray *)MRCollectionViewHeaderDatasource:(id)collectionView;
- (NSArray *)MRCollectionViewDatasource:(id)collectionView;
- (NSArray *)MRCollectionViewFooterDatasource:(id)collectionView;
- (CGSize)MRSetSizeOfCollectionView:(id)collectionView forItem:(NSInteger)item;
- (void)MRCollectionView:(id)collectionView DidScrollPage:(NSInteger)page;
- (void)MRCollectionView:(id)collectionView DidTapPage:(NSInteger)page;
- (void)MRCollectionView:(id)collectionView DidTapItem:(NSInteger)item withContent:(id)content;
- (void)MRCollectionView:(id)collectionView didSelectItem:(NSInteger)item withContent:(id)content;
- (void)MRCollectionView:(id)collectionView didDeselectItem:(NSInteger)item withContent:(id)content;
- (void)MRCollectionView:(id)collectionView DidScroll:(CGPoint)offset;
- (void)MRCollectionView:(id)collectionView isInitialized:(BOOL)initialized;

- (void)MRCollectionView:(id)collectionView willDisplayCell:(UICollectionViewCell*)cell withContent:(id)content;

@end
