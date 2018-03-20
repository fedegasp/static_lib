//
//  MRBaseGridLayout.m
//  CollectionTest
//
//  Created by Federico Gasperini on 14/05/17.
//  Copyright © 2017 -. All rights reserved.
//

#import "MRBaseGridLayout.h"
#if __has_include(<MRBase/MRMacros.h>)
#   import <MRBase/MRMacros.h>
#else
#   define DEFAULT_ANIMATION_DURATION .3
#endif

#pragma mark - MRGridLayout

@implementation MRBaseGridLayout

@dynamic collectionViewDelegate;

-(id)init
{
   self = [super init];
   if (self)
      _currentSection = -1;
   return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
   self = [super initWithCoder:aDecoder];
   if (self)
      _currentSection = -1;
   return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
   if (CGSizeEqualToSize(self.collectionView.bounds.size, newBounds.size))
      return NO;
   
   NSInteger currentSection = _currentSection;
   dispatch_async(dispatch_get_main_queue(), ^{
      
      [self.collectionView reloadData];
      UIScrollView* scrollView = self.collectionView;
      CGPoint offset = CGPointMake(0, 0);
      if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
         offset.x = (newBounds.size.width - scrollView.contentInset.left - scrollView.contentInset.right) * currentSection - scrollView.contentInset.left;
      else
         offset.y = (newBounds.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom) * currentSection - scrollView.contentInset.top;
      scrollView.contentOffset = offset;
      
   });
   return YES;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
   if (!self.collectionView.pagingEnabled)
   {
      if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
         self.collectionView.pagingEnabled = (self.collectionView.contentInset.left == 0 && self.collectionView.contentInset.right == 0);
      else
         self.collectionView.pagingEnabled = (self.collectionView.contentInset.top == 0 && self.collectionView.contentInset.bottom == 0);
   }
   if ([self.collectionViewDelegate respondsToSelector:_cmd])
      [self.collectionViewDelegate scrollViewWillBeginDragging:scrollView];
}

-(void)invalidateLayout
{
   CGRect collectionFrame = self.collectionView.bounds;
   collectionFrame = UIEdgeInsetsInsetRect(collectionFrame, self.sectionInset);
   
   CGFloat w = collectionFrame.size.width - self.collectionView.contentInset.left - self.collectionView.contentInset.right;
   CGFloat h = collectionFrame.size.height - self.collectionView.contentInset.top - self.collectionView.contentInset.bottom;
   
   if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
   {
      w -= (self.minimumLineSpacing * (self.cols - 1));
      h -= (self.minimumInteritemSpacing * (self.rows - 1));
   }
   else
   {
      w -= (self.minimumInteritemSpacing * (self.cols - 1));
      h -= (self.minimumLineSpacing * (self.rows - 1));
   }

   w = w / (CGFloat)self.cols;
   h = h / (CGFloat)self.rows;
   
   self.itemSize = CGSizeMake(w, h);
   
   [super invalidateLayout];
}

-(CGFloat)minimumInteritemSpacing
{
   if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
      return [super minimumLineSpacing];
   return [super minimumInteritemSpacing];
}

-(CGFloat)minimumLineSpacing
{
   if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
      return [super minimumInteritemSpacing];
   return [super minimumLineSpacing];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   return self.cols * self.rows;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
   @throw [NSException exceptionWithName:@"MustOverride"
                                  reason:NSStringFromSelector(_cmd)
                                userInfo:nil];
   return 0;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   if ([self.collectionViewDelegate respondsToSelector:_cmd])
      [self.collectionViewDelegate collectionView:collectionView
                         didSelectItemAtIndexPath:indexPath];
}


-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
   if (self.collectionView.pagingEnabled)
      return;
   
   NSInteger targetSection = 0;
   if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
   {
      targetSection = self->_currentSection + (velocity.x < 0 ? -1 : +1) * MIN(3.0, ceil(fabs(velocity.x) / 1.2));
      
      targetContentOffset->x = (scrollView.frame.size.width - scrollView.contentInset.left - scrollView.contentInset.right) * targetSection - scrollView.contentInset.left;
   }
   else
   {
      targetSection = self->_currentSection + (velocity.y < 0 ? -1 : +1) * MIN(3.0, ceil(fabs(velocity.y) / 1.2));
      
      targetContentOffset->y = (scrollView.frame.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom) * targetSection - scrollView.contentInset.top;
   }
}

#pragma mark - update Current Section

-(void)collectionView:(UICollectionView *)collectionView
      willDisplayCell:(UICollectionViewCell *)cell
   forItemAtIndexPath:(NSIndexPath *)indexPath
{
   [NSObject cancelPreviousPerformRequestsWithTarget:self
                                            selector:@selector(updateCurrentSection)
                                              object:nil];
   [self performSelector:@selector(updateCurrentSection)
              withObject:nil
              afterDelay:.1];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
   [self updateCurrentSection];
   if ([self.collectionViewDelegate respondsToSelector:_cmd])
      [self.collectionViewDelegate scrollViewDidEndDecelerating:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
   if (!decelerate)
      [self updateCurrentSection];
   if ([self.collectionViewDelegate respondsToSelector:_cmd])
      [self.collectionViewDelegate scrollViewDidEndDragging:scrollView
                                             willDecelerate:decelerate];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
   [self updateCurrentSection];
   if ([self.collectionViewDelegate respondsToSelector:_cmd])
      [self.collectionViewDelegate scrollViewDidEndScrollingAnimation:scrollView];
}

-(BOOL)scrollToNextSection
{
   NSInteger targetSection = _currentSection + 1;
   if (targetSection < [self numberOfSectionsInCollectionView:self
                        .collectionView])
   {
      CGPoint targetContentOffset = CGPointZero;
      UIScrollView* scrollView = self.collectionView;
      if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
      {
         targetContentOffset.x = (scrollView.frame.size.width - scrollView.contentInset.left - scrollView.contentInset.right) * targetSection - scrollView.contentInset.left;
      }
      else
      {
         targetContentOffset.y = (scrollView.frame.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom) * targetSection - scrollView.contentInset.top;
      }
      [CATransaction begin ];
      [UIView animateWithDuration:DEFAULT_ANIMATION_DURATION animations:^{
          scrollView.contentOffset = targetContentOffset;
      }];
      [CATransaction setCompletionBlock:^{
             [self updateCurrentSection];
      }];
      [CATransaction commit];

      return YES;
   }
   return NO;
}

-(void)updateCurrentSection
{
   NSArray* sections = [self.collectionView.indexPathsForVisibleItems valueForKey:@"section"];
   NSInteger targetSection = 0;
   
   NSInteger max = [[sections valueForKeyPath:@"@max.intValue"] integerValue];
   NSInteger min = [[sections valueForKeyPath:@"@min.intValue"] integerValue];
   if (max - min <= 1)
   {
      NSCountedSet* cs = [[NSCountedSet alloc] initWithArray:sections];
      targetSection = [cs countForObject:@(max)] > [cs countForObject:@(min)] ? max : min;
   }
   else
   {
      targetSection = (max + min) / 2;
   }
   
   self.currentSection = targetSection;
}

-(void)setCurrentSection:(NSInteger)currentSection
{
   if (_currentSection != currentSection)
   {
      _currentSection = currentSection;
      if ([self.collectionViewDelegate respondsToSelector:@selector(collectionView:didShowSection:)])
         [self.collectionViewDelegate collectionView:self.collectionView
                                      didShowSection:_currentSection];
   }
}

-(NSInteger)currentSection
{
   return _currentSection;
}

#pragma mark - forwarding to _collectionViewDelegate

-(BOOL)respondsToSelector:(SEL)aSelector
{
   BOOL superRespondsToSelectorRet = [super respondsToSelector:aSelector];
   return superRespondsToSelectorRet ||
          [self.collectionViewDelegate respondsToSelector:aSelector];
}

-(id)forwardingTargetForSelector:(SEL)aSelector
{
   if (self.collectionViewDelegate)
      return self.collectionViewDelegate;
   
   return [super forwardingTargetForSelector:aSelector];
}

@end
