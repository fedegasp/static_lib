//
//  CustomFlowLayout.m
//  CollectionTest
//
//  Created by Federico Gasperini on 14/05/17.
//  Copyright © 2017 -. All rights reserved.
//

#import "MRGridLayout.h"
#import <objc/message.h>
#import <objc/runtime.h>


#pragma mark - MRGridLayout

@implementation MRGridLayout

@dynamic rows;
@dynamic cols;

-(instancetype)init
{
   self = [super init];
   if (self)
   {
      self.rows = 1;
      self.cols = 1;
   }
   return self;
}

-(instancetype)initWithCoder:(NSCoder*)coder
{
   self = [super initWithCoder:coder];
   if (self)
   {
      if (self.rows < 1)
         self.rows = 1;
      if (self.cols < 1)
         self.cols = 1;
   }
   return self;
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
   [self invalidateLayout];
   [self.collectionView reloadData];
}

-(id)itemAtIndexPath:(NSIndexPath*)indexPath
{
   NSInteger offset = indexPath.section * (self.cols * self.rows);
   NSInteger item = indexPath.item + offset;

   if (item < self.data.count)
      return self.data[item];
   
   return nil;
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
   NSInteger pages = (NSInteger)ceil((CGFloat)self.data.count / (self.cols * self.rows));
   self.pageControl.numberOfPages = pages;
   return pages;
}

-(BOOL)indexPathIsEmpty:(NSIndexPath *)indexPath
{
   NSInteger offset = indexPath.section * (self.cols * self.rows);
   NSInteger item = indexPath.item + offset;
   
   return item >= self.data.count;
}

-(void)setCurrentSection:(NSInteger)currentSection
{
   [super setCurrentSection:currentSection];
   self.pageControl.currentPage = currentSection;
}

@end
