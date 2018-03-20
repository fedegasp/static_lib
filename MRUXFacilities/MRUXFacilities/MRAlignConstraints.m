//
//  MRAlignConstraints.m
//  MASClient
//
//  Created by Federico Gasperini on 05/09/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "MRAlignConstraints.h"

@implementation MRAlignConstraints

-(void)alignToValue:(CGFloat)value
{
    [self.constraints setValue:@(value)
                        forKey:@"constant"];
}

-(void)alignToMax
{
    NSNumber* max = [self.constraints valueForKeyPath:@"@max.constant"];
    [self.constraints setValue:max
                        forKey:@"constant"];
}

-(void)alignToMin
{
    NSNumber* min = [self.constraints valueForKeyPath:@"@min.constant"];
    [self.constraints setValue:min
                        forKey:@"constant"];
}

@end
