//
//  RememberMeButton.m
//  MASClient
//
//  Created by Gai, Fabio on 14/12/16.
//  Copyright © 2016 Accenture - MAS. All rights reserved.
//

#import "RememberMeButton.h"
#import "MKeychainHelper.h"

@implementation RememberMeButton


-(BOOL)shouldRemember{
    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
    BOOL shouldRemember = [us boolForKey:REMEMBER_ME_KEY];
    return shouldRemember;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self addTarget:self action:@selector(setRememberMe) forControlEvents:UIControlEventTouchUpInside];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self setIcon:[self shouldRemember]];
}

-(void)setRememberMe{
    BOOL rm = ![self shouldRemember];
    [self setIcon:rm];
    [[NSUserDefaults standardUserDefaults] setBool:rm forKey:REMEMBER_ME_KEY];
}

-(void)setIcon:(BOOL)remember{
    if (remember) {
        self.checkIcon.image = [UIImage imageNamed:@"check"];
    }else{
        self.checkIcon.image = [UIImage imageNamed:@"uncheck"];
    }
}

-(void)rememberUsername:(NSString *)username password:(NSString *)password {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [MKeychainHelper removeSavedCredentials];
        NSDictionary *account = @{kAccountUsernameKey:username,
                                  kAccountPasswordKey:password};
        NSData *serializedAccount = [NSKeyedArchiver archivedDataWithRootObject:account];
        NSError *error = nil;
        OSStatus addStatus = [MKeychainHelper addItemAsyncWithData:serializedAccount error:&error];
        if (addStatus != errSecSuccess) {
            NSLog(@"not saved");
        } else {
            NSLog(@"saved");
        }
    });
}

-(void)rememberMeRetrieveWithcompletionBlock:(void (^ __nullable)(BOOL finished))completion{
    
    WEAK_REF(self);
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [MKeychainHelper getSavedCredentialsWithPrompt:NSLocalizedString(@"TOUCH_ID_AUTH_GET_PASSWORD", nil)
                                       completionBlock:^(NSData *serializedAccount, OSStatus status, BOOL usedTouchId) {
                                           
                                           switch (status) {
                                               case errSecSuccess:
                                               {
                                                   NSDictionary *account = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:serializedAccount];
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       _self.username.text = account[kAccountUsernameKey];
                                                       if (usedTouchId == YES) {
                                                           _self.password.text = account[kAccountPasswordKey];
                                                       }
                                                       completion(YES);
                                                   });
                                               }
                                                   break;
                                               default:
                                                   completion(NO);
                                                   break;
                                           }
                                       }];
        
    });
}

-(void)rememberMeClean {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [MKeychainHelper removeSavedCredentials];
        NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
        [us removeObjectForKey:REMEMBER_ME_KEY];
    });
}


@end
