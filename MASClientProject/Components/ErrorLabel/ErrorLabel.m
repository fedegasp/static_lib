//
//  ErrorLabel.m
//  MASClient
//
//  Created by Gai, Fabio on 20/07/2017.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "ErrorLabel.h"

@implementation ErrorLabel

-(void)setErrorState{
    self.textColor = self.errorColor;
}

-(void)clearErrorState{
    self.textColor = self.normalColor;
}

-(void)setHidden:(BOOL)hidden{
    [super setHidden:hidden];
}

@end
