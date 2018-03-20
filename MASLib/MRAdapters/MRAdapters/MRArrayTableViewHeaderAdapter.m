//
//  MRArrayTableViewHeaderAdapter.m
//  MRAdapter
//
//  Created by Federico Gasperini on 27/06/16.
//  Copyright © 2016 accenture. All rights reserved.
//

#import "MRArrayTableViewHeaderAdapter.h"
#import "UITableViewHeaderFooterView+IKInterface.h"
#import "NSArray+IKInterface.h"

static NSString* const kIdentifier = @"static NSString* const kIdentifier";

@interface MRArrayTableViewHeaderAdapter ()

@property (strong, nonatomic) NSArray* data;

@end


@implementation MRArrayTableViewHeaderAdapter

-(void)setHeaderNibName:(NSString *)headerNibName
{
   _headerNibName = headerNibName;
   if (self.tableView)
      [self.tableView registerNib:[UINib nibWithNibName:_headerNibName
                                                 bundle:nil]
forHeaderFooterViewReuseIdentifier:kIdentifier];
}

-(void)setTableView:(UITableView *)tableView
{
   _tableView = tableView;
   if (self.headerNibName)
      [self.tableView registerNib:[UINib nibWithNibName:_headerNibName
                                                 bundle:nil]
forHeaderFooterViewReuseIdentifier:kIdentifier];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   if (tableView.numberOfSections <= section)
      return nil;
   
   UITableViewHeaderFooterView* hv = nil;
   if ([self.nextDelegate respondsToSelector:_cmd])
      hv = [self.nextDelegate tableView:tableView
                     viewForHeaderInSection:section];
   else
   {
      hv = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kIdentifier];
      
      if (self.headerData.count > section)
         [hv setContent:self.headerData[section]];
   }

   return hv;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   if ([self.nextDelegate respondsToSelector:_cmd])
      return [self.nextDelegate tableView:tableView heightForHeaderInSection:section];
   
   NSInteger count = self.data.isMultiDimensional ? [self.data[section] count] : self.data.count;
   
   return count ? self.headerHeight : .0f;
}

@end
