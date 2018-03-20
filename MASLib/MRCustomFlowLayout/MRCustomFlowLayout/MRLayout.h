//
//  MRLayout.h
//  CollectionTest
//
//  Created by Federico Gasperini on 30/05/17.
//  Copyright © 2017 -. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


extern NSString * const kMRGridEmptyCellIdentifier;


@protocol MRLayoutDelegate < NSObject,
                             UICollectionViewDelegate >

@optional
-(nullable UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                          cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@protocol MRLayout

@property (strong, nonatomic, nullable) NSString* reuseCellIdentifier;
@property (weak, nonatomic, nullable) id<MRLayoutDelegate> collectionViewDelegate;

-(nullable UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath;
-(nullable id)itemAtIndexPath:(NSIndexPath*)indexPath;

@property (readonly) NSArray* selection;

@end


@interface MRCollectionFlowLayout : UICollectionViewFlowLayout <MRLayout>

@property (strong, nonatomic, nullable) IBInspectable NSString* reuseCellIdentifier;
@property (weak, nonatomic, nullable) IBOutlet id<MRLayoutDelegate> collectionViewDelegate;

@end


@interface MRCollectionLayout : UICollectionViewLayout <MRLayout>

@property (strong, nonatomic, nullable) IBInspectable NSString* reuseCellIdentifier;
@property (weak, nonatomic, nullable) IBOutlet id<MRLayoutDelegate> collectionViewDelegate;

@end

NS_ASSUME_NONNULL_END
