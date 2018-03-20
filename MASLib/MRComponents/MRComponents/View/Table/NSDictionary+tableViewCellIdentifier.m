//
//  NSDictionary+tableViewCellIdentifier.m
//  MASClient
//
//  Created by Enrico Cupellini on 07/09/2017.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "NSDictionary+tableViewCellIdentifier.h"
extern NSString *const kTableCellIdentifier;

@implementation NSDictionary (tableViewCellIdentifier)

-(NSString *)isp_tableViewCellIdentifier
{
    return [self valueForKey:kTableCellIdentifier];
}

@end
