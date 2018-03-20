//
//  NSArray+pickerViewAdapter.m
//  Ax
//
//  Created by Federico Gasperini on 04/03/15.
//  Copyright (c) 2015 Federico Gasperini. All rights reserved.
//

#import "NSArray+adapters.h"

@implementation NSArray (adapters)


-(MRArrayPickerViewAdapter*)adapterWithPickerView:(UIPickerView *)pickerView andAdapterDelegate:(id<MRArrayPickerViewAdapterDelegate>)adapterDelegate
{
   MRArrayPickerViewAdapter* adapter = [[MRArrayPickerViewAdapter alloc] init];
   adapter.pickerView = pickerView;
   adapter.adapterDelegate = adapterDelegate;
   adapter.data = [self mutableCopy];
   return adapter;
}

-(MRArrayPickerViewAdapter*)pickerViewAdapter
{
   return [self adapterWithPickerView:nil andAdapterDelegate:nil];
}


-(MRArrayTableViewAdapter*)adapterWithTableView:(UITableView*)tableView andAdapterDelegate:(id<MRArrayTableViewAdapterDelegate>)adapterDelegate
{
   MRArrayTableViewAdapter* adapter = [[MRArrayTableViewAdapter alloc] init];
   adapter.tableView = tableView;
   adapter.adapterDelegate = adapterDelegate;
   adapter.data = [self mutableCopy];
   return adapter;
}

-(MRArrayTableViewAdapter*)tableViewAdapter
{
   return [self adapterWithTableView:nil andAdapterDelegate:nil];
}


-(MRArrayCollectionViewAdapter*)collectionViewAdapter
{
   return [self adapterWithCollectionView:nil andAdapterDelegate:nil];
}

-(MRArrayCollectionViewAdapter*)adapterWithCollectionView:(UICollectionView*)collectionView andAdapterDelegate:(id<MRArrayCollectionViewAdapterDelegate>)adapterDelegate
{
   MRArrayCollectionViewAdapter* adapter = [[MRArrayCollectionViewAdapter alloc] init];
   [collectionView.collectionViewLayout invalidateLayout];
   adapter.collectionView = collectionView;
   adapter.adapterDelegate = adapterDelegate;
   adapter.data = [self mutableCopy];
   return adapter;
}


@end
