//
//  SectionHeader.m
//  MASClient
//
//  Created by Federico Gasperini on 04/11/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import "SectionHeader.h"
#import "DisplayableItem.h"
#import <MRBase/MRMacros.h>

@implementation SectionHeader

-(void)setActionText:(NSString *)text
{
   self.actionButton.hidden = NO;
//   if (IS_IPAD)
//   {
//      if (text.length)
//         [self.actionButton setTitle:text
//                            forState:UIControlStateNormal];
//      else
//         self.actionButton.hidden = YES;
//   }
//   else
//      self.actionButton.hidden = YES;
}

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.contentView.backgroundColor = backgroundColor;
}

-(void)setContent:(id<DisplayableItem>)content
{
   _content = content;
   if ([content displayTitle])
      self.titleLabel.text = [content displayTitle];
   if ([content displayImage] != nil) {
      self.iconView.image  = [content displayImage];
   }else{
      self.iconView.image = nil;
      self.heightConstraint.constant = 0;
   }
}

@end
