//
//  MRArrayTableViewAdapter.h
//  IK
//
//  Created by Federico Gasperini on 02/03/15.
//  Copyright (c) 2015 Federico Gasperini. All rights reserved.
//

#import "MRArrayTableViewAdapter.h"
#import <MRBase/lib.h>
#import <MRTableView/lib.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <MRComponents/MRTableViewCell.h>

static NSString* const kDefaultCellIdentifier = @"cell";

@interface MRArrayTableViewAdapter ()

-(id)itemAtIndexPath:(NSIndexPath*)indexPath;
@property (readonly) NSArray* selection;

@property (strong, nonatomic) NSMutableSet* selectedObjects;

@end

@implementation MRArrayTableViewAdapter

//@synthesize arrayOfArray = self.arrayOfArray;
-(BOOL)arrayOfArray
{
   return self.data.isMultiDimensional;
}

-(id)itemAtIndexPath:(NSIndexPath*)indexPath
{
   if (self.arrayOfArray)
      return self.data[indexPath.section][indexPath.row];
   return self.data[indexPath.row];
}

-(NSArray*)selection
{
   NSArray* set = [self.tableView indexPathsForSelectedRows];
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
   self.selectedObjects = [[NSMutableSet alloc] init];
   if ([self.nextDelegate respondsToSelector:@selector(setData:)])
      [self.nextDelegate setData:data];
   //   self.arrayOfArray = self.data.isMultiDimensional;
   [self.tableView reloadData];
}

-(void)setAdapterDelegate:(id<MRArrayTableViewAdapterDelegate>)tableViewDelegate
{
   _adapterDelegate = tableViewDelegate;
   self.tableView.delegate = self;
   [self.tableView reloadData];
}

-(void)setTableView:(UITableView *)tableView
{
   _tableView = tableView;
   _tableView.delegate = self;
   _tableView.dataSource = self;
//   _tableView.rowHeight = UITableViewAutomaticDimension;
//   _tableView.estimatedRowHeight = 60.0f;
    
   [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   if (self.arrayOfArray)
      return self.data.count;
   return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   if (self.arrayOfArray)
      return [self.data[section] count];
   return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell* cell = nil;
   if ([self.nextDelegate respondsToSelector:_cmd])
      cell = [(id)self.nextDelegate tableView:tableView cellForRowAtIndexPath:indexPath];

   id obj = [self itemAtIndexPath:indexPath];
   if (!cell)
   {
      NSString* cellIdentifier = nil;
      if ([self.adapterDelegate respondsToSelector:@selector(tableView:reuseIdentifierForIndexPath:)])
         cellIdentifier = [self.adapterDelegate tableView:self.tableView reuseIdentifierForIndexPath:indexPath];
      if ([obj respondsToSelector:@selector(tableViewCellIdentifier)])
         cellIdentifier = [obj tableViewCellIdentifier];
      if (!cellIdentifier)
         cellIdentifier = self.cellIdentifier;
      if (cellIdentifier.length == 0 && [obj isKindOfClass:NSDictionary.class])
           cellIdentifier = [obj valueForKey:kTableCellIdentifier];
      if (!cellIdentifier)
         cellIdentifier = kDefaultCellIdentifier;
      
      cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
   }
    
    if ([cell respondsToSelector:@selector(setContent:)])
        [cell setContent:obj];
    else
    {
        if ([obj respondsToSelector:@selector(tableViewCellText)])
            [cell.textLabel setText:[obj tableViewCellText]];
        else
            [cell.textLabel setText:[obj description]];
        
        if ([obj respondsToSelector:@selector(tableViewCellImage)])
            [cell.imageView setImage:[obj tableViewCellImage]];
    }
    
    if ([self.selectedObjects containsObject:obj])
        [tableView selectRowAtIndexPath:indexPath
                               animated:YES
                         scrollPosition:UITableViewScrollPositionNone];
    else
        [tableView deselectRowAtIndexPath:indexPath
                                 animated:YES];
   // [cell layoutIfNeeded];


   return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
{
   if ([self.nextDelegate respondsToSelector:_cmd])
      [self.nextDelegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];

//   id obj = [self itemAtIndexPath:indexPath];
   
//   if ([cell respondsToSelector:@selector(setContent:)])
//      [cell setContent:obj];
//   else
//   {
//      if ([obj respondsToSelector:@selector(tableViewCellText)])
//         [cell.textLabel setText:[obj tableViewCellText]];
//      else
//         [cell.textLabel setText:[obj description]];
//      
//      if ([obj respondsToSelector:@selector(tableViewCellImage)])
//         [cell.imageView setImage:[obj tableViewCellImage]];
//   }
//   
//   if ([self.selectedObjects containsObject:obj])
//      [tableView selectRowAtIndexPath:indexPath
//                             animated:YES
//                       scrollPosition:UITableViewScrollPositionNone];
//   else
//      [tableView deselectRowAtIndexPath:indexPath
//                               animated:YES];
//   [cell layoutIfNeeded];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (!tableView.allowsMultipleSelection)
      [self.selectedObjects removeAllObjects];
   
   [self.selectedObjects addObject:[self itemAtIndexPath:indexPath]];
   
   if ([self.nextDelegate respondsToSelector:_cmd])
      [self.nextDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
   
   if (self.transientSelection)
      [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
   
   if ([self.adapterDelegate respondsToSelector:@selector(tableView:didSelect:)])
      [self.adapterDelegate tableView:tableView didSelect:self.selection];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
   [self.selectedObjects removeObject:[self itemAtIndexPath:indexPath]];

   if ([self.nextDelegate respondsToSelector:_cmd])
      [self.nextDelegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
   if ([self.adapterDelegate respondsToSelector:@selector(tableView:didSelect:)] && tableView.allowsMultipleSelection)
      [self.adapterDelegate tableView:tableView didSelect:self.selection];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewAutomaticDimension;
//}

@end
