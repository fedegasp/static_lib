//
//  UIViewController+visibilityNotification.h
//  MRGraphics
//
//  Created by Federico Gasperini on 18/10/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSNotificationName UIViewControllerWillAppear;
extern NSNotificationName UIViewControllerDidAppear;
extern NSNotificationName UIViewControllerWillDisappear;
extern NSNotificationName UIViewControllerDidDisappear;

@interface UIViewController (visibilityNotification)

@property (nonatomic, assign) IBInspectable BOOL lightStatusBar;

@property (nonatomic, readonly) BOOL viewWillAppearPassed;

-(void)popAnimated:(BOOL)animated;
-(void)hideKeyboard;
-(IBAction)closeKeyboard:(id)sender;

@end
