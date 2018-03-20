//
//  UIViewController+Handler.m
//
//  Created by Gai, Fabio on 04/08/15.
//  Copyright (c) 2015 fabio. All rights reserved.
//

#import "UIViewController+Handler.h"

@implementation UIViewController (Handler)

-(IBAction)goToNotifications:(id)sender
{
   [self goToNotifications];
}

-(void)goToNotifications
{
   [self executeMenuAction:@"@Notifications"];
}


#pragma mark - Properties

-(UINavigationController *)nav{
   return self.navigationController;
}

-(IBAction)popRootAnimated:(id)sender{
   [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)popRoot:(id)sender{
   [self.navigationController popToRootViewControllerAnimated:NO];
}

-(IBAction)popAnimated:(id)sender{
   [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)pop:(id)sender{
   [self.navigationController popViewControllerAnimated:NO];
}

-(IBAction)dismissAnimated:(id)sender{
   [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)dismiss:(id)sender{
   [self dismissViewControllerAnimated:NO completion:nil];
}

-(BOOL)isValid{
   return YES;
}

-(UIViewController*)executeMenuAction:(NSString *)menuAction
                         withPostData:(id)postData
{
   return [self executeMenuAction:menuAction
           onNavigationController:[self nav]
                    withModelData:nil
                      andPostData:postData];
}

-(UIViewController*)executeMenuAction:(NSString *)menuAction
                        withModelData:(id)modelData
{
   return [self executeMenuAction:menuAction
           onNavigationController:[self nav]
                    withModelData:modelData
                      andPostData:nil];
}

-(UIViewController*)executeMenuAction:(NSString *)menuAction
                        withModelData:(id)modelData andPostData:(id)postData
{
   return [self executeMenuAction:menuAction
           onNavigationController:[self nav]
                    withModelData:modelData
                      andPostData:postData];
}

-(UIViewController*)executeMenuAction:(NSString *)menuAction
{
   return [self executeMenuAction:menuAction
           onNavigationController:[self nav]
                    withModelData:nil
                      andPostData:nil];
}

-(UIViewController*)executeMenuAction:(NSString *)menuAction
               onNavigationController:(UINavigationController *)navigationController
                        withModelData:(id)modelData
                          andPostData:(id)postData
{
   UIViewController* retVal = nil;
   NSUInteger atLoc = [menuAction rangeOfString:@"@"].location;
   NSString* storyboardName = menuAction;
   NSString* controllerId = nil;
   if (atLoc != NSNotFound)
   {
      controllerId = [menuAction substringToIndex:atLoc];
      storyboardName = [menuAction substringFromIndex:atLoc + 1];
   }
   if (storyboardName.length)
   {
      @try
      {
         UIStoryboard* storyboard = [UIStoryboard storyboardWithName:storyboardName
                                                              bundle:nil];
         UIViewController* controller = nil;
         if (controllerId && ![controllerId isEqualToString:@""]){
            controller = [storyboard instantiateViewControllerWithIdentifier:controllerId];
         }else{
            controller = [storyboard instantiateInitialViewController];
         }
         controller.postData = postData;
         
         UIViewController* controller2 = nil;
         controller2 = [self controllerInStack:controller fromNavigationController:navigationController];
         if (controller2 && (controller2 == controller))
         {
            retVal = controller2;
            [navigationController popToViewController:controller2 animated:YES];
         }
         else if (controller)
         {
            retVal = controller;
            [navigationController pushViewController:controller animated:YES];
         }
      }
      @catch (NSException *exception)
      {
         NSLog(@"Error %@", [exception description]);
      }
      @finally
      {
         return retVal;
      }
   }
   return nil;
}


-(UIViewController*)controllerInStack:(UIViewController*)controller fromNavigationController:(UINavigationController *)navigationController
{
   for (UIViewController* v in navigationController.viewControllers)
      if (v.class == controller.class)
         return v;
   return nil;
}

-(void)alert:(NSString *)title
     message:(NSString*)message
     success:(NSString*)success
successHandler:(void (^ __nullable)(UIAlertAction *action))successHandler
      cancel:(nullable NSString*)cancel
cancelHandler:(void (^ __nullable)( UIAlertAction  * _Nullable action))cancelHandler{
   
   UIAlertController * alert = [UIAlertController
                                alertControllerWithTitle:title
                                message:message
                                preferredStyle:UIAlertControllerStyleAlert];
   
   
   if (success) {
      UIAlertAction* yesButton = [UIAlertAction
                                  actionWithTitle:success
                                  style:UIAlertActionStyleDefault
                                  handler:successHandler];
      [alert addAction:yesButton];
   }
   
   if (cancel) {
      UIAlertAction* noButton = [UIAlertAction
                                 actionWithTitle:cancel
                                 style:UIAlertActionStyleDestructive
                                 handler:cancelHandler];
      [alert addAction:noButton];
   }
   
   [self presentViewController:alert animated:YES completion:nil];
}

-(void)success:(NSString *_Nullable)t m:(NSString *_Nullable)m{
   
}

-(void)error:(NSString *_Nullable)t m:(NSString *_Nullable)m{
   
}

-(void)serverError{
}

-(void)iphone4Handle:(void (^)(void))iphone4Completion else:(void (^)(BOOL iPhone5,BOOL iPhone6,BOOL iPhone6Plus,BOOL iPad))notIphone4Completion{
    if (IS_IPHONE_4_OR_LESS) {
        if (iphone4Completion) {
            iphone4Completion();
        }
    }else{
        if (notIphone4Completion) {
            notIphone4Completion(IS_IPHONE_5,IS_IPHONE_6,IS_IPHONE_6P,IS_IPAD);
        }
    }
}

@end
