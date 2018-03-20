//
//  ISPShadowView.m
//  MASClient
//
//  Created by Gai, Fabio on 14/11/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import "ISPShadowView.h"

@implementation ISPShadowView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowRadius = 7.0;
    self.layer.masksToBounds = NO;
    self.layer.shadowOpacity = .4;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] nativeScale];
}

@end
