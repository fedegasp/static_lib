//
//  RememberMeButton.h
//  MASClient
//
//  Created by Gai, Fabio on 14/12/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import <UIKit/UIKit.h>
#define REMEMBER_ME_KEY @"REMEMBER_ME_KEY"

@interface RememberMeButton : UIButton

@property (weak, nonatomic, nullable) IBOutlet UITextField *username;
@property (weak, nonatomic, nullable) IBOutlet UITextField *password;
@property (weak, nonatomic, nullable) IBOutlet UIImageView *checkIcon;
-(void)setRememberMe;
-(void)rememberUsername:(NSString * _Nullable)username
               password:(NSString * _Nullable)password;
-(void)rememberMeRetrieveWithcompletionBlock:(void (^ __nullable)(BOOL finished))completion;
-(void)rememberMeClean;

@end
