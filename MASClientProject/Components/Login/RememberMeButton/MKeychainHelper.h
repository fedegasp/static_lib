//
//  MKeychainHelper.h
//  Mobily
//
//  Created by Enrico Luciano on 29/04/15.
//
//

#import <Foundation/Foundation.h>

static NSString *kAccountUsernameKey = @"kAccountUsernameKey";
static NSString *kAccountPasswordKey = @"kAccountPasswordKey";

typedef void (^MKeychainHelperCompletionBlock)(NSData *serializedData, OSStatus status, BOOL usedTouchId);

@interface MKeychainHelper : NSObject

// not to be called on main thread
+(void)getSavedCredentialsWithPrompt:(NSString *)prompt completionBlock:(MKeychainHelperCompletionBlock)completion;
+(NSData *)getSavedCredentialsWithPrompt:(NSString *)prompt returnStatus:(OSStatus *)returnOSStatus;

+(OSStatus)updateSavedCredentialsWithData:(NSData*)updatedData prompt:(NSString *)prompt;
+ (OSStatus)addItemAsyncWithData:(NSData*)credentialsData error:(NSError **)error;
+(OSStatus)removeSavedCredentials;

@end
