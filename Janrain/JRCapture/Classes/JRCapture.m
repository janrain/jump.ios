/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2012, Janrain, Inc.

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


 File:   JRCapture.h
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Tuesday, January 31, 2012
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


#import "JRCaptureApidInterface.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "JRCapture.h"
#import "JREngageWrapper.h"
#import "JRCaptureData.h"
#import "debug_log.h"
#import "JRBase64.h"
#import "JRCaptureError.h"
#import "JRCaptureUser+Extras.h"
#import "JRConnectionManager.h"
#import "JRCaptureConfig.h"
#import "NSMutableDictionary+JRDictionaryUtils.h"
#import "JRCaptureUIRequestBuilder.h"
#import "JRCaptureFlow.h"
#import "JRJsonUtils.h"
#import "NSMutableURLRequest+JRRequestUtils.h"
#import "JREngage.h"


NSString* const JRDownloadFlowResult = @"JRDownloadFlowResult";

@implementation JRCapture

+ (void)setCaptureConfig:(JRCaptureConfig *)config
{
    [JRCaptureData setCaptureConfig:config];
    if (config.engageAppId.length > 0){
        [JREngageWrapper configureEngageWithAppId:config.engageAppId engageAppUrl:config.engageAppUrl customIdentityProviders:config.customProviders];
    }else{
        [JREngageWrapper configureEngageWithOutAppId:config.customProviders engageAppUrl:config.engageAppUrl];
        
    }
}

/**
 * Change the Engage app ID and reload the Engage configuration data
 * @param engageAppId
 *   The new Engage app ID
 */
+ (void)reconfigureWithEngageAppId:(NSString *)engageAppId {
    [JREngageWrapper reconfigureEngageWithNewAppId:engageAppId];
}

/**
 * Change the Capture Client ID that will be used in requests to Capture
 * @param clientId
 *   The new Capture Client ID
 */
+ (void)setCaptureClientId:(NSString *)captureClientId {
    [JRCaptureData setCaptureClientId:captureClientId];
}

/**
 * Change the Capture Domain that will be used as the base URL for Capture request
 * @param captureDomain
 *   The new Capture domain
 */
+ (void)setCaptureDomain:(NSString *)captureDomain {
    [JRCaptureData setCaptureBaseUrl:captureDomain];
}

+ (void)setEngageAppId:(NSString *)engageAppId
          engageAppUrl:(NSString *)engageAppUrl
         captureDomain:(NSString *)captureDomain
       captureClientId:(NSString *)clientId
         captureLocale:(NSString *)captureLocale
       captureFlowName:(NSString *)captureFlowName
    captureFlowVersion:(NSString *)captureFlowVersion
captureTraditionalSignInFormName:(NSString *)captureSignInFormName
captureTraditionalSignInType:(__unused JRTraditionalSignInType) tradSignInType
captureEnableThinRegistration:(BOOL)enableThinRegistration
customIdentityProviders:(NSDictionary *)customProviders
captureTraditionalRegistrationFormName:(NSString *)captureTraditionalRegistrationFormName
captureSocialRegistrationFormName:(NSString *)captureSocialRegistrationFormName
          captureAppId:(NSString *)captureAppId
{
    JRCaptureConfig *config = [JRCaptureConfig emptyCaptureConfig];
    config.engageAppId = engageAppId;
    config.engageAppUrl = engageAppUrl;
    config.captureDomain = captureDomain;
    config.captureClientId = clientId;
    config.captureLocale = captureLocale;
    config.captureSignInFormName = captureSignInFormName;
    config.captureFlowName = captureFlowName;
    config.enableThinRegistration = enableThinRegistration;
    config.customProviders = customProviders;
    config.captureTraditionalRegistrationFormName = captureTraditionalRegistrationFormName;
    config.captureSocialRegistrationFormName = captureSocialRegistrationFormName;
    config.captureFlowVersion = captureFlowVersion;
    config.captureAppId = captureAppId;
    
    [JRCapture setCaptureConfig:config];
}

+ (void)setEngageAppId:(NSString *)engageAppId captureDomain:(NSString *)captureDomain
       captureClientId:(NSString *)clientId captureLocale:(NSString *)captureLocale
                 captureFlowName:(NSString *)captureFlowName captureFlowVersion:(NSString *)captureFlowVersion
captureTraditionalSignInFormName:(NSString *)captureSignInFormName
    captureTraditionalSignInType:(__unused JRTraditionalSignInType) tradSignInType
         captureEnableThinRegistration:(BOOL)enableThinRegistration
               customIdentityProviders:(NSDictionary *)customProviders
captureTraditionalRegistrationFormName:(NSString *)captureTraditionalRegistrationFormName
     captureSocialRegistrationFormName:(NSString *)captureSocialRegistrationFormName
                          captureAppId:(NSString *)captureAppId
{
    [JRCapture setEngageAppId:engageAppId engageAppUrl:nil captureDomain:captureDomain captureClientId:clientId
                captureLocale:captureLocale captureFlowName:captureFlowName
           captureFlowVersion:captureFlowVersion
captureTraditionalSignInFormName:captureSignInFormName
 captureTraditionalSignInType:tradSignInType captureEnableThinRegistration:enableThinRegistration
      customIdentityProviders:customProviders
captureTraditionalRegistrationFormName:captureTraditionalRegistrationFormName
captureSocialRegistrationFormName:captureSocialRegistrationFormName
                 captureAppId:captureAppId];
}

+ (void)setEngageAppId:(NSString *)engageAppId captureDomain:(NSString *)captureDomain
       captureClientId:(NSString *)clientId captureLocale:(NSString *)captureLocale
                 captureFlowName:(NSString *)captureFlowName captureFlowVersion:(NSString *)captureFlowVersion
captureTraditionalSignInFormName:(NSString *)captureSignInFormName
   captureEnableThinRegistration:(BOOL)enableThinRegistration
          captureTraditionalSignInType:(__unused JRTraditionalSignInType)captureTraditionalSignInType
captureTraditionalRegistrationFormName:(NSString *)captureTraditionalRegistrationFormName
     captureSocialRegistrationFormName:(NSString *)captureSocialRegistrationFormName
                          captureAppId:(NSString *)captureAppId
               customIdentityProviders:customProviders
{
    [JRCapture setEngageAppId:engageAppId engageAppUrl:nil captureDomain:captureDomain captureClientId:clientId
                captureLocale:captureLocale captureFlowName:captureFlowName
           captureFlowVersion:captureFlowVersion
            captureTraditionalSignInFormName:captureSignInFormName
 captureTraditionalSignInType:captureTraditionalSignInType captureEnableThinRegistration:enableThinRegistration
               customIdentityProviders:customProviders
captureTraditionalRegistrationFormName:captureTraditionalRegistrationFormName
     captureSocialRegistrationFormName:captureSocialRegistrationFormName
                          captureAppId:captureAppId];
}

+ (void)setEngageAppId:(NSString *)engageAppId captureDomain:(NSString *)captureDomain
       captureClientId:(NSString *)clientId captureLocale:(NSString *)captureLocale
                 captureFlowName:(NSString *)captureFlowName captureFlowVersion:(NSString *)captureFlowVersion
captureTraditionalSignInFormName:(NSString *)captureSignInFormName
   captureEnableThinRegistration:(BOOL)enableThinRegistration
          captureTraditionalSignInType:(__unused JRTraditionalSignInType)captureTraditionalSignInType
captureTraditionalRegistrationFormName:(NSString *)captureTraditionalRegistrationFormName
     captureSocialRegistrationFormName:(NSString *)captureSocialRegistrationFormName
                          captureAppId:(NSString *)captureAppId
{
    [JRCapture setEngageAppId:engageAppId engageAppUrl:nil captureDomain:captureDomain captureClientId:clientId
                captureLocale:captureLocale captureFlowName:captureFlowName
           captureFlowVersion:captureFlowVersion
            captureTraditionalSignInFormName :captureSignInFormName
 captureTraditionalSignInType:captureTraditionalSignInType captureEnableThinRegistration:enableThinRegistration
          customIdentityProviders:nil captureTraditionalRegistrationFormName:captureTraditionalRegistrationFormName
captureSocialRegistrationFormName:captureSocialRegistrationFormName
                     captureAppId:captureAppId];

}

+ (void)setEngageAppId:(NSString *)engageAppId captureDomain:(NSString *)captureDomain
       captureClientId:(NSString *)clientId captureLocale:(NSString *)captureLocale
                 captureFlowName:(NSString *)captureFlowName captureFlowVersion:(NSString *)captureFlowVersion
captureTraditionalSignInFormName:(NSString *)captureSignInFormName
    captureTraditionalSignInType:(JRTraditionalSignInType)captureTraditionalSignInType
                    captureAppId:(NSString *)captureAppId customIdentityProviders:(NSDictionary *)customProviders
{
    [JRCapture setEngageAppId:engageAppId captureDomain:captureDomain
              captureClientId:clientId captureLocale:captureLocale
                 captureFlowName:captureFlowName captureFlowVersion:captureFlowVersion
captureTraditionalSignInFormName:captureSignInFormName
   captureEnableThinRegistration:YES
          captureTraditionalSignInType:captureTraditionalSignInType
captureTraditionalRegistrationFormName:nil
     captureSocialRegistrationFormName:nil
                          captureAppId:captureAppId
               customIdentityProviders:customProviders];
}

+ (void)setEngageAppId:(NSString *)engageAppId captureDomain:(NSString *)captureDomain
       captureClientId:(NSString *)clientId captureLocale:(NSString *)captureLocale
             captureFlowName:(NSString *)captureFlowName captureFormName:(NSString *)captureFormName
captureTraditionalSignInType:(JRTraditionalSignInType)captureTraditionalSignInType
{
    [JRCapture setEngageAppId:engageAppId captureDomain:captureDomain
              captureClientId:clientId captureLocale:captureLocale
                 captureFlowName:captureFlowName captureFlowVersion:nil
captureTraditionalSignInFormName:captureFormName
   captureEnableThinRegistration:YES
          captureTraditionalSignInType:captureTraditionalSignInType
captureTraditionalRegistrationFormName:nil
     captureSocialRegistrationFormName:nil
                          captureAppId:nil
               customIdentityProviders:nil];
}

+ (void)setEngageAppId:(NSString *)engageAppId captureDomain:(NSString *)captureDomain
       captureClientId:(NSString *)clientId captureLocale:(NSString *)captureLocale
             captureFlowName:(NSString *)captureFlowName captureFormName:(NSString *)captureFormName
captureTraditionalSignInType:(JRTraditionalSignInType)captureTraditionalSignInType
     customIdentityProviders:(NSDictionary *)customProviders
{
    [JRCapture setEngageAppId:engageAppId captureDomain:captureDomain
              captureClientId:clientId captureLocale:captureLocale
                 captureFlowName:captureFlowName captureFlowVersion:nil
captureTraditionalSignInFormName:captureFormName
   captureEnableThinRegistration:YES
          captureTraditionalSignInType:captureTraditionalSignInType
captureTraditionalRegistrationFormName:nil
     captureSocialRegistrationFormName:nil
                          captureAppId:nil
               customIdentityProviders:customProviders];
}

+ (void)setEngageAppId:(NSString *)engageAppId captureDomain:(NSString *)captureDomain
          captureClientId:(NSString *)clientId captureLocale:(NSString *)captureLocale
          captureFlowName:(NSString *)captureFlowName
    captureSignInFormName:(NSString *)captureFormName
captureEnableThinRegistration:(BOOL)enableThinRegistration
captureTraditionalSignInType:(JRTraditionalSignInType)captureTraditionalSignInType
       captureFlowVersion:(NSString *)captureFlowVersion
captureRegistrationFormName:(NSString *)captureRegistrationFormName
             captureAppId:(NSString *)captureAppId
{
    JRCaptureConfig *config = [JRCaptureConfig emptyCaptureConfig];
    config.engageAppId = engageAppId;
    config.engageAppUrl = nil;
    config.captureDomain = captureDomain;
    config.captureClientId = clientId;
    config.captureLocale = captureLocale;
    config.captureSignInFormName = captureFormName;
    config.captureFlowName = captureFlowName;
    config.enableThinRegistration = enableThinRegistration;
    config.captureSocialRegistrationFormName = captureRegistrationFormName;
    config.captureFlowVersion = captureFlowVersion;
    config.captureAppId = captureAppId;
    config.captureTraditionalSignInType = captureTraditionalSignInType;

    [JRCapture setCaptureConfig:config];
}

/**
 * Clears user sign-in state from the Capture Library
 * This includes:
 *  - access token
 *  - uuid
 * These are cleared from memory as well as from disk.
 *
 * This does not include:
 *  - user model
 * (User models are managed by the host application, not by the Capture library.)
 */
+ (void)clearSignInState
{
    [JRCaptureData clearSignInState];
}

+ (void)setAccessToken:(NSString *)newAccessToken __unused
{
    [JRCaptureData setAccessToken:newAccessToken];
}

+ (void)setRedirectUri:(NSString *)redirectUri __unused
{
    [JRCaptureData setCaptureRedirectUri:redirectUri];
}

+ (NSString *)getAccessToken __unused
{
    return [JRCaptureData sharedCaptureData].accessToken;
}

+ (void)startEngageSignInDialogForDelegate:(id <JRCaptureDelegate>)delegate __unused
{
    [JREngageWrapper startAuthenticationDialogWithTraditionalSignIn:JRTraditionalSignInNone
                                        andCustomInterfaceOverrides:nil forDelegate:delegate];
}

+ (void)startEngageSignInDialogWithTraditionalSignIn:(JRTraditionalSignInType)traditionalSignInType
                                         forDelegate:(id <JRCaptureDelegate>)delegate __unused
{
    [JREngageWrapper startAuthenticationDialogWithTraditionalSignIn:traditionalSignInType
                                        andCustomInterfaceOverrides:nil forDelegate:delegate];
}

+ (void)startEngageSignInDialogOnProvider:(NSString *)provider
                              forDelegate:(id <JRCaptureDelegate>)delegate __unused
{
    [JREngageWrapper startAuthenticationDialogOnProvider:provider withCustomInterfaceOverrides:nil mergeToken:nil
                                             forDelegate:delegate];
}

+ (void)startEngageSignInDialogWithCustomInterfaceOverrides:(NSDictionary *)customInterfaceOverrides
                                                forDelegate:(id <JRCaptureDelegate>)delegate __unused
{
    [JREngageWrapper startAuthenticationDialogWithTraditionalSignIn:JRTraditionalSignInNone
                                        andCustomInterfaceOverrides:customInterfaceOverrides
                                                        forDelegate:delegate];
}

+ (void)startEngageSignInDialogWithTraditionalSignIn:(JRTraditionalSignInType)traditionalSignInType
                         andCustomInterfaceOverrides:(NSDictionary *)customInterfaceOverrides
                                         forDelegate:(id <JRCaptureDelegate>)delegate
{
    [JREngageWrapper startAuthenticationDialogWithTraditionalSignIn:traditionalSignInType
                                        andCustomInterfaceOverrides:customInterfaceOverrides forDelegate:delegate];
}

+ (void)startEngageSignInDialogOnProvider:(NSString *)provider
             withCustomInterfaceOverrides:(NSDictionary *)customInterfaceOverrides
                               mergeToken:(NSString *)mergeToken
                              forDelegate:(id <JRCaptureDelegate>)delegate
{
    [JREngageWrapper startAuthenticationDialogOnProvider:provider
                            withCustomInterfaceOverrides:customInterfaceOverrides mergeToken:mergeToken
                                             forDelegate:delegate];
}

+ (void)startEngageSignInDialogOnProvider:(NSString *)provider
             withCustomInterfaceOverrides:(NSDictionary *)customInterfaceOverrides
                              forDelegate:(id <JRCaptureDelegate>)delegate __unused
{
    [JREngageWrapper startAuthenticationDialogOnProvider:provider
                            withCustomInterfaceOverrides:customInterfaceOverrides mergeToken:nil
                                             forDelegate:delegate];
}

+ (void)startEngageSignInWithNativeProviderToken:(NSString *)provider
                                       withToken: (NSString *)token
                                  andTokenSecret: (NSString *)tokenSecret
                                      mergeToken: (NSString *)mergeToken
                    withCustomInterfaceOverrides:(NSDictionary *)customInterfaceOverrides
                                     forDelegate:(id <JRCaptureDelegate>)delegate
{
    [JREngageWrapper startAuthenticationWithProviderToken:provider
                                                withToken:token
                                           andTokenSecret:tokenSecret
                             withCustomInterfaceOverrides:customInterfaceOverrides
                                               mergeToken:mergeToken
                                              forDelegate:delegate];
}

+ (void)startEngageSignInWithNativeProviderToken:(NSString *)provider
                                       withToken: (NSString *)token
                                  andTokenSecret: (NSString *)tokenSecret
                                      mergeToken: (NSString *)mergeToken
                                    engageAppUrl: (NSString *)engageAppUrl
                    withCustomInterfaceOverrides:(NSDictionary *)customInterfaceOverrides
                                     forDelegate:(id <JRCaptureDelegate>)delegate
{
    [JREngageWrapper startAuthenticationWithProviderToken:provider
                                                withToken:token
                                           andTokenSecret:tokenSecret
                             withCustomInterfaceOverrides:customInterfaceOverrides
                                               mergeToken:mergeToken
                                             engageAppUrl:engageAppUrl
                                              forDelegate:delegate];
}

+ (void)startCaptureTraditionalSignInForUser:(NSString *)user withPassword:(NSString *)password
                              withSignInType:(JRTraditionalSignInType)traditionalSignInTypeSignInType
                                  mergeToken:(NSString *)mergeToken forDelegate:(id <JRCaptureDelegate>)delegate
{
    [self startCaptureTraditionalSignInForUser:user withPassword:password mergeToken:mergeToken forDelegate:delegate];
}

+ (void)startCaptureTraditionalSignInForUser:(NSString *)user withPassword:(NSString *)password
                                  mergeToken:(NSString *)mergeToken forDelegate:(id <JRCaptureDelegate>)delegate
{
    if (!user || !password){
        if ([delegate respondsToSelector:@selector(captureSignInDidFailWithError:)]) {
            [delegate captureSignInDidFailWithError:[JRCaptureError invalidArgumentErrorWithParameterName:@"nil username or password"]];
        }
        return;
    }

    NSMutableDictionary *params = [@{@"user" : user, @"password" : password} mutableCopy];
    [params JR_maybeSetObject:mergeToken forKey:@"merge_token"];

    NSString *secret = [JRCaptureData generateAndStoreRefreshSecret];
    NSDictionary *tradAuthParams = [JRCaptureApidInterface tradAuthParamsWithParams:params refreshSecret:secret
                                                                           delegate:delegate];
    NSString *tradAuthUrl = [[[JRCaptureData requestWithPath:kJRTradAuthUrlPath] URL] absoluteString];

    [JRConnectionManager jsonRequestToUrl:tradAuthUrl params:tradAuthParams
                        completionHandler:^(id json, NSError *error) {
                            [self signInHandler:json error:error delegate:delegate];
                        }];
}

+ (void)signInHandler:(id)json error:(NSError *)error delegate:(id <JRCaptureDelegate>)delegate
{
    if (error || ![json isKindOfClass:[NSDictionary class]] || ![[json objectForKey:@"stat"] isEqual:@"ok"]) {
        if (!error) {
            error = [JRCaptureError errorFromResult:json onProvider:nil engageToken:nil];
        }
        if ([delegate respondsToSelector:@selector(captureSignInDidFailWithError:)]){
            [delegate captureSignInDidFailWithError:error];
        }
        return;
    }

    NSString *accessToken = [json objectForKey:@"access_token"];
    NSString *authorizationCode = [json objectForKey:@"authorization_code"];
    BOOL isNew = [(NSNumber *) [json objectForKey:@"is_new"] boolValue];
    NSDictionary *captureUserJson = [json objectForKey:@"capture_user"];
    JRCaptureUser *captureUser = [JRCaptureUser captureUserObjectFromDictionary:captureUserJson];

    if (!captureUserJson || !captureUser || !accessToken) {
        JRCaptureError *captureError = [JRCaptureError invalidApiResponseErrorWithString:json];
        if ([delegate respondsToSelector:@selector(captureSignInDidFailWithError:)]){
            [delegate captureSignInDidFailWithError:captureError];
        }
        return;
    }

    [JRCaptureData setAccessToken:accessToken];
    NSArray *linkedProfile = [captureUserJson valueForKey:@"profiles"];
    [JRCaptureData setLinkedProfiles:linkedProfile];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    JRCaptureRecordStatus recordStatus = isNew ? JRCaptureRecordNewlyCreated : JRCaptureRecordExists;
    // XXX maybeDispatch inlined here because the second arg is actually an enum and logging it as an object will
    // seg fault, so the log statement is one-off modified here
    DLog(@"Dispatching %@ with %@, %i", NSStringFromSelector(@selector(captureSignInDidSucceedForUser:status:)),
        captureUser, recordStatus);
    if ([delegate respondsToSelector:@selector(captureSignInDidSucceedForUser:status:)]) {
        [delegate captureSignInDidSucceedForUser:captureUser status:recordStatus];
    }

    if ([delegate respondsToSelector:@selector(captureDidSucceedWithCode:)] && authorizationCode) {
        [delegate captureDidSucceedWithCode:authorizationCode];
    }
}

+ (void)startCaptureTraditionalSignInForUser:(NSString *)user withPassword:(NSString *)password
                              withSignInType:(JRTraditionalSignInType)traditionalSignInTypeSignInType
                                 forDelegate:(id <JRCaptureDelegate>)delegate
{
    [self startCaptureTraditionalSignInForUser:user withPassword:password mergeToken:nil forDelegate:delegate];
}

+ (void)refreshAccessTokenForDelegate:(id <JRCaptureDelegate>)delegate context:(id <NSObject>)context
{
    NSString *date = [self utcTimeString];
    NSString *accessToken = [JRCaptureData sharedCaptureData].accessToken;
    NSString *refreshSecret = [JRCaptureData sharedCaptureData].refreshSecret;
    NSString *domain = [JRCaptureData sharedCaptureData].captureBaseUrl;
    NSString *refreshUrl = [NSString stringWithFormat:@"%@/oauth/refresh_access_token", domain];
    NSString *signature = [self base64SignatureForRefreshWithDate:date refreshSecret:refreshSecret
                                                      accessToken:accessToken];
    if (!signature || !accessToken || !date)
    {
        if ([delegate respondsToSelector:@selector(refreshAccessTokenDidFailWithError:context:)]){
            [delegate refreshAccessTokenDidFailWithError:
                    [JRCaptureError invalidInternalStateErrorWithDescription:@"unable to generate signature"]
                                                 context:context];
        }
        return;
    }

    NSDictionary *params = @{
            @"access_token" : accessToken,
            @"signature" : signature,
            @"date" : date,

            @"client_id" : [JRCaptureData sharedCaptureData].clientId,
            @"locale" : [JRCaptureData sharedCaptureData].captureLocale,
            @"flow" : [JRCaptureData sharedCaptureData].captureFlowName,
            @"flow_version" : [JRCaptureData sharedCaptureData].downloadedFlowVersion
    };

    [JRConnectionManager jsonRequestToUrl:refreshUrl params:params completionHandler:^(id r, NSError *e)
    {
        if (e)
        {
            ALog(@"Failure refreshing access token: %@", e);
            if ([delegate respondsToSelector:@selector(refreshAccessTokenDidFailWithError:context:)]){
                [delegate refreshAccessTokenDidFailWithError:e context:context];
            }
            return;
        }

        if ([@"ok" isEqual:[r objectForKey:@"stat"]])
        {
            [JRCaptureData setAccessToken:[r objectForKey:@"access_token"]];
            DLog(@"refreshed access token");
            if ([delegate respondsToSelector:@selector(refreshAccessTokenDidSucceedWithContext:)]){
                [delegate refreshAccessTokenDidSucceedWithContext:context];
            }
        }
        else
        {
            if ([delegate respondsToSelector:@selector(refreshAccessTokenDidFailWithError:context:)]){
                [delegate refreshAccessTokenDidFailWithError:
                        [JRCaptureError errorFromResult:r onProvider:nil engageToken:nil] context:context];
            }
        }
    }];
}

+ (void)startForgottenPasswordRecoveryForField:(NSString *)fieldValue
                                      delegate:(id <JRCaptureDelegate>)delegate {
    JRCaptureData *data = [JRCaptureData sharedCaptureData];
    NSString *url = [NSString stringWithFormat:@"%@/oauth/forgot_password_native", data.captureBaseUrl];
    NSString *fieldName = [data getForgottenPasswordFieldName];
 
    if (!fieldValue) {
        JRCaptureError *captureError =
                [JRCaptureError invalidArgumentErrorWithParameterName:@"fieldValue"];
        if ([delegate respondsToSelector:@selector(forgottenPasswordRecoveryDidFailWithError:)]){
            [delegate forgottenPasswordRecoveryDidFailWithError:captureError];
        }
        return;
    }

    if (!data.captureForgottenPasswordFormName) {
        JRCaptureError *captureError =
            [JRCaptureError invalidArgumentErrorWithParameterName:@"forgottenPasswordFormName"];
        if ([delegate respondsToSelector:@selector(forgottenPasswordRecoveryDidFailWithError:)]){
            [delegate forgottenPasswordRecoveryDidFailWithError:captureError];
        }
        return;
    }

    NSDictionary *params = @{
            @"client_id" : data.clientId,
            @"locale" : data.captureLocale,
            @"response_type" : @"token",
            @"redirect_uri" : data.redirectUri,
            @"form" : data.captureForgottenPasswordFormName,
            @"flow" : data.captureFlowName,
            @"flow_version" : data.downloadedFlowVersion,
            fieldName : fieldValue
    };

    NSURLRequest *request = [NSMutableURLRequest JR_requestWithURL:[NSURL URLWithString:url] params:params];

    [self startURLConnectionWithRequest:request
                               delegate:delegate
                              onSuccess:@selector(forgottenPasswordRecoveryDidSucceed)
                              onFailure:@selector(forgottenPasswordRecoveryDidFailWithError:)
                                message:@"initiating account forgotten password flow"
                  extraOnSuccessHandler:nil];
}

+ (void)resendVerificationEmail:(NSString *)emailAddress delegate:(id <JRCaptureDelegate>)delegate {

    JRCaptureData *data = [JRCaptureData sharedCaptureData];
    NSString *formName = data.resendEmailVerificationFormName;

    void(^dispatchInvalidArgument)(NSString *) = ^(NSString *description) {
        if ([delegate respondsToSelector:@selector(forgottenPasswordRecoveryDidFailWithError:)]){
            [delegate forgottenPasswordRecoveryDidFailWithError:[JRCaptureError invalidArgumentErrorWithParameterName:description]];
        };
    };
    if (!emailAddress) {
        dispatchInvalidArgument(@"emailAddress");
        return;
    }
    if (!formName) {
        dispatchInvalidArgument(@"resendEmailVerificationFormName");
        return;
    }

    NSString *fieldName = [data.captureFlow userIdentifyingFieldForForm:formName];

    JRCaptureUIRequestBuilder *requestBuilder = [[JRCaptureUIRequestBuilder alloc] initWithEnvironment:data];
    NSURLRequest *request = [requestBuilder requestWithParams:@{ fieldName : emailAddress } form:formName];

    [self startURLConnectionWithRequest:request
                               delegate:delegate
                              onSuccess:@selector(resendVerificationEmailDidSucceed)
                              onFailure:@selector(resendVerificationEmailDidFailWithError:)
                                message:@"resending email verification"
                  extraOnSuccessHandler:nil];
}

+ (void)startURLConnectionWithRequest:(NSURLRequest *)request
                             delegate:(id <JRCaptureDelegate>)delegate
                            onSuccess:(SEL)successSelector
                            onFailure:(SEL)failureSelector
                              message:(NSString *)message
                extraOnSuccessHandler:(void(^)(id parsedResponse))extraOnSuccessHandler {
    void(^handler)(id, NSError *) = ^(id result, NSError *error) {
        if (error) {
            ALog("Failure %@: %@", message, error);
            if (failureSelector && [delegate respondsToSelector:failureSelector]){
                NSMethodSignature *propSignature = [[delegate class] instanceMethodSignatureForSelector:failureSelector];
                NSInvocation *propInvoker = [NSInvocation invocationWithMethodSignature:propSignature];
                if (!propSignature || !propInvoker)
                {
                    DLog(@"ERROR! Selector %@ not found", NSStringFromSelector(failureSelector));
                }
                [propInvoker setSelector:failureSelector];
                [propInvoker setTarget:delegate];
                [propInvoker setArgument:&error atIndex:2 /*yes, that's right. 2 is the first arg*/];
                [propInvoker invoke];
            }
        } else if (![result isKindOfClass:[NSDictionary class]]) {
            JRCaptureError *captureError = [JRCaptureError invalidApiResponseErrorWithObject:result];
            if (failureSelector){
                NSMethodSignature *propSignature = [[delegate class] instanceMethodSignatureForSelector:failureSelector];
                NSInvocation *propInvoker = [NSInvocation invocationWithMethodSignature:propSignature];
                if (!propSignature || !propInvoker)
                {
                    DLog(@"ERROR! Selector %@ not found", NSStringFromSelector(failureSelector));
                }
                [propInvoker setSelector:failureSelector];
                [propInvoker setTarget:delegate];
                [propInvoker setArgument:&captureError atIndex:2 /*yes, that's right. 2 is the first arg*/];
                [propInvoker invoke];
            }
        } else if ([result JR_isOKStatus]) {
            DLog(@"Success %@", message);
            if (extraOnSuccessHandler) extraOnSuccessHandler(result);
            if (successSelector){
                NSMethodSignature *propSignature = [[delegate class] instanceMethodSignatureForSelector:successSelector];
                NSInvocation *propInvoker = [NSInvocation invocationWithMethodSignature:propSignature];
                if (!propSignature || !propInvoker)
                {
                    DLog(@"ERROR! Selector %@ not found", NSStringFromSelector(successSelector));
                }
                [propInvoker setSelector:successSelector];
                [propInvoker setTarget:delegate];
                [propInvoker invoke];
            }
        } else {
            JRCaptureError *captureError = [JRCaptureError errorFromResult:result onProvider:nil engageToken:nil];
            if (failureSelector){
                NSMethodSignature *propSignature = [[delegate class] instanceMethodSignatureForSelector:failureSelector];
                NSInvocation *propInvoker = [NSInvocation invocationWithMethodSignature:propSignature];
                if (!propSignature || !propInvoker)
                {
                    DLog(@"ERROR! Selector %@ not found", NSStringFromSelector(failureSelector));
                }
                [propInvoker setSelector:failureSelector];
                [propInvoker setTarget:delegate];
                [propInvoker setArgument:&captureError atIndex:2 /*yes, that's right. 2 is the first arg*/];
                [propInvoker invoke];
            }
        }
    };

    [JRConnectionManager startURLConnectionWithRequest:request completionHandler:handler];
}

+(void)startAccountUnLinking:(id<JRCaptureDelegate>)delegate
        forProfileIdentifier:(NSString *)identifier {
    
    JRCaptureData *data = [JRCaptureData sharedCaptureData];
    NSString *url = [NSString stringWithFormat:@"%@/entity", data.captureBaseUrl];
    NSDictionary *params = @{
                             @"access_token" : [data accessToken]
                             };

    NSURLRequest *request = [NSMutableURLRequest JR_requestWithURL:[NSURL URLWithString:url] params:params];

    void(^successHandler)(id) = ^(id result) {
        if(![JRCaptureUser hasPasswordField:[result valueForKey:@"result"]] &&
           ([[JRCaptureData getLinkedProfiles] count] == 1)) {
            NSString *errorString = @"At least one profile should be must on a Social Sign-in Account.";
            if ([delegate respondsToSelector:@selector(accountUnlinkingDidFailWithError:)]){
                [delegate accountUnlinkingDidFailWithError:[JRCaptureError invalidInternalStateErrorWithDescription:errorString]];
            }
            return;
        }else {
            [JRCapture startActualAccountUnLinking:delegate
                              forProfileIdentifier:identifier];
        }
    };

    [self startURLConnectionWithRequest:request
                               delegate:delegate
                              onSuccess:nil
                              onFailure:@selector(accountUnlinkingDidFailWithError:)
                                message:@"initiating account unlinking flow"
                  extraOnSuccessHandler:successHandler];
}

+ (NSString *)utcTimeString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}

+ (NSString *)base64SignatureForRefreshWithDate:(NSString *)dateString refreshSecret:(NSString *)refreshSecret
                                    accessToken:(NSString *)accessToken
{
    if (!refreshSecret) return nil;
    NSString *stringToSign = [NSString stringWithFormat:@"refresh_access_token\n%@\n%@\n", dateString, accessToken];

    const char *cKey  = [refreshSecret cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [stringToSign cStringUsingEncoding:NSASCIIStringEncoding];

    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];

    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);

    return [[[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)] JRBase64EncodedString];
}

+ (void)registerNewUser:(JRCaptureUser *)newUser socialRegistrationToken:(NSString *)socialRegistrationToken
            forDelegate:(id <JRCaptureDelegate>)delegate
{
    if (!newUser)
    {
        if ([delegate respondsToSelector:@selector(registerUserDidFailWithError:)]){
            [delegate registerUserDidFailWithError:[JRCaptureError invalidArgumentErrorWithParameterName:@"newUser"]];
        }
        return;
    }

    JRCaptureData *config = [JRCaptureData sharedCaptureData];
    NSString *registrationForm = socialRegistrationToken ?
            config.captureSocialRegistrationFormName : config.captureTraditionalRegistrationFormName;
    NSMutableDictionary *params = [newUser toFormFieldsForForm:registrationForm withFlow:config.captureFlow];
    NSString *refreshSecret = [JRCaptureData generateAndStoreRefreshSecret];

    if (!refreshSecret)
    {
        if ([delegate respondsToSelector:@selector(registerUserDidFailWithError:)]){
            [delegate registerUserDidFailWithError:[JRCaptureError invalidInternalStateErrorWithDescription:@"unable to generate secure "
                    "random refresh secret"]];
        }
        return;
    }

    [params addEntriesFromDictionary:@{
            @"client_id" : config.clientId,
            @"locale" : config.captureLocale,
            @"response_type" : [config responseType:delegate],
            @"redirect_uri" : [config redirectUri],
            @"flow" : config.captureFlowName,
            @"form" : registrationForm,
            @"refresh_secret" : refreshSecret,
    }];

    if ([config downloadedFlowVersion]) [params setObject:[config downloadedFlowVersion] forKey:@"flow_version"];

    NSString *urlString;
    if (socialRegistrationToken)
    {
        [params setObject:socialRegistrationToken forKey:@"token"];
        urlString = [NSString stringWithFormat:@"%@/oauth/register_native", config.captureBaseUrl];
    }
    else
    {
        urlString = [NSString stringWithFormat:@"%@/oauth/register_native_traditional", config.captureBaseUrl];
    }

    [JRConnectionManager jsonRequestToUrl:urlString params:params completionHandler:^(id parsedResponse, NSError *e)
    {
        [self handleRegistrationResponse:parsedResponse orError:e delegate:delegate];
    }];
}

+ (void)handleRegistrationResponse:(id)parsedResponse orError:(NSError *)e
                          delegate:(id <JRCaptureDelegate>)delegate
{
    NSString *accessToken;
    if (e || ![parsedResponse isKindOfClass:[NSDictionary class]]) {
        if (!e) e = [JRCaptureError invalidApiResponseErrorWithObject:parsedResponse];
    }

    if (!e && ![[parsedResponse objectForKey:@"stat"] isEqual:@"ok"]) {
        e = [JRCaptureError errorFromResult:parsedResponse onProvider:nil engageToken:nil];
    }

    if (!e && !(accessToken = [parsedResponse objectForKey:@"access_token"])) {
        e = [JRCaptureError invalidApiResponseErrorWithObject:parsedResponse];
    }

    if (e) {
        ALog(@"%@", e);
        if ([delegate respondsToSelector:@selector(registerUserDidFailWithError:)]){
            [delegate registerUserDidFailWithError:e];
        }
        return;
    }

    NSString *authorizationCode = [parsedResponse objectForKey:@"authorization_code"];

    void (^handler)(id, NSError *) = ^(id entityResponse, NSError *e_) {
        if (e_ || ![entityResponse isKindOfClass:[NSDictionary class]] ||
                ![@"ok" isEqual:[entityResponse objectForKey:@"stat"]] ||
                ![entityResponse objectForKey:@"result"]
        ) {
            if (!e_) e_ = [JRCaptureError invalidApiResponseErrorWithObject:entityResponse];
            ALog(@"%@", e);
            if ([delegate respondsToSelector:@selector(registerUserDidFailWithError:)]){
                [delegate registerUserDidFailWithError:e_];
            }
            return;
        }

        JRCaptureUser *newUser =
            [JRCaptureUser captureUserObjectFromDictionary:[entityResponse objectForKey:@"result"]];
        [self setAccessToken:accessToken];
        NSArray *linkedProfile = [[entityResponse objectForKey:@"result"] valueForKey:@"profiles"];
        [JRCaptureData setLinkedProfiles:linkedProfile];
        if ([delegate respondsToSelector:@selector(registerUserDidSucceed:)]){
            [delegate registerUserDidSucceed:newUser];
        }

        if (authorizationCode) {
            if ([delegate respondsToSelector:@selector(captureDidSucceedWithCode:)]){
                [delegate captureDidSucceedWithCode:authorizationCode];
            }
        }
    };

    NSString *entityUrl = [NSString stringWithFormat:@"%@/entity", [JRCaptureData sharedCaptureData].captureBaseUrl];
    [JRConnectionManager jsonRequestToUrl:entityUrl params:@{@"access_token" : accessToken} completionHandler:handler];
}

+ (void)updateProfileForUser:(JRCaptureUser *)user delegate:(id <JRCaptureDelegate>)delegate
{
    if (!user && [delegate respondsToSelector:@selector(updateUserProfileDidFailWithError:)]){
        [delegate updateUserProfileDidFailWithError:[JRCaptureError invalidArgumentErrorWithParameterName:@"user"]];
    }

    JRCaptureData *data = [JRCaptureData sharedCaptureData];
    NSString *editProfileForm = data.captureEditProfileFormName;

    if (!editProfileForm) {
        [NSException raiseJRDebugException:@"JRCaptureMissingParameterException"
                                    format:@"Missing editProfileFormName configuration option"];
    }
    NSMutableDictionary *params = [user toFormFieldsForForm:editProfileForm withFlow:data.captureFlow];

    [params addEntriesFromDictionary:@{
            @"client_id" : data.clientId,
            @"access_token" : data.accessToken,
            @"locale" : data.captureLocale,
            @"form" : editProfileForm,
            @"flow" : data.captureFlowName,
    }];

    if ([data downloadedFlowVersion]) {
        [params setObject:[data downloadedFlowVersion] forKey:@"flow_version"];
    }

    NSString *url = [NSString stringWithFormat:@"%@/oauth/update_profile_native", data.captureBaseUrl];
    NSURLRequest *request = [NSMutableURLRequest JR_requestWithURL:[NSURL URLWithString:url] params:params];

    [self startURLConnectionWithRequest:request
                               delegate:delegate
                              onSuccess:@selector(updateUserProfileDidSucceed)
                              onFailure:@selector(updateUserProfileDidFailWithError:)
                                message:@"updating user profile"
                  extraOnSuccessHandler:nil];
}

+ (void)updateProfileForUserWithForm:(JRCaptureUser *)user
                            withEditProfileForm:(NSString *)formName
                            delegate:(id <JRCaptureDelegate>)delegate
{
    if (!user && [delegate respondsToSelector:@selector(updateUserProfileDidFailWithError:)]){
        [delegate updateUserProfileDidFailWithError:[JRCaptureError invalidArgumentErrorWithParameterName:@"user"]];
    }
    
    JRCaptureData *data = [JRCaptureData sharedCaptureData];
    
    if (!formName) {
        [NSException raiseJRDebugException:@"JRCaptureMissingParameterException"
                                    format:@"Missing editProfileFormName configuration option"];
    }
    NSMutableDictionary *params = [user toFormFieldsForForm:formName withFlow:data.captureFlow];
    
    [params addEntriesFromDictionary:@{
                                       @"client_id" : data.clientId,
                                       @"access_token" : data.accessToken,
                                       @"locale" : data.captureLocale,
                                       @"form" : formName,
                                       @"flow" : data.captureFlowName,
                                       }];
    
    if ([data downloadedFlowVersion]) {
        [params setObject:[data downloadedFlowVersion] forKey:@"flow_version"];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/oauth/update_profile_native", data.captureBaseUrl];
    NSURLRequest *request = [NSMutableURLRequest JR_requestWithURL:[NSURL URLWithString:url] params:params];
    
    [self startURLConnectionWithRequest:request
                               delegate:delegate
                              onSuccess:@selector(updateUserProfileDidSucceed)
                              onFailure:@selector(updateUserProfileDidFailWithError:)
                                message:[NSString stringWithFormat:@"updating user profile with form name: %@", formName]
                  extraOnSuccessHandler:nil];
}

+ (void)postFormWithFormDataProvided:(JRCaptureUser *)user
                   toCaptureEndpoint:(NSString *)endpointUrl
                        withFormName:(NSString *)formName
                        andFieldData:(NSMutableDictionary *)fieldData
                            delegate:(id <JRCaptureDelegate>)delegate
{
    if (!user && [delegate respondsToSelector:@selector(updateUserProfileDidFailWithError:)]){
        [delegate updateUserProfileDidFailWithError:[JRCaptureError invalidArgumentErrorWithParameterName:@"user"]];
    }
    
    JRCaptureData *data = [JRCaptureData sharedCaptureData];
    
    if (!endpointUrl) {
        [NSException raiseJRDebugException:@"JRCaptureMissingParameterException"
                                    format:@"Missing toCaptureEndpoint configuration option"];
    }
    
    if (!formName) {
        [NSException raiseJRDebugException:@"JRCaptureMissingParameterException"
                                    format:@"Missing withFormName configuration option"];
    }
    
    if ([fieldData count] == 0) {
        [NSException raiseJRDebugException:@"JRCaptureMissingParameterException"
                                    format:@"andFieldData configuration option is empty"];
    }
    
    [fieldData addEntriesFromDictionary:@{
                                       @"client_id" : data.clientId,
                                       @"access_token" : data.accessToken,
                                       @"locale" : data.captureLocale,
                                       @"form" : formName,
                                       @"flow" : data.captureFlowName,
                                       }];
    
    if ([data downloadedFlowVersion]) {
        [fieldData setObject:[data downloadedFlowVersion] forKey:@"flow_version"];
    }
    NSString *url = [NSString stringWithFormat:@"%@%@", data.captureBaseUrl, endpointUrl];
    NSURLRequest *request = [NSMutableURLRequest JR_requestWithURL:[NSURL URLWithString:url] params:fieldData];
    
    [self startURLConnectionWithRequest:request
                               delegate:delegate
                              onSuccess:@selector(updateUserProfileDidSucceed)
                              onFailure:@selector(updateUserProfileDidFailWithError:)
                                message:[NSString stringWithFormat:@"Posting provided form field data to Capture endpoint: %@ form name: %@", url, formName]
                  extraOnSuccessHandler:nil];
}

- (void)dealloc
{
}

+ (void)startEngageSignInForDelegate:(id <JRCaptureDelegate>)delegate
{
    [JRCapture startEngageSignInDialogForDelegate:delegate];
}

+(void)startAccountLinkingSignInDialogForDelegate:(id<JRCaptureDelegate>)delegate
                                forAccountLinking:(BOOL)linkAccount
                                  withRedirectUri:(NSString *)redirectUri
{
    [JREngageWrapper startAuthenticationDialogWithTraditionalSignIn:JRTraditionalSignInNone
                                        andCustomInterfaceOverrides:nil
                                                        forDelegate:delegate
                                                  forAccountLinking:YES
                                                    withRedirectUri:redirectUri];
}

+ (void)startLinkNewAccountFordelegate:(id<JRCaptureDelegate>)delegate
                           redirectUri:(NSString *)redirectUri
                          withAuthInfo:(NSDictionary *)authInfo
{
    JRCaptureData *data = [JRCaptureData sharedCaptureData];
    NSString *url = [NSString stringWithFormat:@"%@/oauth/link_account_native", data.captureBaseUrl];
    if (!redirectUri) redirectUri = data.captureRedirectUri;
    if (!redirectUri) {
        JRCaptureError *captureError =
        [JRCaptureError invalidArgumentErrorWithParameterName:@"redirectUri"];
        if ([delegate respondsToSelector:@selector(linkNewAccountDidFailWithError:)]){
            [delegate linkNewAccountDidFailWithError:captureError];
        }
        [NSException raiseJRDebugException:@"JRCaptureMissingParameterException"
                                    format:@"Missing argument/setting redirectUri"];
        return;
    }
    
    NSDictionary *params = @{
                             @"client_id" : data.clientId,
                             @"locale" : data.captureLocale,
                             @"response_type" : @"token",
                             @"redirect_uri" : redirectUri,
                             @"access_token" : [data accessToken], //Capture From currently logged in user
                             @"token" :[authInfo valueForKey:@"token"], //Engage Token From New Linked Account
                             @"flow" :data.captureFlowName,
                             @"flow_version" :data.downloadedFlowVersion
                             };

    NSURLRequest *request = [NSMutableURLRequest JR_requestWithURL:[NSURL URLWithString:url] params:params];

    void(^successHandler)(id) = ^(id result) {
             DLog(@"Link account Flow started successfully");
             NSString *url = [NSString stringWithFormat:@"%@/entity", data.captureBaseUrl];
             NSDictionary *params = @{
                                      @"access_token" : [data accessToken]
                                      };
             
             [JRConnectionManager jsonRequestToUrl:url params:params completionHandler:^(id result, NSError *error) {
                 if (error) {
                     ALog("Failure: Failed to fetch linked accounts after linking: %@", error);
                     if ([delegate respondsToSelector:@selector(linkNewAccountDidFailWithError:)]){
                         [delegate linkNewAccountDidFailWithError:error];
                     }
                 } else if ([@"ok" isEqual:[result objectForKey:@"stat"]]) {
                      DLog(@"Success: Fetched the linked accounts & updated Capture object successfully");
                     [JRCaptureData setLinkedProfiles:[[result valueForKey:@"result"] valueForKey:@"profiles"]];
                     if ([delegate respondsToSelector:@selector(linkNewAccountDidSucceed)]){
                         [delegate linkNewAccountDidSucceed];
                     }
                 } else {
                     JRCaptureError *captureError = [JRCaptureError errorFromResult:result onProvider:nil engageToken:nil];
                     if ([delegate respondsToSelector:@selector(linkNewAccountDidFailWithError:)]){
                         [delegate linkNewAccountDidFailWithError:captureError];
                     }
                 }
             }];
    };
    [self startURLConnectionWithRequest:request
                               delegate:delegate
                              onSuccess:nil
                              onFailure:@selector(linkNewAccountDidFailWithError:)
                                message:@"initiating account linking flow"
                  extraOnSuccessHandler:successHandler];
}

+ (void)startActualAccountUnLinking:(id <JRCaptureDelegate>)delegate forProfileIdentifier:(NSString *)identifier {
    
    JRCaptureData *data = [JRCaptureData sharedCaptureData];
    
    NSString *url = [NSString stringWithFormat:@"%@/oauth/unlink_account_native", data.captureBaseUrl];
    NSDictionary *params = @{
                             @"client_id" : data.clientId,
                             @"locale" : data.captureLocale,
                             @"identifier_to_remove" : identifier,
                             @"access_token" : data.accessToken,
                             @"flow": data.captureFlowName,
                             @"flow_version": data.downloadedFlowVersion
                             };

    NSURLRequest *request = [NSMutableURLRequest JR_requestWithURL:[NSURL URLWithString:url] params:params];

    void(^successHandler)(id) = ^(id result) {
        DLog(@"Account Unlinking flow started successfully");

        if( [[JRCaptureData getLinkedProfiles] count] ) {
            NSMutableArray *updateProfiles = [[NSMutableArray alloc]init];
            for(NSDictionary *dict in [JRCaptureData getLinkedProfiles] ) {
                if(![[dict valueForKey:@"identifier"] isEqualToString:identifier]) {
                    [updateProfiles addObject:dict];
                }
            }
            [JRCaptureData setLinkedProfiles:updateProfiles];
        }
        if ([delegate respondsToSelector:@selector(accountUnlinkingDidSucceed)]){
            [delegate accountUnlinkingDidSucceed];
        }
    };

    [self startURLConnectionWithRequest:request
                               delegate:delegate
                              onSuccess:nil
                              onFailure:@selector(accountUnlinkingDidFailWithError:)
                                message:@"initiating account unlinking flow"
                  extraOnSuccessHandler:successHandler];
}



@end
