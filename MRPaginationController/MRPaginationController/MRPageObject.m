//
//  MRPageObject.m
//  dpr
//
//  Created by Giovanni Castiglioni on 16/01/16.
//  Copyright © 2016 Accenture. All rights reserved.
//

#import "MRPageObject.h"

@implementation MRPageObject

+(instancetype)pageObjectWithStoryboard:(NSString *)st andController:(NSString *)cid
{
    MRPageObject* p = [[self alloc] init];
    p.StoriboardRef = st;
    p.controllerID = cid;
    return p;
}

@end
