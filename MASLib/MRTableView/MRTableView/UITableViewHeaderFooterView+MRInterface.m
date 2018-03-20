//
//  UITableViewHeaderFooterView+IKInterface.m
//  ikframework
//
//  Created by Federico Gasperini on 26/03/15.
//  Copyright (c) 2015 accenture. All rights reserved.
//

#import "UITableViewHeaderFooterView+MRInterface.h"
#import <objc/runtime.h>

static void* _title_label_ = &_title_label_;

@implementation UITableViewHeaderFooterView (MRInterface)

-(void)setTitleLabel:(UILabel *)titleLabel
{
   objc_setAssociatedObject(self, _title_label_, titleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UILabel*)titleLabel
{
   return objc_getAssociatedObject(self, _title_label_);
}


-(void)setContent:(id)content
{
   [self.titleLabel setText:[content description]];
}

@end
