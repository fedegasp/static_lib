//
//  SectionFooter.m
//  MASClient
//
//  Created by Federico Gasperini on 04/11/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import "SectionFooter.h"
#import "DisplayableItem.h"

@implementation SectionFooter

-(void)setContent:(id<DisplayableItem>)content
{
   if (self.sectionButton)
      [self.sectionButton setTitle:[content displayTitle]
                          forState:UIControlStateNormal];
   else
      self.titleLabel.text = [content displayTitle];
   self.iconView.image  = [content displayImage];
}

@end
