//
//  MRGreedyPartitionLayout.h
//  CollectionTest
//
//  Created by Federico Gasperini on 30/05/17.
//  Copyright © 2017 -. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRLayout.h"

NS_ASSUME_NONNULL_BEGIN

@class MRGreedyPartitionLayout;
@protocol MRGreedyPartitionLayoutDelegate <MRLayoutDelegate>

-(CGFloat)collectionViewLayout:(MRGreedyPartitionLayout*)layout
      heightForItemAtIndexPath:(NSIndexPath*)indexPath;

@end

extern const CGFloat kMRZeroHeight;

@interface MRGreedyPartitionLayout : MRCollectionLayout
                            < UICollectionViewDelegate,
                              UICollectionViewDataSource >

@property (weak, nonatomic, nullable) IBOutlet id<MRGreedyPartitionLayoutDelegate> collectionViewDelegate;

@property (assign, nonatomic) IBInspectable NSInteger cols;

@property (strong, nonatomic, nullable) NSArray* data;

@property (strong, nonatomic, nullable) IBInspectable NSString* json;

@property (assign, nonatomic) UIEdgeInsets sectionInset;

@property (assign, nonatomic) IBInspectable CGFloat columnsSpace;
@property (assign, nonatomic) IBInspectable CGFloat verticalItemSpace;

@property (assign, nonatomic) IBInspectable BOOL disableGreedy;

@end

NS_ASSUME_NONNULL_END
