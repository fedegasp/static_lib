//
//  MRArrayTableViewHeaderAdapter.h
//  MRAdapter
//
//  Created by Federico Gasperini on 27/06/16.
//  Copyright © 2016 accenture. All rights reserved.
//

#import <MRBase/MRChainedDelegate.h>

@interface MRArrayTableViewHeaderAdapter : IKChainedDelegate <UITableViewDelegate>

@property (strong, nonatomic, nullable) IBInspectable NSString* headerNibName;
@property (strong, nonatomic, nullable) IBInspectable NSArray* headerData;
@property (strong, nonatomic, nullable) IBOutlet UITableView* tableView;

@property (assign, nonatomic) IBInspectable CGFloat headerHeight;

@end
