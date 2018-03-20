//
//  SectionFooter.h
//  MASClient
//
//  Created by Federico Gasperini on 04/11/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionFooter : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel* titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView* iconView;
@property (weak, nonatomic) IBOutlet UIButton* sectionButton;

@property (assign, nonatomic) NSInteger section;

-(void)setContent:(id)content;

@end
