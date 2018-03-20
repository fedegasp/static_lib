//
//  MRTransposedGridLayout.m
//  CollectionTest
//
//  Created by Federico Gasperini on 22/05/17.
//  Copyright © 2017 -. All rights reserved.
//

#import "MRTransposedGridLayout.h"
#import <objc/runtime.h>

#pragma mark - Private stuff

@interface UICollectionViewLayoutAttributes (translation)

@property (assign, nonatomic, getter=isTranslated) BOOL translated;

@end


#pragma mark - MRGridLayout

@implementation MRTransposedGridLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
   NSArray * array = [super layoutAttributesForElementsInRect:rect];
   
   if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
   for (UICollectionViewLayoutAttributes* attr in array)
   if (!attr.isTranslated)
   {
      attr.indexPath = [self translateIndexPath:attr.indexPath];
      attr.translated = YES;
   }
   
   return array;
}

-(NSIndexPath*)translateIndexPath:(NSIndexPath*)indexPath
{
   NSInteger item = indexPath.item;
   item = (item / self.rows) + ((item % self.rows) * self.cols);
   NSIndexPath* retIdx = [NSIndexPath indexPathForItem:item inSection:indexPath.section];
   return retIdx;
}

#pragma mark - UICollectionViewDataSource

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   UICollectionViewCell *cell = nil;
   
   if (![self indexPathIsEmpty:indexPath])
      cell = [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
   
   if (!cell)
   {
         cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMRGridEmptyCellIdentifier
                                                          forIndexPath:indexPath];
         cell.userInteractionEnabled = NO;
   }
   
   return cell;
}

-(BOOL)indexPathIsEmpty:(NSIndexPath *)indexPath
{
   return NO;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
   [super collectionView:collectionView
         willDisplayCell:cell
      forItemAtIndexPath:indexPath];
   if (![self indexPathIsEmpty:indexPath] &&
       [self.collectionViewDelegate respondsToSelector:_cmd])
   [self.collectionViewDelegate collectionView:collectionView
                               willDisplayCell:cell
                            forItemAtIndexPath:indexPath];
}

@end


#pragma mark - UICollectionViewLayoutAttributes (translation)

@implementation UICollectionViewLayoutAttributes (translation)

-(void)setTranslated:(BOOL)translated
{
   objc_setAssociatedObject(self, @selector(isTranslated),
                            @(translated), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)isTranslated
{
   return [objc_getAssociatedObject(self, @selector(isTranslated)) boolValue];
}

@end
