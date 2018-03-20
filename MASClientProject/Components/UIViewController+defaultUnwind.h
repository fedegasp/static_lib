//
//  UIViewController+defaultUnwind.h
//  MASClient
//
//  Created by Federico Gasperini on 04/11/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import <UIKit/UIKit.h>

void GoLandscape();
void GoPortrait();

@interface UIViewController (defaultUnwind)

-(IBAction)defaultUnwind:(UIStoryboardSegue*)sender;

@end
