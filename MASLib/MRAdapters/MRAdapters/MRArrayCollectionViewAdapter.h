//
//  MRArrayCollectionViewAdapter.h
//  Ax
//
//  Created by Federico Gasperini on 02/03/15.
//  Copyright (c) 2015 Federico Gasperini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MRBase/lib.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MRArrayCollectionViewAdapterDelegate <UICollectionViewDelegateFlowLayout>

@optional
-(void)collectionView:(UICollectionView *)collectionView didSelect:(NSArray*)selection;
-(UICollectionViewCell * __nullable)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface MRArrayCollectionViewAdapter : NSObject <UICollectionViewDataSource,
                                                    UICollectionViewDelegateFlowLayout>

@property (readonly) BOOL arrayOfArray;

@property (weak, nonatomic, nullable) IBOutlet id<MRArrayCollectionViewAdapterDelegate> adapterDelegate;
@property (weak, nonatomic, nullable) IBOutlet UICollectionView* collectionView;
@property (strong, nonatomic, nullable) IBOutletCollection(NSObject) NSMutableArray* data;
@property (strong, nonatomic, nullable) IBInspectable NSString* plistSource;
@property (strong, nonatomic, nullable) IBInspectable NSString* cellIdentifier;

@property (assign, nonatomic) IBInspectable CGFloat adaptCellHeight;
@property (assign, nonatomic) IBInspectable CGFloat adaptCellWidth;
@property (assign, nonatomic) IBInspectable CGFloat maxCellHeigth;
@property (assign, nonatomic) IBInspectable CGFloat maxCellWidth;
@property (assign, nonatomic) IBInspectable CGFloat minCellHeigth;
@property (assign, nonatomic) IBInspectable CGFloat minCellWidth;
-(void)insertData:(NSArray *)array completion:(void (^ _Nullable)(BOOL finished))completion;
-(void)appendData:(NSArray*)array completion:(void (^ __nullable)(BOOL finished))completion;
-(void)removeData:(NSArray*)array completion:(void (^ __nullable)(BOOL finished))completion;

-(void)selectItems:(NSArray*)items;

@end

NS_ASSUME_NONNULL_END
