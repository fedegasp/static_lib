//
//  MRExpandCellTableViewDelegate.m
//  MRAdapter
//
//  Created by Federico Gasperini on 16/03/16.
//  Copyright © 2016 accenture. All rights reserved.
//

#import "MRExpandCellTableViewDelegate.h"

@implementation MRExpandCellTableViewDelegate
{
   NSMutableSet* _selection;
}

-(instancetype)init
{
   self = [super init];
   if (self)
      _selection = [[NSMutableSet alloc] init];

   return self;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   CGFloat ret = [tableView.indexPathsForSelectedRows containsObject:indexPath] ?
                  self.selectedHeight : self.normalHeight;
   return ret;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   if ([self.nextDelegate respondsToSelector:_cmd])
      [self.nextDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
   if ([_selection containsObject:indexPath])
   {
      [_selection removeObject:indexPath];
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
   }
   else
      [_selection addObject:indexPath];
   [tableView beginUpdates];
   [tableView endUpdates];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
   [_selection removeObject:indexPath];
   if ([self.nextDelegate respondsToSelector:_cmd])
      [self.nextDelegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
   [tableView beginUpdates];
   [tableView endUpdates];
}

@end
