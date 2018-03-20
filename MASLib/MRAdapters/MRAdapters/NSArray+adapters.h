//
//  NSArray+adapters.h
//  Ax
//
//  Created by Federico Gasperini on 04/03/15.
//  Copyright (c) 2015 Federico Gasperini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRArrayPickerViewAdapter.h"
#import "MRArrayTableViewAdapter.h"
#import "MRArrayCollectionViewAdapter.h"

@interface NSArray (adapters)

-(MRArrayPickerViewAdapter*)pickerViewAdapter;
-(MRArrayPickerViewAdapter*)adapterWithPickerView:(UIPickerView*)pickerView andAdapterDelegate:(id<MRArrayPickerViewAdapterDelegate>)adapterDelegate;

-(MRArrayTableViewAdapter*)tableViewAdapter;
-(MRArrayTableViewAdapter*)adapterWithTableView:(UITableView*)tableView andAdapterDelegate:(id<MRArrayTableViewAdapterDelegate>)adapterDelegate;

-(MRArrayCollectionViewAdapter*)collectionViewAdapter;
-(MRArrayCollectionViewAdapter*)adapterWithCollectionView:(UICollectionView*)collectionView andAdapterDelegate:(id<MRArrayCollectionViewAdapterDelegate>)adapterDelegate;

@end
