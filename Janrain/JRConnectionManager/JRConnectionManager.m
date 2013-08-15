/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2010, Janrain, Inc.

 All rights reserved.

 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
     list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
     this list of conditions and the following disclaimer in the documentation and/or
     other materials provided with the distribution.
 * Neither the name of the Janrain, Inc. nor the names of its
     contributors may be used to endorse or promote products derived from this
     software without specific prior written permission.


 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 File:	 JRConnectionManager.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:	 Tuesday, June 1, 2010
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


#import "NSMutableURLRequest+JRRequestUtils.h"
#import "JRConnectionManager.h"
#import "debug_log.h"

@implementation NSString (JRString_UrlEscaping)
- (NSString *)stringByAddingUrlPercentEscapes
{

    NSString *encodedString = (NSString *) CFURLCreateStringByAddingPercentEscapes(
            NULL,
            (CFStringRef) self,
            NULL,
            (CFStringRef) @"!*'();:@&=+$,/?%#[]",
            kCFStringEncodingUTF8);

    return [encodedString autorelease];
}
@end

@interface ConnectionData : NSObject
{
    NSURLRequest *_request;
    NSMutableData *_response;
    NSURLResponse *_fullResponse;
    id _tag;

    BOOL _returnFullResponse;

    id <JRConnectionManagerDelegate> _delegate;
}

@property(retain) NSURLRequest *request;
@property(retain) NSMutableData *response;
@property(retain) NSURLResponse *fullResponse;
@property(readonly) id tag;
@property(readonly) BOOL returnFullResponse;
@property(readonly) id <JRConnectionManagerDelegate> delegate;
@end

@implementation ConnectionData
@synthesize request = _request;
@synthesize response = _response;
@synthesize fullResponse = _fullResponse;
@synthesize returnFullResponse = _returnFullResponse;
@synthesize tag = _tag;
@synthesize delegate = _delegate;

- (id)initWithRequest:(NSURLRequest *)request
          forDelegate:(id <JRConnectionManagerDelegate>)delegate
   returnFullResponse:(BOOL)returnFullResponse
              withTag:(id)userdata
{
    //DLog(@"");

    if ((self = [super init]))
    {
        _request = [request retain];
        _tag = [userdata retain];
        _returnFullResponse = returnFullResponse;

        _response = nil;
        _fullResponse = nil;

        _delegate = [delegate retain];
    }

    return self;
}

- (void)dealloc
{
    [_request release];
    [_response release];
    [_fullResponse release];
    [_delegate release];
    [_tag release];

    [super dealloc];
}
@end

@implementation JRConnectionManager
@synthesize connectionBuffers;

static JRConnectionManager *singleton = nil;

- (JRConnectionManager *)init
{
    if ((self = [super init]))
    {
        connectionBuffers = CFDictionaryCreateMutable(kCFAllocatorDefault, 0,
                &kCFTypeDictionaryKeyCallBacks,
                &kCFTypeDictionaryValueCallBacks);
    }

    return self;
}

+ (id)getJRConnectionManager
{
    if (singleton == nil)
    {
        singleton = [((JRConnectionManager *) [super allocWithZone:NULL]) init];
    }

    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self getJRConnectionManager] retain];
}

- (id)copyWithZone:(__unused NSZone *)zone __unused
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (oneway void)release
{
}

- (id)autorelease
{
    return self;
}

+ (NSUInteger)openConnections
{
    JRConnectionManager *connectionManager = [JRConnectionManager getJRConnectionManager];
    return [(NSDictionary *) connectionManager.connectionBuffers count];
}

- (void)startActivity
{
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
}

- (void)stopActivity
{
    if ([(NSDictionary *) connectionBuffers count] == 0)
    {
        UIApplication *app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = NO;
    }
}

- (void)dealloc
{
    //DLog(@"");
    ConnectionData *connectionData;

    for (NSURLConnection *connection in [(NSMutableDictionary *) connectionBuffers allKeys])
    {
        connectionData = (ConnectionData *) CFDictionaryGetValue(connectionBuffers, connection);
        [connection cancel];

        if ([connectionData tag])
        {
            [[connectionData delegate] connectionWasStoppedWithTag:[connectionData tag]];
        }

        CFDictionaryRemoveValue(connectionBuffers, connection);
    }

    CFRelease(connectionBuffers);
    [self stopActivity];

    [super dealloc];
}

+ (bool)createConnectionFromRequest:(NSURLRequest *)request
                        forDelegate:(id <JRConnectionManagerDelegate>)delegate
                 returnFullResponse:(BOOL)returnFullResponse
                            withTag:(id)userData
{
    NSString *body = [[[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding] autorelease];
    DLog(@"request to '%@' with body: '%@'", [[request URL] absoluteString], body);

    JRConnectionManager *connectionManager = [JRConnectionManager getJRConnectionManager];
    CFMutableDictionaryRef connectionBuffers = connectionManager.connectionBuffers;

    if (![NSURLConnection canHandleRequest:request])
        return NO;

    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:connectionManager
                                                          startImmediately:NO];

    if (!connection)
        return NO;

    ConnectionData *connectionData = [[ConnectionData alloc] initWithRequest:request
                                                                 forDelegate:delegate
                                                          returnFullResponse:returnFullResponse
                                                                     withTag:userData];
    CFDictionaryAddValue(connectionBuffers, connection, connectionData);

    [connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [connection start];

    [connectionManager startActivity];

    [connection release];
    [connectionData release];

    return YES;
}

+ (bool)createConnectionFromRequest:(NSURLRequest *)request
                        forDelegate:(id <JRConnectionManagerDelegate>)delegate
                            withTag:(id)userData
{
    return [JRConnectionManager createConnectionFromRequest:request forDelegate:delegate returnFullResponse:NO
                                                    withTag:userData];
}

+ (void)stopConnectionsForDelegate:(id <JRConnectionManagerDelegate>)delegate
{
    JRConnectionManager *connectionManager = [JRConnectionManager getJRConnectionManager];
    CFMutableDictionaryRef connectionBuffers = connectionManager.connectionBuffers;
    ConnectionData *connectionData = nil;

    for (NSURLConnection *connection in [(NSMutableDictionary *) connectionBuffers allKeys])
    {
        connectionData = (ConnectionData *) CFDictionaryGetValue(connectionBuffers, connection);

        if ([connectionData delegate] == delegate)
        {
            [connection cancel];

            if ([connectionData tag])
            {
                if ([delegate respondsToSelector:@selector(connectionWasStoppedWithTag:)])
                    [delegate connectionWasStoppedWithTag:[connectionData tag]];
            }

            CFDictionaryRemoveValue(connectionBuffers, connection);
        }
    }

    [connectionManager stopActivity];
}

+ (void)jsonRequestToUrl:(NSString *)url params:(NSDictionary *)params
     completionHandler:(void(^)(id parsedResponse, NSError *e))handler
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request JR_setBodyWithParams:params];
    NSString *p = [[[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding] autorelease];
    DLog(@"URL: \"%@\" params: \"%@\"", url, p);
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *r, NSData *d, NSError *e)
                           {
                               if (e)
                               {
                                   ALog(@"Error fetching JSON: %@", e);
                                   handler(nil, e);
                               }
                               else
                               {
                                   NSString *bodyString =
                                           [[[NSString alloc] initWithData:d
                                                                  encoding:NSUTF8StringEncoding] autorelease];
                                   NSError *err=nil;
                                   id parsedJson = [NSJSONSerialization JSONObjectWithData:d
                                                                                   options:(NSJSONReadingOptions) 0
                                                                                     error:&err];
                                   ALog(@"Fetched: \"%@\"", bodyString);
                                   if (err)
                                   {
                                       ALog(@"Parse err: \"%@\"", err);
                                       handler(nil, e);
                                   }
                                   else
                                   {
                                       handler(parsedJson, nil);
                                   }
                               }
                           }];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //DLog(@"");
    [[(ConnectionData *) CFDictionaryGetValue(connectionBuffers, connection) response] appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //DLog(@"");
    ConnectionData *connectionData = (ConnectionData *) CFDictionaryGetValue(connectionBuffers, connection);

    [connectionData setResponse:[[[NSMutableData alloc] init] autorelease]];

    if ([connectionData returnFullResponse])
        connectionData.fullResponse = response;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //DLog(@"");
    ConnectionData *connectionData = (ConnectionData *) CFDictionaryGetValue(connectionBuffers, connection);

    NSURLRequest *request = [connectionData request];
    NSURLResponse *fullResponse = [connectionData fullResponse];
    NSData *responseBody = [connectionData response];
    id userData = [connectionData tag];
    id <JRConnectionManagerDelegate> delegate = [connectionData delegate];

    NSStringEncoding encoding = NSUTF8StringEncoding;

    if (![connectionData fullResponse])
    {
        NSString *payload = [[[NSString alloc] initWithData:responseBody encoding:encoding] autorelease];

        if ([delegate respondsToSelector:@selector(connectionDidFinishLoadingWithPayload:request:andTag:)])
            [delegate connectionDidFinishLoadingWithPayload:payload request:request andTag:userData];
    }
    else
    {
        SEL finishMsg = @selector(connectionDidFinishLoadingWithFullResponse:unencodedPayload:request:andTag:);
        if ([delegate respondsToSelector:finishMsg])
            [delegate connectionDidFinishLoadingWithFullResponse:fullResponse unencodedPayload:responseBody
                                                         request:request andTag:userData];
    }

    CFDictionaryRemoveValue(connectionBuffers, connection);

    [self stopActivity];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    DLog(@"error message: %@", [error localizedDescription]);

    ConnectionData *connectionData = (ConnectionData *) CFDictionaryGetValue(connectionBuffers, connection);

    NSURLRequest *request = [connectionData request];
    id userData = [connectionData tag];
    id <JRConnectionManagerDelegate> delegate = [connectionData delegate];

    if ([delegate respondsToSelector:@selector(connectionDidFailWithError:request:andTag:)])
        [delegate connectionDidFailWithError:error request:request andTag:userData];

    CFDictionaryRemoveValue(connectionBuffers, connection);

    [self stopActivity];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)redirectResponse
{
    //DLog(@"");
    ConnectionData *connectionData = (ConnectionData *) CFDictionaryGetValue(connectionBuffers, connection);

    if ([connectionData returnFullResponse])
        connectionData.fullResponse = redirectResponse;

    return request;
}

- (void)              connection:(NSURLConnection *)connection
didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    DLog(@"");
}

- (void)               connection:(NSURLConnection *)connection
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    DLog(@"");
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    /*DLog(@"");*/
    return cachedResponse;
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten
        totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    //DLog(@"bytesWritten: %d, totalBytesWritten: %d, totalBytesExpected: %d", bytesWritten, totalBytesWritten,
    //    totalBytesExpectedToWrite);
}

@end
