//
//  MRArrayTableViewPaginatedAdapter.m
//  MRAdapter
//
//  Created by Federico Gasperini on 26/05/16.
//  Copyright © 2016 accenture. All rights reserved.
//

#import "MRArrayTableViewPaginatedAdapter.h"

@implementation MRArrayTableViewPaginatedAdapter
{
   BOOL loading;
}

@synthesize adapterDelegate;

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (!loading)
   {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                     ^{
                        if (indexPath.row == self.data.count - 1)
                           if ([self.adapterDelegate tableViewShouldLoadMore:tableView])
                              [self addLoadingCell];
                     });
   }
   if (indexPath.row < self.data.count)
      [super tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
   else
   {
      UIActivityIndicatorView* activity = [cell.contentView viewWithTag:(NSInteger) &(*self)];
      [activity startAnimating];
      activity.frame = activity.superview.bounds;
   }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [super tableView:tableView numberOfRowsInSection:section] + (loading ? 1 : 0);
}

-(void)addLoadingCell
{
   @synchronized (self)
   {
      [self.tableView beginUpdates];
      loading = YES;
      [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.data.count
                                                                  inSection:0]]
                            withRowAnimation:UITableViewRowAnimationAutomatic];
      [self.tableView endUpdates];
   }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (indexPath.row == self.data.count)
   {
      UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:self.waitingCellIdentifier];
      if (!cell)
      {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:self.waitingCellIdentifier];
         UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
         cell.contentView.contentMode = UIViewContentModeCenter;
         activity.tag = (NSInteger) &(*self);
         [[cell contentView] addSubview:activity];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         activity.hidesWhenStopped = NO;
      }
      return cell;
   }
   else
      return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (indexPath.row == self.data.count)
      return 60.0;
   else
      return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

-(void)appendData:(NSArray*)otherData
{
   @synchronized (self)
   {
      if (loading)
      {
         NSInteger appendCount = otherData.count;
         NSInteger lastRow = self.data.count;
         NSIndexPath* lastIndexPath = [NSIndexPath indexPathForRow:lastRow
                                                         inSection:0];
         [self.tableView beginUpdates];
         [[self data] addObjectsFromArray:otherData];
         loading = NO;
         NSMutableArray* indxs = [[NSMutableArray alloc] init];
         for (NSInteger i = 0; i < appendCount; i++)
            [indxs addObject:[NSIndexPath indexPathForRow:lastRow + i inSection:0]];
         [self.tableView insertRowsAtIndexPaths:indxs
                               withRowAnimation:UITableViewRowAnimationAutomatic];
         
         [self.tableView deleteRowsAtIndexPaths:@[lastIndexPath]
                               withRowAnimation:UITableViewRowAnimationAutomatic];
         
         [self.tableView endUpdates];
      }
   }
}

-(NSString*)waitingCellIdentifier
{
   return _waitingCellIdentifier ?: @"WAITING_CELL";
}

@end
