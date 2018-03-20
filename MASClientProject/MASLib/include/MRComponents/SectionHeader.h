//
//  SectionHeader.h
//  MASClient
//
//  Created by Federico Gasperini on 04/11/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisplayableItem.h"

@interface SectionHeader : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel* titleLabel;
@property (weak, nonatomic) IBOutlet UIButton* actionButton;
@property (weak, nonatomic) IBOutlet UIButton* collapseButton;
@property (weak, nonatomic) IBOutlet UIImageView* iconView;

@property (assign, nonatomic) NSInteger section;

@property (strong, nonatomic) id<DisplayableItem> content;

-(void)setActionText:(NSString*)text;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@end
