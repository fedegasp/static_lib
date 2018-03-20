//
//  UICollectionViewCell+MRUtil.m
//  MRBase
//
//  Created by Federico Gasperini on 06/10/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import "UICollectionViewCell+MRUtil.h"
#import "MRWeakWrapper.h"
#import <objc/runtime.h>

@implementation UIView (MRUtil)

-(NSIndexPath*)collectionIndexPath
{
    UICollectionViewCell* cell = (id)self;
    while (cell && ![cell isKindOfClass:UICollectionViewCell.class])
        cell = (id)cell.superview;
    NSIndexPath* indexPath = [cell collectionIndexPath];
    return [indexPath copy];
}

@end


@implementation UICollectionViewCell (MRUtil)

-(void)setContent:(id)content
{
    objc_setAssociatedObject(self, @selector(content), content,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(id)content
{
    return objc_getAssociatedObject(self, @selector(content));
}

-(void)displayCell
{
   
}

-(NSIndexPath*)collectionIndexPath
{
   return [[self.collectionView indexPathForCell:self] copy];
}

-(UICollectionView*)collectionView
{
    UIView* collectionView = [self superview];
    while (collectionView)
    {
        if ([collectionView isKindOfClass:UICollectionView.class])
            return (id)collectionView;
        else
            collectionView = [collectionView superview];
    }
    return nil;
}

@end


@implementation NSObject (MRUtil)

-(NSString * __nullable)mr_collectionCellIdentifier:(UICollectionView* __nonnull)collectionView
{
   return nil;
}

@end

