//
//  main.m
//  MASClient
//
//  Created by Federico Gasperini on 26/10/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <stdarg.h>
#import <stdio.h>

static int stderrSave;
void myHandler(NSException * exception)
{
   NSLog(@"%@\n\n\n============================\n\n",[exception description]);
   fflush(stderr);
   
   dup2(stderrSave, STDERR_FILENO);
   close(stderrSave);
}

#undef LOG_ON_CONSOLE
#define LOG_ON_CONSOLE YES

int main(int argc, char * argv[])
{
   @autoreleasepool
   {
#if (DISTRIBUTION==0)
      [NSUserDefaults registerDefaultsFromSettingsBundle];
      
      BOOL logOnConsole = LOG_ON_CONSOLE;
      
      if (!logOnConsole)
      {
         
         NSSetUncaughtExceptionHandler(&myHandler);
         
         stderrSave = dup(STDERR_FILENO);
         
         NSString *logPath = [DocumentsDirectory() stringByAppendingPathComponent:@"console.log"];
         [[NSFileManager defaultManager] removeItemAtPath:logPath
                                                    error:NULL];
         freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding],"a",stderr);
         
         int retVal = 1;
         @try
         {
            retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
         }
         @catch (NSException *exception)
         {
            myHandler(exception);
         }
         @finally
         {
            return retVal;
         }
      }
#else
      [NSUserDefaults registerDefaultsFromSettingsBundle];
#endif
      
      return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
   }
}

@interface NSDate (a)

@end

@implementation NSDate (a)

-(id)prenotationDate
{
   return nil;
}

@end
