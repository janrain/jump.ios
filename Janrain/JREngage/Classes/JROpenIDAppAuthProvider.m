/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2016, Janrain, Inc.
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
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "JROpenIDAppAuthProvider.h"
#import "debug_log.h"
#import "JREngageError.h"
#import "JRSessionData.h"


@implementation JROpenIDAppAuthProvider {
}

- (NSString *)provider {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return nil;
}

+ (BOOL)canHandleAuthentication {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
    return NO;
}

- (void)startAuthenticationWithCompletion:(OpenIDAppAuthCompletionBlock)completion {
    self.completion = completion;
    
    [JRSessionData jrSessionData].authenticationFlowIsInFlight = YES;
    [JRSessionData jrSessionData].openIDAppAuthAuthenticationFlowIsInFlight = YES;
    
    DLog(@"Starting native %@ authentication.", [self provider]);
}

- (void)getAuthInfoTokenForAccessToken:(id)token {
    if (![token isKindOfClass:[NSString class]])
    {
        id userInfo = @{@"description":@"invalid token", @"token":[NSValue valueWithNonretainedObject:token]};
        NSError *error = [NSError errorWithDomain:JREngageErrorDomain code:JRAuthenticationNativeAuthError
                                         userInfo:userInfo];
        DLog(@"Native auth error: %@", error);
        self.completion(error);
        return;
    }
    
    [self getAuthInfoTokenForAccessToken:(NSString *)token andTokenSecret:nil];
}

- (void)triggerWebViewAuthenticationWithMessage:(NSString *)message {
    [JRSessionData jrSessionData].nativeAuthenticationFlowIsInFlight = NO;
    self.completion([JREngageError errorWithMessage:message andCode:JRAuthenticationShouldTryWebViewError]);
}

- (void)getAuthInfoTokenForAccessToken:(NSString *)token andTokenSecret:(NSString *)tokenSecret {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                  @"token" : token,
                                                                                  @"provider" : self.provider
                                                                                  }];
    
    NSString *url = [[JRSessionData jrSessionData].baseUrl stringByAppendingString:@"/signin/oauth_token"];
    
    if(self.provider.length > 0){
        url = [url stringByAppendingString:[NSString stringWithFormat: @"?providername=%@", self.provider]];
    }
    
    if (tokenSecret) {
        if([self.provider  isEqual: @"twitter"]){
            [params setObject:tokenSecret forKey:@"token_secret"];
        }
        if([self.provider  isEqual: @"wechat"]){
            [params setObject:tokenSecret forKey:@"wechat.openid"];
        }
    }
    
    void (^responseHandler)(id, NSError *) = ^(id result, NSError *error)
    {
        NSString *authInfoToken;
        if (error || ![result isKindOfClass:[NSDictionary class]]
            || ![[((NSDictionary *) result) objectForKey:@"stat"] isEqual:@"ok"]
            || ![authInfoToken = [((NSDictionary *) result) objectForKey:@"token"] isKindOfClass:[NSString class]])
        {
            NSObject *error_ = error; if (error_ == nil) error_ = [NSNull null];
            NSObject *result_ = result; if (result_ == nil) result_ = [NSNull null];
            NSError *nativeAuthError = [NSError errorWithDomain:JREngageErrorDomain
                                                           code:JRAuthenticationNativeAuthError
                                                       userInfo:@{@"result": result_, @"error": error_}];
            DLog(@"OpenID AppAuth auth error: %@", nativeAuthError);
            self.completion(nativeAuthError);
            return;
        }
        
        JRSessionData *sessionData = [JRSessionData jrSessionData];
        [sessionData setCurrentProvider:[sessionData getProviderNamed:self.provider]];
        [sessionData triggerAuthenticationDidCompleteWithPayload:@{
                                                                   @"rpx_result" : @{
                                                                           @"token" : authInfoToken,
                                                                           @"auth_info" : @{}
                                                                           },
                                                                   }];
        
        self.completion(nil);
    };
    [JRConnectionManager jsonRequestToUrl:url params:params completionHandler:responseHandler];
}

- (void)dealloc
{
}

@end
