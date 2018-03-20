//
//  WSRequest.h
//  MRWebServer
//
//  Created by Federico Gasperini on 15/11/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WebServer;

@interface WSRequest : NSObject

@property (readonly, nonatomic, nonnull) NSString* httpMethod;
@property (readonly, nonatomic, nonnull) NSString* uri;
@property (readonly, nonatomic, nonnull) NSString* httpVersion;
@property (readonly, nonatomic, nonnull) NSString* queryString;
@property (readonly, nonatomic, nonnull) NSData*   body;

@property (readonly, nonatomic, nonnull) WebServer* webServer;

@property (readonly, nonnull) NSDictionary* headers;

@property (readonly, nonatomic) BOOL isPost;
@property (readonly, nonatomic) BOOL isGet;

-(void)sendData:(NSData* _Nonnull)data withHeaders:(NSDictionary* _Nullable)headers;

-(int)beginRequest;
-(void)endRequestWithStatus:(NSInteger)status;
-(int)httpErrorWithStatus:(NSInteger)status;

@end

