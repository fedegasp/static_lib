//
//  UINavigationItem+outletCollection.h
//  ionix-lib
//
//  Created by Federico Gasperini on 14/10/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (outletCollection)

@property (readwrite) IBOutletCollection(UIBarButtonItem) NSArray* rightBarButtonItems;
@property (readwrite) IBOutletCollection(UIBarButtonItem) NSArray* leftBarButtonItems;

@end
