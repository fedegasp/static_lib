//
//  MRCollectionViewCard.m
//  Card
//
//  Created by Gai, Fabio on 11/02/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import "MRCollectionViewCard.h"
#import <MRBase/lib.h>

@interface MRCollectionViewCard () <UIGestureRecognizerDelegate>

@end

@implementation MRCollectionViewCard

-(NSIndexPath *)firstIndexPath{
    return [NSIndexPath indexPathForItem:0 inSection:0];
}

-(NSIndexPath *)lastIndexPath{
    return [NSIndexPath indexPathForItem:self.mutableDataArray.count-1 inSection:0];
}

-(UICollectionViewCell *)firstCell{
    return [self.collectionView cellForItemAtIndexPath:self.firstIndexPath];
}

-(UICollectionViewCell *)lastCell{
    return [self.collectionView cellForItemAtIndexPath:self.lastIndexPath];
}

-(void)initCollectionView{
    [super initCollectionView];
    
    if (self.isCard) {
        
        [self.collectionView setClipsToBounds:NO];
        self.mutableDataArray = [[NSMutableArray alloc] initWithArray:[[self.dataArray reverseObjectEnumerator] allObjects]] ;
        
        self.cardLayout = [[MRCollectionViewCardLayout alloc] init];
        [self.cardLayout setParent:self];
        [self.collectionView setCollectionViewLayout:self.cardLayout];
        
        [self addPanRecognizer];
    }
}

-(void)addPanRecognizer{
    self.panRecognizer = [[UIPanGestureRecognizer alloc]
                          initWithTarget:self
                          action:@selector(handlePan:)];
    self.panRecognizer.delegate = self;
    [self.panRecognizer setMinimumNumberOfTouches:1];
    [self.panRecognizer setMaximumNumberOfTouches:1];
    [self.collectionView  addGestureRecognizer:self.panRecognizer];
}

-(void)removePanRecognizer{
    [self.collectionView removeGestureRecognizer:self.panRecognizer];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.isCard) {
        return [self.mutableDataArray count];
    }else{
        return [self.dataArray count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isCard) {
        indexPath = [NSIndexPath indexPathForItem:(self.mutableDataArray.count-1)-indexPath.row inSection:indexPath.section];
    }
    return [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isCard) {
        [self notifyTap];
        if ([self.delegate respondsToSelector:@selector(MRCollectionView:DidTapPage:)]) {
            [self.delegate MRCollectionView:self DidTapPage:(int)self.currentPage];
        }
        if (self.slideOnTap){
            [self moveCellAtPosition:CGPointMake(self.collectionView.frame.size.width+20, 0)];
        }
    }else{
        [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
    
}

-(void)notifyTap{
    
    if ([self.delegate respondsToSelector:@selector(MRCollectionView:DidTapItem:withContent:)]) {
        [self.delegate MRCollectionView:self DidTapItem:(int)self.lastCell.collectionIndexPath.row  withContent:self.dataArray[self.lastCell.collectionIndexPath.row]];
    }
    MRCollectionViewContent *cell = (MRCollectionViewContent *)self.lastCell;
    [self setStateOfCell:cell];
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    if (self.dataArray.count > 1)
    {
        CGPoint velocity = [panGestureRecognizer velocityInView:panGestureRecognizer.view];
        return fabs(velocity.x) > fabs(velocity.y);
    }
    return NO;
}

-(void)handlePan:(UIPanGestureRecognizer *)panRecognizer {
    
    CGPoint translation = [panRecognizer translationInView:self.collectionView];
    if ([self.delegate respondsToSelector:@selector(MRCollectionView:DidScroll:)]) {
        [self.delegate MRCollectionView:self DidScroll:translation];
    }
    
    if (self.isAnimating) {
        translation = self.collectionView.center;
    }
    
    CGFloat offsetX = self.lastCell.frame.size.width/2;
    
    if ([panRecognizer state] == UIGestureRecognizerStateBegan)
    {
        if (!self.isAnimating) {
            _originalCenter = self.firstCell.center;
        }
    }
    
    else if ([panRecognizer state] == UIGestureRecognizerStateChanged)
    {
        if (!self.isAnimating) {
            self.lastCell.center = CGPointMake(_originalCenter.x + translation.x,
                                               _originalCenter.y + translation.y/6);
        }
    }
    
    if (panRecognizer.state == UIGestureRecognizerStateEnded) {
        
        if (!self.isAnimating) {
            
            [self setIsAnimating:YES];
            CGFloat x = 0;
            if (translation.x < -offsetX+(offsetX/2) ) {
                x = -self.collectionView.frame.size.width-20;
            }
            if(translation.x > offsetX-(offsetX/2) ){
                x= self.collectionView.frame.size.width+20;
            }
            if (x == 0) {
            }
            [self moveCellAtPosition:CGPointMake(x, 0)];
        }
    }
}

-(void)autoPanToLeft
{
    if (!self.isAnimating) {
        [self setIsAnimating:YES];
        
        CGFloat offsetX = -self.lastCell.frame.size.width * 3.0 / 4.0;
        _originalCenter = self.firstCell.center;
        CGPoint target = _originalCenter;
        target.x += offsetX;
        
        [UIView animateWithDuration:DEFAULT_ANIMATION_DURATION
                         animations:^{
                             self.lastCell.center = target;
                         }
                         completion:^(BOOL finished) {
                             CGFloat x = -self.collectionView.frame.size.width-20;
                             [self moveCellAtPosition:CGPointMake(x, 0)];
                         }];
    }
}

-(void)moveCellAtPosition:(CGPoint)position{
    
    
    [UIView animateWithDuration:.15 animations:^{
        
        [self.lastCell setFrame:CGRectMake(position.x,
                                           0,
                                           self.lastCell.frame.size.width,
                                           self.lastCell.frame.size.height)];
        
        if (position.x != 0) {
            
            MRCollectionViewContent *cell = (MRCollectionViewContent *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.lastIndexPath.row-1 inSection:0]];
            cell.transform = CGAffineTransformIdentity;
        }
        
    } completion:^(BOOL finished) {
        
        if (position.x != 0) {
            
            NSString *lastElement = [self.mutableDataArray lastObject];
            [self.mutableDataArray removeObjectIdenticalTo:lastElement];
            [self.mutableDataArray insertObject:lastElement atIndex:0];
            
            [UIView animateWithDuration:.15 animations:^{
                
                [self.collectionView sendSubviewToBack:self.lastCell];
                [self.lastCell setFrame:CGRectMake(0,
                                                   0,
                                                   self.lastCell.frame.size.width,
                                                   self.lastCell.frame.size.height)];
                
            } completion:^(BOOL finished) {
                
                [self.collectionView moveItemAtIndexPath:self.lastIndexPath toIndexPath:self.firstIndexPath];
                
                if (self.currentPage == self.numberOfPages-1){
                    self.currentPage = 0;
                }else{
                    self.currentPage++;
                }
                
                //self.currentPage = self.lastCell.indexPath.row;
                
                if ([self.delegate respondsToSelector:@selector(MRCollectionView:DidScrollPage:)]) {
                    [self.delegate MRCollectionView:self DidScrollPage:self.currentPage];
                }
                [self updatePageControl];
                
            }];
        }else{
            [self setIsAnimating:NO];
        }
    }];
}

@end


