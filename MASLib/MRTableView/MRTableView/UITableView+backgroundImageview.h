//
//  UITableView+backgroundImageview.h
//  ikframework
//
//  Created by Federico Gasperini on 09/01/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (backgroundImageview)

@property (readwrite) IBOutlet UIView* backgroundView;
-(void)reloadDatawithCompletion:(void (^)(BOOL finished))completion;

@end
