//
//  UIViewControllerLifeCycleLogger.m
//  MRGraphics
//
//  Created by Federico Gasperini on 18/10/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "UIViewControllerLifeCycleLogger.h"
#import "UIViewController+visibilityNotification.h"

#if (HUGE_LOG)

@implementation UIViewControllerLifeCycleLogger

+(void)load
{
    static UIViewControllerLifeCycleLogger* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UIViewControllerLifeCycleLogger alloc] init];
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:instance
                                             selector:@selector(log:)
                                                 name:UIViewControllerWillAppear
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:instance
                                             selector:@selector(log:)
                                                 name:UIViewControllerDidAppear
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:instance
                                             selector:@selector(log:)
                                                 name:UIViewControllerWillDisappear
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:instance
                                             selector:@selector(log:)
                                                 name:UIViewControllerDidDisappear
                                               object:nil];
}

-(void)log:(NSNotification*)n
{
    NSLog(@"ControllerLifeCycle -- %@",
          [NSString stringWithFormat:n.name,n.object]);
}

@end

#endif

