//
//  MRArrayTableViewPaginatedAdapter.h
//  MRAdapter
//
//  Created by Federico Gasperini on 26/05/16.
//  Copyright © 2016 accenture. All rights reserved.
//

#import "MRArrayTableViewAdapter.h"

@protocol MRArrayTableViewPaginatedAdapterDelegate <MRArrayTableViewAdapterDelegate>

-(BOOL)tableViewShouldLoadMore:(UITableView* __nonnull)tableView;

@end


@interface MRArrayTableViewPaginatedAdapter : MRArrayTableViewAdapter

@property (weak, nonatomic, nullable) IBOutlet id<MRArrayTableViewPaginatedAdapterDelegate> adapterDelegate;
@property (strong, nonatomic, nonnull) IBInspectable NSString* waitingCellIdentifier;
-(void)appendData:(NSArray* __nonnull)otherData;

@end
