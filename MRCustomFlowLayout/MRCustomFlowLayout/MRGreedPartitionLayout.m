//
//  MRGreedyPartitionLayout.m
//  CollectionTest
//
//  Created by Federico Gasperini on 30/05/17.
//  Copyright © 2017 -. All rights reserved.
//

#import "MRGreedyPartitionLayout.h"

const CGFloat kMRZeroHeight = -1.0;

@implementation MRGreedyPartitionLayout
{
   CGRect* _rects;
   CGFloat _cellWidth;
   CGSize _collectionViewContentSize;
}

@dynamic collectionViewDelegate;

-(instancetype)init
{
   self = [super init];
   if (self)
      self.cols = 2;
   
   return self;
}

-(instancetype)initWithCoder:(NSCoder*)coder
{
   self = [super initWithCoder:coder];
   if (self)
      if (self.cols < 2)
         self.cols = 2;
   
   return self;
}

-(void)dealloc
{
   free(_rects);
}

-(void)setJson:(NSString *)json
{
   _json = json;
   NSString* jsonFile = [[NSBundle mainBundle] pathForResource:json
                                                        ofType:@"json"];
   if (jsonFile)
   {
      NSData* jsonData = [NSData dataWithContentsOfFile:jsonFile];
      if (jsonData)
      {
         NSArray* a = [NSJSONSerialization JSONObjectWithData:jsonData
                                                      options:0
                                                        error:NULL];
         self.data = a;
      }
   }
}

-(void)setData:(NSArray *)data
{
   _data = data;
   free(_rects);
   if (data.count)
      _rects = malloc(sizeof(CGRect) * data.count);
   else
      _rects = NULL;
   [self invalidateLayout];
   [self.collectionView reloadData];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   return self.data.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
   return 1;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
   return newBounds.size.width != self.collectionView.frame.size.width;
}

-(id)itemAtIndexPath:(NSIndexPath *)indexPath
{
   return self.data[indexPath.item];
}

-(void)prepareLayout
{
   [super prepareLayout];
   
   CGFloat* ys = malloc(sizeof(CGFloat) * _cols);
   CGFloat* xs = malloc(sizeof(CGFloat) * _cols);
   
   NSInteger shorterCol = 0;
   
   _cellWidth = (self.collectionView.frame.size.width - self.sectionInset.left -
                 self.sectionInset.right - self.columnsSpace * (_cols - 1)) / _cols;
   for (NSInteger i = 0; i < _cols; i++)
   {
      xs[i] = self.sectionInset.left + (_cellWidth + _columnsSpace) * i;
      ys[i] = self.sectionInset.top;
   }
   
   CGFloat maxHeight = 0;
   
   for (NSInteger i = 0; i < self.data.count; i++)
   {
      CGFloat h = [self.collectionViewDelegate
                   collectionViewLayout:self
                   heightForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
      
      if (h == .0)
         h = _cellWidth;
      else if (h < .0)
         h = .0;
      CGRect r = CGRectMake(xs[shorterCol],
                            ys[shorterCol],
                            _cellWidth, h);
      _rects[i] = r;
      ys[shorterCol] += h > .0 ? (h + _verticalItemSpace) : .0;
      
      if (ys[shorterCol] > maxHeight)
         maxHeight = ys[shorterCol];
      
      if (self.disableGreedy)
      {
         shorterCol = (shorterCol + 1) % _cols;
      }
      else
      {
         for (NSInteger i = 0; i < _cols; i++)
            if (ys[i] < ys[shorterCol])
               shorterCol = i;
            else if (ys[i] == ys[shorterCol])
               shorterCol = MIN(i, shorterCol);
      }
   }
   
   _collectionViewContentSize = CGSizeMake(self.collectionView.frame.size.width,
                                           maxHeight - _verticalItemSpace + self.sectionInset.bottom);
   
   free(ys);
   free(xs);
}

-(CGSize)collectionViewContentSize
{
   return _collectionViewContentSize;
}

-(NSArray<__kindof UICollectionViewLayoutAttributes*>*)layoutAttributesForElementsInRect:(CGRect)rect
{
   NSMutableArray* elementsInRect = [NSMutableArray array];
   
   for(NSUInteger j = 0; j < [self.collectionView numberOfItemsInSection:0]; j++)
   {
      //this is the cell at row j in section i
      CGRect cellFrame = _rects[j];
      
      //see if the collection view needs this cell
      if(CGRectIntersectsRect(cellFrame, rect))
      {
         //create the attributes object
         NSIndexPath* indexPath = [NSIndexPath indexPathForRow:j inSection:0];
         UICollectionViewLayoutAttributes* attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
         
         //set the frame for this attributes object
         attr.frame = cellFrame;
         [elementsInRect addObject:attr];
      }
   }
   
   return elementsInRect;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
   UICollectionViewLayoutAttributes* attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
   
   CGRect cellFrame = _rects[indexPath.item];
   
   attr.frame = cellFrame;
   
   return attr;
}

#pragma mark - forwarding to _collectionViewDelegate

-(BOOL)respondsToSelector:(SEL)aSelector
{
   BOOL superRespondsToSelectorRet = [super respondsToSelector:aSelector];
   return superRespondsToSelectorRet ||
          [self.collectionViewDelegate respondsToSelector:aSelector];
}

-(id)forwardingTargetForSelector:(SEL)aSelector
{
   if (self.collectionViewDelegate)
      return self.collectionViewDelegate;
   
   return [super forwardingTargetForSelector:aSelector];
}

@end
