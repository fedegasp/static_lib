//
//  ParallaxSlidesViewController.m
//  MASClient
//
//  Created by Gai, Fabio on 06/06/2017.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "ParallaxSlidesManager.h"

@interface ParallaxSlidesManager ()

@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) CGFloat oldOffset;
@property (assign, nonatomic) BOOL shouldSetOffset;


@end

@implementation ParallaxSlidesManager

-(void)setMrCollectionView:(MRCollectionView *)mrCollectionView
{
    _mrCollectionView = mrCollectionView;
    _mrCollectionView.delegate = self;
    self.page = [self.mrCollectionView.collectionView visibleCells].firstObject.indexPath.item;
}

-(void)setDefaultCells{
    
    if (self.visibleCell == nil) {
        self.visibleCell = [self.mrCollectionView.collectionView visibleCells].firstObject;
    }
    if (self.forwCell == nil &&
        self.visibleCell.indexPath.row != self.mrCollectionView.dataArray.count-1)
    {
        self.forwCell = self.mrCollectionView.cells[self.visibleCell.indexPath.row+1];
        [self.forwCell transformAlpha:0];
    }
    
    if (!self.shouldSetOffset)
    {
        self.offsetV = self.visibleCell.parallaxView.center.x;
        self.offsetP = self.prevCell.parallaxView.center.x;
        self.offsetF = self.forwCell.parallaxView.center.x;
        [self setShouldSetOffset:YES];
    }
}

-(void)MRCollectionView:(id)collectionView DidScroll:(CGPoint)offset{
    
    [self setDefaultCells];
    
    if ([self.mrCollectionViewCallbacks respondsToSelector:@selector(MRCollectionView:DidScroll:)]) {
        [self.mrCollectionViewCallbacks MRCollectionView:collectionView DidScroll:offset];
    }


    [self.visibleCell applyParallaxEffectForPoint:offset];
    [self.prevCell applyParallaxEffectForPoint:offset];
    [self.forwCell applyParallaxEffectForPoint:offset];
    
//    CGFloat delta = self.mrCollectionView.bounds.size.width*self.page;
//    CGFloat offsetToAdd = offset.x-delta;
//    
//    NSLog(@"**** PAGE: %ld", (long)self.page);
//    
//    if (self.oldOffset < offset.x || self.offsetF < self.forwCell.parallaxView.center.x) {
//        if (self.visibleCell.indexPath.row != self.mrCollectionView.dataArray.count-1) {
//            [self.forwCell.parallaxView setCenter:CGPointMake(self.offsetF+offsetToAdd*0.5,
//                                                              self.forwCell.parallaxView.center.y)];
//            
//          
//        }
//    }
//    else if(self.oldOffset > offset.x || self.offsetP > self.prevCell.parallaxView.center.x) {
//        if (self.visibleCell.indexPath.row != 0) {
//            [self.prevCell.parallaxView setCenter:CGPointMake(self.offsetP+offsetToAdd*0.5,
//                                                              self.prevCell.parallaxView.center.y)];
//        }
//    }
//    
//    [self.visibleCell.parallaxView setCenter:CGPointMake(self.offsetV+offsetToAdd*0.5,
//                                                         self.visibleCell.parallaxView.center.y)];
//    
//    
//    self.oldOffset = offset.x;
}

-(void)MRCollectionView:(id)collectionView DidScrollPage:(NSInteger)page{
    [self didScrollPage:page];
    [self setShouldSetOffset:NO];
    if ([self.mrCollectionViewCallbacks respondsToSelector:@selector(MRCollectionView:DidScrollPage:)]) {
        [self.mrCollectionViewCallbacks MRCollectionView:collectionView DidScrollPage:page];
    }
}


-(void)didScrollPage:(NSInteger)page{
    NSLog(@"didScrollPage");
    self.page = page;
    
    for (ParallaxSlidesContent* cell in self.mrCollectionView.cells) {
        [UIView animateWithDuration:0.7 animations:^{
            if (cell.indexPath.row == page) {
                [cell transformAlpha:1];
            }else{
                [cell transformAlpha:0];
            }
        }];
    }
    [self assignCellsForPage:page];
    
    [self.visibleCell resetParallaxEffect];
    [self.prevCell resetParallaxEffect];
    [self.forwCell resetParallaxEffect];
    
}

-(void)assignCellsForPage:(NSInteger)page{
    
    self.visibleCell = self.mrCollectionView.cells[page];
    if (self.visibleCell.indexPath.row != self.mrCollectionView.dataArray.count-1) {
        self.forwCell = self.mrCollectionView.cells[self.visibleCell.indexPath.row+1];
    }
    if (self.visibleCell.indexPath.row != 0) {
        self.prevCell = self.mrCollectionView.cells[self.visibleCell.indexPath.row-1];
    }
}

-(void)goForward{
    [self.mrCollectionView scrollToPage:@(self.page+1) animated:YES];
}

- (void)MRCollectionView:(id)collectionView DidTapPage:(NSInteger)page{
    if ([self.mrCollectionViewCallbacks respondsToSelector:@selector(MRCollectionView:DidTapPage:)]) {
        [self.mrCollectionViewCallbacks MRCollectionView:collectionView DidTapPage:page];
    }
}

- (void)MRCollectionView:(id)collectionView DidTapItem:(NSInteger)item withContent:(id)content{
    if ([self.mrCollectionViewCallbacks respondsToSelector:@selector(MRCollectionView:DidTapItem:withContent:)]) {
        [self.mrCollectionViewCallbacks MRCollectionView:collectionView DidTapItem:item withContent:content];
    }
}
- (void)MRCollectionView:(id)collectionView didSelectItem:(NSInteger)item withContent:(id)content{
    if ([self.mrCollectionViewCallbacks respondsToSelector:@selector(MRCollectionView:didSelectItem:withContent:)]) {
        [self.mrCollectionViewCallbacks MRCollectionView:collectionView didSelectItem:item withContent:content];
    }
}

- (void)MRCollectionView:(id)collectionView didDeselectItem:(NSInteger)item withContent:(id)content{
    if ([self.mrCollectionViewCallbacks respondsToSelector:@selector(MRCollectionView:didDeselectItem:withContent:)]) {
        [self.mrCollectionViewCallbacks MRCollectionView:collectionView didDeselectItem:item withContent:content];
    }
}

- (void)MRCollectionView:(id)collectionView isInitialized:(BOOL)initialized{
    if ([self.mrCollectionViewCallbacks respondsToSelector:@selector(MRCollectionView:isInitialized:)]) {
        [self.mrCollectionViewCallbacks MRCollectionView:collectionView isInitialized:initialized];
    }
}
- (void)MRCollectionView:(id)collectionView willDisplayCell:(UICollectionViewCell*)cell withContent:(id)content{
    if ([self.mrCollectionViewCallbacks respondsToSelector:@selector(MRCollectionView:willDisplayCell:withContent:)]) {
        [self.mrCollectionViewCallbacks MRCollectionView:collectionView willDisplayCell:cell withContent:content];
    }
}

@end
