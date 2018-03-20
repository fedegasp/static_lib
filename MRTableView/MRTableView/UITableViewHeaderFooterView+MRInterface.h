//
//  UITableViewHeaderFooterView+IKInterface.h
//  ikframework
//
//  Created by Federico Gasperini on 26/03/15.
//  Copyright (c) 2015 accenture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewHeaderFooterView (MRInterface)

@property (strong, nonatomic) IBOutlet UILabel* titleLabel;

-(void)setContent:(id)content;

@end

