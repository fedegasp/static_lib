//
//  AppDelegate.h
//  MASClient
//
//  Created by Federico Gasperini on 26/10/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly) NSOperationQueue* notificationQueue;

@end

