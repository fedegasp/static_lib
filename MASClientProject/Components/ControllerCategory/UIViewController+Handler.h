//
//  UIViewController+Handler.h
//
//  Created by Gai, Fabio on 04/08/15.
//  Copyright (c) 2015 fabio. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UIViewController+Properties.h"

typedef enum : NSInteger{
    typeOfTransition_PUSH = 0,
    typeOfTransition_PRESENT = 1,
} TypeOfTransition;

@interface UIViewController (Handler)
//@property (nonatomic, strong) MEZoomAnimationController *zoomAnimationController;

//@property TypeOfTransition typeOfTransition;

-(IBAction)dismissAnimated:(_Nullable id)sender;
-(IBAction)dismiss:(_Nullable id)sender;
-(IBAction)popRootAnimated:(_Nullable id)sender;
-(IBAction)popRoot:(_Nullable id)sender;
-(IBAction)popAnimated:(_Nullable id)sender;
-(IBAction)pop:(_Nullable id)sender;

//-(IBAction)menuButtonTapped:(_Nullable id)sender;
//-(IBAction)topMenuButtonTapped:(_Nullable id)sender;

//-(IBAction)closeKeyboard:(_Nullable id)sender;

-(UIViewController* _Nullable)executeMenuAction:(NSString * _Nullable )menuAction withPostData:(_Nullable id)postData;
-(UIViewController* _Nullable)executeMenuAction:(NSString *_Nullable)menuAction withModelData:(_Nullable id)modelData;
-(UIViewController* _Nullable)executeMenuAction:(NSString *_Nullable)menuAction withModelData:(_Nullable id)modelData andPostData:(_Nullable id)postData;
-(UIViewController* _Nullable)executeMenuAction:(NSString *_Nullable)menuAction;
-(UIViewController* _Nullable)executeMenuAction:(NSString *_Nullable)menuAction onNavigationController:(UINavigationController *_Nullable)navigationController withModelData:(_Nullable id)modelData andPostData:(_Nullable id)postData;

-(void)alert:(NSString *_Nullable)title
     message:(NSString*_Nullable)message
     success:(NSString*_Nullable)success
successHandler:(void (^ __nullable)(UIAlertAction *_Nullable action))successHandler
      cancel:(nullable NSString*)cancel
cancelHandler:(void (^ __nullable)( UIAlertAction  * _Nullable action))cancelHandler;
-(void)success:(NSString *_Nullable)t m:(NSString *_Nullable)m;
-(void)error:(NSString *_Nullable)t m:(NSString *_Nullable)m;
-(void)serverError;

-(IBAction)goToNotifications:(_Nullable id)sender;
-(void)goToNotifications;
//-(void)iphone4Handle:(void (^)(void))iphone4Completion else:(void (^)(BOOL iPhone5,BOOL iPhone6,BOOL iPhone6Plus,BOOL iPad)) notIphone4Completion;
@end
