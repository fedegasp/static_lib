//
//  MKeychainHelper.m
//  Mobily
//
//  Created by Enrico Luciano on 29/04/15.
//
//

#import "MKeychainHelper.h"
#import "UIDevice+Hardware.h"

@import Security;

static NSString *kMobileAppAttributeCredentials = @"kDPRAttributeCredentials";

@implementation MKeychainHelper

+(void)getSavedCredentialsWithPrompt:(NSString *)prompt completionBlock:(MKeychainHelperCompletionBlock)completion {
   
   BOOL is_iOS_8 = NO;
   
   if (&SecAccessControlCreateWithFlags) {
      is_iOS_8 = YES;
   }
   
   NSDictionary *query ;
   BOOL usedTouchId = NO;
   
   if ( (is_iOS_8 == NO) || ([[UIDevice  getDeviceHardware] isEqualToString:@"Simulator"])) {
      query = @{
                (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                (__bridge id)kSecAttrService: kMobileAppAttributeCredentials,
                (__bridge id)kSecReturnData: @YES
                };
      
      usedTouchId = NO;
   } else {
      query = @{
                (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                (__bridge id)kSecAttrService: kMobileAppAttributeCredentials,
                (__bridge id)kSecReturnData: @YES,
                (__bridge id)kSecUseOperationPrompt:prompt
                };
      
      usedTouchId = YES;
   }
   
   CFTypeRef dataTypeRef = NULL;
   
   NSData *returnData = nil;
   
   OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)(query), &dataTypeRef);
   
   if (status == errSecSuccess)
   {
      returnData = ( __bridge_transfer NSData *)dataTypeRef;
   }
   
   if (nil!=completion) {
      completion(returnData, status, usedTouchId);
   }
}

+(NSData *)getSavedCredentialsWithPrompt:(NSString *)prompt returnStatus:(OSStatus *)returnOSStatus {
   
   __block NSData *returnData = nil;
   __block OSStatus tempStatus;
   
   dispatch_semaphore_t sem = dispatch_semaphore_create(0);
   
   [MKeychainHelper getSavedCredentialsWithPrompt:prompt
                                  completionBlock:^(NSData *serializedAccount, OSStatus status, BOOL usedTouchId) {
                                     
                                     tempStatus = status;
                                     returnData = serializedAccount;
                                     
                                     dispatch_semaphore_signal(sem);
                                  }];
   
   dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
   
   *returnOSStatus = tempStatus;
   return returnData;
   
}

// This is the old version that does not call the completion block version
/*
+(NSData *)getSavedCredentialsWithPrompt:(NSString *)prompt returnStatus:(OSStatus *)returnOSStatus {
   
   BOOL is_iOS_8 = NO;
   
   if (SecAccessControlCreateWithFlags) {
      is_iOS_8 = YES;
   }
   
   NSDictionary *query ;
   
   if ( (is_iOS_8 == NO) || ([[UIDevice  getDeviceHardware] isEqualToString:@"Simulator"])) {
      query = @{
                (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                (__bridge id)kSecAttrService: kMobilyAttributeCredentials,
                (__bridge id)kSecReturnData: @YES
                };
   } else {
      query = @{
                (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                (__bridge id)kSecAttrService: kMobilyAttributeCredentials,
                (__bridge id)kSecReturnData: @YES,
                (__bridge id)kSecUseOperationPrompt:prompt
                };
   }

    CFTypeRef dataTypeRef = NULL;
   
    NSData *returnData = nil;
   
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)(query), &dataTypeRef);
    
    if (status == errSecSuccess)
    {
        returnData = ( __bridge_transfer NSData *)dataTypeRef;
    }
    
    *returnOSStatus = status;
    return returnData;
}
*/
+(OSStatus)updateSavedCredentialsWithData:(NSData*)updatedData prompt:(NSString *)prompt
{
    NSDictionary *query = @{
                            (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService: kMobileAppAttributeCredentials,
                            (__bridge id)kSecUseOperationPrompt: prompt
                            };
    
    NSDictionary *changes = @{
                              (__bridge id)kSecValueData: updatedData
                              };
    
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)changes);
    return status;
}

+ (OSStatus)addItemAsyncWithData:(NSData*)credentialsData error:(NSError **)error
{
   
   SecAccessControlRef sacObject = NULL;
   BOOL is_iOS_8 = NO;
   
   if (![[UIDevice  getDeviceHardware] isEqualToString:@"Simulator"]) {
      
      CFErrorRef cferror = NULL;
      
      if (&SecAccessControlCreateWithFlags) {
         sacObject = SecAccessControlCreateWithFlags(kCFAllocatorDefault,
                                                     kSecAttrAccessibleWhenUnlocked,
                                                     kSecAccessControlUserPresence, &cferror);
         
         is_iOS_8 = YES;
      }
      
      if (error)
      {
         if(cferror != NULL)
         {
            *error = (__bridge NSError *)cferror;
            return errSecParam;
         }
         
         if((is_iOS_8 == YES) && (sacObject == NULL ))
         {
            
            NSError *returnError = [NSError errorWithDomain:@"Mobily Domain" code:100 userInfo:nil];
            
            *error = returnError;
            return errSecParam;
         }
      }
   }
   
   NSDictionary *attributes = nil;
   
   if ((is_iOS_8 == NO) || ([[UIDevice  getDeviceHardware] isEqualToString:@"Simulator"])) {
      attributes = @{
                                   (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                                   (__bridge id)kSecAttrService: kMobileAppAttributeCredentials,
                                   (__bridge id)kSecValueData: credentialsData
                                   };
   } else {
      attributes = @{
                                   (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                                   (__bridge id)kSecAttrService: kMobileAppAttributeCredentials,
                                   (__bridge id)kSecValueData: credentialsData,
                                   //(__bridge id)kSecUseNoAuthenticationUI: @YES,
                                   (__bridge id)kSecAttrAccessControl: (__bridge_transfer id)sacObject
                                   };
   }
    
    OSStatus status =  SecItemAdd((__bridge CFDictionaryRef)attributes, nil);
    if (status == errSecSuccess)
    {
        NSLog(@"");
    }
    return status;
}

+(OSStatus)removeSavedCredentials
{
    NSDictionary *query = @{
                            (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrService: kMobileAppAttributeCredentials
                            };
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)(query));
    
    return status;
}

- (NSString *)keychainErrorToString: (OSStatus)error
{
    
    NSString *msg = [NSString stringWithFormat:@"%ld",(long)error];
    
    switch (error) {
        case errSecSuccess:
            msg = NSLocalizedString(@"SUCCESS", nil);
            break;
        case errSecDuplicateItem:
            msg = NSLocalizedString(@"ERROR_ITEM_ALREADY_EXISTS", nil);
            break;
        case errSecItemNotFound :
            msg = NSLocalizedString(@"ERROR_ITEM_NOT_FOUND", nil);
            break;
        case errSecAuthFailed:
            msg = NSLocalizedString(@"ERROR_ITEM_AUTHENTICATION_FAILED", nil);
            break;
        case errSecInteractionNotAllowed:
            msg = NSLocalizedString(@"ERROR_SECURITY_INTERACTION_NOT_ALLOWED", nil);
            break;
        default:
            break;
    }
    
    return msg;
}


@end
