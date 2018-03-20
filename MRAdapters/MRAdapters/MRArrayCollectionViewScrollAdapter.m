//
//  TLCArrayCollectionVewScrollAdapter.m
//  Telco
//
//  Created by Federico Gasperini on 06/03/15.
//  Copyright (c) 2015 accenture. All rights reserved.
//

#import "MRArrayCollectionViewScrollAdapter.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation MRArrayCollectionViewScrollAdapter
{
   NSInteger page;
}

//-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//   return self.data.count * 1000;
//}

//-(id)itemAtIndexPath:(NSIndexPath*)indexPath
//{
//   if (self.arrayOfArray)
//      return self.data[indexPath.section][indexPath.row % self.data.count];
//   return self.data[indexPath.row % self.data.count];
//}

-(void)setCollectionView:(UICollectionView *)collectionView
{
//   [NSObject cancelPreviousPerformRequestsWithTarget:self
//                                            selector:@selector(scroll)
//                                              object:nil];
   collectionView.showsVerticalScrollIndicator = NO;
   collectionView.showsHorizontalScrollIndicator = NO;
   [super setCollectionView:collectionView];
   //[self performSelector:@selector(scroll) withObject:nil afterDelay:3];
}

//-(void)dealloc
//{
//   [NSObject cancelPreviousPerformRequestsWithTarget:self
//                                            selector:@selector(scroll)
//                                              object:nil];
//}

// it seems to be called inspite of respondsToSelector: response
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   
}

-(void)setData:(NSMutableArray *)data
{
//   [NSObject cancelPreviousPerformRequestsWithTarget:self
//                                            selector:@selector(scroll)
//                                              object:nil];
   self.pageControl.numberOfPages = data.count;
   [super setData:data];
//   [self performSelector:@selector(scroll) withObject:nil afterDelay:3];
}

//-(void)scroll
//{
//   if ([self.collectionView numberOfItemsInSection:0])
//   {
//      [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:page+1
//                                                                       inSection:0]
//                                  atScrollPosition:UICollectionViewScrollPositionLeft
//                                          animated:YES];
//   }
//}

//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//   [NSObject cancelPreviousPerformRequestsWithTarget:self
//                                            selector:@selector(scroll)
//                                              object:nil];
//}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//   [NSObject cancelPreviousPerformRequestsWithTarget:self
//                                            selector:@selector(scroll)
//                                              object:nil];
   [self adjustPageControl];
//   [self performSelector:@selector(scroll) withObject:nil afterDelay:3];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
//   [NSObject cancelPreviousPerformRequestsWithTarget:self
//                                            selector:@selector(scroll)
//                                              object:nil];
   [self adjustPageControl];
//   [self performSelector:@selector(scroll) withObject:nil afterDelay:3];
}

-(void)adjustPageControl
{
   NSIndexPath *idxP = [[self.collectionView indexPathsForVisibleItems] lastObject];
   page = idxP.item;
   NSInteger p = self.pageControl.currentPage;
   self.pageControl.currentPage = page % self.pageControl.numberOfPages;
   if (p == self.pageControl.currentPage)
      page ++;
   self.pageControl.currentPage = page % self.pageControl.numberOfPages;
}

-(BOOL)respondsToSelector:(SEL)aSelector
{
   if (sel_isEqual(aSelector, @selector(scrollViewWillBeginDragging:))
       ||
       sel_isEqual(aSelector, @selector(scrollViewDidEndScrollingAnimation:))
       ||
       sel_isEqual(aSelector, @selector(scrollViewDidEndDecelerating:)))
      return YES;
   
   return [super respondsToSelector:aSelector];
}

@end
