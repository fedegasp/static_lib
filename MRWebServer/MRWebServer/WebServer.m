//
//  WebServer.m
//  TelcoApp
//
//  Created by Federico Gasperini on 03/02/14.
//  Copyright (c) 2014 accenture. All rights reserved.
//

#import "mongoose.h"
#import "WebServer.h"
#import <objc/message.h>
#import <UIKit/UIKit.h>
#import "WSRequest.h"

NSString* WebServerDidStop = @"WebServerDidStop";
NSString* WebServerDidStart = @"WebServerDidStart";

NSString* kWSAccessControlList = @"access_control_list";
NSString* kWSExtraMimeTypes = @"extra_mime_types";
NSString* kWSListeningPorts = @"listening_ports";
NSString* kWSDocumentRoot = @"document_root";
NSString* kWSNumOfThreads = @"num_threads";
NSString* kWSUrlRewritePatterns = @"url_rewrite_patterns";
NSString* kWSHideFilesPatterns = @"hide_files_patterns";
NSString* kWSRequestTimeout = @"request_timeout_ms";

const NSInteger NUM_OF_OPTIONS = 8;
#define OPTIONS_LENGTH (NUM_OF_OPTIONS * 2 + 1)
#define OPT_NAME_IDX(X) (X * 2)
#define OPT_VALUE_IDX(X) (X * 2 + 1)

@interface WebServer ()

@property (strong, atomic) NSThread* workerThread;
static int begin_request(const struct mg_connection *connection);
static void end_request(const struct mg_connection *connection, int status);
static int http_error(const struct mg_connection * connection, int status);

@end


@implementation WebServer
{
    struct mg_context *ctx;
    struct mg_callbacks callbacks;
    // List of options. Last element must be NULL
    const char* options[OPTIONS_LENGTH];
}

#pragma mark - WebServer lifecycle

-(instancetype) init
{
   self = [super init];
   if (self)
   {
      memset(&callbacks, 0, sizeof(callbacks));
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(startServer)
                                                   name:UIApplicationDidBecomeActiveNotification
                                                 object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(stopServer)
                                                   name:UIApplicationDidEnterBackgroundNotification
                                                 object:nil];
   }
   return self;
}

-(void)startServer
{
   if (!self.workerThread)
   {
      self.configuration = _configuration;
      self.workerThread = [[NSThread alloc] initWithTarget:self
                                                  selector:@selector(startServerThread)
                                                    object:nil];
      [self.workerThread start];
      [NSThread sleepForTimeInterval:.5];
   }
}

-(void)setBeginRequest:(BeginRequestBlock)beginRequest
{
    _beginRequest = beginRequest;
    if (beginRequest)
        callbacks.begin_request = begin_request;
    else
        callbacks.begin_request = NULL;
}

-(void)setEndRequest:(EndRequestBlock)endRequest
{
    _endRequest = endRequest;
    if (endRequest)
        callbacks.end_request = end_request;
    else
        callbacks.end_request = NULL;
}

-(void)setError:(ErrorBlock)error
{
    _error = error;
    if (error)
        callbacks.http_error = http_error;
    else
        callbacks.http_error = NULL;
}

-(void)startServerThread
{
   @autoreleasepool
   {
      // Start the web server.
      callbacks.begin_request = begin_request;
      ctx = mg_start(&callbacks, (__bridge void *)(self), options);
      
      dispatch_async(dispatch_get_main_queue(),
                     ^{
                        [[NSNotificationCenter defaultCenter]
                         postNotificationName:WebServerDidStart
                         object:self];
                     });
      
      while (![NSThread currentThread].isCancelled)
         [NSThread sleepForTimeInterval:.1];
      
      // Stop the server.
      mg_stop(ctx);
      dispatch_async(dispatch_get_main_queue(),
                     ^{
                        [[NSNotificationCenter defaultCenter]
                         postNotificationName:WebServerDidStop
                         object:self];
                     });
   }
}

-(void)setConfiguration:(NSDictionary<NSString *,NSString *> *)configuration
{
    _configuration = configuration;
    
    _documentRoot = [self.configuration[kWSDocumentRoot] copy];
    _documentRoot = [_documentRoot stringByStandardizingPath];
    _documentRoot = [_documentRoot stringByReplacingOccurrencesOfString:@"file:"
                                                             withString:@""
                                                                options:0
                                                                  range:NSMakeRange(0, MIN(5, _documentRoot.length))];
    if (![_documentRoot hasPrefix:@"/"])
        _documentRoot = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:_documentRoot];

    for (NSInteger i = 0; i < OPTIONS_LENGTH; i++)
        options[i] = NULL;
    
    NSInteger idx = 0;
    for (NSString* opt in self.configuration.keyEnumerator)
    {
        if (idx >= NUM_OF_OPTIONS)
            break;
        
        options[OPT_NAME_IDX(idx)] = opt.UTF8String;
        if ([opt isEqualToString:kWSDocumentRoot])
            options[OPT_VALUE_IDX(idx)] = _documentRoot.UTF8String;
        else
            options[OPT_VALUE_IDX(idx)] = self.configuration[opt].UTF8String;
        
        idx ++;
    }
}

-(void)stopServer
{
   [self.workerThread cancel];
   self.workerThread = nil;
}

-(void)dealloc
{
   [[NSNotificationCenter defaultCenter] removeObserver:self];
   [self stopServer];
}

@end


@interface WSRequest ()

-(instancetype __nonnull)initWithConnection:(const struct mg_connection * __nonnull)connection;

@end


static int begin_request(const struct mg_connection *connection)
{
    @autoreleasepool{
        WSRequest* c = [[WSRequest alloc] initWithConnection:connection];
        return [c beginRequest];
    }
}

static void end_request(const struct mg_connection *connection, int status)
{
    @autoreleasepool{
        WSRequest* c = [[WSRequest alloc] initWithConnection:connection];
        [c endRequestWithStatus:status];
    }
}

static int http_error(const struct mg_connection * connection, int status)
{
    @autoreleasepool{
        WSRequest* c = [[WSRequest alloc] initWithConnection:connection];
        return [c httpErrorWithStatus:status];
    }
}
