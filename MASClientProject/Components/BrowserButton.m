//
//  BrowserButton.m
//  MASClient
//
//  Created by Gai, Fabio on 13/12/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import "BrowserButton.h"

@implementation BrowserButton

-(void)awakeFromNib{
    [super awakeFromNib];
    if (self.url != nil)
        [self addTarget:self action:@selector(openBrowser) forControlEvents:UIControlEventTouchUpInside];
}

-(void)openBrowser{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.url]];
}

@end
