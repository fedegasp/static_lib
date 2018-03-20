//
//  MRInfiniteGridLayout.m
//  CollectionTest
//
//  Created by Federico Gasperini on 22/05/17.
//  Copyright © 2017 -. All rights reserved.
//

#import "MRInfiniteGridLayout.h"
#if __has_include(<MRBase/MRMacros.h>)
#   import <MRBase/MRMacros.h>
#else
#   define DEFAULT_ANIMATION_DURATION .3
#endif

@implementation MRInfiniteGridLayout
{
   NSInteger _boundedSection;
}

-(void)setRows:(NSInteger)rows{}
-(void)setCols:(NSInteger)cols{}

-(NSInteger)rows {return 1;}
-(NSInteger)cols {return 1;}

-(void)setJson:(NSString *)json
{
   _json = json;
   NSString* jsonFile = [[NSBundle mainBundle] pathForResource:json
                                                        ofType:@"json"];
   if (jsonFile)
   {
      NSData* jsonData = [NSData dataWithContentsOfFile:jsonFile];
      if (jsonData)
      {
         NSArray* a = [NSJSONSerialization JSONObjectWithData:jsonData
                                                      options:0
                                                        error:NULL];
         self.data = a;
      }
   }
}

-(void)setData:(NSArray *)data
{
   self.pageControl.numberOfPages = data.count;
   _data = data;
   self->_currentSection = -1;
   [self invalidateLayout];
   [self.collectionView reloadData];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
   if (self.data.count)
      return MAX(self.data.count * 3, 256 - (256 % self.data.count));
   return 0;
}

-(void)invalidateLayout
{
   [super invalidateLayout];
   if (_currentSection == -1)
   {
      CGPoint offset = CGPointMake(0, 0);
      UIScrollView* scrollView = self.collectionView;
      if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
         offset.x = (scrollView.frame.size.width - scrollView.contentInset.left - scrollView.contentInset.right) *
         [self initialSection] - scrollView.contentInset.left;
      else
         offset.y = (scrollView.frame.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom) *
         [self initialSection] - scrollView.contentInset.top;
      self->_currentSection = [self initialSection];
      self.collectionView.contentOffset = offset;
   }
}

-(id)itemAtIndexPath:(NSIndexPath *)indexPath
{
   NSInteger item = indexPath.section % self.data.count;
   return self.data[item];
}

-(NSInteger)initialSection
{
   if (self.data.count)
   {
      NSInteger midSection = [self numberOfSectionsInCollectionView:self.collectionView];
      midSection = midSection / 2;
      midSection = midSection - (midSection % self.data.count);
      return midSection;
   }
   return 0;
}

-(void)setCurrentSection:(NSInteger)currentSection
{
   NSInteger boundedSection = currentSection % self.data.count;
   _currentSection = currentSection;
   
   if (boundedSection != _boundedSection)
   {
      _boundedSection = boundedSection;
      if ([self.collectionViewDelegate respondsToSelector:@selector(collectionView:didShowSection:)])
         [self.collectionViewDelegate collectionView:self.collectionView
                                      didShowSection:boundedSection];
      self.pageControl.currentPage = boundedSection;
   }
}

-(void)scrollToNearestIndex:(NSInteger)item
{
   static NSInteger center = UICollectionViewScrollPositionCenteredVertically|
                             UICollectionViewScrollPositionCenteredHorizontally;
   
   if (_boundedSection != item)
   {
       NSInteger initialSection = [self initialSection];
       NSInteger after;
       if (item) after = initialSection + item ;
       else after = initialSection + self.data.count;
       
       NSInteger before = initialSection - (self.data.count - item);
       NSInteger dest = after;
       if (_currentSection - before < after - _currentSection)
           dest = before;
      
      [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:dest]
                                  atScrollPosition:center
                                          animated:YES];
   }
}

-(BOOL) scrollToNextSection
{
    [self scrollToNearestIndex:((_boundedSection+1) % self.data.count)];
    return YES;
}

-(void)scrollToNearestItem:(id)item
{
   NSUInteger idx = [self.data indexOfObject:item];
   if (idx != NSNotFound)
      [self scrollToNearestIndex:idx];
}

-(void)updateCurrentSection
{
   [super updateCurrentSection];
   UIScrollView *scrollView = self.collectionView;
   CGPoint offset = CGPointMake(0, 0);
   if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
      offset.x = (scrollView.frame.size.width - scrollView.contentInset.left - scrollView.contentInset.right) *
      ([self initialSection] + _boundedSection) - scrollView.contentInset.left;
   else
      offset.y = (scrollView.frame.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom) *
      ([self initialSection] + _boundedSection) - scrollView.contentInset.top;
   scrollView.contentOffset = offset;
}

-(NSInteger)currentSection
{
   return _boundedSection;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath*)indexPath
{
   if ([self.collectionViewDelegate respondsToSelector:_cmd])
      [self.collectionViewDelegate collectionView:collectionView
                                  willDisplayCell:cell
                               forItemAtIndexPath:indexPath];
}

@end
