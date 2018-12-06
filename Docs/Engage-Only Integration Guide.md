# Engage-Only Integration Guide

This guide describes integrating Engage-only into your iOS App. For a description of integration steps for the JUMP
platform see `JUMP Integration Guide.md`.

## 10,000' View

1. Gather configuration details.
2. Add the library to your Xcode project.
3. Initialize the library with your Engage application’s application ID, your web server’s token URL, and your delegate
   object (which conforms to the the
   [JREngageSigninDelegate](http://janrain.github.com/jump.ios/gh_docs/engage/html/protocol_j_r_engage_signin_delegate-p.html)
   and/or the
   [JREngageSharingDelegate](http://janrain.github.com/jump.ios/gh_docs/engage/html/protocol_j_r_engage_sharing_delegate-p.html)
   protocols.)
4. Begin authentication or sharing by calling one of the "show...Dialog" methods.
5. Receive your token URL's response in `-authenticationDidReachTokenUrl:withResponse:andPayload:forProvider:`.

## Gather Configuration Details

### Configure Identity Providers on the Engage Dashboard

Make sure your desired set of social identity providers is configured in the Engage Dashboard. Sign-in to Engage and
[configure the providers](http://developers.janrain.com/documentation/widgets/social-sign-in-widget/social-sign-in-widget-users-guide/configure-the-widget/provider-setup-guide/).

(Configuring the providers themselves is a separate step from configuring which providers are enabled for the Engage
library.)

### Configure the Providers Used in the iOS Library

While signed in to the Engage dashboard go to the Engage for iOS configuration wizard (in the drop-down menus, under
Deployment -> Engage for iOS). Follow the wizard, use it to configure the providers to use for authentication and
social sharing from the iOS library.

### Retrieve your Engage Application ID

You will also need your 20-character Application ID from the Engage Dashboard. Click the `Home` link int the Engage
dashboard and you will find your app ID in the right-most column towards the bottom of the colum under the "Application
Info" header.

## Add the Engage Library to the Xcode Project

1. Follow the steps JUMP for iOS Xcode setup instructions here, but skip generating the Capture User Model:
   [Adding to Xcode](http://developers.janrain.com/documentation/mobile-libraries/jump-for-ios/adding-to-xcode/)
2. Remove the JRCapture project group from your project.

## Choose an Engage Delegate Class and Initialize the Library

Select the class you will use to receive callbacks from the Engage library. This is called your Engage delegate.
The delegate should be persistent (will not be dealloced during the course of your app's lifetime) and it should be a
singleton. Your app's AppDelegate is a good choice to start with.

In the interface of your chosen Engage delegate class import the Engage header: `#import "JREngage.h"`, and conform to
the `JREngageSigninDelegate` and `JREngageSharingDelegate` protocols:

    @interface AppDelegate : UIResponder <UIApplicationDelegate, JREngageSigninDelegate>

In your delegate's implementation, during its initialization, (or from elsewhere in your app's initialization), call
the JREngage initialization method, for example from from your AppDelegate's
`-application:didFinishLaunchingWithOptions:`:

    [JREngage setEngageAppId:@"<your app id>" tokenUrl:@"<your_token_url>" andDelegate:yourEngageDelegate];

Stub out these two delegate message implementations in your delegate:

    - (void)authenticationDidReachTokenUrl:(NSString *)tokenUrl withResponse:(NSURLResponse *)response
                                andPayload:(NSData *)tokenUrlPayload forProvider:(NSString *)provider
    {
        NSLog(@"%@", [response description]);
    }

    - (void)authenticationDidSucceedForUser:(NSDictionary *)authInfo forProvider:(NSString *)provider
    {
        NSLog(@"%@", [authInfo description]);
    }

## Implement the OpenID AppAuth Libraries

There are potentially *breaking* changes to the Janrain Mobile SDK with version 5.0.  Due to Google's decision to not allow web-based authentication through webviews, support for web-based authentication for Google has been implemented using Google's recommended OpenID AppAuth (http://openid.github.io/AppAuth-iOS/) libraries.  These libraries are now a *required* dependency of the Janrain Mobile Libraries.'

The OpenID AppAuth for iOS libraries (version 0.7.1 tested) can be installed using CocoaPods or as an Xcode Workspace library.  Please refer to this link for additional information on installing the OpenID AppAuth for iOS libraries: http://openid.github.io/AppAuth-iOS/ Make sure your project's "Linked Frameworks and Libraries" includes a reference to the OpenID AppAuth for iOS Library ("libAppAuth.a" or "libAppAuth-iOS.a")

If you are linking to the OpenID AppAuth Library repo and not using CocoaPods you may need to add the OpenID AppAuth library source code location to your Xcode project's Build Settings -> Search Paths -> Header Search Paths value: example: `/GitHub/OpenIDAppAuth/AppAuth-iOS/Source` (use the "recursive" option if needed).

The sample applications provided as part of the Janrain Mobile Libraries repository have been updated to use the Xcode Workspace library implementation method.  This may require re-linking of the libraries for your build environement. *NOTE:* You may have to convert your Xcode project to a workspace project if you do not want to use CocoaPods.

Once you have added the OpenID AppAuth libraries to your project or workspace the following settings will need to be added/updated in your application if you are planning on using Google as a web-based identity provider in your mobile application.  NOTE: These steps are not necessary if you are using Google Native authentication using the Google iOS SDK.

###Create an iOS Google OAuth Client

Visit https://console.developers.google.com/apis/credentials?project=_ and find the project that correlates to the Google Web OAuth client that is being used with the *same* Engage application being used by the Janrain Mobile Libraries. Then tap "Create credentials" and select "OAuth client ID".  Follow the instructions to configure the consent screen (just the Product Name is needed).

Then, complete the OAuth client creation by selecting "iOS" as the Application type.  Enter the Bundle ID of the project (`com.janrain.simpledemo.example` for example, but you must change this in the project and use your own Bundle ID).

Copy the client ID to the clipboard or a location for future use.

###Update Janrain Library configuration
Update your application's configuration (i.e. https://github.com/janrain/jump.ios/blob/master/Samples/SimpleCaptureDemo/assets/janrain-config-default.plist ) by adding the following values:

`<key>googlePlusRedirectUri</key>
<string>com.googleusercontent.apps.YOUR_CLIENT_ID:/oauthredirect</string>
<key>googlePlusClientId</key>
<string>YOUR_CLIENT_ID.apps.googleusercontent.com</string>`

If you are not using the plist format shown in the Sample Applications you will need to make sure that the appropriate values ("googlePlusClientId" and "googlePlusRedirectUri") are passed through when you are initializing the JRCaptureConfig prior to initializing the libraries:
`JRCaptureConfig *config = [JRCaptureConfig emptyCaptureConfig];
config.engageAppId = engageAppId;
config.captureDomain = captureDomain;
config.captureClientId = captureClientId;
config.captureLocale = captureLocale;
config.captureFlowName = captureFlowName;
...
config.googlePlusClientId = googlePlusClientId;
config.googlePlusRedirectUri = googlePlusRedirectUri;`

###Update your applications info.plist
Open your application's' `Info.plist` and fully expand "URL types" (a.k.a. "CFBundleURLTypes") and replace `com.googleusercontent.apps.YOUR_CLIENT_ID` with the reverse DNS notation form of your client id (not including the `:/oauthredirect` path component).

Example:
`<key>CFBundleURLTypes</key>
    <array>
        <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.YOUR_CLIENT_ID</string>
        </array>
        </dict>
</array>
`

####Update your application's AppDelegate.h####

ADD the following import:
`#import "JROpenIDAppAuthGoogleDelegate.h"`
ADD the JROpenIDAppAuthGoogleDelegate Protocol:
`@interface AppDelegate : UIResponder <UIApplicationDelegate, JROpenIDAppAuthGoogleDelegate>`

####Update your application's AppDelegate.m####

Synthesize the variables:
`@synthesize googlePlusClientId;` and
`@synthesize googlePlusRedirectUri;` and
`@synthesize openIDAppAuthAuthorizationFlow;`


UPDATE/ADD the following method so it is as follows:

    /*! @brief Handles inbound URLs. Checks if the URL matches the redirect URI for a pending
     AppAuth authorization request.
     */
    - (BOOL)application:(UIApplication *)app
                openURL:(NSURL *)url
                options:(NSDictionary<NSString *, id> *)options {
        // Sends the URL to the current authorization flow (if any) which will process it if it relates to
        // an authorization response.
        if ([self.openIDAppAuthAuthorizationFlow resumeAuthorizationFlowWithURL:url ]) {
            self.openIDAppAuthAuthorizationFlow = nil;
            return YES;
        }
        // Your additional URL handling (if any) goes here.
        return NO;
    }

ADD/UPDATE the `(void)parseConfigNamed:(NSString *)cfgKeyName fromConfigPlist:(NSDictionary *)cfgPlist` method to load the Google AppAuth values from the plist:

    //OpenID AppAuth
    if ([cfg objectForKey:@"googlePlusClientId"])
        self.googlePlusClientId = [cfg objectForKey:@"googlePlusClientId"];
    if ([cfg objectForKey:@"googlePlusRedirectUri"])
        self.googlePlusRedirectUri = [cfg objectForKey:@"googlePlusRedirectUri"];

####New optional configuration items####

1. `config.engageAppUrl` If this value is set when intializing the Mobile Libraries the libraries will attempt to use the url provided for all Social Login (Engage) communications.  This setting should only be used when advised to do so by a Janrain technical resource.

2. `config.downloadFlowUrl` If this value is set when intializing the Mobile Libraries the libraries will attempt to use the url provided for all download the Registration flow configuration file.  This setting should only be used when advised to do so by a Janrain technical resource.

## Social Sign-In

An Engage authentication is only meaningful in the context of authenticating your mobile app /to/ something.
If you are unsure of what your users should be signing-in to, then Janrain Capture may be a suitable choice.

To start authentication send the
[showAuthenticationDialog](http://janrain.github.com/jump.ios/gh_docs/engage/html/interface_j_r_engage.html#a0de1aa16e951a1b62e2ef459b1596e83)
message to the `JREngage` class:

    [JREngage showAuthenticationDialog];

You will receive your authentication token URL's response in the authenticationDidReachTokenUrl:... message. When
received you will have access to the body of the response, as well as the headers, which frequently contain session
cookies used to coordinate the app's session with your web server. Parsing your authentication token URL's response
for session establishing information, or retrieving session cookies from the header, is your app's responsibility.

For guidance implementing your web-server's authentication token URL, see `Authentication-Token-URL.md`.

### UI Customization

To customize the look and feel of the sign-in experience, please see the
[Custom Interface Guide for iOS](https://github.com/janrain/jump.ios/blob/master/Docs/Custom_UI_for_iOS.md).

## Social Sharing

If you want to share an activity, first
[create an instance](http://janrain.github.com/jump.ios/gh_docs/engage/html/interface_j_r_activity_object.html#a853261b333e02bbd096a8e1d2092195d)
of the [JRActivityObject](http://janrain.github.com/jump.ios/gh_docs/engage/html/interface_j_r_activity_object.html)
and populate the activity object’s fields:

    JRActivityObject *activity =
        [JRActivityObject activityObjectWithAction:@"added JREngage to her iPhone application!"
                                            andUrl:@"http://janrain.com"];[/sourcecode]

Then pass the activity to the
[showSharingDialogWithActivity:](http://janrain.github.com/jump.ios/gh_docs/engage/html/interface_j_r_engage.html#adbbf64bfffdd179fe593145f16ab4b5f)
message:

    [JREngage showSharingDialogWithActivity:activity];

Your user may choose to sign in with additional social providers in order to share. If they do, your delegate will
receive the
[authenticationDidSucceedForUser:forProvider:](http://janrain.github.com/jump.ios/gh_docs/engage/html/protocol_j_r_engage_signin_delegate-p.html#a9803676f3066c7eae7127d57a193f38f "authenticationDidSucceedForUser") and [authenticationDidReachTokenUrl:withResponse:andPayload:forProvider:](http://janrain.github.com/jump.ios/gh_docs/engage/html/protocol_j_r_engage_signin_delegate-p.html#abb576f76e23750d0fbc90409f60ab250 "authenticationDidSucceedForUser") messages. If you don’t want new authentications posted to your token URL, you can remove the token URL with the [updateTokenUrl:](http://janrain.github.com/jump.ios/gh_docs/engage/html/interface_j_r_engage.html#a5af5ed8a0bcaf58a31656d4ed81b7b40)
message.

Additionally, as your users shares their activity on the different providers, you will receive
[sharingDidSucceedForActivity:forProvider:](http://janrain.github.com/jump.ios/gh_docs/engage/html/protocol_j_r_engage_sharing_delegate-p.html#afe0da35cf96f23421abfa12d497c0132 "sharingDidSucceedForActivity:forProvider:") messages on your [JREngageSharingDelegate](http://janrain.github.com/jump.ios/gh_docs/engage/html/protocol_j_r_engage_sharing_delegate-p.html "JREngageSharingDelegate") delegate. Finally, the [JREngageSharingDelegate](http://janrain.github.com/jump.ios/gh_docs/engage/html/protocol_j_r_engage_sharing_delegate-p.html "JREngageSharingDelegate") delegate will receive a [sharingDidComplete](http://janrain.github.com/jump.ios/gh_docs/engage/html/protocol_j_r_engage_sharing_delegate-p.html#abfd122aa4da3befaa402a8c528ab67ef "SharingDidComplete") message once the user finishes sharing. If the user cancels sharing before the activity was posted to any provider, the delegate will receive the [sharingDidNotComplete](http://janrain.github.com/jump.ios/gh_docs/engage/html/protocol_j_r_engage_sharing_delegate-p.html#abfd122aa4da3befaa402a8c528ab67ef)
message.

### More

For information on sharing through email or SMS, please see
[Email, SMS, and Shortening URLs](http://developers.janrain.com/documentation/mobile-libraries/advanced-topics/email-sms-and-urls/).

## Good to Know

The first time your application uses `JREngage` on any device, the library contacts the Engage servers to retrieve your
application’s configuration information. After downloading, the library caches this information. The library updates
the cache only when the information changes (for example, when you add or remove a provider). The Library checks for
updates after it initializes.

While you can initialize the `JREngage` library immediately before you call one of the `show...` methods, understand
that your users may encounter our loading screen while the library contacts the Engage servers.
