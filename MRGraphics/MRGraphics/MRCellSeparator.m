//
//  MRCellSeparator.m
//  MRGraphics
//
//  Created by Federico Gasperini on 26/07/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "MRCellSeparator.h"

@implementation MRCellSeparator
{
   BOOL setted;
}

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
   if (!setted)
      [super setBackgroundColor:backgroundColor];
   setted = YES;
}

-(CGSize)intrinsicContentSize
{
   return CGSizeMake(0, 0.5);
}

@end
