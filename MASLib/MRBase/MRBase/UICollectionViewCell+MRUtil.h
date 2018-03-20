//
//  UICollectionViewCell+IKInterface.h
//  MRBase
//
//  Created by Federico Gasperini on 06/10/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (MRUtil)

-(NSString * __nullable)mr_collectionCellIdentifier:(UICollectionView* __nonnull)collectionView;

@end

@interface UICollectionViewCell (MRUtil)

@property (nonatomic, strong, nullable) id content;

-(void)displayCell;

@property (readonly, nonatomic, nullable) NSIndexPath* collectionIndexPath;
@property (readonly, nonatomic, nullable) UICollectionView* collectionView;

@end

@interface UIView (MRUtil)

-(NSIndexPath* __nullable)collectionIndexPath;

@end
