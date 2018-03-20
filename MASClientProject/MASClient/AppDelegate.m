//
//  AppDelegate.m
//  MASClient
//
//  Created by Federico Gasperini on 26/10/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import "AppDelegate.h"
//#import "UIViewController+remoteNotificationHandling.h"
#import <notify.h>

#undef SUPPRESS_LOG
#define SUPPRESS_LOG 1

#if !SUPPRESS_LOG
#import "AFNetworkActivityLogger.h"
#import "AFNetworkActivityConsoleLogger.h"
#endif

@interface AppDelegate ()

@property (nonatomic, strong) WebServer* localServer;
@property (nonatomic, strong)NSString* trackingId;

@property UIBackgroundTaskIdentifier backgroundTaskIdentifier;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
   [UIResponder setActivityIndicatorNibName:@"IKActivity"];
   
   _notificationQueue = [[NSOperationQueue alloc] init];
   _notificationQueue.suspended = YES;
   
#if !SUPPRESS_LOG
   AFNetworkActivityConsoleLogger *logger = [AFNetworkActivityLogger sharedLogger].loggers.anyObject;
   logger.level = AFLoggerLevelDebug;
   [[AFNetworkActivityLogger sharedLogger] startLogging];
#endif
   
   if (![IKEnvironment loadAppConf])
      @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                     reason:@"Invalid conf in Info.plist"
                                   userInfo:nil];

   [IKObjectManager unsuspendAll];
   
#ifndef NO_INTERNAL_SERVER
    self.localServer = [[StubServer alloc] init];
    self.localServer.configuration = @{kWSDocumentRoot: @"stub_root",
                                       kWSListeningPorts: @"8899",
                                       kWSAccessControlList: @"+127.0.0.1"};
    [self.localServer startServer];
#endif
   
   [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
   [[UINavigationBar appearance] setShadowImage:[UIImage new]];
   [[UINavigationBar appearance] setTitleTextAttributes:@{
      NSForegroundColorAttributeName:[UIColor whiteColor],
      NSFontAttributeName:[UIFont fontWithName:@"Source Sans Pro" size:16]
      }];
   [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back-btn"]];
   [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"back-btn"]];
   //[[UINavigationBar appearance] setTintColor:[UIColor colorWithHexString:@"343434"]];
   
   return YES;
}

//-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
//{
//   [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidRegisterForRemoteNotifications
//                                                       object:deviceToken];
//}

//-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//{
//   COPY_BLOCK_REF(userInfo);
//   UIApplicationState state = application.applicationState;
//   if (state == UIApplicationStateInactive || state == UIApplicationStateBackground)
//      [_notificationQueue addOperationWithBlock:^{
//         dispatch_async(dispatch_get_main_queue(), ^{
//            [QBManager handleRemoteNotification:_userInfo];
//         });
//      }];
//}

//- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler
//{
//   NSDictionary* userInfo = response.notification.request.content.userInfo;
//   COPY_BLOCK_REF(userInfo);
//   [_notificationQueue addOperationWithBlock:^{
//      dispatch_async(dispatch_get_main_queue(), ^{
//         [QBManager handleRemoteNotification:_userInfo];
//      });
//   }];
//}

- (void)applicationWillResignActive:(UIApplication *)application {
   // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    // OneSignal resets the badge counter when the app becomes active
//    if ([User currentUser]) {
//        [[User currentUser] setBadge:[User currentUser].badge];
//    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   
   // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
   // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
   // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
   // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // OneSignal resets the badge counter when the app becomes active
//    if ([User currentUser]) {
//        [[User currentUser] setBadge:[User currentUser].badge];
//    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
   // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
