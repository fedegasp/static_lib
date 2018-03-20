//
//  MRCollectionViewCell.m
//  MRComponents
//
//  Created by Enrico Cupellini on 15/09/2017.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "MRCollectionViewCell.h"
#import "MRViewModel.h"

@implementation MRCollectionViewCell

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
