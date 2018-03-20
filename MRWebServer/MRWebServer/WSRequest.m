//
//  WSRequest.m
//  MRWebServer
//
//  Created by Federico Gasperini on 15/11/17.
//  Copyright © 2017 Accenture - MAS. All rights reserved.
//

#import "WSRequest.h"
#import "WebServer.h"
#import "mongoose.h"

@implementation WSRequest
{
    struct mg_connection* _connection;
    struct mg_request_info* req_info;
    __weak WebServer* _webServer;
    
    NSString* _httpMethod;
    NSString* _uri;
    NSString* _httpVersion;
    NSString* _queryString;
    NSData*   _body;
}

-(instancetype __nonnull)initWithConnection:(void*)connection
{
    self = [super init];
    if (self)
    {
        _connection = connection;
        req_info = mg_get_request_info((struct mg_connection*)connection);
        _webServer = (__bridge WebServer*)req_info->user_data;
        if (NULL != req_info->request_method)
            _httpMethod =  [NSString stringWithUTF8String:req_info->request_method];
        else
            _httpMethod = @"GET";
        
        if (NULL != req_info->uri)
            _uri = [NSString stringWithUTF8String:req_info->uri];
        else
            _uri = @"";

        if (NULL != req_info->http_version)
            _httpVersion = [NSString stringWithUTF8String:req_info->http_version];
        else
            _httpVersion = @"1.0";
        
        if (NULL != req_info->query_string)
            _queryString = [NSString stringWithUTF8String:req_info->query_string];
        else
            _queryString = @"";


    }
    return self;
}

-(int)beginRequest
{
    if (self.webServer.beginRequest)
        return self.webServer.beginRequest(self);
    return 0;
}

-(void)endRequestWithStatus:(NSInteger)status
{
    if (self.webServer.endRequest)
        self.webServer.endRequest(self, status);
}

-(int)httpErrorWithStatus:(NSInteger)status
{
    if (self.webServer.error)
        return self.webServer.error(self, status);
    return 0;
}

-(NSData*)body
{
    if (!self.isPost)
        return [NSData data];
    if (_body)
        return _body;
    
    size_t size = 512*sizeof(char);
    size_t buff_size = size;
    char* body = malloc(buff_size);
    
    if (NULL == body)
        return [NSData data];
    
    size_t len = 0;
    size_t read = 0;
    char* currPtr = body;
    while ((read = mg_read(_connection, currPtr, size)) == size)
    {
        len += read;
        buff_size += size;
        char *bodyTmp = realloc(body, buff_size);
        if (NULL != bodyTmp)
        {
            body = bodyTmp;
            currPtr = body + len;
        }
        else
        {
            read = 0;
            break;
        }
    }
    len += read;
    
    if (read > 0)
        _body = [NSData dataWithBytes:body length:read];
    else
        _body = [NSData data];
    
    free(body);
    
    return _body;
}

-(WebServer*)webServer
{
    return _webServer;
}

-(NSDictionary*)headers
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    for (NSInteger i = 0; i < req_info->num_headers; i++)
    {
        dict[[NSString stringWithUTF8String:req_info->http_headers[i].name]] =
        [NSString stringWithUTF8String:req_info->http_headers[i].value];
    }
    return dict;
}

-(BOOL)isPost
{
    return [_httpMethod isEqualToString:@"POST"];
}

-(BOOL)isGet
{
    return [_httpMethod isEqualToString:@"GET"];
}

-(void)sendData:(NSData *)data withHeaders:(NSDictionary *)headers
{
    NSMutableString* header = [@"HTTP" mutableCopy];
    [header appendFormat:@"/%@ 200 OK\r\n", self.httpVersion];

    for (NSString* key in headers.keyEnumerator)
        [header appendFormat:@"%@: %@\r\n", key, headers[key]];
    
    [header appendFormat:@"Content-Length: %zu\r\n\r\n", data.length];
    [header appendString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    
    mg_printf(_connection,
              [header UTF8String],
              header.length);
}

@end

