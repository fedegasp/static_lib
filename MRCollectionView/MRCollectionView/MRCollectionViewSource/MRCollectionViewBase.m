//
//  MRCollectionViewBase.m
//  Card
//
//  Created by Gai, Fabio on 11/02/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import "MRCollectionViewBase.h"
#import <MRBase/lib.h>

@implementation MRCollectionViewBase

-(void)setOrientationNotification{
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    
    [self.collectionView removeFromSuperview];
    self.collectionView = nil;
    [self setIsInitialized:NO];
}

-(NSArray *)jsonArray{
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:self.json ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error = nil;
    NSArray *jsonArray = nil;
    if (self.jsonKey) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        jsonArray = [dic objectForKey:self.jsonKey];
    }else{
        jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    }
    return jsonArray;
}

-(NSArray *)plistArray{
    
    NSURL* url = [[NSBundle mainBundle] URLForResource:self.plist withExtension: @"plist"];
    return  [NSArray arrayWithContentsOfURL: url];
}

-(NSArray *)dataArray{
    
    if (self.json) {
        return [self jsonArray];
    }
    
    if (self.plist) {
        return [self plistArray];
    }
    
    if ((!self.json && !self.plist) ||
        (self.json.length >0 && self.plist.length >0)) {
        
        if ([self.delegate respondsToSelector:@selector(MRCollectionViewDatasource:)]) {
            return [self.delegate MRCollectionViewDatasource:self];
        }else{
            return _dataArray;
        }
    }
    return nil;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.dataArray.count > 0 && !self.isInitialized) {
        [self setIsInitialized:YES];
        [self initCollectionView];
    }
}

-(void)initCollectionView{
    
    if (!self.collectionView) {
        
        self.cells = [[NSMutableArray alloc] init];
        self.selectedContent = [[NSMutableArray alloc] init];
        
        self.standardflowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.standardflowLayout.minimumInteritemSpacing = self.minimumInteritemSpacing;
        self.standardflowLayout.minimumLineSpacing = self.minimumLineSpacing;
        
        CGRect frame =CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.standardflowLayout];
        [self.standardflowLayout setParent:self];
        
        self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.collectionView setDelegate:self];
        [self.collectionView setDataSource:self];
        [self.collectionView setAllowsMultipleSelection:self.allowMultipleSelection];
        [self.collectionView setPagingEnabled:self.isPaginated];
        [self.collectionView setBounces:self.bounce];
        [self.collectionView setClipsToBounds:YES];
        [self.collectionView setBackgroundColor:[UIColor clearColor]];
        [self.collectionView setShowsHorizontalScrollIndicator:NO];
        [self.collectionView setShowsVerticalScrollIndicator:NO];
        [self insertSubview:self.collectionView atIndex:0];
        
        [self registerCells];
        [self registerHeader];
        [self registerFooter];
        
        if ([self.delegate respondsToSelector:@selector(MRCollectionView:isInitialized:)]) {
            [self.delegate MRCollectionView:self isInitialized:YES];
        }
        
    }else{
        [self.collectionView reloadData];
    }
}

-(void)registerCells{
    
    if (self.customCells.count) {
        for (NSString *custCell in self.customCells) {
            UINib *nib = [UINib nibWithNibName:custCell bundle:[NSBundle mainBundle]];
            [self.collectionView registerNib:nib forCellWithReuseIdentifier:custCell];
            // [self.collectionView registerClass:[custCell class] forCellWithReuseIdentifier:custCell];
        }
    }else{
        if (self.customCell) {
            UINib *nib = [UINib nibWithNibName:self.customCell bundle:[NSBundle bundleForClass:NSClassFromString(self.customCell)]];
            [self.collectionView registerNib:nib forCellWithReuseIdentifier:self.customCell];
            //            [self.collectionView registerClass:[self.collectionCell class] forCellWithReuseIdentifier:self.customCell];
        }
        for (id obj in self.dataArray) {
            NSString* nib_class = [obj mr_collectionCellIdentifier:(id)self];
            if (nib_class) {
                UINib *nib = [UINib nibWithNibName:nib_class
                                            bundle:nil];
                [self.collectionView registerNib:nib
                      forCellWithReuseIdentifier:nib_class];
            }
        }
    }
    
    UINib *nullNib;
    if (self.customNullCell) {
        nullNib = [UINib nibWithNibName:self.customNullCell bundle:[NSBundle mainBundle]];
    }else{
        nullNib = [UINib nibWithNibName:@"NullCell" bundle:[NSBundle mainBundle]];
    }
    
    [self.collectionView registerNib:nullNib forCellWithReuseIdentifier:NULL_CELL_ID];
}

-(void)registerHeader{
    if (self.header && self.headerHeight) {
        [self.collectionView registerNib:[UINib nibWithNibName:self.header bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:self.header];
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView
                 layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (self.header && self.headerHeight) {
        return CGSizeMake(self.collectionView.frame.size.width, self.headerHeight);
    }else{
        return CGSizeZero;
    }
}

-(void)registerFooter{
    if (self.footer && self.footerHeight) {
        [self.collectionView registerNib:[UINib nibWithNibName:self.footer bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:self.footer];
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView
                 layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section{
    
    if (self.footer && self.footerHeight) {
        return CGSizeMake(self.collectionView.frame.size.width, self.footerHeight);
    }else{
        return CGSizeZero;
    }
}


//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
//                        layout:(UICollectionViewLayout *)collectionViewLayout
//        insetForSectionAtIndex:(NSInteger)section{
//
//    return UIEdgeInsetsMake(0, 0, 200, 0);
//}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        self.headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                             withReuseIdentifier:self.header
                                                                    forIndexPath:indexPath];
        if ([self.delegate respondsToSelector:@selector(MRCollectionViewHeaderDatasource:)]) {
            [self.headerView setContent:[self.delegate MRCollectionViewHeaderDatasource:self]];
        }
        return self.headerView;
    }else{
        self.footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                             withReuseIdentifier:self.footer
                                                                    forIndexPath:indexPath];
        if ([self.delegate respondsToSelector:@selector(MRCollectionViewFooterDatasource:)]) {
            [self.footerView setContent:[self.delegate MRCollectionViewFooterDatasource:self]];
        }
        return self.footerView;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    const id model = self.dataArray[indexPath.row];
   
    if (model == [NSNull null]) {
        self.nullCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:NULL_CELL_ID forIndexPath:indexPath];
        if (self.cells.count < self.dataArray.count) {
            [self.cells addObject:self.nullCell];
        }
        return self.nullCell;
        
    }else{
        
        MRCollectionViewContent *cell = nil;
        if ((self.cells.count == 0) || (self.cells.count != self.dataArray.count)){
            for (int i = 0; i < self.dataArray.count; i++) {
                NSIndexPath *indexP = [NSIndexPath indexPathForItem:i inSection:indexPath.section];
                if (self.customCells.count) {
                   NSString* ci = self.customCells.lastObject;
                   if (indexP.row < self.customCells.count)
                      ci = self.customCells[indexP.row];
                    cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:ci
                                                                          forIndexPath:indexP];
                }else{
                    NSString* ci = self.customCell;
                    NSString* nib_class = [self.dataArray[i] mr_collectionCellIdentifier:(id)self];
                    if (nib_class && !self.forceCustomCell) {
                        ci = nib_class;
                    }
                    cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:ci
                                                                          forIndexPath:indexP];
                }
                [self.cells addObject:cell];
            }
        }
        
        cell = self.cells[indexPath.row];
        
        [cell setParentCollectionView:self];
        
        if ([self.selectedContent containsObject:model] &&
            [self.selectedContent containsObject:indexPath] ) {
            
            [cell setSelectedState:YES];
        }else{
            [cell setSelectedState:NO];
        }
        
        [cell setContent:model];
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(MRCollectionView:DidTapItem:withContent:)]) {
        [self.delegate MRCollectionView:self DidTapItem:(NSInteger)indexPath.row  withContent:self.dataArray[indexPath.row]];
    }
    else if ([self.delegate respondsToSelector:@selector(MRCollectionView:didSelectItem:withContent:)]) {
       [self.delegate MRCollectionView:self didSelectItem:(NSInteger)indexPath.row  withContent:self.dataArray[indexPath.row]];
    }
   
    if ([self.delegate respondsToSelector:@selector(MRCollectionView:DidTapPage:)]) {
        [self.delegate MRCollectionView:self DidTapPage:(NSInteger)self.currentPage];
    }
    
    MRCollectionViewContent *cell = (id)[self.collectionView cellForItemAtIndexPath:indexPath];
    [self setStateOfCell:cell];
    
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
   if ([self.delegate respondsToSelector:@selector(MRCollectionView:didDeselectItem:withContent:)]) {
      [self.delegate MRCollectionView:self didDeselectItem:indexPath.row  withContent:self.dataArray[indexPath.row]];
   }
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
   if ([self.delegate respondsToSelector:@selector(MRCollectionView:willDisplayCell:withContent:)]) {
      [self.delegate MRCollectionView:self willDisplayCell:cell withContent:self.dataArray[indexPath.row]];
   }
}

-(void)setStateOfCell:(MRCollectionViewContent *)cell{
   
    if (self.isSelectable) {
        BOOL should = NO;
        if (![self.selectedContent containsObject:self.dataArray[cell.indexPath.row]] && ![self.selectedContent containsObject:cell.indexPath] && !cell.selectedState) {
            if (!self.allowMultipleSelection) {
                [self.selectedContent removeAllObjects];
                for (MRCollectionViewContent *c in self.cells) {
                    if (c != cell) {
                        [c setDeselectedState];
                        [c setSelected:NO];
                    }else{
                        [c setSelectedState];
                    }
                }
            }
            [self.selectedContent addObject:self.dataArray[cell.collectionIndexPath.row]];
            [self.selectedContent addObject:cell.collectionIndexPath];
            should = YES;
        }else{
            [self.selectedContent removeObject:self.dataArray[cell.collectionIndexPath.row]];
            [self.selectedContent removeObject:cell.collectionIndexPath];
        }
        
        if ([cell respondsToSelector:@selector(didSelect:)]){
            [cell didSelect:should];
            [cell setSelectedState:should];
        }        
    }
}

-(CGSize)itemSize{
        
    if (!self.horizontalItemsInGrid) {
        [self setHorizontalItemsInGrid:2];
    }
    if (!self.verticalItemsInGrid) {
        [self setVerticalItemsInGrid:2];
    }
    CGSize gridSize =CGSizeMake((self.collectionView.frame.size.width-self.minimumInteritemSpacing)/self.horizontalItemsInGrid,
                                (self.collectionView.frame.size.height-self.minimumLineSpacing-self.headerHeight)/self.verticalItemsInGrid);
    return  gridSize;
}

-(void)cleanAndBuild{
    [self.collectionView removeFromSuperview];
    self.collectionView = nil;
    [self reloadData];
}

-(void)clear{
    [self.collectionView reloadData];
    [self reloadData];
}

-(void)reloadData{
    
    [self setIsInitialized:NO];
    [self initCollectionView];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma  mark utils

-(void)iphone4Handle:(void (^)(void))iphone4Completion else:(void (^)(BOOL iPhone5,BOOL iPhone6,BOOL iPhone6Plus)) notIphone4Completion{
    if (IS_IPHONE_4_OR_LESS) {
        if (iphone4Completion) {
            iphone4Completion();
        }
    }else{
        if (notIphone4Completion) {
            notIphone4Completion(IS_IPHONE_5,IS_IPHONE_6,IS_IPHONE_6P);
        }
    }
}

@end

@implementation NullCell
@end
