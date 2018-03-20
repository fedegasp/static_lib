//
//  UITableView+backgroundImageview.m
//  ikframework
//
//  Created by Federico Gasperini on 09/01/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import "UITableView+backgroundImageview.h"

@implementation UITableView (backgroundImageview)

@dynamic backgroundView;

-(void)reloadDatawithCompletion:(void (^)(BOOL finished))completion
{
   [UIView animateWithDuration:.0 animations:^{
      [self reloadData];
   } completion:completion];
}

@end
