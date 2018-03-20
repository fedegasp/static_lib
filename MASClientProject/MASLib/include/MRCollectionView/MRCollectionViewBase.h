//
//  MRCollectionViewBase.h
//  Card
//
//  Created by Gai, Fabio on 11/02/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCollectionViewDefine.h"
#import "MRCollectionViewDelegate.h"
#import "MRCollectionViewContent.h"
#import "UICollectionViewCell+MRCarouselContent.h"


@interface NSObject ()

-(NSString*)mr_collectionCellIdentifier:(MRCollectionView *)collection;

@end


@interface NullCell : UICollectionViewCell
@end

@interface MRCollectionViewBase : UIView<UICollectionViewDataSource,UICollectionViewDelegate>


//base
@property BOOL isInitialized;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *standardflowLayout;
@property (nonatomic) CGSize itemSize;

@property IBInspectable NSString *plist;
@property IBInspectable NSString *json;
@property IBInspectable NSString *jsonKey;
@property (strong, nonatomic) NSArray *dataArray;

//collection properties
@property (nonatomic) IBInspectable CGFloat minimumLineSpacing;
@property (nonatomic) IBInspectable CGFloat minimumInteritemSpacing;
@property IBInspectable BOOL isSelectable;
@property IBInspectable BOOL allowMultipleSelection;
@property IBInspectable BOOL isPaginated;
@property IBInspectable BOOL bounce;
@property IBInspectable BOOL disableGrid;
@property IBInspectable CGFloat horizontalItemsInGrid;
@property IBInspectable CGFloat verticalItemsInGrid;
@property NSInteger currentPage;

//header
@property UICollectionReusableView *headerView;
@property IBInspectable NSString *header;
@property IBInspectable CGFloat headerHeight;

//header
@property UICollectionReusableView *footerView;
@property IBInspectable NSString *footer;
@property IBInspectable CGFloat footerHeight;

//cells
@property (strong, nonatomic) NSMutableArray *cells;
@property NSMutableArray *selectedContent;
@property IBInspectable BOOL forceCustomCell;
@property IBInspectable NSString *customCell;
@property IBInspectable NSString *customNullCell;
@property (weak, nonatomic) IBOutlet  MRCollectionViewContent *collectionCell;
@property (strong, nonatomic) NullCell *nullCell;
@property NSArray *customCells;

//delegate
@property (weak) IBOutlet id <MRCollectionViewDelegate> delegate;

//utils methods
-(void)setStateOfCell:(MRCollectionViewContent *)cell;
-(void)initCollectionView;
-(void)cleanAndBuild;
-(void)clear;
-(void)reloadData;

-(void)iphone4Handle:(void (^)(void))iphone4Completion else:(void (^)(BOOL iPhone5,BOOL iPhone6,BOOL iPhone6Plus)) notIphone4Completion;
@end


