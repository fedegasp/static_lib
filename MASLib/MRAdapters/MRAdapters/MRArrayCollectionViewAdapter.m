//
//  MRArrayCollectionViewAdapter
//  IK
//
//  Created by Federico Gasperini on 02/03/15.
//  Copyright (c) 2015 Federico Gasperini. All rights reserved.
//

#import "MRArrayCollectionViewAdapter.h"
#import <MRBase/lib.h>
#import <MRTableView/lib.h>
#import <objc/runtime.h>
#import <objc/message.h>

static NSString* const kDefaultCellIdentifier = @"12345678900cell";

@interface MRArrayCollectionViewAdapter ()

-(id)itemAtIndexPath:(NSIndexPath*)indexPath;
@property (readonly) NSArray* selection;

@end

@implementation MRArrayCollectionViewAdapter
{
   BOOL sendDidSelect;
   BOOL sendDidSelectRowAtIndexPath;
   BOOL sendDidDeselectRowAtIndexPath;
   BOOL sendDisplayCell;
   BOOL sendCellForRow;
	
}

-(id)itemAtIndexPath:(NSIndexPath*)indexPath
{
   if (self.arrayOfArray)
      return self.data[indexPath.section][indexPath.row];
   return self.data[indexPath.row];
}

-(NSArray*)selection
{
   NSArray* set = [self.collectionView indexPathsForSelectedItems];
   NSMutableArray* selection = [[NSMutableArray alloc] init];
   for (NSIndexPath* indexPath in set)
      [selection addObject:[self itemAtIndexPath:indexPath]];
   return selection;
}

#pragma mark - Properties

-(void)setPlistSource:(NSString *)plistSource
{
   _plistSource = plistSource;
   if (_plistSource)
      self.data = [NSMutableArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:self.plistSource
                                                                                 withExtension:@"plist"]];
   else
      self.data = nil;
}

-(void)setData:(NSMutableArray *)data
{
   _data = data;
   _arrayOfArray = self.data.isMultiDimensional;
   [self.collectionView.collectionViewLayout invalidateLayout];
   [self.collectionView reloadData];
}

-(void)insertData:(NSArray *)array completion:(void (^ _Nullable)(BOOL))completion
{
    if (array.count > 0)
    {
        if (self.data == nil)
            self.data = [[NSMutableArray alloc] initWithCapacity:array.count];
        [self.collectionView performBatchUpdates:^{
            NSRange range = NSMakeRange(0, array.count);
            [self.data insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
            NSArray* idxs = [NSIndexPath indexPathsWithRange:range inSection:0];
            [self.collectionView insertItemsAtIndexPaths:idxs];
        } completion:completion];
    }
}

-(void)appendData:(NSArray*)array completion:(void (^ _Nullable)(BOOL))completion
{
   if (array.count > 0)
   {
      if (self.data == nil)
         self.data = [[NSMutableArray alloc] initWithCapacity:array.count];
      [self.collectionView performBatchUpdates:^{
         NSUInteger initialSize = [self.data count]; //data is the previous array of data
         [self.data addObjectsFromArray:array];
         NSRange range = NSMakeRange(initialSize, array.count);
         NSArray* idxs = [NSIndexPath indexPathsWithRange:range inSection:0];
         [self.collectionView insertItemsAtIndexPaths:idxs];
      } completion:completion];
   }
}

-(void)removeData:(NSArray *)array completion:(void (^ _Nullable)(BOOL))completion
{
   NSMutableIndexSet* indexSet = [NSMutableIndexSet indexSet];
   for (NSObject* obj in array)
   {
      NSUInteger pos = [self.data indexOfObject:obj];
      if (pos != NSNotFound)
         [indexSet addIndex:pos];
   }
   if (indexSet.count > 0)
   {
      [self.collectionView performBatchUpdates:^{
         [self.data removeObjectsAtIndexes:indexSet];
         NSMutableArray *arrayWithIndexPaths = [NSMutableArray array];
         
         [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
            [arrayWithIndexPaths addObject:[NSIndexPath indexPathForItem:idx
                                                               inSection:0]];
         }];
         
         [self.collectionView deleteItemsAtIndexPaths:arrayWithIndexPaths];
      } completion:completion];
   }
}

-(void)selectItems:(NSArray*)items
{
   NSMutableArray<NSIndexPath*>* futureSelection = [NSMutableArray arrayWithCapacity:items.count];
   for (id obj in items)
   {
      if (self.arrayOfArray)
      {
         for (NSInteger section = 0; section < self.data.count; section++)
         {
            NSUInteger idx = [self.data[section] indexOfObject:obj];
            if (idx != NSNotFound)
            {
               [futureSelection addObject:[NSIndexPath indexPathForItem:idx inSection:section]];
               break;
            }
         }
      }
      else
      {
         NSUInteger idx = [self.data indexOfObject:obj];
         if (idx != NSNotFound)
            [futureSelection addObject:[NSIndexPath indexPathForItem:idx inSection:0]];
      }
   }
   for (NSIndexPath* idp in self.collectionView.indexPathsForSelectedItems)
      [self.collectionView deselectItemAtIndexPath:idp
                                          animated:NO];
   for (NSIndexPath* idp in futureSelection)
      [self.collectionView selectItemAtIndexPath:idp
                                        animated:NO
                                  scrollPosition:UICollectionViewScrollPositionNone];
}

-(void)setAdapterDelegate:(id<MRArrayCollectionViewAdapterDelegate>)tableViewDelegate
{
   _adapterDelegate = tableViewDelegate;
   sendDidSelect = [_adapterDelegate respondsToSelector:@selector(collectionView:didSelect:)];
   sendDidSelectRowAtIndexPath = [_adapterDelegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)];
   sendDidDeselectRowAtIndexPath = [_adapterDelegate respondsToSelector:@selector(collectionView:didDeselectItemAtIndexPath:)];
   sendDisplayCell = [_adapterDelegate respondsToSelector:@selector(collectionView:willDisplayCell:forItemAtIndexPath:)];
   sendCellForRow = [_adapterDelegate respondsToSelector:@selector(collectionView:cellForItemAtIndexPath:)];
   self.collectionView.delegate = self;
   [self.collectionView reloadData];
}

-(void)setCollectionView:(UICollectionView *)collectionView
{
   _collectionView = collectionView;
   [_collectionView registerClass:UICollectionViewCell.class
       forCellWithReuseIdentifier:kDefaultCellIdentifier];
   _collectionView.delegate = self;
   _collectionView.dataSource = self;
}

-(void)dealloc
{
    if (_collectionView.delegate == self) {
        _collectionView.delegate = nil;
        _collectionView.dataSource = nil;
        _collectionView = nil;
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
   if (self.arrayOfArray)
      return self.data.count;
   return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   if (self.arrayOfArray)
      return [self.data[section] count];
   return self.data.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   UICollectionViewCell *cell = nil;
   if (sendCellForRow)
      cell = [(id)self.adapterDelegate collectionView:collectionView cellForItemAtIndexPath:indexPath];
   
   if (!cell)
   {
      NSString* cellIdentifier = nil;
      id obj = [self itemAtIndexPath:indexPath];
      cellIdentifier = [obj mr_collectionCellIdentifier:collectionView];
      if (!cellIdentifier)
         cellIdentifier = self.cellIdentifier;
      
      if (cellIdentifier)
         cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                          forIndexPath:indexPath];
   }
   
   if (cell)
   {
      id obj = [self itemAtIndexPath:indexPath];
      [cell setContent:obj];
   }
   else
      cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDefaultCellIdentifier
                                                       forIndexPath:indexPath];

	return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
   if (sendDisplayCell)
   {
      [self.adapterDelegate collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
   }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//   if (!collectionView.allowsMultipleSelection)
//   {
//      NSIndexPath* toDeselect = [collectionView indexPathsForSelectedItems].firstObject;
//      if (toDeselect)
//         [self.collectionView deselectItemAtIndexPath:toDeselect animated:YES];
//   }
   if (sendDidSelectRowAtIndexPath)
      [self.adapterDelegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
   if (sendDidSelect)
      [self.adapterDelegate collectionView:collectionView didSelect:self.selection];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
   if (sendDidDeselectRowAtIndexPath)
      [self.adapterDelegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
   if (sendDidSelect && collectionView.allowsMultipleSelection)
      [self.adapterDelegate collectionView:collectionView didSelect:self.selection];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.adapterDelegate respondsToSelector:_cmd])
        return [self.adapterDelegate collectionView:collectionView
                                             layout:collectionViewLayout
                             sizeForItemAtIndexPath:indexPath];
    
    if ([collectionViewLayout isKindOfClass:UICollectionViewFlowLayout.class])
    {
        UICollectionViewFlowLayout* flowLayout = (id)collectionViewLayout;
        CGSize size = flowLayout.itemSize;
        
        if (self.adaptCellHeight > .0) {
            size.height = (collectionView.bounds.size.height - flowLayout.sectionInset.top - flowLayout.sectionInset.bottom) * self.adaptCellHeight;
        }
        
        if (self.adaptCellWidth > .0) {
            size.width = (collectionView.bounds.size.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right)* self.adaptCellWidth;
        }
        
        if (size.height > self.maxCellHeigth && self.maxCellHeigth > 0) {
            
            size.height = self.maxCellHeigth;
        }
        
        if (size.width > self.maxCellWidth && self.maxCellWidth > 0) {
            
            size.width = self.maxCellWidth;
        }
   
        return size;
    }
    
    return CGSizeMake(100, 100);
}

#pragma mark - UICollectionViewDelegate methods forwarding

-(BOOL)respondsToSelector:(SEL)aSelector
{
   if (sel_isEqual(aSelector, @selector(collectionView:willDisplayCell:forItemAtIndexPath:))
       ||
       sel_isEqual(aSelector, @selector(collectionView:didSelectItemAtIndexPath:))
       ||
       sel_isEqual(aSelector, @selector(collectionView:didDeselectItemAtIndexPath:))
       ||
       sel_isEqual(aSelector, @selector(collectionView:layout:sizeForItemAtIndexPath:)))
      return YES;
   
   struct objc_method_description hasMethod;
   hasMethod = protocol_getMethodDescription(@protocol(UICollectionViewDelegateFlowLayout), aSelector, NO, YES);
   if ( hasMethod.name != NULL )
      return [self.adapterDelegate respondsToSelector:aSelector];
   
   return [super respondsToSelector:aSelector];
}

-(NSMethodSignature*)methodSignatureForSelector:(SEL)aSelector
{
   return [((NSObject*)self.adapterDelegate) methodSignatureForSelector:aSelector];
}

-(id)forwardingTargetForSelector:(SEL)aSelector
{
   return self.adapterDelegate;
}

@end
