//
//  UICollectionViewCell+util.h
//  CollectionTest
//
//  Created by Federico Gasperini on 22/05/17.
//  Copyright © 2017 -. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (util)

-(NSString*)mr_collectionCellIdentifier:(UICollectionView*)c;

@end

@interface UICollectionViewCell (util)

@property (strong, nonatomic) id content;
@property (strong, nonatomic) NSIndexPath* collectionIndexPath;
@property (unsafe_unretained, nonatomic) UICollectionView* collectionView;

@end
