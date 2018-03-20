//
//  ContentInsetLabel.m
//  MASClient
//
//  Created by Federico Gasperini on 15/02/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "ContentInsetLabel.h"

@implementation ContentInsetLabel

-(void)drawTextInRect:(CGRect)rect
{
   CGRect r = UIEdgeInsetsInsetRect(rect, self.textInset);
   [super drawTextInRect:r];
}

-(void)setTextInset:(UIEdgeInsets)textInset
{
   _textInset = textInset;
   [self setNeedsDisplay];
}

@end
