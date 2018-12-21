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

 File:   JRAuthenticate.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Tuesday, June 1, 2010
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "debug_log.h"
#import "JREngage.h"
#import "JRSessionData.h"
#import "JRUserInterfaceMaestro.h"
#import "JREngageError.h"
#import "JROpenIDAppAuth.h"
#import "JROpenIDAppAuthProvider.h"


@interface JREngage () <JRSessionDelegate>
/** \internal Class that handles customizations to the library's UI */
@property (nonatomic) JRUserInterfaceMaestro *interfaceMaestro;

/** \internal Holds configuration and state for the JREngage library */
@property (nonatomic) JRSessionData          *sessionData;

/** \internal Array of JREngageDelegate objects */
@property (nonatomic) NSMutableArray         *delegates;

@property (nonatomic) NSString *googlePlusClientId;

@property (nonatomic) JROpenIDAppAuthProvider *openIDAppAuthProvider;

@end

NSString *const JRFinishedUpdatingEngageConfigurationNotification = @"JRFinishedUpdatingEngageConfigurationNotification";
NSString *const JRFailedToUpdateEngageConfigurationNotification = @"JRFailedToUpdateEngageConfigurationNotification";

@implementation JREngage

@synthesize interfaceMaestro;
@synthesize sessionData;
@synthesize delegates;


static JREngage* singleton = nil;

+ (JREngage *)singletonInstance
{
    if (singleton == nil) {
        singleton = [((JREngage *)[super allocWithZone:NULL]) init];
    }

    return singleton;
}




+ (id)allocWithZone:(NSZone *)zone
{
    return [self singletonInstance];
}

- (void)setEngageAppID:(NSString *)appId appUrl:(NSString *)appUrl tokenUrl:(NSString *)tokenUrl andDelegate:(id<JREngageSigninDelegate>)delegate
{
    ALog (@"Initialize JREngage library with appID: %@, appUrl: %@,and tokenUrl: %@", appId, appUrl, tokenUrl);
    
    if (!delegates)
        self.delegates = [NSMutableArray arrayWithObjects:delegate, nil];
    else
        [delegates addObject:delegate];
    
    if (!sessionData)
        self.sessionData = [JRSessionData jrSessionDataWithAppId:appId appUrl:appUrl tokenUrl:tokenUrl andDelegate:self];
    else
        [sessionData reconfigureWithAppId:appId appUrl:appUrl tokenUrl:tokenUrl];
    
    if (!interfaceMaestro)
        interfaceMaestro = [JRUserInterfaceMaestro jrUserInterfaceMaestroWithSessionData:sessionData];
}

+ (void)setEngageAppId:(NSString *)appId appUrl:(NSString *)appUrl tokenUrl:(NSString *)tokenUrl andDelegate:(id<JREngageSigninDelegate>)delegate
{
    [[JREngage singletonInstance] setEngageAppID:appId appUrl:appUrl tokenUrl:tokenUrl andDelegate:delegate];
}

- (void)setEngageAppID:(NSString *)appId tokenUrl:(NSString *)tokenUrl andDelegate:(id<JREngageSigninDelegate>)delegate
{
    [[JREngage singletonInstance] setEngageAppID:appId appUrl:nil tokenUrl:tokenUrl andDelegate:delegate];
}

+ (void)setEngageAppId:(NSString *)appId tokenUrl:(NSString *)tokenUrl andDelegate:(id<JREngageSigninDelegate>)delegate
{
     [[JREngage singletonInstance] setEngageAppID:appId appUrl:nil tokenUrl:tokenUrl andDelegate:delegate];
}

+ (JREngage *)instance {
    if (singleton) {
        return [JREngage singletonInstance];
    }
    return nil;
}

+ (JREngage *)jrEngageWithAppId:(NSString *)appId
                         appUrl:(NSString *)appUrl
                    andTokenUrl:(NSString *)tokenUrl
                       delegate:(id <JREngageSigninDelegate>)delegate {
    [JREngage setEngageAppId:appId appUrl:appUrl tokenUrl:tokenUrl andDelegate:delegate];
    
    return [JREngage singletonInstance];
}

+ (JREngage *)jrEngageWithAppId:(NSString *)appId andTokenUrl:(NSString *)tokenUrl
                       delegate:(id <JREngageSigninDelegate>)delegate {
    [JREngage setEngageAppId:appId appUrl:nil tokenUrl:tokenUrl andDelegate:delegate];

    return [JREngage singletonInstance];
}

+ (void)setGooglePlusClientId:(NSString *)clientId {
    [[JREngage singletonInstance] setGooglePlusClientId:clientId];
}

- (id)copyWithZone:(__unused NSZone *)zone __unused
{
    return self;
}

- (void)addDelegate:(id<JREngageSigninDelegate>)delegate
{
    if (![delegates containsObject:delegate])
        [delegates addObject:delegate];
}

+ (void)addDelegate:(id<JREngageSigninDelegate>)delegate
{
    [[JREngage singletonInstance] addDelegate:delegate];
}

- (void)removeDelegate:(id<JREngageSigninDelegate>)delegate
{
    [delegates removeObject:delegate];
}

+ (void)removeDelegate:(id<JREngageSigninDelegate>)delegate
{
    [[JREngage singletonInstance] removeDelegate:delegate];
}

- (void)engageDidFailWithError:(NSError *)error
{
    ALog (@"JREngage failed to load with error: %@", [error localizedDescription]);

    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageSigninDelegate> delegate in delegatesCopy)
    {
        if ([delegate respondsToSelector:@selector(engageDialogDidFailToShowWithError:)])
            [delegate engageDialogDidFailToShowWithError:error];
    }
}

- (void)markFlowForAccountLinking:(BOOL)linkAccount forProviders:(NSString *)provider
                  customInterface:(NSDictionary *)customInterfaceOverrides {
    ALog (@"JREngage Marking flow for Account Linking");
    sessionData.accountLinking = linkAccount;
    [self showAuthenticationDialogForProvider:provider customInterface:customInterfaceOverrides];
    
}
- (void)showAuthenticationDialogForProvider:(NSString *)provider
                            customInterface:(NSDictionary *)customInterfaceOverrides
{
    ALog (@"");

    /* If there was error configuring the library, sessionData.error will not be null. */
    if (sessionData.error)
    {
        // Since configuration should happen long before the user attempts to use the library and because the user may
        // not attempt to use the library at all, we shouldn't notify the calling application of the error until the
        // library is actually needed.  Additionally, since many configuration issues could be temporary (e.g., network
        // issues), a subsequent attempt to reconfigure the library could end successfully.  The calling application
        // could alert the user of the issue (with a pop-up dialog, for example) right when the user wants to use it
        // (and not before). This gives the calling application an ad hoc way to reconfigure the library, and doesn't
        // waste the limited resources by trying to reconfigure itself if it doesn't know if it’s actually needed.

        if (sessionData.error.code / 100 == ConfigurationError)
        {
            [self engageDidFailWithError:[sessionData.error copy]];
            [sessionData tryToReconfigureLibrary];

            return;
        }
        else
        {
            // TODO: The session data error doesn't get reset here.  When will this happen and what will be the
            // expected behavior?
            [self engageDidFailWithError:[sessionData.error copy]];
            return;
        }
    }

    if (sessionData.authenticationFlowIsInFlight)
    {
        [self engageDidFailWithError:
                      [JREngageError errorWithMessage:@"The dialog failed to show because there is already a JREngage "
                              "dialog loaded."
                                              andCode:JRDialogShowingError]];
        return;
    }

    if (provider && ![sessionData.allProviders objectForKey:provider])
    {
        NSString *message =
                @"You tried to authenticate on a specific provider, but this provider has not yet been configured.";
        [self engageDidFailWithError:[JREngageError errorWithMessage:message andCode:JRProviderNotConfiguredError]];
        return;
    }

    if ([JROpenIDAppAuth canHandleProvider:provider])
    {
        [self startOpenIDAppAuthOnProvider:provider customInterface:customInterfaceOverrides];
    }
    else
    {
    
        [interfaceMaestro startWebAuthWithCustomInterface:customInterfaceOverrides provider:provider];
    }
}

- (void)startOpenIDAppAuthOnProvider:(NSString *)provider customInterface:(NSDictionary *)customInterfaceOverrides {
    self.openIDAppAuthProvider = [JROpenIDAppAuth openIDAppAuthProviderNamed:provider];
    [self.openIDAppAuthProvider startAuthenticationWithCompletion:^(NSError *error) {
        
        if (!error) return;
        
        if ([error.domain isEqualToString:JREngageErrorDomain] && error.code == JRAuthenticationCanceledError) {
            [self authenticationDidCancel];
        } else if ([error.domain isEqualToString:JREngageErrorDomain]
                   && error.code == JRAuthenticationShouldTryWebViewError) {
            [self.interfaceMaestro startWebAuthWithCustomInterface:customInterfaceOverrides provider:provider];
        } else {
            [self authenticationDidFailWithError:error forProvider:provider];
        }
    }];
}

+ (void)getAuthInfoTokenForNativeProvider:(NSString *)provider
                                withToken:(NSString *)token
                           andTokenSecret:(NSString *)tokenSecret {
    [self getAuthInfoTokenForNativeProvider:provider withToken:token andTokenSecret:tokenSecret andEngageAppUrl:nil];
}

+ (void)getAuthInfoTokenForNativeProvider:(NSString *)provider
                                withToken:(NSString *)token
                           andTokenSecret:(NSString *)tokenSecret
                          andEngageAppUrl:(NSString *)engageAppUrl{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                  @"token" : token,
                                                                                  @"provider" : provider
                                                                                  }];
    
    
    NSString *url;
    if(engageAppUrl.length > 0){
        url = [NSString stringWithFormat: @"https://%@/signin/oauth_token",engageAppUrl];
    }else{
        url = [[JRSessionData jrSessionData].baseUrl stringByAppendingString:@"/signin/oauth_token"];
    }
    
    if(provider.length > 0){
        url = [url stringByAppendingString:[NSString stringWithFormat: @"?providername=%@", provider]];
    }
    
    if (tokenSecret) {
        if([provider  isEqual: @"twitter"]){
            [params setObject:tokenSecret forKey:@"token_secret"];
        }
        if([provider  isEqual: @"wechat"]){
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
            DLog(@"Native authentication error: %@", nativeAuthError);
            JRSessionData *sessionData = [JRSessionData jrSessionData];
            [sessionData setCurrentProvider:[sessionData getProviderNamed:provider]];
            [sessionData triggerAuthenticationDidFailWithError:nativeAuthError];
            return;
        }
        
        
        JRSessionData *sessionData = [JRSessionData jrSessionData];
        [sessionData setCurrentProvider:[sessionData getProviderNamed:provider]];
        [sessionData triggerAuthenticationDidCompleteWithPayload:@{
                                                                   @"rpx_result" : @{
                                                                           @"token" : authInfoToken,
                                                                           @"auth_info" : @{}
                                                                           },
                                                                   }];
        
    };
    [JRConnectionManager jsonRequestToUrl:url params:params completionHandler:responseHandler];
}


+ (void)showAuthenticationDialogForProvider:(NSString *)provider
               withCustomInterfaceOverrides:(NSDictionary *)customInterfaceOverrides __unused
{
    [[JREngage singletonInstance] showAuthenticationDialogForProvider:provider
                                                      customInterface:customInterfaceOverrides];
}

+ (void)showAuthenticationDialogWithCustomInterfaceOverrides:(NSDictionary *)customInterfaceOverrides __unused
{
    [[JREngage singletonInstance] showAuthenticationDialogForProvider:nil
                                                      customInterface:customInterfaceOverrides];
}

+(void)showAuthenticationDialogWithCustomInterfaceOverrides:(NSDictionary *)customInterfaceOverrides
                                          forAccountLinking:(BOOL)linkAccount
{
    [[JREngage singletonInstance] markFlowForAccountLinking:linkAccount
                                               forProviders:nil
                                            customInterface:customInterfaceOverrides];
    
}


+ (void)showAuthenticationDialogForProvider:(NSString *)provider
{
    [[JREngage singletonInstance] showAuthenticationDialogForProvider:provider
                                                      customInterface:nil ];
}

- (void)showAuthenticationDialog
{
    [self showAuthenticationDialogForProvider:nil customInterface:nil ];
}

+ (void)showAuthenticationDialog __unused
{
    [[JREngage singletonInstance] showAuthenticationDialog];
}

- (void)showSharingDialogWithActivity:(JRActivityObject *)activity
         withCustomInterfaceOverrides:(NSDictionary *)customInterfaceOverrides
{
    ALog (@"");

    /* If there was error configuring the library, sessionData.error will not be null. */
    if (sessionData.error)
    {

    /* Since configuration should happen long before the user attempts to use the library and because the user may not
        attempt to use the library at all, we shouldn't notify the calling application of the error until the library
        is actually needed.  Additionally, since many configuration issues could be temporary (e.g., network issues),
        a subsequent attempt to reconfigure the library could end successfully.  The calling application could alert the
        user of the issue (with a pop-up dialog, for example) right when the user wants to use it (and not before).
        This gives the calling application an ad hoc way to reconfigure the library, and doesn't waste the limited
        resources by trying to reconfigure itself if it doesn't know if it’s actually needed. */

        if (sessionData.error.code / 100 == ConfigurationError)
        {
            [self engageDidFailWithError:[sessionData.error copy]];
            [sessionData tryToReconfigureLibrary];

            return;
        }
        else
        {
            [self engageDidFailWithError:[sessionData.error copy]];
            return;
        }
    }

    if (sessionData.authenticationFlowIsInFlight)
    {
        [self engageDidFailWithError:
                      [JREngageError errorWithMessage:@"The dialog failed to show because there is already a JREngage "
                              "dialog loaded."
                                              andCode:JRDialogShowingError]];
        return;
    }

    if (!activity)
    {
        [self engageDidFailWithError:
                      [JREngageError errorWithMessage:@"Activity object can't be nil."
                                              andCode:JRPublishErrorActivityNil]];
        return;
    }

    sessionData.activity = activity;
    [interfaceMaestro showPublishingDialogForActivityWithCustomInterface:customInterfaceOverrides];
}

//- (void)showSocialPublishingDialogWithActivity:(JRActivityObject *)activity
//                   andCustomInterfaceOverrides:(NSDictionary *)customInterfaceOverrides
//{
//    [self showSharingDialogWithActivity:activity withCustomInterfaceOverrides:customInterfaceOverrides];
//}

+ (void)showSharingDialogWithActivity:(JRActivityObject *)activity
         withCustomInterfaceOverrides:(NSDictionary *)customInterfaceOverrides __unused
{
    [[JREngage singletonInstance] showSharingDialogWithActivity:activity 
                                   withCustomInterfaceOverrides:customInterfaceOverrides];
}

- (void)showSharingDialogWithActivity:(JRActivityObject *)activity
{
    [self showSharingDialogWithActivity:activity withCustomInterfaceOverrides:nil];
}

+ (void)showSharingDialogWithActivity:(JRActivityObject *)activity __unused
{
    [[JREngage singletonInstance] showSharingDialogWithActivity:activity];
}

- (void)authenticationDidRestart
{
    DLog (@"");
    [interfaceMaestro authenticationRestarted];
}

- (void)authenticationDidCancel
{
    DLog (@"");

    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageSigninDelegate> delegate in delegatesCopy)
    {
        if ([delegate respondsToSelector:@selector(authenticationDidNotComplete)])
            [delegate authenticationDidNotComplete];
    }

    [interfaceMaestro authenticationCanceled];
}

- (void)authenticationDidCompleteForUser:(NSDictionary *)profile forProvider:(NSString *)provider
{
    ALog (@"Signing complete for %@", provider);

    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageSigninDelegate> delegate in delegatesCopy)
    {
        if ([delegate respondsToSelector:@selector(authenticationDidSucceedForUser:forProvider:)])
            [delegate authenticationDidSucceedForUser:profile forProvider:provider];
    }

    [interfaceMaestro authenticationCompleted];
}

- (void)authenticationDidFailWithError:(NSError *)error forProvider:(NSString *)provider
{
    ALog (@"Sign in failed for %@ with error: %@", provider, [error localizedDescription]);

    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageSigninDelegate> delegate in delegatesCopy)
    {
        if ([delegate respondsToSelector:@selector(authenticationDidFailWithError:forProvider:)])
            [delegate authenticationDidFailWithError:error forProvider:provider];
    }

    [interfaceMaestro authenticationFailed];
}

- (void)authenticationDidReachTokenUrl:(NSString *)tokenUrl withResponse:(NSURLResponse *)response
                            andPayload:(NSData *)tokenUrlPayload forProvider:(NSString *)provider;
{
    ALog (@"Token URL reached for %@: %@", provider, tokenUrl);

    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageSigninDelegate> delegate in delegatesCopy)
    {
        SEL selector = @selector(authenticationDidReachTokenUrl:withResponse:andPayload:forProvider:);
        if ([delegate respondsToSelector:selector])
            [delegate authenticationDidReachTokenUrl:tokenUrl withResponse:response andPayload:tokenUrlPayload 
                                         forProvider:provider];
    }
}

- (void)authenticationCallToTokenUrl:(NSString *)tokenUrl didFailWithError:(NSError *)error
                         forProvider:(NSString *)provider
{
    ALog (@"Token URL failed for %@: %@", provider, tokenUrl);

    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageSigninDelegate> delegate in delegatesCopy)
    {
        if ([delegate respondsToSelector:@selector(authenticationCallToTokenUrl:didFailWithError:forProvider:)])
            [delegate authenticationCallToTokenUrl:tokenUrl didFailWithError:error forProvider:provider];
    }
}

//- (void)publishingDidRestart
//{
//    DLog (@"");
//    [interfaceMaestro publishingRestarted];
//}

- (void)publishingDidCancel
{
    DLog(@"");

    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageSharingDelegate> delegate in delegatesCopy)
    {
        if ([delegate respondsToSelector:@selector(sharingDidNotComplete)])
            [delegate sharingDidNotComplete];
    }

    [interfaceMaestro publishingCanceled];
}

- (void)publishingDidComplete
{
    DLog(@"");

    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageSharingDelegate> delegate in delegatesCopy)
    {
        if ([delegate respondsToSelector:@selector(sharingDidComplete)])
            [delegate sharingDidComplete];
    }

    [interfaceMaestro publishingCompleted];
}

- (void)publishingActivityDidSucceed:(JRActivityObject *)activity forProvider:(NSString *)provider
{
    ALog (@"Activity shared on %@", provider);

    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageSharingDelegate> delegate in delegatesCopy)
    {
        if ([delegate respondsToSelector:@selector(sharingDidSucceedForActivity:forProvider:)])
            [delegate sharingDidSucceedForActivity:activity forProvider:provider];
    }
}

- (void)publishingActivity:(JRActivityObject *)activity didFailWithError:(NSError *)error forProvider:(NSString *)provider
{
    ALog (@"Sharing activity failed for %@", provider);

    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageSharingDelegate> delegate in delegatesCopy)
    {
        if ([delegate respondsToSelector:@selector(sharingDidFailForActivity:withError:forProvider:)])
            [delegate sharingDidFailForActivity:activity withError:error forProvider:provider];
    }
}

- (void)clearSharingCredentialsForProvider:(NSString *)provider
{
    DLog(@"");
    [sessionData forgetAuthenticatedUserForProvider:provider];
}

+ (void)clearSharingCredentialsForProvider:(NSString *)provider
{
    [[JREngage singletonInstance] clearSharingCredentialsForProvider:provider];
}

- (void)clearSharingCredentialsForAllProviders __unused
{
    DLog(@"");
    [sessionData forgetAllAuthenticatedUsers];
}

+ (void)clearSharingCredentialsForAllProviders
{
    [[JREngage singletonInstance] clearSharingCredentialsForAllProviders];
}

- (void)alwaysForceReauthentication:(BOOL)force
{
    [sessionData setAlwaysForceReauth:force];
}

+ (void)alwaysForceReauthentication:(BOOL)force
{
    [[JREngage singletonInstance] alwaysForceReauthentication:force];
}

- (void)cancelAuthentication
{
    DLog(@"");
    [sessionData triggerAuthenticationDidCancel];
}

+ (void)cancelAuthentication
{
    [[JREngage singletonInstance] cancelAuthentication];
}

- (void)cancelSharing
{
    DLog(@"");
    [sessionData triggerPublishingDidCancel];
}

+ (void)cancelSharing
{
    [[JREngage singletonInstance] cancelSharing];
}

- (void)updateTokenUrl:(NSString *)newTokenUrl
{
    DLog(@"new token URL: %@", newTokenUrl);
    [sessionData setTokenUrl:newTokenUrl];
}

+ (NSString *)tokenUrl
{
    return [JREngage singletonInstance].sessionData.tokenUrl;
}

+ (void)updateTokenUrl:(NSString *)newTokenUrl __unused
{
    [[JREngage singletonInstance] updateTokenUrl:newTokenUrl];
}

- (void)setCustomInterfaceDefaults:(NSMutableDictionary *)customInterfaceDefaults
{
    [interfaceMaestro setCustomInterfaceDefaults:customInterfaceDefaults];
}

- (void)dealloc
{
}

+ (void)setCustomInterfaceDefaults:(NSDictionary *)customInterfaceDefaults
{
    NSMutableDictionary *mutable = [NSMutableDictionary dictionaryWithDictionary:customInterfaceDefaults];
    [[JREngage singletonInstance] setCustomInterfaceDefaults:mutable];
}

+ (void)setCustomProviders:(NSDictionary *)customProviders __unused
{
    [[JREngage singletonInstance].sessionData setCustomProvidersWithDictionary:customProviders];
}


+ (void)applicationDidBecomeActive:(UIApplication *)application {
    
    if (singleton) {
        [singleton applicationDidBecomeActive:application];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (sessionData.openIDAppAuthAuthenticationFlowIsInFlight) {
        [interfaceMaestro authenticationCanceled];
    }
}

- (void)authenticationDidSucceedForAccountLinking:(NSDictionary *)profile
                                      forProvider:(NSString *)provider
{
    ALog (@"Signing complete for %@", provider);
    
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JREngageSigninDelegate> delegate in delegatesCopy)
    {
        if ([delegate respondsToSelector:@selector(engageAuthenticationDidSucceedForAccountLinking:forProvider:)])
            [delegate engageAuthenticationDidSucceedForAccountLinking:profile forProvider:provider];
    }
    
    [interfaceMaestro authenticationCompleted];
}


@end
