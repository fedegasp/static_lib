//
//  UIViewController+Branding.m
//  MRBranding
//
//  Created by Enrico Cupellini on 08/03/18.
//  Copyright © 2018 Accenture - MAS. All rights reserved.
//

#import "UIViewController+Branding.h"
#import "MRBrandConfigurator.h"
#import <MRBase/lib.h>

@implementation UIViewController (Branding)

-(void)setBrandLabel:(NSArray*)brandLabels
{
    MRBrandConfigurator *configurator = [MRBrandConfigurator sharedInstance];
    NSDictionary *confDict = [configurator configurationDict];
    for (UILabel *label in brandLabels) {
        label.textColor = [UIColor colorWithName:[[confDict valueForKey:@"labelTextColor"]valueForKey:[configurator configurationKey]]];
    }
}

@end
