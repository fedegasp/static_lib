//
//  MRLayout.m
//  CollectionTest
//
//  Created by Federico Gasperini on 30/05/17.
//  Copyright © 2017 -. All rights reserved.
//

#import "MRLayout.h"
#if __has_include(<MRBase/UICollectionViewCell+MRUtil.h>)
#import <MRBase/UICollectionViewCell+MRUtil.h>
#endif

NSString *const kMRGridEmptyCellIdentifier = @"1234567890-EmptyCellIdentifier-0987654321";

#pragma mark - MRLayout_impl declaration

@interface UICollectionViewLayout (MRLayout_impl)

@property (weak, nonatomic, nullable) NSString* reuseCellIdentifier;
@property (weak, nonatomic, nullable) id<MRLayoutDelegate> collectionViewDelegate;

-(UICollectionViewCell *)MRLayout_impl_collectionView:(UICollectionView *)collectionView
                               cellForItemAtIndexPath:(NSIndexPath *)indexPath;
-(nullable id)itemAtIndexPath:(NSIndexPath*)indexPath;
-(NSArray*)MRLayout_impl_selection;

@end

#pragma mark - MRCollectionFlowLayout

@implementation MRCollectionFlowLayout
{
   BOOL emptyRegistered;
}

@synthesize reuseCellIdentifier;
@synthesize collectionViewDelegate;

-(void)prepareLayout
{
   [super prepareLayout];
   if (!emptyRegistered && self.collectionView)
   {
      [self.collectionView registerClass:[UICollectionViewCell class]
              forCellWithReuseIdentifier:kMRGridEmptyCellIdentifier];
      emptyRegistered = YES;
   }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                          cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   return [super MRLayout_impl_collectionView:collectionView
                      cellForItemAtIndexPath:indexPath];
}

-(id)itemAtIndexPath:(NSIndexPath*)indexPath
{
   return [super itemAtIndexPath:indexPath];
}

-(NSArray*)selection
{
   return [self MRLayout_impl_selection];
}

@end

#pragma mark - MRCollectionLayout

@implementation MRCollectionLayout
{
   BOOL emptyRegistered;
}

@synthesize reuseCellIdentifier;
@synthesize collectionViewDelegate;

-(void)prepareLayout
{
   [super prepareLayout];
   if (!emptyRegistered && self.collectionView)
   {
      [self.collectionView registerClass:[UICollectionViewCell class]
              forCellWithReuseIdentifier:kMRGridEmptyCellIdentifier];
      emptyRegistered = YES;
   }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   return [self MRLayout_impl_collectionView:collectionView
                      cellForItemAtIndexPath:indexPath];
}

-(id)itemAtIndexPath:(NSIndexPath*)indexPath
{
   return [super itemAtIndexPath:indexPath];
}

-(NSArray*)selection
{
   return [self MRLayout_impl_selection];
}

@end


#pragma mark -

@implementation UICollectionViewLayout (MRLayout_impl)

@dynamic collectionViewDelegate;
@dynamic reuseCellIdentifier;

-(UICollectionViewCell *)MRLayout_impl_collectionView:(UICollectionView *)collectionView
                               cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   UICollectionViewCell *cell = nil;
   
   NSObject* obj = [self itemAtIndexPath:indexPath];
   
   if ([self.collectionViewDelegate respondsToSelector:@selector(collectionView:cellForItemAtIndexPath:)])
      cell = [self.collectionViewDelegate collectionView:collectionView
                                  cellForItemAtIndexPath:indexPath];
   
   @try {
      if (!cell)
      {
         NSString* reuseCellIdentifier = [self reuseCellIdentifier_impl:obj];
         cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseCellIdentifier
                                                               forIndexPath:indexPath];
      }
   } @catch (NSException *exception) {
      cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMRGridEmptyCellIdentifier
                                                       forIndexPath:indexPath];
      cell.userInteractionEnabled = NO;
   } @finally {
      [cell setContent:obj];
   }
   
   return cell;
}

-(NSString*)reuseCellIdentifier_impl:(NSObject*)obj
{
   return [obj mr_collectionCellIdentifier:self.collectionView] ?: self.reuseCellIdentifier;
}

-(id)itemAtIndexPath:(NSIndexPath*)indexPath
{
   @throw [NSException exceptionWithName:@"MustOverride"
                                  reason:NSStringFromSelector(_cmd)
                                userInfo:nil];
   return nil;
}

-(NSArray*)MRLayout_impl_selection
{
   NSArray<NSIndexPath*>* s = self.collectionView.indexPathsForSelectedItems;
   NSMutableArray* ret = [NSMutableArray arrayWithCapacity:s.count];
   for (NSIndexPath* indexPath in s)
      [ret addObject:[self itemAtIndexPath:indexPath]];
   return [ret copy];
}

@end


