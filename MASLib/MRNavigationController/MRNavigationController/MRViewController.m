//
//
//  Created by fabio on 01/08/15.
//  Copyright (c) 2015 fabio. All rights reserved.
//

#import "MRViewController.h"
#import <objc/runtime.h>
#import "MRNavigationViewController.h"

@interface MRViewController ()

@end


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-property-synthesis"
#pragma clang diagnostic ignored "-Wprotocol"

@implementation MRViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (!self.disableHideKeyboardOnTap)
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


@end

#pragma clang diagnostic pop
