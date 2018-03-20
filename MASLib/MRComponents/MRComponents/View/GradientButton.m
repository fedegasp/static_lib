//
//  GradientButton.m
//  MASClient
//
//  Created by Gai, Fabio on 05/06/2017.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "GradientButton.h"
#import <MRGraphics/lib.h>
#import <MRBase/UIColor+colorWithName.h>

@implementation GradientButton
{
    UIColor* firstEnabled;
    UIColor* secondEnabled;
}

-(void)awakeFromNib
{
   [super awakeFromNib];
    firstEnabled = self.firstColor;
    secondEnabled = self.secondColor;
    [self setEnabled:self.enabled];

}

-(void)setEnabled:(BOOL)enabled
{
   [super setEnabled:enabled];
   if (enabled)
   {
      self.firstColor = firstEnabled;
      self.secondColor = secondEnabled;
   }
   else
   {
      self.firstColor = [firstEnabled grayScaleColor];
      self.secondColor = [secondEnabled grayScaleColor];
   }
}

@end
