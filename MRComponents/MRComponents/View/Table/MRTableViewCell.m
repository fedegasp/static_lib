//
//  ECTableViewCell.m
//  MASClient
//
//  Created by Enrico Cupellini on 12/06/2017.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "MRTableViewCell.h"
#import "MRViewModel.h"
NSString *const kTableCellIdentifier = @"cellIdentifier";

@implementation MRTableViewCell

-(void)setContent:(id)content
{
    MRViewModel *model = [[MRViewModel alloc]init];
    
    model.label = self.label;
    model.image = self.image;
    model.webView = self.webView;
    model.button = self.button;
    model.textView = self.textView;
    model.textField = self.textField;
    model.view = self.view;
    
    [model setContent:content];
}

@end
