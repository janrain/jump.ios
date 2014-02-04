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

 File:   JRSessionData.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Tuesday, June 1, 2010
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "debug_log.h"
#import "JRSessionData.h"
#import "JREngageError.h"
#import "JRUserInterfaceMaestro.h"
#import "JREngage+CustomInterface.h"
#import "JRJsonUtils.h"

static NSString *serverUrl = @"https://rpxnow.com";

#pragma mark consts
static NSString *const GET_CONFIGURATION_TAG = @"getConfiguration";
static NSString *const PREFS_KEY_ETAG = @"jrengage.sessionData.configurationEtag";
static NSString *const CONFIG_KEY_PROVIDER_INFO = @"provider_info";
static NSString *const CONFIG_KEY_BASEURL = @"baseurl";
static NSString *const CONFIG_KEY_SIGNIN_PROVIDERS = @"enabled_providers";
static NSString *const CONFIG_KEY_SHARING_PROVIDERS = @"social_providers";

#define cJRAuthenticatedUsersByProvider @"jrengage.sessionData.authenticatedUsersByProvider"
#define cJREngageProviders                 @"jrengage.sessionData.allProviders"
#define cJRAuthenticationProviders               @"jrengage.sessionData.basicProviders"
#define cJRSharingProviders              @"jrengage.sessionData.socialProviders"
#define cJRIconsStillNeeded             @"jrengage.sessionData.iconsStillNeeded"
#define cJRProvidersWithIcons           @"jrengage.sessionData.providersWithIcons"
#define cJRBaseUrl                      @"jrengage.sessionData.baseUrl"
#define cJRHidePoweredBy                @"jrengage.sessionData.hidePoweredBy"
#define cJRLastUsedSharingProvider       @"jrengage.sessionData.lastUsedSocialProvider"
#define cJRLastUsedAuthenticationProvider        @"jrengage.sessionData.lastUsedBasicProvider"

#define cJRUserDefaultsUuidName @"jrUserDefaultsUuidName"

#define cJREngageKeychainIdentifier     @"device_tokens.janrain"

#define cJRProviderName                     @"jrengage.provider.name"
#define cJRProviderFriendlyName             @"jrengage.provider.friendlyName"
#define cJRProviderPlaceholderText          @"jrengage.provider.placeholderText"
#define cJRProviderShortText                @"jrengage.provider.shortText"
#define cJRProviderOpenIdentifier           @"jrengage.provider.openIdentifier"
#define cJRProviderUrl                      @"jrengage.provider.url"
#define cJRProviderRequiresInput            @"jrengage.provider.requiresInput"
#define cJRProviderSharingProperties  @"jrengage.provider.socialSharingProperties"
#define cJRProviderCookieDomains            @"jrengage.provider.cookieDomains"
#define cJRProviderCustomUserAgentString    @"jrengage.provider.customUserAgentString"

#define cJRProviderUserInput     @"jrengage.provider.%@.userInput"
#define cJRProviderForceReauth   @"jrengage.provider.%@.forceReauth"

#define cJRUserProviderName      @"provider_name"
#define cJRUserPhoto             @"photo"
#define cJRUserDisplayName       @"display_name"
#define cJRUserPreferredUsername @"preferred_username"
#define cJRUserWelcomeString     @"welcome_string"

#pragma mark helper_functions
static NSString *applicationBundleDisplayNameAndIdentifier()
{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *name = [infoPlist objectForKey:@"CFBundleDisplayName"];
    NSString *bundleIdentifier = [infoPlist objectForKey:@"CFBundleIdentifier"];

    return [NSString stringWithFormat:@"%@.%@", name, bundleIdentifier];
}

static NSString *applicationBundleDisplayName()
{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    return [infoPlist objectForKey:@"CFBundleDisplayName"];
}

static void deleteWebViewCookiesForDomains(NSArray *domains)
{
    if (!domains) return;
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];

    NSArray* cookiesWithDomain;
    for (NSString *domain in domains)
    {
        /* http:// */
        NSString *domainBaseUrl = [NSString stringWithFormat:@"http://%@", domain];
        cookiesWithDomain = [cookies cookiesForURL:[NSURL URLWithString:domainBaseUrl]];
        for (NSHTTPCookie* cookie in cookiesWithDomain)
            [cookies deleteCookie:cookie];

        /* https:// */
        domainBaseUrl = [NSString stringWithFormat:@"https://%@", domain];
        cookiesWithDomain = [cookies cookiesForURL:[NSURL URLWithString:domainBaseUrl]];
        for (NSHTTPCookie* cookie in cookiesWithDomain)
            [cookies deleteCookie:cookie];
    }
}

#pragma mark JRActivityObject ()
@interface JRActivityObject (JRActivityObject_shortenedUrl)
@property (retain) NSString *shortenedUrl;
@end

@implementation JRActivityObject (JRActivityObject_shortenedUrl)
- (NSString *)shortenedUrl { return _shortenedUrl; }
- (void)setShortenedUrl:(NSString *)newUrl { [newUrl retain]; [_shortenedUrl release]; _shortenedUrl = newUrl; }
@end

#pragma mark JRAuthenticatedUser ()
@interface JRAuthenticatedUser ()
- (id)initUserWithDictionary:(NSDictionary *)dictionary andWelcomeString:(NSString *)welcomeString
            forProviderNamed:(NSString *)providerName;
@end

@implementation JRAuthenticatedUser
@synthesize photo             = _photo;
@synthesize displayName       = _displayName;
@synthesize preferredUsername = _preferredUsername;
@synthesize deviceToken       = _deviceToken;
@synthesize providerName      = _providerName;
@synthesize welcomeString     = _welcomeString;

- (id)initUserWithDictionary:(NSDictionary *)dictionary andWelcomeString:(NSString *)welcomeString
            forProviderNamed:(NSString *)providerName
{
    if (dictionary == nil || providerName == nil || (void *)[dictionary objectForKey:@"device_token"] == kCFNull)
    {
        [self release];
        return nil;
    }

    if ((self = [super init]))
    {
        _deviceToken  = [[dictionary objectForKey:@"device_token"] retain];
        _providerName = [providerName retain];

        if ((void *)[dictionary objectForKey:@"photo"] != kCFNull)
            _photo = [[dictionary objectForKey:@"photo"] retain];

        _displayName = [[[dictionary objectForKey:@"auth_info"] objectForKey:@"profile"] objectForKey:@"displayName"];
        [_displayName retain];

        if ((void *)[dictionary objectForKey:@"preferred_username"] != kCFNull)
            _preferredUsername = [[dictionary objectForKey:@"preferred_username"] retain];

        if (welcomeString && ![welcomeString isEqualToString:@""]) {
            _welcomeString = [welcomeString retain];
        } else if (_preferredUsername) {
            _welcomeString = [[NSString stringWithFormat:@"Sign in as %@?", _preferredUsername] retain];
        } else {
            _welcomeString = @"Sign back in?";
        }
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_providerName      forKey:cJRUserProviderName];
    [coder encodeObject:_photo             forKey:cJRUserPhoto];
    [coder encodeObject:_displayName       forKey:cJRUserDisplayName];
    [coder encodeObject:_preferredUsername forKey:cJRUserPreferredUsername];
    [coder encodeObject:_welcomeString     forKey:cJRUserWelcomeString];

    [coder encodeObject:nil forKey:@"device_token"];

    NSError *error = nil;
    [SFHFKeychainUtils storeUsername:_providerName
                         andPassword:_deviceToken
                      forServiceName:[NSString stringWithFormat:@"%@.%@.",
                                               cJREngageKeychainIdentifier,
                                               applicationBundleDisplayName()]
                      updateExisting:YES
                               error:&error];

    if (error)
        ALog (@"Error storing device token in keychain: %@", [error localizedDescription]);
}

- (id)initWithCoder:(NSCoder *)coder
{
    if (self != nil)
    {
        _providerName      = [[coder decodeObjectForKey:cJRUserProviderName] retain];
        _photo             = [[coder decodeObjectForKey:cJRUserPhoto] retain];
        _displayName       = [[coder decodeObjectForKey:cJRUserDisplayName] retain];
        _preferredUsername = [[coder decodeObjectForKey:cJRUserPreferredUsername] retain];
        _welcomeString     = [[coder decodeObjectForKey:cJRUserWelcomeString] retain];

        if (!_welcomeString)
            _welcomeString = [[NSString stringWithFormat:@"Sign in as %@?", _preferredUsername] retain];

        NSError *error = nil;
        _deviceToken = [[SFHFKeychainUtils getPasswordForUsername:_providerName
                                                   andServiceName:[NSString stringWithFormat:@"%@.%@.",
                                                                            cJREngageKeychainIdentifier,
                                                                            applicationBundleDisplayName()]
                                                            error:&error] retain];

        if (error)
            ALog (@"Error retrieving device token in keychain: %@", [error localizedDescription]);

        /* For backwards compatibility */
        if (!_deviceToken)
            _deviceToken = [[coder decodeObjectForKey:@"device_token"] retain];
    }

    return self;
}

- (void)removeDeviceTokenFromKeychain
{
    NSError *error = nil;
    NSString *name = [NSString stringWithFormat:@"%@.%@.",
                                                cJREngageKeychainIdentifier,
                                                applicationBundleDisplayNameAndIdentifier()];
    [SFHFKeychainUtils deleteItemForUsername:_providerName andServiceName:name error:&error];
    if (error)
    ALog (@"Error deleting device token from keychain: %@", [error localizedDescription]);
}

- (void)dealloc
{
    [self removeDeviceTokenFromKeychain];

    [_providerName release];
    [_photo release];
    [_preferredUsername release];
    [_deviceToken release];
    [_welcomeString release];
    [_displayName release];
    [super dealloc];
}
@end

#pragma mark JRProvider
@interface JRProvider ()
@property (nonatomic, readonly) BOOL      social;
@property (nonatomic, readonly) NSString *openIdIdentifier; // already URL encoded
@property (nonatomic, readonly) NSString *relativeUrl;
- (JRProvider *)initWithName:(NSString *)name andDictionary:(NSDictionary *)dictionary;
@end

@implementation JRProvider
@synthesize name                    = _name;
@synthesize friendlyName            = _friendlyName;
@synthesize placeholderText         = _placeholderText;
@synthesize openIdIdentifier = _openIdIdentifier; // already URL encoded
@synthesize relativeUrl = _relativeUrl;
@synthesize requiresInput           = _requiresInput;
@synthesize shortText               = _shortText;
@synthesize socialSharingProperties = _socialSharingProperties;
@synthesize social                  = _social;
@synthesize cookieDomains           = _cookieDomains;
@synthesize customUserAgentString;

- (void)setUserInput:(NSString *)userInput
{
    [userInput retain], [_userInput release];
    _userInput = userInput;

    [[NSUserDefaults standardUserDefaults] setValue:_userInput
                                             forKey:[NSString stringWithFormat:cJRProviderUserInput, self.name]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setForceReauthStartUrlFlag:(BOOL)forceReauthStartUrlFlag
{
    _forceReauthStartUrlFlag = forceReauthStartUrlFlag;

    [[NSUserDefaults standardUserDefaults] setBool:_forceReauthStartUrlFlag
                                            forKey:[NSString stringWithFormat:cJRProviderForceReauth, self.name]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadLocalConfig
{
    _userInput     = [[[NSUserDefaults standardUserDefaults]
                       stringForKey:[NSString stringWithFormat:cJRProviderUserInput, _name]] retain];
    _forceReauthStartUrlFlag =  [[NSUserDefaults standardUserDefaults]
                       boolForKey:[NSString stringWithFormat:cJRProviderForceReauth, _name]];
}

- (JRProvider *)initWithName:(NSString *)name andDictionary:(NSDictionary *)dictionary
{
    if (name == nil || name.length == 0 || dictionary == nil)
    {
        [self release];
        return nil;
    }

    if ((self = [super init]))
    {
        _name = [name retain];
        _friendlyName    = [[dictionary objectForKey:@"friendly_name"] retain];
        _placeholderText = [[dictionary objectForKey:@"input_prompt"] retain];
        _openIdIdentifier = [[dictionary objectForKey:@"openid_identifier"] retain];
        _relativeUrl = [[dictionary objectForKey:@"url"] retain];
        self.samlName = [dictionary objectForKey:kJRCustomSamlProviderSamlName];
        self.opxBlob = [dictionary objectForKey:kJRCustomOpenIdOpxblob];
        _cookieDomains   = [[dictionary objectForKey:@"cookie_domains"] retain];
        if (IS_IPAD && [dictionary objectForKey:@"ipad_webview_options"])
        {
            [self setPropertiesForWebViewOptions:[dictionary objectForKey:@"ipad_webview_options"]];
        }
        else if (IS_IPHONE && [dictionary objectForKey:@"iphone_webview_options"])
        {
            [self setPropertiesForWebViewOptions:[dictionary objectForKey:@"iphone_webview_options"]];
        }

        if ([[dictionary objectForKey:@"requires_input"] isEqualToString:@"YES"])
            _requiresInput = YES;

        if (_requiresInput)
        {
            NSArray *arr    = [[self.placeholderText stringByTrimmingCharactersInSet:
                                    [NSCharacterSet whitespaceCharacterSet]]
                                        componentsSeparatedByString:@" "];
            NSRange  subArr = {[arr count] - 2, 2};
            NSArray *newArr = [arr subarrayWithRange:subArr];

            _shortText = [[newArr componentsJoinedByString:@" "] retain];
        }
        else
        {
            _shortText = @"";
        }

        _socialSharingProperties = [[dictionary objectForKey:@"social_sharing_properties"] retain];

        if ([_socialSharingProperties count])
            _social = YES;

        [self loadLocalConfig];
    }

    return self;
}

- (void)setPropertiesForWebViewOptions:(NSDictionary *)options
{
    self.customUserAgentString = [options objectForKey:@"user_agent"];
    self.usesPhoneUserAgentString = [[options objectForKey:@"uses_iphone_user_agent"] boolValue];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_name                    forKey:cJRProviderName];
    [coder encodeObject:_friendlyName            forKey:cJRProviderFriendlyName];
    [coder encodeObject:_placeholderText         forKey:cJRProviderPlaceholderText];
    [coder encodeObject:_shortText               forKey:cJRProviderShortText];
    [coder encodeObject:_openIdIdentifier forKey:cJRProviderOpenIdentifier];
    [coder encodeObject:_relativeUrl forKey:cJRProviderUrl];
    [coder encodeBool:_requiresInput             forKey:cJRProviderRequiresInput];
    [coder encodeObject:_socialSharingProperties forKey:cJRProviderSharingProperties];
    [coder encodeObject:_cookieDomains           forKey:cJRProviderCookieDomains];
    [coder encodeObject:self.customUserAgentString forKey:cJRProviderCustomUserAgentString];
}

- (id)initWithCoder:(NSCoder *)coder
{
    if (self != nil)
    {
        _name                    = [[coder decodeObjectForKey:cJRProviderName] retain];
        _friendlyName            = [[coder decodeObjectForKey:cJRProviderFriendlyName] retain];
        _placeholderText         = [[coder decodeObjectForKey:cJRProviderPlaceholderText] retain];
        _shortText               = [[coder decodeObjectForKey:cJRProviderShortText] retain];
        _openIdIdentifier = [[coder decodeObjectForKey:cJRProviderOpenIdentifier] retain];
        _relativeUrl = [[coder decodeObjectForKey:cJRProviderUrl] retain];
        _requiresInput           =  [coder decodeBoolForKey:  cJRProviderRequiresInput];
        _socialSharingProperties = [[coder decodeObjectForKey:cJRProviderSharingProperties] retain];
        _cookieDomains           = [[coder decodeObjectForKey:cJRProviderCookieDomains] retain];
        self.customUserAgentString = [coder decodeObjectForKey:cJRProviderCustomUserAgentString];
    }
    [self loadLocalConfig];

    return self;
}

- (BOOL)isEqualToReturningProvider:(NSString *)returningProvider
{
    if ([self.name isEqualToString:returningProvider])
        return YES;
    return NO;
}

- (void)clearCookiesOnCookieDomains
{
    if ([self.cookieDomains count])
        deleteWebViewCookiesForDomains(self.cookieDomains);
}


- (void)dealloc
{
    [_name release];
    [_friendlyName release];
    [_placeholderText release];
    [_shortText release];
    [_openIdIdentifier release];
    [_relativeUrl release];
    [_userInput release];
    [_socialSharingProperties release];
    [_cookieDomains release];
    [customUserAgentString release];
    [super dealloc];
}

- (void)forceReauth
{
    if ([self.cookieDomains count])
        [self clearCookiesOnCookieDomains];
    else self.forceReauthStartUrlFlag = YES; // MOB-135
}
@end

#pragma mark JRSessionData
@interface JRSessionData ()
{
    NSMutableArray *delegates;

    JRProvider *currentProvider;
    NSMutableDictionary *authenticatedUsersByProvider;

    NSMutableSet        *providersWithIcons;
    NSMutableDictionary *iconsStillNeeded;

    JRActivityObject *activity;

    NSString *tokenUrl;
    NSString *appId;

    BOOL hidePoweredBy;
    BOOL alwaysForceReauth;

    BOOL socialSharing;
    BOOL authenticationFlowIsInFlight;
    BOOL stillNeedToShortenUrls;

    NSError *error;
    NSArray *engageAuthenticationProviders;
}

@property NSString *returningAuthenticationProvider;
@property NSString *returningSharingProvider;
@property(retain) NSError *error;
@property(retain) NSString *appId;
@property(retain) NSString *updatedEtag;
@property(retain) NSDictionary *savedConfigurationBlock;
//@property (retain) NSString *gitCommit;
@property(nonatomic, retain) NSDictionary *customProviders;

/** engageProviders is a dictionary of JRProviders, where each JRProvider contains the information specific to that
    provider. authenticationProviders and sharingProviders are arrays of NSStrings, each string being the primary key
    in engageProviders for that provider, representing the list of providers to be used in authentication and social
    publishing. The arrays are in the order configured by the RP on http://rpxnow.com. */
@property (readwrite, retain) NSMutableDictionary *engageProviders;
@property (readwrite, retain) NSArray             *sharingProviders;

- (NSError *)startGetConfiguration;
- (void)startGetShortenedUrlsForActivity:(JRActivityObject *)theActivity;
@end

@implementation JRSessionData
@synthesize appId;
@synthesize tokenUrl;
@synthesize baseUrl;

@synthesize error;
@synthesize updatedEtag;
@synthesize savedConfigurationBlock;

@synthesize engageProviders;
@synthesize sharingProviders;

@synthesize returningSharingProvider;
@synthesize returningAuthenticationProvider;
@synthesize currentProvider;
@synthesize socialSharing;
@synthesize accountLinking;

@synthesize alwaysForceReauth;
@synthesize hidePoweredBy;

#pragma mark singleton_methods
static JRSessionData *singleton = nil;

- (void)setCustomProvidersWithDictionary:(NSDictionary *)customProviders __unused
{
    self.customProviders = [self customProvidersFromConfigurationDictionary:customProviders];
}

+ (JRSessionData *)jrSessionData
{
    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self jrSessionData] retain];
}

- (id)copyWithZone:(__unused NSZone *)zone __unused
{
    return self;
}

- (id)retain                { return self; }
- (NSUInteger)retainCount   { return NSUIntegerMax; }
- (oneway void)release      { /* Do nothing... */ }
- (id)autorelease           { return self; }

#pragma mark accessors
- (BOOL)authenticationFlowIsInFlight
{
    return authenticationFlowIsInFlight;
}

- (void)setAuthenticationFlowIsInFlight:(BOOL)isInFlight
{
    /* If we found out that the configuration changed while a dialog was showing, we saved it until the dialog wasn't
    showing since the dialogs dynamically load our data. Now that the dialog isn't showing, load the saved
    configuration information. */
    if (!isInFlight && savedConfigurationBlock)
        self.error = [self updateConfig:savedConfigurationBlock];

    /* If the dialog is going away, then we don't still need to shorten the urls */
    if (!isInFlight) {
        stillNeedToShortenUrls = NO;
        _nativeAuthenticationFlowIsInFlight = NO;
    }

    authenticationFlowIsInFlight = isInFlight;
}

- (JRActivityObject *)activity
{
    return activity;
}

- (void)setActivity:(JRActivityObject *)newActivity
{
    JRActivityObject *oldActivity = activity;
    activity = [newActivity copy];
    [oldActivity release];

    if (!activity)
        return;

    [self startGetShortenedUrlsForActivity:activity];
}

-(BOOL)accountLinking {
    return accountLinking;
}

-(void)setAccountLinking:(BOOL)linkAccount {
    accountLinking = linkAccount;
}

#pragma mark initialization
- (id)reconfigureWithAppId:(NSString *)newAppId tokenUrl:(NSString *)newTokenUrl
{
    self.appId = newAppId;
    self.tokenUrl = newTokenUrl;
    self.error = [self startGetConfiguration];

    return self;
}

- (NSString *)device
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? @"ipad" : @"iphone";
}

- (id)initWithAppId:(NSString *)newAppId tokenUrl:(NSString *)newTokenUrl andDelegate:(id<JRSessionDelegate>)newDelegate
{
    DLog (@"");

    if ((self = [super init]))
    {
        singleton = self;

        delegates     = [[NSMutableArray alloc] initWithObjects:newDelegate, nil];
        self.appId    = newAppId;
        self.tokenUrl = newTokenUrl;

        NSData *archivedUsers = [[NSUserDefaults standardUserDefaults] objectForKey:cJRAuthenticatedUsersByProvider];
        if (archivedUsers != nil)
        {
            NSDictionary *unarchivedUsers = [NSKeyedUnarchiver unarchiveObjectWithData:archivedUsers];
            if (unarchivedUsers != nil)
                authenticatedUsersByProvider = [[NSMutableDictionary alloc] initWithDictionary:unarchivedUsers];
        }

        if (!authenticatedUsersByProvider)
            authenticatedUsersByProvider = [[NSMutableDictionary alloc] init];

        NSData *archivedProviders = [[NSUserDefaults standardUserDefaults] objectForKey:cJREngageProviders];
        if (archivedProviders != nil)
        {
            NSDictionary *unarchivedProviders = [NSKeyedUnarchiver unarchiveObjectWithData:archivedProviders];
            if (unarchivedProviders != nil)
                self.engageProviders = [NSMutableDictionary dictionaryWithDictionary:unarchivedProviders];
        }

        engageAuthenticationProviders =
                [[[NSUserDefaults standardUserDefaults] objectForKey:cJRAuthenticationProviders] retain];
        self.sharingProviders = [[NSUserDefaults standardUserDefaults] objectForKey:cJRSharingProviders];

        NSData *archivedIconsStillNeeded = [[NSUserDefaults standardUserDefaults] objectForKey:cJRIconsStillNeeded];
        if (archivedIconsStillNeeded != nil)
        {
            NSDictionary *iconsStillNeeded_ = [NSKeyedUnarchiver unarchiveObjectWithData:archivedIconsStillNeeded];
            if (iconsStillNeeded_ != nil)
                iconsStillNeeded = [[NSMutableDictionary alloc] initWithDictionary:iconsStillNeeded_];
        }

        NSData *providersWithIcons_ = [[NSUserDefaults standardUserDefaults] objectForKey:cJRProvidersWithIcons];
        if (providersWithIcons_ != nil)
        {
            NSSet *unarchivedProvidersWithIcons = [NSKeyedUnarchiver unarchiveObjectWithData:providersWithIcons_];
            if (unarchivedProvidersWithIcons != nil)
                providersWithIcons = [[NSMutableSet alloc] initWithSet:unarchivedProvidersWithIcons];
        }

        baseUrl = [[[NSUserDefaults standardUserDefaults] stringForKey:cJRBaseUrl] retain];
        hidePoweredBy = !baseUrl ? YES : ([[NSUserDefaults standardUserDefaults] boolForKey:cJRHidePoweredBy]);

        returningSharingProvider = [[[NSUserDefaults standardUserDefaults] stringForKey:cJRLastUsedSharingProvider] retain];
        returningAuthenticationProvider = [[[NSUserDefaults standardUserDefaults] stringForKey:cJRLastUsedAuthenticationProvider] retain];

        self.error = [self startGetConfiguration];
    }

    return self;
}

+ (id)jrSessionDataWithAppId:(NSString *)newAppId tokenUrl:(NSString *)newTokenUrl
                 andDelegate:(id <JRSessionDelegate>)newDelegate
{
    if (singleton)
        return [singleton reconfigureWithAppId:newAppId tokenUrl:newTokenUrl];

    return [[((JRSessionData *) [super allocWithZone:nil]) initWithAppId:newAppId
                                                                tokenUrl:newTokenUrl
                                                             andDelegate:newDelegate] autorelease];
}

- (void)tryToReconfigureLibrary
{
    ALog (@"Configuration error occurred. Trying to reconfigure the library.");

    self.error = [self startGetConfiguration];
}

#pragma mark configuration
- (NSString*)appNameAndVersion
{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString     *name      = [[[infoPlist objectForKey:@"CFBundleDisplayName"]
                                stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                stringByAddingUrlPercentEscapes];
    NSString     *bundle    = [[[infoPlist objectForKey:@"CFBundleIdentifier"]
                                stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                stringByAddingUrlPercentEscapes];

    infoPlist = [NSDictionary dictionaryWithContentsOfFile:
                 [[[NSBundle mainBundle] resourcePath]
                  stringByAppendingPathComponent:@"/JREngage-Info.plist"]];

    NSString *version       = [[[infoPlist objectForKey:@"CFBundleShortVersionString"]
                                stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                stringByAddingUrlPercentEscapes];

    return [NSString stringWithFormat:@"appName=%@.%@3&version=%@_%@", name, bundle, self.device, version];
}

- (NSError *)startGetConfiguration
{
    NSString *urlString = [NSString stringWithFormat:
                                            @"%@/openid/mobile_config_and_baseurl?device=%@&appId=%@&%@",
                                            serverUrl, self.device, self.appId, self.appNameAndVersion];
    ALog (@"Getting configuration for RP: %@", urlString);

    NSMutableURLRequest *configRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];

    if (![JRConnectionManager createConnectionFromRequest:configRequest forDelegate:self returnFullResponse:YES
                                                  withTag:GET_CONFIGURATION_TAG])
    {
        NSString *errMsg = @"There was a problem connecting to the Janrain server while configuring authentication.";
        return [JREngageError errorWithMessage:errMsg andCode:JRUrlError];
    }

    return nil;
}

- (NSError*)updateConfig:(NSDictionary *)configDict
{
    ALog (@"Updating JREngage configuration");

    [baseUrl release];
    baseUrl = [[[configDict objectForKey:CONFIG_KEY_BASEURL]
            stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]] retain];

    if (stillNeedToShortenUrls && activity)
        [self startGetShortenedUrlsForActivity:activity];
    stillNeedToShortenUrls = NO;

    [[NSUserDefaults standardUserDefaults] setValue:baseUrl forKey:cJRBaseUrl];
    NSDictionary *providerInfo = [configDict objectForKey:CONFIG_KEY_PROVIDER_INFO];

    self.engageProviders = [NSMutableDictionary dictionary];

    for (NSString *name in [providerInfo allKeys])
    {
        NSDictionary *providerDict = [providerInfo objectForKey:name];
        JRProvider *provider = [[[JRProvider alloc] initWithName:name andDictionary:providerDict] autorelease];
        //[self checkForNeededIcons:((provider.social) ? (NSString **) iconNamesSocial : (NSString **) iconNames)
        //              forProvider:name];

        /* and finally add the object to our dictionary of providers. */
        [self.engageProviders setObject:provider forKey:name];
    }

    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:iconsStillNeeded]
                                              forKey:cJRIconsStillNeeded];
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:providersWithIcons]
                                              forKey:cJRProvidersWithIcons];

    [engageAuthenticationProviders release];
    engageAuthenticationProviders =
            [[NSArray arrayWithArray:[configDict objectForKey:CONFIG_KEY_SIGNIN_PROVIDERS]] retain];
    self.sharingProviders = [NSArray arrayWithArray:[configDict objectForKey:CONFIG_KEY_SHARING_PROVIDERS]];

    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:engageProviders]
                                              forKey:cJREngageProviders];
    [[NSUserDefaults standardUserDefaults] setObject:engageAuthenticationProviders forKey:cJRAuthenticationProviders];
    [[NSUserDefaults standardUserDefaults] setObject:self.sharingProviders forKey:cJRSharingProviders];

    hidePoweredBy = ([[configDict objectForKey:@"hide_tagline"] isEqualToString:@"YES"]) ? YES : NO;
    [[NSUserDefaults standardUserDefaults] setBool:hidePoweredBy forKey:cJRHidePoweredBy];

    [[NSUserDefaults standardUserDefaults] setValue:self.updatedEtag forKey:PREFS_KEY_ETAG];
    [[NSUserDefaults standardUserDefaults] synchronize];

    //[self downloadNeededIcons:iconsStillNeeded];

    self.savedConfigurationBlock = nil;
    self.updatedEtag = nil;

    [[NSNotificationCenter defaultCenter] postNotificationName:JRFinishedUpdatingEngageConfigurationNotification
                                                        object:self];

    return nil;
}

- (NSError *)finishGetConfiguration:(NSString *)configJson response:(NSHTTPURLResponse *)response
{
    #define MAX_LOGGED_CONFIG_RESPONSE_LENGTH 80
    NSUInteger max = [configJson length];
    if (max > MAX_LOGGED_CONFIG_RESPONSE_LENGTH) max = MAX_LOGGED_CONFIG_RESPONSE_LENGTH;
    ALog (@"Configuration information downloaded (%d): %@", [response statusCode], [configJson substringToIndex:max]);

    NSDictionary *configDict = [configJson JR_objectFromJSONString];
    NSString *err = @"There was a problem communicating with the Janrain server while configuring authentication.";
    if (!configDict)
    {
        ALog(@"%@", configJson);
        return [JREngageError errorWithMessage:err andCode:JRJsonError];
    }

    if (![configDict objectForKey:CONFIG_KEY_BASEURL] || ![configDict objectForKey:CONFIG_KEY_PROVIDER_INFO])
    {
        ALog(@"%@", configJson);
        return [JREngageError errorWithMessage:err andCode:JRConfigurationInformationError];
    }

    self.updatedEtag = ([self etagFromResponse:response]);

    /* We can only update all of our data if the UI isn't currently using that information.  Otherwise, the library
    may crash/behave inconsistently.  If a dialog isn't showing, go ahead and update new configuration information.

    Or, in rare cases, there might not be any data at all (the lists of basic and social providers are nil),
    perhaps because this is the first time the library was used and the configuration information is still
    downloading. In these cases, the dialogs will display their view as greyed-out, with a spinning activity
    indicator and a loading message, as they wait for the lists of providers to download, so we can go ahead and
    update the configuration information here, too. The dialogs won't try and do anything until we're done updating
    the lists. */
    if (!authenticationFlowIsInFlight
            || ([engageAuthenticationProviders count] == 0 && !socialSharing)
            || ([sharingProviders count] == 0 && socialSharing))
    {
        return [self updateConfig:configDict];
    }
    else
    {
        self.savedConfigurationBlock = configDict;
        return nil;
    }
}

- (NSString *)etagFromResponse:(NSHTTPURLResponse *)response
{
    NSSet *etagKeys = [[response allHeaderFields] keysOfEntriesPassingTest:^(id key, id val, BOOL *stop)
        {
            if ([key isKindOfClass:[NSString class]] && [[key lowercaseString] isEqual:@"etag"])
            {
                *stop = YES;
                return YES;
            }
            return NO;
        }];
    NSString *etag = [[response allHeaderFields] objectForKey:[etagKeys anyObject]];
    return etag;
}

#pragma mark user_management
- (BOOL)weShouldBeFirstResponder
{
    /* If we're authenticating with a provider for social publishing, then don't worry about the return experience
       for basic authentication. */
    if (socialSharing)
        return currentProvider.requiresInput;

    /* If we're authenticating with a basic provider, then we don't need to gather information if we're displaying
       return screen. */
    if ([currentProvider isEqualToReturningProvider:returningAuthenticationProvider])
        return NO;

    return currentProvider.requiresInput;
}

- (JRAuthenticatedUser *)authenticatedUserForProvider:(JRProvider *)provider
{
    return [authenticatedUsersByProvider objectForKey:provider.name];
}

- (JRAuthenticatedUser *)authenticatedUserForProviderNamed:(NSString *)provider;
{
    return [authenticatedUsersByProvider objectForKey:provider];
}

- (void)forgetAuthenticatedUserForProvider:(NSString *)providerName
{
    DLog (@"");
    JRProvider* provider = [engageProviders objectForKey:providerName];

    if (!provider) return;

    [provider forceReauth];
    [authenticatedUsersByProvider removeObjectForKey:providerName];
    NSData *usersData = [NSKeyedArchiver archivedDataWithRootObject:authenticatedUsersByProvider];
    [[NSUserDefaults standardUserDefaults] setObject:usersData forKey:cJRAuthenticatedUsersByProvider];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDictionary *)allProviders
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result addEntriesFromDictionary:self.engageProviders];
    [result addEntriesFromDictionary:self.customProviders];
    return result;
}

- (NSArray *)authenticationProviders
{
    return [engageAuthenticationProviders arrayByAddingObjectsFromArray:[_customProviders allKeys]];
}

- (void)forgetAllAuthenticatedUsers
{
    DLog (@"");

    for (NSString *providerName in [[self allProviders] allKeys])
    {
        [self forgetAuthenticatedUserForProvider:providerName];
    }

    [authenticatedUsersByProvider removeAllObjects];
    NSData *usersData = [NSKeyedArchiver archivedDataWithRootObject:authenticatedUsersByProvider];
    [[NSUserDefaults standardUserDefaults] setObject:usersData forKey:cJRAuthenticatedUsersByProvider];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark provider_management
- (JRProvider *)getProviderNamed:(NSString *)name
{
    return [[self allProviders] objectForKey:name];
}

#pragma mark authentication
- (void)saveLastUsedSharingProvider:(NSString *)providerName
{
    DLog (@"Saving last used social provider: %@", providerName);

    [returningSharingProvider release], returningSharingProvider = [providerName retain];

    [[NSUserDefaults standardUserDefaults] setObject:returningSharingProvider
                                              forKey:cJRLastUsedSharingProvider];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveLastUsedAuthenticationProvider:(NSString *)providerName
{
    DLog (@"Saving last used basic provider: %@", providerName);

    [returningAuthenticationProvider release], returningAuthenticationProvider = [providerName retain];

    [[NSUserDefaults standardUserDefaults] setObject:returningAuthenticationProvider
                                              forKey:cJRLastUsedAuthenticationProvider];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getWelcomeMessageFromCookie
{
    DLog (@"");

    NSHTTPCookieStorage *cookieStore = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStore cookiesForURL:[NSURL URLWithString:baseUrl]];

    for (NSHTTPCookie *savedCookie in cookies)
    {
        if ([savedCookie.name isEqualToString:@"welcome_info"])
        {
            NSString *cookieString = savedCookie.value;
            NSArray *strArr = [cookieString componentsSeparatedByString:@"%22"];

            if ([strArr count] <= 5)
                return nil;

            return [[[NSString stringWithFormat:@"Sign in as %@?", (NSString *)[strArr objectAtIndex:5]]
                     stringByReplacingOccurrencesOfString:@"+" withString:@" "]
                        stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }

    return nil;
}

- (NSURL *)startUrlForCurrentProvider
{
    return [self startUrlForProvider:self.currentProvider];
}

- (NSURL *)startUrlForProvider:(JRProvider *)provider
{
    NSString *extraParamString = @"";

    if (!provider)
        return nil;

    if (provider.openIdIdentifier)
    {
        NSString *openIdIdentifier = provider.openIdIdentifier;
        if(provider.requiresInput)
        {
            NSString *userInput = [provider.userInput stringByAddingUrlPercentEscapes];
            openIdIdentifier = [NSString stringWithFormat:provider.openIdIdentifier, userInput];
        }
        extraParamString = [NSString stringWithFormat:@"openid_identifier=%@&", openIdIdentifier];
        if (provider.opxBlob) 
        {
            NSString *blobParam = [NSString stringWithFormat:@"opx_blob=%@&", provider.opxBlob];
            extraParamString = [extraParamString stringByAppendingString:blobParam];
        }
    }
    else if (provider.samlName)
    {
        extraParamString = [NSString stringWithFormat:@"saml_provider=%@&", provider.samlName];
    }

    NSString *uuid = [[self deviceIdentifier] stringByAddingUrlPercentEscapes];

    BOOL forceReauthFlag = (alwaysForceReauth || currentProvider.forceReauthStartUrlFlag) ? YES : NO;

    if (forceReauthFlag)
        deleteWebViewCookiesForDomains(provider.cookieDomains);

    NSString *urlString = [NSString stringWithFormat:@"%@%@?%@%@device=%@&extended=true&installation_id=%@",
                                                     baseUrl, provider.relativeUrl, extraParamString,
                                                     forceReauthFlag ? @"force_reauth=true&" : @"",
                                                     [self device], uuid];

    provider.forceReauthStartUrlFlag = NO;
    ALog (@"Starting authentication for %@:\n%@", provider.name, urlString);
    return [NSURL URLWithString:urlString];
}

- (NSString *)deviceIdentifier
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [defaults objectForKey:cJRUserDefaultsUuidName];

    if (!uuid)
    {
        // Using the core foundation version of UUID because NSUUID is only supported
        // in iOS 6.0+. CFUUIDRef is supported all the way back to iOS 2.0.
        CFUUIDRef cfUUID = CFUUIDCreate(NULL);
        uuid = [(NSString *)CFUUIDCreateString(NULL, cfUUID) autorelease];

        [defaults setObject:uuid forKey:cJRUserDefaultsUuidName];
        [defaults synchronize];

        CFRelease(cfUUID);
    }

    return uuid;
}

#pragma mark sharing
- (void)startShareActivityForUser:(JRAuthenticatedUser *)user
{
    // TODO: Better error checking in sessionData's share activity bit
    NSMutableDictionary *activityDictionary = [activity dictionaryForObject];

    if ([currentProvider.name isEqualToString:@"linkedin"])
    {
        NSString *desc = [activity.resourceDescription substringToIndex:((activity.resourceDescription.length < 256) ?
                                                activity.resourceDescription.length : 256)];
        [activityDictionary setObject:desc forKey:@"description"];
    }


    NSString *activityContent = [[activityDictionary JR_jsonString] stringByAddingUrlPercentEscapes];
    NSString *deviceToken = user.deviceToken;

    DLog(@"activity json string \n %@", activityContent);

    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"activity=%@",
                                                 activityContent] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&device_token=%@",
                                                 deviceToken] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&url_shortening=true"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&device=%@", [self device]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&provider=%@",
                                                 currentProvider.name] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&app_name=%@",
                                                 applicationBundleDisplayName()] dataUsingEncoding:NSUTF8StringEncoding]];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/v2/activity", serverUrl]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSDictionary *tag = [NSDictionary dictionaryWithObjectsAndKeys:
                                              @"shareActivity", @"action",
                                              activity, @"activity",
                                              currentProvider.name, @"providerName", nil];

    ALog ("Sharing activity on %@:\n request=%@\nbody=%@", user.providerName, [[request URL] absoluteString],
    [NSString stringWithCString:body.bytes encoding:NSUTF8StringEncoding]);

    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
    {
        NSString *message = @"There was a problem connecting to the Janrain server to share this activity";
        [self triggerPublishingDidFailWithError:[JREngageError errorWithMessage:message
                                                                        andCode:JRPublishErrorBadConnection]];
    }
}

- (void)startSetStatusForUser:(JRAuthenticatedUser *)user
{
    DLog (@"activity status: %@", [activity userGeneratedContent]);

    NSString *status = [[activity userGeneratedContent] stringByAddingUrlPercentEscapes];

    NSString *deviceToken = user.deviceToken;

    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"status=%@", status] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&device_token=%@",
                                                 deviceToken] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&device=%@", [self device]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&app_name=%@",
                                                 applicationBundleDisplayName()] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&provider=%@",
                                                 currentProvider.name] dataUsingEncoding:NSUTF8StringEncoding]];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/v2/set_status", serverUrl]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSDictionary *tag = [NSDictionary dictionaryWithObjectsAndKeys:
                                              @"shareActivity", @"action",
                                              activity, @"activity",
                                              currentProvider.name, @"providerName", nil];

    ALog ("Sharing activity on %@:\n request=%@\nbody=%@", user.providerName, [[request URL] absoluteString],
    [NSString stringWithCString:body.bytes encoding:NSUTF8StringEncoding]);

    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag])
    {
        NSString *message = @"There was a problem connecting to the Janrain server to share this activity";
        [self triggerPublishingDidFailWithError:[JREngageError errorWithMessage:message
                                                                        andCode:JRPublishErrorBadConnection]];
    }
}

- (void)shareActivityForUser:(JRAuthenticatedUser *)user
{
    [self startShareActivityForUser:user];
}

- (void)setStatusForUser:(JRAuthenticatedUser *)user
{
    [self startSetStatusForUser:user];
}

- (void)finishShareActivity:(JRActivityObject *)_activity forProvider:(NSString *)providerName withResponse:(NSString *)response
{
    ALog (@"Activity sharing response: %@", response);

    NSDictionary *responseDict = [response JR_objectFromJSONString];

    if (!responseDict)
    {
        NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
        for (id<JRSessionDelegate> delegate in delegatesCopy)
        {
            if ([delegate respondsToSelector:@selector(publishingActivity:didFailWithError:forProvider:)])
                [delegate publishingActivity:_activity
                            didFailWithError:[JREngageError errorWithMessage:[NSString stringWithString:response]
                                                                     andCode:JRPublishFailedError]
                                 forProvider:providerName];
        }
        return;
    }

    if ([[responseDict objectForKey:@"stat"] isEqualToString:@"ok"])
    {
        [self saveLastUsedSharingProvider:providerName];
        NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
        for (id<JRSessionDelegate> delegate in delegatesCopy)
        {
            if ([delegate respondsToSelector:@selector(publishingActivityDidSucceed:forProvider:)])
                [delegate publishingActivityDidSucceed:_activity forProvider:providerName];
        }
    }
    else
    {
        NSDictionary *errorDict = [responseDict objectForKey:@"err"];
        NSError *publishError = nil;

        if (!errorDict)
        {
            publishError = [JREngageError errorWithMessage:@"There was a problem publishing this activity"
                                                   andCode:JRPublishFailedError];
        }
        else
        {
            int code;
            if (!CFNumberGetValue((void *)[errorDict objectForKey:@"code"], kCFNumberSInt32Type, &code))
                code = 1000;

            NSString *errorMessage = [errorDict objectForKey:@"msg"];
            switch (code)
            {
                case 0: /* "Missing parameter: ..." error */
                case 1: /* Invalid parameter: ..." error */

                 /* Missing apiKey; this error should prompt a reauthentication. */
                    if ([errorMessage isEqualToString:@"Missing parameter: apiKey"])
                        publishError = [JREngageError errorWithMessage:errorMessage
                                                               andCode:JRPublishErrorMissingApiKey];

                 /* Missing some other parameter: activity/url/etc." */
                    else
                        publishError = [JREngageError errorWithMessage:errorMessage
                                                               andCode:JRPublishErrorMissingParameter];
                    break;

                case 4: /* "Facebook Error: ..." */

                /* "Invalid OAuth 2.0 Access Token" or "Error validating access token: The session has been
                    invalidated because the user has changed the password" or TODO: THE SESSION EXPIRED ERROR;
                    these errors should prompt a reauthentication. */
                    if (([errorMessage rangeOfString:@"Invalid OAuth 2.0 Access Token"
                                             options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                        ([errorMessage rangeOfString:@"Error validating access token"
                                             options:NSCaseInsensitiveSearch].location != NSNotFound) ||
                        ([errorMessage rangeOfString:@"Error validating access token"
                                             options:NSCaseInsensitiveSearch].location != NSNotFound))
                            publishError = [JREngageError errorWithMessage:errorMessage
                                                                   andCode:JRPublishErrorInvalidFacebookSession];

                 /* Bad image error: "One or more of your image records failed to include a valid 'href' field" */
                    else if ([errorMessage rangeOfString:@"image records failed"
                                                 options:NSCaseInsensitiveSearch].location != NSNotFound)
                        publishError = [JREngageError errorWithMessage:errorMessage
                                                               andCode:JRPublishErrorInvalidFacebookMedia];

                 /* Bad flash object error: "flash objects must have the 'source' and 'picture' attributes/etc." */
                    else if ([errorMessage rangeOfString:@"flash objects must"
                                                 options:NSCaseInsensitiveSearch].location != NSNotFound)
                        publishError = [JREngageError errorWithMessage:errorMessage
                                                               andCode:JRPublishErrorInvalidFacebookMedia];

                 /* Any other generic Facebook error */
                    else
                        publishError = [JREngageError errorWithMessage:errorMessage
                                                               andCode:JRPublishErrorFacebookGeneric];

                    break;

                case 6: /* Error interacting with a previously operational provider */
                 /* Twitter duplicate message error: "Twitter server error: Status is a duplicate." */
                    if ([errorMessage isEqualToString:@"Twitter server error: Status is a duplicate."])
                        publishError = [JREngageError errorWithMessage:errorMessage
                                                               andCode:JRPublishErrorDuplicateTwitter];
                 /* Any other error with code 6 */
                    else
                        publishError = [JREngageError errorWithMessage:errorMessage
                                                               andCode:JRPublishFailedError];
                    break;

                case 13: /* Twitter Error */
                    publishError = [JREngageError errorWithMessage:errorMessage
                                                           andCode:JRPublishErrorTwitterGeneric];
                    break;

                case 14: /* LinkedIn Error */
                    publishError = [JREngageError errorWithMessage:errorMessage
                                                           andCode:JRPublishErrorLinkedInGeneric];
                    break;

                case 16: /* MySpace Error */
                    publishError = [JREngageError errorWithMessage:errorMessage
                                                           andCode:JRPublishErrorMyspaceGeneric];
                    break;

                case 17: /* Yahoo Error */
                    publishError = [JREngageError errorWithMessage:errorMessage
                                                           andCode:JRPublishErrorYahooGeneric];
                    break;

                case 100: /* Character limit error?  Not documented on rpxnow.com. */
                 /* Formerly LinkedIn character limit error (JRPublishErrorLinkedInCharacterExceeded) */
                    publishError = [JREngageError errorWithMessage:errorMessage
                                                           andCode:JRPublishErrorCharacterLimitExceeded];
                    break;


                case 1000: /* Extracting code failed; Fall through. */
                default:   /* See below for list of ignored error codes. */
                    publishError = [JREngageError errorWithMessage:@"There was a problem publishing this activity"
                                                           andCode:JRPublishFailedError];
                    break;

            /* -1:  Service Temporarily Unavailable
                1:  Invalid parameter
                2:  Data not found
                3:  Authentication error
                5:  Mapping exists
                7:  Engage account upgrade needed to access this API
                8:  Missing third-party credentials for this identifier
                9:  Third-party credentials have been revoked
                10: Your application is not properly configured
                11: The provider or identifier does not support this feature
                12: Google Error
                13: Twitter Error
                14: LinkedIn Error
                15: LiveId Error
                16: MySpace Error
                18: Domain already exists
                19: App Id not found
                17: Yahoo Error
                20: Orkut Error */
            }
        }

        NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
        for (id<JRSessionDelegate> delegate in delegatesCopy)
        {
            if ([delegate respondsToSelector:@selector(publishingActivity:didFailWithError:forProvider:)])
                [delegate publishingActivity:_activity
                            didFailWithError:publishError
                                 forProvider:providerName];
        }
    }
}

- (void)startRecordActivitySharedBy:(NSString *)method
{
    ALog (@"");
    NSMutableData* body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"device=%@", [self device]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"&method=%@", method] dataUsingEncoding:NSUTF8StringEncoding]];

    NSString *urlString = [NSString stringWithFormat:
                           @"%@/social/record_activity?",
                           baseUrl];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSString *tag = [NSString stringWithFormat:@"%@Success", method];

    [JRConnectionManager createConnectionFromRequest:request forDelegate:self returnFullResponse:NO withTag:tag];
}

#pragma mark url_shortening
- (void)startGetShortenedUrlsForActivity:(JRActivityObject *)theActivity
{
    DLog(@"");

    if (!theActivity.url && ![theActivity.email.urls count] && ![theActivity.sms.urls count])
        return;

 /* In case there's an error, we'll just set the activity's shortened url to the
  * unshortened url for now, and update it only if we successfully shorten it. */
    theActivity.shortenedUrl = theActivity.url;

 /* If we haven't gotten the baseUrl back from the configuration yet, return, and get the shortened urls later */
    if (!baseUrl)
    {
        stillNeedToShortenUrls = YES;
        return;
    }

    NSMutableDictionary *urls = [NSMutableDictionary dictionaryWithCapacity:3];
    if (theActivity.email.urls) [urls setObject:theActivity.email.urls forKey:@"email"];
    if (theActivity.sms.urls)   [urls setObject:theActivity.sms.urls forKey:@"sms"];
    if (theActivity.url)        [urls setObject:[NSArray arrayWithObject:theActivity.url] forKey:@"activity"];

    NSString *urlsArg = [[urls JR_jsonString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"%@/openid/get_urls?urls=%@&app_name=%@&device=%@",
                                                     baseUrl, urlsArg, [self appNameAndVersion], [self device]];

    DLog (@"Getting shortened URLs: %@", urlString);

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];

    NSDictionary *tag = [NSDictionary dictionaryWithObjectsAndKeys:theActivity, @"activity",
                                                                   @"shortenUrls", @"action", nil];

    [JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:tag];
}

- (void)finishGetShortenedUrlsForActivity:(JRActivityObject *)_activity withShortenedUrls:(NSString *)urls
{
    DLog ("Shortened Urls: %@", urls);

    NSDictionary *dict = [urls JR_objectFromJSONString];

    if (!dict)
        goto CALL_DELEGATE_SELECTOR;

    if ([dict objectForKey:@"err"])
        goto CALL_DELEGATE_SELECTOR;

    NSDictionary *emailUrls    = [[dict objectForKey:@"urls"] objectForKey:@"email"];
    NSDictionary *smsUrls      = [[dict objectForKey:@"urls"] objectForKey:@"sms"];
    NSDictionary *activityUrls = [[dict objectForKey:@"urls"] objectForKey:@"activity"];

    for (NSString *key in [emailUrls allKeys])
    {
        _activity.email.messageBody = [_activity.email.messageBody
                                       stringByReplacingOccurrencesOfString:key
                                       withString:[emailUrls objectForKey:key]];
    }

    for (NSString *key in [smsUrls allKeys])
    {
        _activity.sms.message = [_activity.sms.message
                                 stringByReplacingOccurrencesOfString:key
                                 withString:[smsUrls objectForKey:key]];
    }

    for (NSString *key in [activityUrls allKeys])
    {
        if ([key isEqualToString:activity.url])
            [_activity setShortenedUrl:[activityUrls objectForKey:key]];
    }

CALL_DELEGATE_SELECTOR:
    for (id<JRSessionDelegate> delegate in [NSArray arrayWithArray:delegates])
        if ([delegate respondsToSelector:@selector(urlShortenedToNewUrl:forActivity:)])
            [delegate urlShortenedToNewUrl:[_activity shortenedUrl] forActivity:_activity];
}

#pragma mark token_url
- (void)startMakeCallToTokenUrl:(NSString *)_tokenUrl withToken:(NSString *)token forProvider:(NSString *)providerName
{
    ALog (@"Calling token URL for %@:\n%@", providerName, _tokenUrl);

    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"token=%@", token] dataUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_tokenUrl]];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];

    NSDictionary *tag = [NSDictionary dictionaryWithObjectsAndKeys:_tokenUrl, @"tokenUrl",
                                                                   providerName, @"providerName",
                                                                   @"callTokenUrl", @"action", nil];

    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self returnFullResponse:YES withTag:tag])
    {
        NSError *_error = [JREngageError errorWithMessage:@"Problem initializing the connection to the token url"
                                                  andCode:JRAuthenticationTokenUrlFailedError];

        NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
        for (id<JRSessionDelegate> delegate in delegatesCopy)
        {
            if ([delegate respondsToSelector:@selector(authenticationCallToTokenUrl:didFailWithError:forProvider:)])
                [delegate authenticationCallToTokenUrl:_tokenUrl didFailWithError:_error forProvider:providerName];
        }
    }
}

- (void)finishMakeCallToTokenUrl:(NSString *)_tokenUrl withResponse:(NSURLResponse *)fullResponse
                      andPayload:(NSData *)payload forProvider:(NSString *)providerName
{
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JRSessionDelegate> delegate in delegatesCopy)
    {
        SEL tokenUrlSelector = @selector(authenticationDidReachTokenUrl:withResponse:andPayload:forProvider:);
        if ([delegate respondsToSelector:tokenUrlSelector])
            [delegate authenticationDidReachTokenUrl:_tokenUrl withResponse:fullResponse andPayload:payload
                                         forProvider:providerName];
    }
}

#pragma mark connection_manager_delegate_protocol
- (void)connectionDidFinishLoadingWithFullResponse:(NSURLResponse *)fullResponse unencodedPayload:(NSData *)payload
                                           request:(NSURLRequest *)request andTag:(id)tag
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)fullResponse;

    if ([tag isKindOfClass:[NSDictionary class]])
    {
        NSString *action = [(NSDictionary *)tag objectForKey:@"action"];

        if ([action isEqualToString:@"callTokenUrl"])
        {
            [self finishMakeCallToTokenUrl:[(NSDictionary *)tag objectForKey:@"tokenUrl"]
                              withResponse:fullResponse
                                andPayload:payload
                               forProvider:[(NSDictionary *)tag objectForKey:@"providerName"]];
        }
        //else if ([action isEqualToString:@"downloadPicture"])
        //{
        //    // TODO: Later, make this more dynamic, and not fixed to just pngs.
        //    if ([[fullResponse MIMEType] isEqualToString:@"image/png"])
        //        [self finishDownloadPicture:payload
        //                              named:[(NSDictionary*)tag objectForKey:@"pictureName"]
        //                        forProvider:[(NSDictionary*)tag objectForKey:@"providerName"]];
        //    else
        //        ALog ("Not able to download the picture: %@", [[request URL] absoluteString]);
        //}
    }
    else if ([tag isKindOfClass:[NSString class]])
    {
        if ([(NSString *) tag isEqualToString:GET_CONFIGURATION_TAG])
        {
            NSString *configJson = [[[NSString alloc] initWithData:payload encoding:NSUTF8StringEncoding] autorelease];
            self.error = [self finishGetConfiguration:configJson response:httpResponse];
            if (self.error) {
                [[NSNotificationCenter defaultCenter]
                        postNotificationName:JRFailedToUpdateEngageConfigurationNotification
                                      object:self
                                    userInfo:@{@"error" : self.error}];
            }
        }
    }
}

- (void)connectionDidFinishLoadingWithPayload:(NSString *)payload request:(NSURLRequest *)request andTag:(id)tag
{
    if ([tag isKindOfClass:[NSDictionary class]])
    {
        NSString *action = [(NSDictionary *)tag objectForKey:@"action"];
        DLog (@"Connect did finish loading: %@", action);

        if ([action isEqualToString:@"shareActivity"])
        {
            [self finishShareActivity:[(NSDictionary *)tag objectForKey:@"activity"]
                          forProvider:[(NSDictionary *)tag objectForKey:@"providerName"]
                         withResponse:payload];
        }
        else if ([action isEqualToString:@"shortenUrls"])
        {
            [self finishGetShortenedUrlsForActivity:[(NSDictionary *)tag objectForKey:@"activity"]
                                  withShortenedUrls:payload];
        }
    }
    else if ([tag isKindOfClass:[NSString class]])
    {
        DLog (@"Connect did finish loading: %@", tag);
        DLog (@"Response: %@", payload);
        if ([(NSString *)tag isEqualToString:@"emailSuccess"])
        {
            // Do nothing for now...
        }
        else if ([(NSString *)tag isEqualToString:@"smsSuccess"])
        {
            // Do nothing for now...
        }
        else
        {
            // Do nothing for now...
        }
    }
}

- (void)connectionDidFailWithError:(NSError *)connectionError request:(NSURLRequest *)request andTag:(id)tag
{
    if ([tag isKindOfClass:[NSString class]])
    {
        ALog (@"Connection for %@ failed with error: %@", tag, [connectionError localizedDescription]);

        if ([(NSString *)tag isEqualToString:GET_CONFIGURATION_TAG])
        {
            self.error = [JREngageError errorWithMessage:@"There was a problem communicating with the Janrain server while configuring authentication."
                                                 andCode:JRConfigurationInformationError];
        }
        else if ([(NSString *)tag isEqualToString:@"emailSuccess"])
        {
            // Do nothing for now...
        }
        else if ([(NSString *)tag isEqualToString:@"smsSuccess"])
        {
            // Do nothing for now...
        }
        else
        {
            // Do nothing for now...
        }
    }
    else if ([(NSDictionary *)tag isKindOfClass:[NSDictionary class]])
    {
        NSString *action = [(NSDictionary *)tag objectForKey:@"action"];
        ALog (@"Connection for %@ failed with error: %@", action, [connectionError localizedDescription]);

        if ([action isEqualToString:@"callTokenUrl"])
        {
            NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
            for (id<JRSessionDelegate> delegate in delegatesCopy)
            {
                if ([delegate respondsToSelector:@selector(authenticationCallToTokenUrl:didFailWithError:forProvider:)])
                    [delegate authenticationCallToTokenUrl:[(NSDictionary *)tag objectForKey:@"tokenUrl"]
                                          didFailWithError:connectionError
                                               forProvider:[(NSDictionary *)tag objectForKey:@"providerName"]];
            } // TODO: Perhaps update the error code to use a JREngageError enum?
        }
        else if ([action isEqualToString:@"shareActivity"])
        {
            NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
            for (id<JRSessionDelegate> delegate in delegatesCopy)
            {
                if ([delegate respondsToSelector:@selector(publishingActivity:didFailWithError:forProvider:)])
                    [delegate publishingActivity:activity
                                didFailWithError:connectionError
                                     forProvider:currentProvider.name];

            }
        }
        else if ([action isEqualToString:@"shortenUrls"])
        {
            /* Call with _activity.shortenedUrl (as opposed to newShortened) in case there was an error, as
             * _activity.shortenedUrl was previously set to fall back to the full url. */
            NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
            for (id<JRSessionDelegate> delegate in delegatesCopy)
                if ([delegate respondsToSelector:@selector(urlShortenedToNewUrl:forActivity:)])
                    [delegate urlShortenedToNewUrl:((JRActivityObject *)[(NSDictionary *)tag objectForKey:@"activity"]).shortenedUrl
                                       forActivity:((JRActivityObject *)[(NSDictionary *)tag objectForKey:@"activity"])];
        }
        else
        {
            // Do nothing for now...
        }
    }
}

- (void)connectionWasStoppedWithTag:(id)userdata
{
    DLog (@"Connection was stopped.");
}

#pragma mark delegate_management
- (void)addDelegate:(id<JRSessionDelegate>)delegateToAdd
{
    if (delegateToAdd)
        [delegates addObject:delegateToAdd];
}

- (void)removeDelegate:(id<JRSessionDelegate>)delegateToRemove
{
    [delegates removeObject:delegateToRemove];
}

#pragma mark trigger_methods
- (void)triggerAuthenticationDidCompleteWithPayload:(NSDictionary *)payloadDict
{
    // This value will be nil if authentication was canceled after the user authenticated in the
    // WebView, but before the authentication call was completed, like in the case where the calling
    // application issues the cancelAuthentication command.
    if (!currentProvider)
        return;

    NSDictionary *rpxResult = [payloadDict objectForKey:@"rpx_result"];
    NSString *token = [rpxResult objectForKey:@"token"];
    NSMutableDictionary *authInfo = [[[rpxResult objectForKey:@"auth_info"] mutableCopy] autorelease];

    [authInfo setObject:token forKey:@"token"];

    DLog (@"Authentication completed for user: %@", [rpxResult description]);

    JRAuthenticatedUser *user = nil;
    if ([authInfo count] > 0) // native auth only provides an empty auth_info blob
    {
        user = [[[JRAuthenticatedUser alloc] initUserWithDictionary:rpxResult
                                                   andWelcomeString:[self getWelcomeMessageFromCookie]
                                                   forProviderNamed:currentProvider.name] autorelease];
    }

    if (user)
    {
        [authenticatedUsersByProvider setObject:user forKey:currentProvider.name];
        NSData *usersData = [NSKeyedArchiver archivedDataWithRootObject:authenticatedUsersByProvider];
        [[NSUserDefaults standardUserDefaults] setObject:usersData forKey:cJRAuthenticatedUsersByProvider];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    if ([self.authenticationProviders containsObject:currentProvider.name] && !socialSharing)
        [self saveLastUsedAuthenticationProvider:currentProvider.name];

    if ([self.sharingProviders containsObject:currentProvider.name])
        [self saveLastUsedSharingProvider:currentProvider.name];

    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id <JRSessionDelegate> delegate in delegatesCopy)
    {
        if(accountLinking) {
            if([delegate respondsToSelector:@selector(authenticationDidSucceedForAccountLinking:forProvider:)])
                [delegate authenticationDidSucceedForAccountLinking:authInfo forProvider:currentProvider.name];
        }else{
            if ([delegate respondsToSelector:@selector(authenticationDidCompleteForUser:forProvider:)])
                [delegate authenticationDidCompleteForUser:authInfo forProvider:currentProvider.name];
        }
    }
    
    if(accountLinking)
    {
        accountLinking = NO;
        return;
    }

    if (tokenUrl)
        [self startMakeCallToTokenUrl:tokenUrl withToken:token forProvider:currentProvider.name];

    self.currentProvider = nil;
}

- (void)triggerAuthenticationDidFailWithError:(NSError *)authError
{
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JRSessionDelegate> delegate in delegatesCopy)
    {
        if ([delegate respondsToSelector:@selector(authenticationDidFailWithError:forProvider:)])
            [delegate authenticationDidFailWithError:authError forProvider:currentProvider.name];
    }

    [currentProvider release],         currentProvider         = nil;
    [returningAuthenticationProvider release],  returningAuthenticationProvider = nil;
    [returningSharingProvider release], returningSharingProvider = nil;
}

- (void)triggerAuthenticationDidCancel
{
    DLog (@"");

    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JRSessionDelegate> delegate in delegatesCopy)
    {
        if ([delegate respondsToSelector:@selector(authenticationDidCancel)])
            [delegate authenticationDidCancel];
    }

    [currentProvider release], currentProvider = nil;
}

- (void)triggerAuthenticationDidCancel:(id)sender
{
    [self triggerAuthenticationDidCancel];
}

- (void)triggerAuthenticationDidTimeOutConfiguration
{
    DLog (@"");

    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JRSessionDelegate> delegate in delegatesCopy)
    {
        if ([delegate respondsToSelector:@selector(authenticationDidCancel)])
            [delegate authenticationDidCancel];
    }

    [currentProvider release], currentProvider = nil;
}

- (void)triggerAuthenticationDidStartOver:(id)sender
{
    DLog (@"");

    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JRSessionDelegate> delegate in delegatesCopy)
    {
        if ([delegate respondsToSelector:@selector(authenticationDidRestart)])
            [delegate authenticationDidRestart];
    }
}

- (void)triggerPublishingDidCancel
{
    DLog (@"");

    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JRSessionDelegate> delegate in delegatesCopy)
    {
        if ([delegate respondsToSelector:@selector(publishingDidCancel)])
            [delegate publishingDidCancel];
    }

    [currentProvider release], currentProvider = nil;
    socialSharing = NO;
}

- (void)triggerPublishingDidCancel:(id)sender
{
    [self triggerPublishingDidCancel];
}

- (void)triggerPublishingDidTimeOutConfiguration
{
    DLog (@"");

    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JRSessionDelegate> delegate in delegatesCopy)
    {
        if ([delegate respondsToSelector:@selector(publishingDidCancel)])
            [delegate publishingDidCancel];
    }

    [currentProvider release], currentProvider = nil;
    socialSharing = NO;
}

- (void)triggerPublishingDidComplete
{
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JRSessionDelegate> delegate in delegatesCopy)
    {
        if ([delegate respondsToSelector:@selector(publishingDidComplete)])
            [delegate publishingDidComplete];
    }

    [currentProvider release], currentProvider = nil;
    socialSharing = NO;
}

- (void)triggerPublishingDidComplete:(id)sender
{
    [self triggerPublishingDidComplete];
}

- (void)triggerPublishingDidFailWithError:(NSError *)pubError
{
    NSArray *delegatesCopy = [NSArray arrayWithArray:delegates];
    for (id<JRSessionDelegate> delegate in delegatesCopy)
    {
        if ([delegate respondsToSelector:@selector(publishingActivity:didFailWithError:forProvider:)])
            [delegate publishingActivity:activity didFailWithError:pubError forProvider:currentProvider.name];
    }
}

- (void)triggerEmailSharingDidComplete
{
    DLog (@"");
    [self startRecordActivitySharedBy:@"email"];
}

- (void)triggerSmsSharingDidComplete
{
    DLog (@"");
    [self startRecordActivitySharedBy:@"sms"];
}

- (NSDictionary *)customProvidersFromConfigurationDictionary:(NSDictionary *)configDict
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for (NSString *providerId in [configDict allKeys])
    {
        NSDictionary *providerDict = [configDict objectForKey:providerId];
        if ([providerDict objectForKey:kJRCustomSamlProviderSamlName])
        {
            [result setObject:[self customSamlProviderWithId:providerId andDict:providerDict] forKey:providerId];
        }
        else if ([providerDict objectForKey:kJRCustomOpenIdIdentifier])
        {
            [result setObject:[self customOpenIdProviderWithId:providerId andDict:providerDict] forKey:providerId];
        }
        else
        {
            ALog(@"Error: unrecognized entry in custom provider configuration dictionary: %@",
                [providerDict description]);
        };
    }
    return result;
}

- (JRProvider *)customSamlProviderWithId:(NSString *)providerId andDict:(NSDictionary *)dict
{
    NSMutableDictionary *dict_ = [NSMutableDictionary dictionaryWithDictionary:dict];
    [dict_ addEntriesFromDictionary:@{
            @"url" : @"/saml2/sso/start",
            @"saml_provider" : [[dict objectForKey:kJRCustomSamlProviderSamlName] stringByAddingUrlPercentEscapes]
    }];

    return [[[JRProvider alloc] initWithName:providerId andDictionary:dict_] autorelease];
}

- (JRProvider *)customOpenIdProviderWithId:(NSString *)providerId andDict:(NSDictionary *)dict
{
    NSMutableDictionary *dict_ = [NSMutableDictionary dictionaryWithDictionary:dict];
    [dict_ addEntriesFromDictionary:@{
            @"url" : @"/openid/start",
            @"openid_identifier" : [[dict objectForKey:kJRCustomOpenIdIdentifier] stringByAddingUrlPercentEscapes]
    }];
    NSString *opxBlob;
    if ((opxBlob = [dict objectForKey:kJRCustomOpenIdOpxblob]))
    {
        [dict_ setObject:[opxBlob stringByAddingUrlPercentEscapes] forKey:kJRCustomOpenIdOpxblob];
    }

    return [[[JRProvider alloc] initWithName:providerId andDictionary:dict_] autorelease];
}

- (void)dealloc
{
    DLog();
    [sharingProviders release];
    [returningSharingProvider release];
    [returningAuthenticationProvider release];
    [baseUrl release];
    [providersWithIcons release];
    [iconsStillNeeded release];
    [engageProviders release];
    [authenticatedUsersByProvider release];
    [delegates release];
    [activity release];
    [appId release];
    [tokenUrl release];
    [currentProvider release];
    [error release];
    [updatedEtag release];
    [savedConfigurationBlock release];
    [engageAuthenticationProviders release];
    [super dealloc];
}

- (void)clearReturningAuthenticationProvider
{
    returningAuthenticationProvider = nil;
}
@end

@implementation JRSessionData (Internal)
+ (void)setServerUrl:(NSString *)serverUrl_
{
    NSString *oldServerUrl = serverUrl;
    serverUrl = [serverUrl_ retain];
    [oldServerUrl release];
}
@end
