//
//  WebServer.h
//  TelcoApp
//
//  Created by Administrator on 03/02/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSNotificationName _Nonnull WebServerDidStop;
extern NSNotificationName _Nonnull WebServerDidStart;

extern NSString* _Nonnull kWSAccessControlList;
extern NSString* _Nonnull kWSExtraMimeTypes;
extern NSString* _Nonnull kWSListeningPorts;
extern NSString* _Nonnull kWSDocumentRoot;
extern NSString* _Nonnull kWSNumOfThreads;
extern NSString* _Nonnull kWSUrlRewritePatterns;
extern NSString* _Nonnull kWSHideFilesPatterns;
extern NSString* _Nonnull kWSRequestTimeout;


@class WSRequest;

typedef int(^BeginRequestBlock)(const WSRequest * _Nonnull);
typedef void(^EndRequestBlock)(const WSRequest * _Nonnull, NSInteger);
typedef int(^ErrorBlock)(const WSRequest * _Nonnull, NSInteger);

@interface WebServer : NSObject

@property (strong, nonatomic, nullable) NSDictionary<NSString*, NSString*>* configuration;

@property (readonly, nonatomic, nonnull) NSString* documentRoot;

@property (copy, nonatomic, nullable) BeginRequestBlock beginRequest;
@property (copy, nonatomic, nullable) EndRequestBlock endRequest;
@property (copy, nonatomic, nullable) ErrorBlock error;

-(void)startServer;
-(void)stopServer;

@end
