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
//#define JR_FACEBOOK_SDK_TEST

#import "AppDelegate.h"
#import "JRCapture.h"
#import "debug_log.h"
#import "JRSessionData.h"
#import "JRCaptureData.h"
#import "JRCaptureConfig.h"
#import "JRCaptureError.h"
#import "JREngage.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>



@interface MyCaptureDelegate : NSObject <JRCaptureDelegate>
@end

@interface JRSessionData (Internal)
+ (void)setServerUrl:(NSString *)serverUrl_;
@end


AppDelegate *appDelegate = nil;

@implementation AppDelegate
@synthesize window;
@synthesize prefs;



// Capture stuff:
@synthesize captureUser;
@synthesize captureClientId;
@synthesize captureDomain;
@synthesize captureLocale;
@synthesize captureTraditionalSignInFormName;
@synthesize captureFlowName;
@synthesize engageAppId;
@synthesize captureFlowVersion;
@synthesize captureEnableThinRegistration;
@synthesize captureTraditionalRegistrationFormName;
@synthesize captureSocialRegistrationFormName;
@synthesize captureAppId;
@synthesize customProviders;
@synthesize captureForgottenPasswordFormName;
@synthesize captureEditProfileFormName;
@synthesize resendVerificationFormName;


// Demo state machine stuff:
@synthesize currentProvider;
@synthesize isNotYetCreated;

//OpenID AppAuth
@synthesize googlePlusClientId;
@synthesize googlePlusRedirectUri;
@synthesize googlePlusOpenIDScopes;
@synthesize openIDAppAuthAuthorizationFlow;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    appDelegate = self;

    // register for Janrain notification(s)
    [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(onJRDownLoadFlowResult:)
                   name:JRDownloadFlowResult object:nil];

    [self loadDemoConfigFromPlist];

    JRCaptureConfig *config = [JRCaptureConfig emptyCaptureConfig];
    config.engageAppId = engageAppId;
    config.captureDomain = captureDomain;
    config.captureClientId = captureClientId;
    config.captureLocale = captureLocale;
    config.captureFlowName = captureFlowName;
    config.captureFlowVersion = captureFlowVersion;
    config.captureSignInFormName = captureTraditionalSignInFormName;
    config.captureTraditionalSignInType = JRTraditionalSignInEmailPassword;
    config.enableThinRegistration = captureEnableThinRegistration;
    config.customProviders = customProviders;
    config.captureTraditionalRegistrationFormName = captureTraditionalRegistrationFormName;
    config.captureSocialRegistrationFormName = captureSocialRegistrationFormName;
    config.captureAppId = captureAppId;
    config.forgottenPasswordFormName = captureForgottenPasswordFormName;
    config.editProfileFormName = captureEditProfileFormName;
    config.resendEmailVerificationFormName = resendVerificationFormName;

    [JRCapture setCaptureConfig:config];
    self.prefs = [NSUserDefaults standardUserDefaults];
    self.currentProvider = [self.prefs objectForKey:cJRCurrentProvider];

    NSData *archivedCaptureUser = [self.prefs objectForKey:cJRCaptureUser];
    if (archivedCaptureUser)
    {
        self.captureUser = [NSKeyedUnarchiver unarchiveObjectWithData:archivedCaptureUser];
    }

    return YES;
}


/*! @brief Handles inbound URLs. Checks if the URL matches the redirect URI for a pending
 AppAuth authorization request.
 */
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *, id> *)options {
    // Sends the URL to the current authorization flow (if any) which will process it if it relates to
    // an authorization response.
    if ([self.openIDAppAuthAuthorizationFlow resumeExternalUserAgentFlowWithURL:url]) {
        self.openIDAppAuthAuthorizationFlow = nil;
        return YES;
    }
    // Your additional URL handling (if any) goes here.
    return NO;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

}

- (void)loadDemoConfigFromPlist
{
    // See assets folder in Resources project group for janrain-config-default.plist
    // Copy to janrain-config.plist and change it to your details
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"janrain-config" ofType:@"plist"];
    if (!plistPath)
    {
        plistPath = [[NSBundle mainBundle] pathForResource:@"janrain-config-default" ofType:@"plist"];
    }
    if (!plistPath)
    {
        plistPath = [[NSBundle mainBundle] pathForResource:@"assets/janrain-config" ofType:@"plist"];
    }
    NSDictionary *cfgPlist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSString *configKeyName = [cfgPlist objectForKey:@"default-config"];
    self.captureEnableThinRegistration = YES;
    [self parseConfigNamed:configKeyName fromConfigPlist:cfgPlist];
}

- (void)parseConfigNamed:(NSString *)cfgKeyName fromConfigPlist:(NSDictionary *)cfgPlist
{
    NSDictionary *cfg = [cfgPlist objectForKey:cfgKeyName];

    NSString *parentConfig = [cfg objectForKey:@"parentConfig"];
    if (parentConfig) [self parseConfigNamed:parentConfig fromConfigPlist:cfgPlist];

    if ([cfg objectForKey:@"captureClientId"])
        self.captureClientId = [cfg objectForKey:@"captureClientId"];
    if ([cfg objectForKey:@"captureDomain"])
        self.captureDomain = [cfg objectForKey:@"captureDomain"];
    if ([cfg objectForKey:@"captureLocale"])
        self.captureLocale = [cfg objectForKey:@"captureLocale"];
    if ([cfg objectForKey:@"captureTraditionalSignInFormName"])
        self.captureTraditionalSignInFormName = [cfg objectForKey:@"captureTraditionalSignInFormName"];
    if ([cfg objectForKey:@"captureFlowName"])
        self.captureFlowName = [cfg objectForKey:@"captureFlowName"];
    if ([cfg objectForKey:@"captureEnableThinRegistration"])
        self.captureEnableThinRegistration = [[cfg objectForKey:@"captureEnableThinRegistration"] boolValue];
    if ([cfg objectForKey:@"captureFlowVersion"])
        self.captureFlowVersion = [cfg objectForKey:@"captureFlowVersion"];
    if ([cfg objectForKey:@"captureTraditionalRegistrationFormName"])
        self.captureTraditionalRegistrationFormName = [cfg objectForKey:@"captureTraditionalRegistrationFormName"];
    if ([cfg objectForKey:@"captureSocialRegistrationFormName"])
        self.captureSocialRegistrationFormName = [cfg objectForKey:@"captureSocialRegistrationFormName"];
    if ([cfg objectForKey:@"captureAppId"])
        self.captureAppId = [cfg objectForKey:@"captureAppId"];
    if ([cfg objectForKey:@"engageAppId"])
        self.engageAppId = [cfg objectForKey:@"engageAppId"];
    if ([cfg objectForKey:@"captureForgottenPasswordFormName"])
        self.captureForgottenPasswordFormName = [cfg objectForKey:@"captureForgottenPasswordFormName"];
    if ([cfg objectForKey:@"captureEditProfileFormName"])
        self.captureEditProfileFormName = [cfg objectForKey:@"captureEditProfileFormName"];
    if ([cfg objectForKey:@"resendVerificationFormName"])
        self.resendVerificationFormName = [cfg objectForKey:@"resendVerificationFormName"];
    if ([cfg objectForKey:@"rpxDomain"])
        [JRSessionData setServerUrl:[NSString stringWithFormat:@"https://%@", [cfg objectForKey:@"rpxDomain"]]];
    if ([cfg objectForKey:@"flowUsesTestingCdn"])
    {
        BOOL useTestingCdn = [[cfg objectForKey:@"flowUsesTestingCdn"] boolValue];
        [JRCaptureData sharedCaptureData].flowUsesTestingCdn = useTestingCdn;
    }
    //OpenID AppAuth
    if ([cfg objectForKey:@"googlePlusClientId"])
        self.googlePlusClientId = [cfg objectForKey:@"googlePlusClientId"];
    if ([cfg objectForKey:@"googlePlusRedirectUri"])
        self.googlePlusRedirectUri = [cfg objectForKey:@"googlePlusRedirectUri"];
    if ([cfg objectForKey:@"googlePlusOpenIDScopes"])
        self.googlePlusOpenIDScopes = [cfg objectForKey:@"googlePlusOpenIDScopes"];
}

- (void)saveCaptureUser
{
    [self.prefs setObject:[NSKeyedArchiver archivedDataWithRootObject:self.captureUser] forKey:cJRCaptureUser];
}

- (void)onJRDownLoadFlowResult:(NSNotification *)notification
{
    if ([notification object] != nil){
        JRCaptureError *error = (JRCaptureError*)[notification object];
        NSLog(@"JRCaptureError! Desc=%@", [error localizedDescription]);
        for (NSString *key in [[error userInfo] allKeys]){
            NSLog(@"JRCaptureError:%@", [[error userInfo] objectForKey:key]);
        }
    }
    else
    {
        NSLog(@"THE Janrain FLOW was successfully downloaded");
    }
}


@end
