//
//  UniversalContentsTableViewController.m
//  MASClient
//
//  Created by Federico Gasperini on 30/01/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "UniversalContentsTableViewController.h"
//#import "SectionHeader.h"

@interface UniversalContentsTableViewController ()

@end

@implementation UniversalContentsTableViewController

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   UIView* v = (id)[super tableView:tableView viewForHeaderInSection:section];
   if ([v isKindOfClass:SectionHeader.class])
   {
      SectionHeader* sh = (id)v;
      if (IS_IPAD)
      {
         id<DisplayableItem> footerItem = [self itemForFooterInSection:section];
         [sh setActionText:[footerItem displayTitle]];
      }
      else
         [sh setActionText:nil];
   }
   return v;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
   if (IS_IPAD)
   {
      if ([self countForSection:section withOverflow:NULL] > 0)
         return 20.0;
      else
         return .01;
   }
   return [super tableView:tableView heightForFooterInSection:section];
}

@end
