//
//  MRGridParallaxLayout.m
//  MRCustomFlowLayoutExample
//
//  Created by Federico Gasperini on 01/06/17.
//  Copyright © 2017 -. All rights reserved.
//

#import "MRGridParallaxLayout.h"

@implementation MRGridParallaxLayout
{
   NSInteger noTransformSection;
   NSInteger topItem;
   NSInteger landingSection;
   CGPoint lastOffset;
   NSInteger* zIndexes;
}

-(void)setRows:(NSInteger)rows{}
-(void)setCols:(NSInteger)cols{}

-(NSInteger)rows {return 1;}
-(NSInteger)cols {return 1;}

-(void)setData:(NSArray *)data
{
   free(zIndexes);
   zIndexes = NULL;
   if (data.count)
   {
      zIndexes = calloc(data.count, sizeof(NSInteger));
      for (NSInteger idx = data.count; idx > 0; idx--)
         zIndexes[data.count - idx] = idx;
   }
   [super setData:data];
   self.currentSection = 0;
}

-(id)itemAtIndexPath:(NSIndexPath *)indexPath
{
   return self.data[indexPath.section];
}

-(void)dealloc
{
   free(zIndexes);
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
   [super scrollViewWillBeginDragging:scrollView];
   landingSection = -1;
   lastOffset = scrollView.contentOffset;
   if ([self.collectionViewDelegate respondsToSelector:_cmd])
      [self.collectionViewDelegate scrollViewWillBeginDragging:scrollView];
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
//   NSLog(@"%@", NSStringFromCGPoint(velocity));
   if (self.collectionView.pagingEnabled)
      return;
   
   if (landingSection < 0 || landingSection >= self.data.count)
      return;
   
   if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
   {
      targetContentOffset->x = (scrollView.frame.size.width - scrollView.contentInset.left - scrollView.contentInset.right) * landingSection - scrollView.contentInset.left;
   }
   else
   {
      targetContentOffset->y = (scrollView.frame.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom) * landingSection - scrollView.contentInset.top;
   }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   [self invalidateLayout];
   if (landingSection == -1)
   {
      CGPoint offset = scrollView.contentOffset;
      if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
         landingSection = noTransformSection + (offset.x - lastOffset.x < 0 ? -1 : 1);
      else
         landingSection = noTransformSection + (offset.y - lastOffset.y < 0 ? -1 : 1);
      if (landingSection < 0)
         landingSection = 0;
      else if (landingSection >= self.data.count)
         landingSection = self.data.count - 1;
      
      CGRect r = CGRectZero;
      r.size = scrollView.contentSize;
      if (CGRectContainsPoint(r, offset))
         lastOffset = offset;
   }
   if ([self.collectionViewDelegate respondsToSelector:_cmd])
      [self.collectionViewDelegate scrollViewDidScroll:scrollView];
}

-(void)updateCurrentSection
{
   UIScrollView* scrollView = self.collectionView;
   CGFloat _lastOffset = lastOffset.x;
   CGFloat _offset = scrollView.contentOffset.x;
   if (self.scrollDirection != UICollectionViewScrollDirectionHorizontal)
   {
      _lastOffset = lastOffset.y;
      _offset = scrollView.contentOffset.y;
   }
   
   NSInteger targetSection = MAX(0, MIN(self.data.count - 1, landingSection));
   
   if ((targetSection > _currentSection && _offset > _lastOffset) ||
       (targetSection < _currentSection && _offset <= _lastOffset))
      self.currentSection = targetSection;
}

-(void)setCurrentSection:(NSInteger)section
{
   if (section != _currentSection)
   {
      for (NSInteger i = 0; i < self.data.count; i++)
         zIndexes[i] = self.data.count - labs(i - section);
      landingSection = -1;
      noTransformSection = section;
      topItem = section;
      [super setCurrentSection:section];
      lastOffset = self.collectionView.contentOffset;
   }
}

+(Class)layoutAttributesClass
{
   return MRParallaxLayoutAttributes.class;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
   NSArray* array = [super layoutAttributesForElementsInRect:rect];
   
   CGFloat counterTranslationMax = 0;
   if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
      counterTranslationMax = self.itemSize.width / self.parallaxMultiplier;
   else
      counterTranslationMax = self.itemSize.height / self.parallaxMultiplier;
   
   NSMutableArray* ret = [[NSMutableArray alloc] initWithCapacity:array.count];
   
   CGFloat deltaMin = MAXFLOAT;

   for (MRParallaxLayoutAttributes* attrb in array)
   {
      MRParallaxLayoutAttributes* attr = [attrb copy];
      [ret addObject:attr];
      CGRect dest = attr.frame;
      CGPoint offset = self.collectionView.contentOffset;

      CGFloat delta = 0;
      if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
      {
         delta = (offset.x - dest.origin.x) / self.parallaxMultiplier;
         
         attr.antiParallax = CGAffineTransformMakeTranslation(-delta, 0);
         attr.parallax = CGAffineTransformMakeTranslation(delta, 0);
         
         CGFloat signedPercentage = .0;
//         if (labs(attr.indexPath.section - topItem) == 1)
//            signedPercentage = 1.0 - fabs(((offset.x - dest.origin.x) / dest.size.width));
//         else if (attr.indexPath.section == topItem)
            signedPercentage = (offset.x - dest.origin.x) / dest.size.width;
         attr.percentage = fabs(signedPercentage);
         
         attr.counterParallax = CGAffineTransformMakeTranslation(signedPercentage * counterTranslationMax, 0);
         
         if (attr.indexPath.section == landingSection)
            attr.transform = CGAffineTransformMakeTranslation(delta, 0);
         else
            attr.transform = CGAffineTransformIdentity;
      }
      else
      {
         delta = (offset.y - dest.origin.y) / self.parallaxMultiplier;
         
         attr.antiParallax = CGAffineTransformMakeTranslation(0, -delta);
         attr.parallax = CGAffineTransformMakeTranslation(0, delta);
         
         CGFloat signedPercentage = .0;
         if (labs(attr.indexPath.section - topItem) == 1)
            signedPercentage = 1.0 - fabs(((offset.y - dest.origin.y) / dest.size.height));
         else if (attr.indexPath.section == topItem)
            signedPercentage = (offset.y - dest.origin.y) / dest.size.height;
         attr.percentage = fabs(signedPercentage);
         
         attr.counterParallax = CGAffineTransformMakeTranslation(0, signedPercentage * counterTranslationMax);
         
         if (attr.indexPath.section == landingSection)
            attr.transform = CGAffineTransformMakeTranslation(0, delta);
         else
            attr.transform = CGAffineTransformIdentity;
      }
      
      attr.zIndex = zIndexes[attr.indexPath.section];
      attr.isTopItem = attr.indexPath.section == topItem;
      deltaMin = MIN(fabs(delta), deltaMin);
   }

   if (landingSection > -1 && landingSection < self.data.count)
   {
      noTransformSection = landingSection;
      if (deltaMin == .0)
         topItem = landingSection;
   }
   
   return [ret copy];
}

-(CGFloat)parallaxMultiplier
{
   return _parallaxMultiplier < 1.0 ? 2.0 : _parallaxMultiplier;
}

@end
