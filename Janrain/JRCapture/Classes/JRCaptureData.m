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
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "debug_log.h"
#import "JRCaptureData.h"
#import "SFHFKeychainUtils.h"
#import "JRCaptureConfig.h"
#import "NSDictionary+JRQueryParams.h"
#import "JREngageWrapper.h"
#import "JRCaptureFlow.h"
#import "JRCaptureError.h"
#import "JRCapture.h"

#define cJRCaptureKeychainIdentifier @"capture_tokens.janrain"
#define cJRCaptureKeychainUserName @"capture_user"

@implementation NSString (JRString_UrlWithDomain)
- (NSString *)urlStringFromBaseDomain
{
    if ([self hasPrefix:@"https://"])
        return self;

    if ([self hasPrefix:@"http://"])
        return [self stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];

    return [@"https://" stringByAppendingString:self];
}
@end

static NSString*appBundleDisplayNameAndIdentifier()
{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *name = [infoPlist objectForKey:@"CFBundleDisplayName"];
    NSString *identifier = [infoPlist objectForKey:@"CFBundleIdentifier"];

    return [NSString stringWithFormat:@"%@.%@", name, identifier];
}

typedef enum
{
    JRTokenTypeAccess,
    JRTokenTypeRefresh,
} JRTokenType;

static NSString *const FLOW_KEY = @"JR_capture_flow";

@interface JRCaptureData ()

@property(nonatomic) NSString *accessToken;
@property(nonatomic) NSString *refreshSecret;

@property(nonatomic) NSString *captureBaseUrl;
@property(nonatomic) NSString *clientId;
@property(nonatomic) NSString *captureAppId;
@property(nonatomic) NSString *captureRedirectUri;
@property(nonatomic) NSString *passwordRecoverUri;

@property(nonatomic) NSString *captureFlowName;
@property(nonatomic) NSString *captureFlowVersion;
@property(nonatomic) NSString *captureLocale;
@property(nonatomic) NSString *captureTraditionalSignInFormName;
@property(nonatomic) NSString *captureTraditionalRegistrationFormName;
@property(nonatomic) NSString *captureSocialRegistrationFormName;
@property(nonatomic) NSString *captureForgottenPasswordFormName;
@property(nonatomic) NSString *captureEditProfileFormName;
@property(nonatomic) NSString *resendEmailVerificationFormName;

//@property(nonatomic) JRTraditionalSignInType captureTradSignInType;
@property(nonatomic) BOOL captureEnableThinRegistration;

@property(nonatomic) NSString *downloadFlowUrl;
@property(nonatomic) NSString *engageAppUrl;

@property(nonatomic) JRCaptureFlow *captureFlow;
@property(nonatomic) NSArray *linkedProfiles;
@property(nonatomic) BOOL initialized;
@property(nonatomic) BOOL socialSignMode;
@end

@implementation JRCaptureData
static JRCaptureData *singleton = nil;

@synthesize clientId;
@synthesize captureBaseUrl;
@synthesize accessToken;
@synthesize refreshSecret;
@synthesize captureLocale;
@synthesize captureTraditionalSignInFormName;
//@synthesize captureTradSignInType;
@synthesize captureFlowName;
@synthesize captureTraditionalRegistrationFormName;
@synthesize captureSocialRegistrationFormName;
@synthesize captureForgottenPasswordFormName;
@synthesize captureEditProfileFormName;
@synthesize resendEmailVerificationFormName;
@synthesize captureFlowVersion;
@synthesize captureAppId;
@synthesize captureFlow;
@synthesize captureRedirectUri;
@synthesize downloadFlowUrl;
@synthesize engageAppUrl;

- (JRCaptureData *)init
{
    if ((self = [super init]))
    {
        self.accessToken = [self readTokenForTokenName:@"access_token"];
        self.refreshSecret = [self readTokenForTokenName:@"refresh_secret"];
    }

    return self;
}

- (NSString *)readTokenForTokenName:(NSString *)tokenName
{
    return [SFHFKeychainUtils getPasswordForUsername:cJRCaptureKeychainUserName
                                      andServiceName:[JRCaptureData serviceNameForTokenName:tokenName]
                                               error:nil];
}

+ (JRCaptureData *)sharedCaptureData
{
    if (singleton == nil)
    {
        singleton = [((JRCaptureData*)[super allocWithZone:NULL]) init];
    }

    return singleton;
}

+ (NSArray *)getLinkedProfiles {
    if(singleton) {
        return [singleton linkedProfiles];
    }
    return nil;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedCaptureData];
}

- (id)copyWithZone:(__unused NSZone *)zone __unused
{
    return self;
}

+ (NSString *)captureTokenUrlWithMergeToken:(NSString *)mergeToken
                          delegate:(id)delegate {
    return [self captureTokenUrlWithMergeToken:mergeToken forAccountLinking:NO delegate:delegate];
}

+ (NSString *)captureTokenUrlWithMergeToken:(NSString *)mergeToken
                          forAccountLinking:(BOOL)linkAccount
                                   delegate:(id)delegate {
    JRCaptureData *captureData = [JRCaptureData sharedCaptureData];
    
    NSString *redirectUri = [singleton redirectUri];
    NSString *thinReg = [JRCaptureData sharedCaptureData].captureEnableThinRegistration ? @"true" : @"false";
    NSMutableDictionary *urlArgs = [NSMutableDictionary dictionaryWithDictionary:
            @{
                    @"client_id" : captureData.clientId,
                    @"locale" : captureData.captureLocale,
                    @"response_type" : [captureData responseType:delegate],
                    @"redirect_uri" : redirectUri,
                    @"thin_registration" : thinReg
            }];
    
    if (!linkAccount) [urlArgs setObject:[self generateAndStoreRefreshSecret] forKey:@"refresh_secret"];
    if (captureData.captureFlowName) [urlArgs setObject:captureData.captureFlowName forKey:@"flow"];
    if ([captureData downloadedFlowVersion])
        [urlArgs setObject:[captureData downloadedFlowVersion] forKey:@"flow_version"];
    if (mergeToken) [urlArgs setObject:mergeToken forKey:@"merge_token"];
    if (captureData.captureSocialRegistrationFormName)
    {
        [urlArgs setObject:captureData.captureSocialRegistrationFormName forKey:@"registration_form"];
    }

    NSString *getParams = [urlArgs asJRURLParamString];
    return [NSString stringWithFormat:@"%@/oauth/auth_native?%@", captureData.captureBaseUrl, getParams];
}

+ (NSString *)generateAndStoreRefreshSecret
{
    #define RANDOM_BYTES 20

    uint8_t refreshSecret_[RANDOM_BYTES];
    int errCode = SecRandomCopyBytes(kSecRandomDefault, RANDOM_BYTES, refreshSecret_);
    if (errCode)
    {
        ALog(@"UNABLE TO GENERATE RANDOM REFRESH SECRET. ERRNO: %d", errno);
        return nil;
    }

    NSMutableString *buffer = [NSMutableString string];
    for (int i=0; i<RANDOM_BYTES; i++) [buffer appendFormat:@"%02hhx", refreshSecret_[i]];
    [buffer replaceCharactersInRange:NSMakeRange(0, 1) withString:@"a"];

    [JRCaptureData saveNewToken:[NSString stringWithString:buffer] ofType:JRTokenTypeRefresh];
    return [JRCaptureData sharedCaptureData].refreshSecret;
}

- (NSString *)downloadedFlowVersion
{
    id version = [captureFlow objectForKey:@"version"];
    if ([version isKindOfClass:[NSString class]]) return version;
    ALog(@"Error parsing flow version: %@", version);
    return nil;
}

- (NSString *)redirectUri
{
    if (captureRedirectUri) return captureRedirectUri;
    return [NSString stringWithFormat:@"%@", singleton.captureBaseUrl];
}

+ (void)setCaptureConfig:(JRCaptureConfig *)config
{
    JRCaptureData *captureDataInstance = [JRCaptureData sharedCaptureData];
    if (captureDataInstance.initialized)
    {
        [NSException raiseJRDebugException:@"JRCaptureDuplicateInitializationException" format:@"Repeated "
                "initialization of JRCapture is unsafe"];
    }
    captureDataInstance.initialized = YES;
    captureDataInstance.captureBaseUrl = [config.captureDomain urlStringFromBaseDomain];
    captureDataInstance.clientId = config.captureClientId;
    captureDataInstance.captureLocale = config.captureLocale;
    captureDataInstance.captureTraditionalSignInFormName = config.captureSignInFormName;
    captureDataInstance.captureFlowName = config.captureFlowName;
    captureDataInstance.captureEnableThinRegistration = config.enableThinRegistration;
    captureDataInstance.captureTraditionalRegistrationFormName = config.captureTraditionalRegistrationFormName;
    captureDataInstance.captureSocialRegistrationFormName = config.captureSocialRegistrationFormName;
    captureDataInstance.captureFlowVersion = config.captureFlowVersion;
    captureDataInstance.captureAppId = config.captureAppId;
    captureDataInstance.captureForgottenPasswordFormName = config.forgottenPasswordFormName;
    captureDataInstance.captureEditProfileFormName = config.editProfileFormName;
    captureDataInstance.resendEmailVerificationFormName = config.resendEmailVerificationFormName;
    captureDataInstance.downloadFlowUrl = config.downloadFlowUrl;
    captureDataInstance.engageAppUrl = config.engageAppUrl;

    if ([captureDataInstance.captureLocale length] &&
            [captureDataInstance.captureFlowName length] && [captureDataInstance.captureAppId length])
    {
        [captureDataInstance loadFlow];
        [captureDataInstance downloadFlow];
    }
}

- (void)loadFlow
{
    NSDictionary *flowDict =
            [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:FLOW_KEY]];
    self.captureFlow = [JRCaptureFlow flowWithDictionary:flowDict];
}

- (NSString *)getForgottenPasswordFieldName {
    if (!self.captureForgottenPasswordFormName) {
        [NSException raiseJRDebugException:@"JRCaptureMissingParameterException"
                                    format:@"Missing capture configuration setting forgottenPasswordFormName"];
    }

    return [self.captureFlow userIdentifyingFieldForForm:self.captureForgottenPasswordFormName];
}

- (void)downloadFlow
{
    NSString *flowVersion = self.captureFlowVersion ? self.captureFlowVersion : @"HEAD";

    NSString *flowUrlString = @"";
    
    if (self.downloadFlowUrl.length > 0){
        flowUrlString = [NSString stringWithFormat:@"https://%@/widget_data/flows/%@/%@/%@/%@.json",
                         self.downloadFlowUrl,
                         self.captureAppId, self.captureFlowName,
                         flowVersion, self.captureLocale];
    }else{
        flowUrlString = [NSString stringWithFormat:@"https://%@.cloudfront.net/widget_data/flows/%@/%@/%@/%@.json",
                         self.flowUsesTestingCdn ? @"dlzjvycct5xka" : @"d1lqe9temigv1p",
                         self.captureAppId, self.captureFlowName, flowVersion,
                         self.captureLocale];
    }
    
    NSMutableURLRequest *downloadRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:flowUrlString]];
    [downloadRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:downloadRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable e) {
        /*
         * "Notification Centers" @ developer.apple.com
         * A notification center delivers notifications to observers synchronously. In other words,
         * when posting a notification, control does not return to the poster until all observers
         * have received and processed the notification. To send notifications asynchronously use
         * a notification queue, which is described in “Notification Queues.”
         */
        if (e)
        {
            ALog(@"Error downloading flow: %@", e);
            NSNotification *notification = [NSNotification notificationWithName:JRDownloadFlowResult object:e];
            [[NSNotificationQueue defaultQueue] enqueueNotification:notification postingStyle:NSPostWhenIdle];
            return;
        }
        DLog(@"Fetched flow URL: %@", flowUrlString);
        NSError *error = [self processFlow:data response:(NSHTTPURLResponse *) response];
        NSNotification *notification = [NSNotification notificationWithName:JRDownloadFlowResult object:error];
        [[NSNotificationQueue defaultQueue] enqueueNotification:notification postingStyle:NSPostWhenIdle];
    }];
    
    [task resume];
}

- (NSError *)processFlow:(NSData *)flowData response:(NSHTTPURLResponse *)response
{
    NSError *jsonErr = nil;
    NSObject *parsedFlow = [NSJSONSerialization JSONObjectWithData:flowData options:(NSJSONReadingOptions) 0
                                                             error:&jsonErr];

    if (jsonErr)
    {
        NSString *responseString = [NSHTTPURLResponse localizedStringForStatusCode:[response statusCode]];
        ALog(@"Error parsing flow JSON, response: %@", responseString);
        ALog(@"Error parsing flow JSON, err: %@", [jsonErr description]);
        return jsonErr;
    }
    
    if (![parsedFlow isKindOfClass:[NSDictionary class]])
    {
        NSString *errorMsg = [NSString stringWithFormat:@"Error parsing flow JSON, top level object was not a hash...: %@",
                        [parsedFlow description]];

        ALog(@"%@", errorMsg);
        JRCaptureError *error = [JRCaptureError errorWithErrorString:@"JSON Parsing Error"
                                                                code:JRCaptureErrorWhileParsingJson
                                                         description:errorMsg
                                                         extraFields:nil];
        return error;
    }

    self.captureFlow = [JRCaptureFlow flowWithDictionary:(NSDictionary *) parsedFlow];
    DLog(@"Parsed flow, version: %@", [self downloadedFlowVersion]);
    
    [self writeCaptureFlow];
    return nil;
}

- (void)writeCaptureFlow
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSKeyedArchiver archivedDataWithRootObject:[captureFlow dictionary]]
                                             forKey:FLOW_KEY];
}

+ (NSString *)serviceNameForTokenName:(NSString *)tokenName
{
    return [NSString stringWithFormat:@"%@.%@.%@.", cJRCaptureKeychainIdentifier, tokenName,
                     appBundleDisplayNameAndIdentifier()];
}

+ (void)deleteTokenNameFromKeychain:(NSString *)name
{
    [SFHFKeychainUtils deleteItemForUsername:cJRCaptureKeychainUserName
                              andServiceName:[JRCaptureData serviceNameForTokenName:name]
                                       error:nil];
}

+ (void)storeTokenInKeychain:(NSString *)token name:(NSString *)name
{
    NSError *error = nil;

    [SFHFKeychainUtils storeUsername:cJRCaptureKeychainUserName andPassword:token
                      forServiceName:[JRCaptureData serviceNameForTokenName:name]
                      updateExisting:YES error:&error];

    if (error)
    {
        ALog (@"Error storing device token in keychain: %@", [error localizedDescription]);
    }
}

+ (void)saveNewToken:(NSString *)token ofType:(JRTokenType)tokenType
{
    NSString *name = tokenType == JRTokenTypeAccess ? @"access_token" : @"refresh_secret";
    [JRCaptureData deleteTokenNameFromKeychain:name];

    if (tokenType == JRTokenTypeAccess)
    {
        [JRCaptureData sharedCaptureData].accessToken = token;
    }
    else if (tokenType == JRTokenTypeRefresh)
    {
        [JRCaptureData sharedCaptureData].refreshSecret = token;
    }

    [JRCaptureData storeTokenInKeychain:token name:name];
}

+ (void)setCaptureRedirectUri:(NSString *)captureRedirectUri
{
    [JRCaptureData sharedCaptureData].captureRedirectUri = captureRedirectUri;
}

+ (void)setAccessToken:(NSString *)token
{
    [JRCaptureData saveNewToken:token ofType:JRTokenTypeAccess];
}

+ (NSString *)captureBaseUrl __unused
{
    return [[JRCaptureData sharedCaptureData] captureBaseUrl];
}

+ (void)setCaptureClientId:(NSString*)captureClientId {
    [JRCaptureData sharedCaptureData].clientId = captureClientId;
}

+ (void)setCaptureBaseUrl:(NSString*)baseUrl {
    [JRCaptureData sharedCaptureData].captureBaseUrl = [baseUrl urlStringFromBaseDomain];
}

+ (NSString *)clientId __unused
{
    return [[JRCaptureData sharedCaptureData] clientId];
}

+ (void)clearSignInState
{
    [JRCaptureData deleteTokenNameFromKeychain:@"access_token"];
    [JRCaptureData deleteTokenNameFromKeychain:@"refresh_secret"];
    [JRCaptureData sharedCaptureData].accessToken = nil;
    [JRCaptureData sharedCaptureData].refreshSecret = nil;
}

+ (NSMutableURLRequest *)requestWithPath:(NSString *)path
{
    JRCaptureData *data = [JRCaptureData sharedCaptureData];
    NSString *urlString = [[data captureBaseUrl] stringByAppendingString:path];
    return [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
}

+ (void)setLinkedProfiles:(NSArray *)profileData {
    NSMutableArray *returnArray = [[NSMutableArray alloc]init];
    if([profileData count] > 0) {
        for(NSDictionary *dict in profileData) {
            
            NSDictionary *tempDict = @{
                   @"verifiedEmail" : ([dict objectForKey:@"verifiedEmail"] ? [dict objectForKey:@"verifiedEmail"] : @""),
                   @"identifier" : [dict objectForKey:@"identifier"],
            };
            [returnArray addObject:tempDict];
        }
    }
    [JRCaptureData sharedCaptureData].linkedProfiles = profileData;
}

- (NSString *)responseType:(id)delegate {
    SEL captureDidSucceedWithCode = sel_registerName("captureDidSucceedWithCode:");
    if ([delegate respondsToSelector:captureDidSucceedWithCode]) {
        return @"code_and_token";
    }
    return @"token";
}
@end
