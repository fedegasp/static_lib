//
//  MRArrayCollapsableSelectionTableViewAdapter.m
//  a
//
//  Created by Federico Gasperini on 17/02/16.
//  Copyright © 2016 Federico Gasperini. All rights reserved.
//

#import "MRArrayCollapsableSelectionTableViewAdapter.h"

@implementation MRArrayCollapsableSelectionTableViewAdapter

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
   [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
   if ([[tableView indexPathsForSelectedRows] containsObject:indexPath])
      cell.accessoryType = UITableViewCellAccessoryCheckmark;
   else
      cell.accessoryType = UITableViewCellAccessoryNone;
}

-(NSArray<NSIndexPath*>*)expandSection:(NSInteger)section
{
   NSMutableArray<NSIndexPath*>* retval = [[NSMutableArray alloc] init];
   
   NSMutableArray* filtered = nil;
   NSMutableArray* original = nil;
   
   if (self.arrayOfArray)
   {
      filtered = self.filteredData[section];
      original = self.originalData[section];
   }
   else
   {
      filtered = self.filteredData;
      original = self.originalData;
   }
   
   [filtered removeAllObjects];
   [filtered addObjectsFromArray:original];
   
   for (NSInteger i = 0; i < original.count; i++)
      if (![self.selectedObjects containsObject:original[i]])
         [retval addObject:[NSIndexPath indexPathForRow:i inSection:section]];
   
   return retval;
}

-(NSArray<NSIndexPath*>*)collapseSection:(NSInteger)section
{
   NSMutableArray<NSIndexPath*>* retval = [[NSMutableArray alloc] init];
   
   NSMutableArray* filtered = nil;
   NSMutableArray* original = nil;
   
   if (self.arrayOfArray)
   {
      filtered = self.filteredData[section];
      original = self.originalData[section];
   }
   else
   {
      filtered = self.filteredData;
      original = self.originalData;
   }
   
   [filtered removeAllObjects];
   
   NSMutableArray* reloadRows = [[NSMutableArray alloc] init];
   
   for (NSInteger i = 0; i < original.count; i++)
   {
      id obj = original[i];
      if ([self.selectedObjects containsObject:obj])
      {
         [filtered addObject:obj];
         [reloadRows addObject:[NSIndexPath indexPathForRow:i inSection:section]];
      }
      else
         [retval addObject:[NSIndexPath indexPathForRow:i inSection:section]];
   }
   
   return retval;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
   if ([self.collapsedSections containsIndex:indexPath.section] &&
       [self.selectedObjects containsObject:[self itemAtIndexPath:indexPath]])
   {
      [tableView selectRowAtIndexPath:indexPath
                             animated:NO
                       scrollPosition:UITableViewScrollPositionNone];
      [self expandOrCollapseSectionAction:indexPath];
   }
   else
      [super tableView:tableView didDeselectRowAtIndexPath:indexPath];
}

@end
