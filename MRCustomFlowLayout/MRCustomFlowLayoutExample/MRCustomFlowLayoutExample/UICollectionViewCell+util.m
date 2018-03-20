//
//  UICollectionViewCell+util.m
//  CollectionTest
//
//  Created by Federico Gasperini on 22/05/17.
//  Copyright © 2017 -. All rights reserved.
//

#import "UICollectionViewCell+util.h"
#import <objc/runtime.h>

const void* UICollectionViewCell_util = &UICollectionViewCell_util;
const void* UICollectionViewCell_util2 = &UICollectionViewCell_util2;
const void* UICollectionViewCell_util3 = &UICollectionViewCell_util3;

@implementation UICollectionViewCell (util)

-(void)setContent:(id)content
{
   objc_setAssociatedObject(self, UICollectionViewCell_util,
                            content, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(id)content
{
   return objc_getAssociatedObject(self, UICollectionViewCell_util);
}

-(void)setCollectionIndexPath:(NSIndexPath *)collectionIndexPath
{
   objc_setAssociatedObject(self, UICollectionViewCell_util2,
                            collectionIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(id)collectionIndexPath
{
   return objc_getAssociatedObject(self, UICollectionViewCell_util2);
}

-(void)setCollectionView:(UICollectionView *)collectionView
{
   objc_setAssociatedObject(self, UICollectionViewCell_util3,
                            collectionView, OBJC_ASSOCIATION_ASSIGN);
}

-(UICollectionView*)collectionView
{
   return objc_getAssociatedObject(self, UICollectionViewCell_util3);
}

@end

@implementation NSObject (util)

-(NSString*)mr_collectionCellIdentifier:(UICollectionView*)c
{
   return nil;
}

@end
