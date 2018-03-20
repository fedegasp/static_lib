//
//  IKObjectManager.h
//  iconick-lib
//
//  Created by Federico Gasperini on 29/05/15.
//  Copyright (c) 2015 accenture. All rights reserved.
//

#import "RestKit.h"

@class IKObjectManager;

@protocol IKObjectManagerDelegate <NSObject>

-(void)urlRequestWillStart:(NSMutableURLRequest*)request;

@end

@interface IKObjectManager : RKObjectManager

@property (weak) id<IKObjectManagerDelegate> mObjectManagerDelegate;

+(IKObjectManager*)managerForUrl:(NSString*)baseUrl
                      withMethod:(NSString*)method
                  acceptMimeType:(NSString*)accept
        andSerializationMimeType:(NSString*)serial
                            name:(NSString*)name
                     suspendable:(BOOL)suspendable;
+(IKObjectManager*)managerForUrl:(NSString*)baseUrl
              withAcceptMimeType:(NSString*)accept
        andSerializationMimeType:(NSString*)serial
                            name:(NSString*)name
                     suspendable:(BOOL)suspendable;
+(IKObjectManager*)managerForUrl:(NSString*)baseUrl andName:(NSString*)name;

@property (assign) BOOL suspendable;

+(void)unsuspendAll;
+(void)suspendAll;

@end

