//
//  MRProgressView.m
//  MASClient
//
//  Created by Ludovica Acciai on 24/08/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "MRProgressView.h"

@implementation MRProgressView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.gradientDirection = GradientDirectionCustom;
    self.firstColor = COLOR_GRADIENT_1;
    self.secondColor = COLOR_GRADIENT_2;
}


@end
