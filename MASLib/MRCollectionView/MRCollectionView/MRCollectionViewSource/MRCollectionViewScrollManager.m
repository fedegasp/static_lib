//
//  MRCollectionViewScrollManager.m
//  Card
//
//  Created by Gai, Fabio on 11/02/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import "MRCollectionViewScrollManager.h"

@interface MRCollectionViewScrollManager ()
@property BOOL isDragging;
@end

@implementation MRCollectionViewScrollManager

#pragma mark scroll delegate

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isDragging = YES;
    [self timerInvalidate];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self setParallaxWithOffset:scrollView.contentOffset];
    [self set3DEffectWithOffset:scrollView.contentOffset];
    
    if (self.slideHorizontal) {
        self.currentPage = round(scrollView.contentOffset.x / self.collectionView.frame.size.width);
    }else{
        self.currentPage = round(scrollView.contentOffset.y / self.collectionView.frame.size.height);
    }
    
    if (self.currentPage < 0)
        self.currentPage = 0;
    if (self.currentPage >= self.numberOfPages && self.disableGrid)
        self.currentPage = self.numberOfPages - 1;
    self.pageControl.currentPage = self.currentPage;
    [self updateButtons];
    
    if ([self.delegate respondsToSelector:@selector(MRCollectionView:DidScroll:)]) {
        [self.delegate MRCollectionView:self DidScroll:scrollView.contentOffset];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //NSLog(@"scrollViewDidEndScrollingAnimation");
    [self resetTimer];
    [self notifyUpdatedPage];
    self.isDragging = NO;
}

-(void)setParallaxWithOffset:(CGPoint)offset{
    
    if(self.isParallax){
        if (offset.y < 0) {
            
            [self.headerView setClipsToBounds:NO];
            UIView* v = self.headerView.subviews.firstObject;
            v.frame = CGRectMake(v.bounds.origin.x,
                                 offset.y,
                                 v.bounds.size.width,
                                 self.headerHeight-offset.y);
            
        }else{
            [self.headerView setClipsToBounds:YES];
            UIView* v = self.headerView.subviews.firstObject;
            v.frame = CGRectMake(v.bounds.origin.x,
                                 offset.y/3,
                                 v.bounds.size.width,
                                 v.frame.size.height);
        }
    }
}

-(void)set3DEffectWithOffset:(CGPoint)offset{
    
    if (self.fade3DEffect)
    {
        NSArray *cells = [self.collectionView visibleCells];
        CGPoint p0 = self.collectionView.superview.center;
        for (UICollectionViewCell *cell in cells)
        {
            CGPoint p1 = [self.collectionView convertPoint:cell.center toView:self.collectionView.superview];
            
            double scale = cos((p0.x - p1.x)/(2.0*p0.x));
            CGAffineTransform t = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
            cell.transform = t;
            cell.alpha = pow(scale, 4.0);
        }
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self resetTimer];
    [self notifyUpdatedPage];
    self.isDragging = NO;
    NSLog(@"scrollViewDidEndDecelerating");
}


@end
