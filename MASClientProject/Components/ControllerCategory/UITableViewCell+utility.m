//
//  UITableViewCell+utility.m
//  Giruland
//
//  Created by Gai, Fabio on 02/09/16.
//  Copyright © 2016 Gai, Fabio. All rights reserved.
//

#import "UITableViewCell+utility.h"

@implementation UITableViewCell (utility)
-(CGFloat)weight
{
    NSNumber* n = objc_getAssociatedObject(self, @selector(weight));
    return n ? [n floatValue] : 1.0f;
}

-(void)setWeight:(CGFloat)weight
{
    objc_setAssociatedObject(self, @selector(weight), @(weight), OBJC_ASSOCIATION_RETAIN);
}

-(BOOL)fixSingleHeight
{
    NSNumber* n = objc_getAssociatedObject(self, @selector(fixSingleHeight));
    return n ? [n floatValue] : 1.0f;
}

-(void)setFixSingleHeight:(BOOL)fixSingleHeight
{
    objc_setAssociatedObject(self, @selector(fixSingleHeight), @(fixSingleHeight), OBJC_ASSOCIATION_RETAIN);
}
@end
