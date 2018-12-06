# Configuring the SimpleCaptureDemoNative application.

## IMPORTANT

This sample application is NOT configured with any credentials or provided configuration.  You will need to follow the steps below to configure the relevant settings for your environment.

SimpleCaptureDemoNative demos:
- Traditional sign-in to Capture
- Social sign-in (via Engage) to Capture
- Sign-in session management
- Registration (traditional and social)
- Native Authentication using Facebook, Google+, and Twitter
- REQUIRED: Facebook SDK version 4.31.1
- REQUIRED: Google Signin SDK 4.1.2
- REQUIRED: TwitterKit 3.3.0

To run this demo with your own configuration:

1. Find janrain-config-default.plist
2. Copy it to janrain-config.plist
3. Edit the settings in the copy to reflect your Social Login and Registration Settings.
4. Edit the settings to include the correct form names as found in your flow file.
5. Make sure you have the OpenID AppAuth for iOS Libraries implemented/installed:

Due to Google's decision to not allow web-based authentication through webviews, support for web-based authentication for Google has been implemented using Google's recommended OpenID AppAuth (http://openid.github.io/AppAuth-iOS/) libraries.  These libraries are now a *required* dependency of the Janrain Mobile Libraries.

The OpenID AppAuth for iOS libraries (version 0.7.1 tested) can be installed using CocoaPods or as an Xcode Workspace library.  Please refer to this link for additional information on installing the OpenID AppAuth for iOS libraries: http://openid.github.io/AppAuth-iOS/ Make sure your project's "Linked Frameworks and Libraries" includes a reference to the OpenID AppAuth for iOS Library ("libAppAuth.a")

If you are linking to the OpenID AppAuth Library repo and not using CocoaPods you may need to add the OpenID AppAuth library source code location to your Xcode project's Build Settings -> Search Paths -> Header Search Paths value: example: `/GitHub/OpenIDAppAuth/AppAuth-iOS/Source` (use the "recursive" option if needed).

This sample application has been updated to use the Xcode Workspace library implementation method.  This *WILL* require re-linking of the libraries for your build environement. *NOTE:* You may have to convert your Xcode project to a workspace project if you do not want to use CocoaPods.

Once you have added the OpenID AppAuth libraries to your project or workspace the following settings will need to be added/updated in your application if you are planning on using Google as a web-based identity provider in your mobile application.  NOTE: These steps are not necessary if you are using Google Native authentication using the Google iOS SDK.

#### Create an iOS Google OAuth Client

Visit https://console.developers.google.com/apis/credentials?project=_ and find the project that correlates to the Google Web OAuth client that is being used with the *same* Engage application being used by the Janrain Mobile Libraries. Then tap "Create credentials" and select "OAuth client ID".  Follow the instructions to configure the consent screen (just the Product Name is needed).

Then, complete the OAuth client creation by selecting "iOS" as the Application type.  Enter the Bundle ID of the project (`com.janrain.simpledemo.example` for example, but you must change this in the project and use your own Bundle ID).

Copy the client ID to the clipboard or a location for future use.

#### Update Janrain Library configuration
Update your application's configuration (i.e. https://github.com/janrain/jump.ios/blob/master/Samples/SimpleCaptureDemo/assets/janrain-config-default.plist ) by adding/updating the following values:

`<key>googlePlusRedirectUri</key>
<string>com.googleusercontent.apps.YOUR_CLIENT_ID:/oauthredirect</string>
<key>googlePlusClientId</key>
<string>YOUR_CLIENT_ID.apps.googleusercontent.com</string>`

#### Update your applications info.plist
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

There is now an optional janrain-config.plist setting that allows you to define the OpenID Scopes that will be requested during the Google OpenID request process.  The full list of scopes available is as follows:

    <key>googlePlusOpenIDScopes</key>
    <array>
        <string>OIDScopeAddress</string>
        <string>OIDScopePhone</string>
        <string>OIDScopeEmail</string>
        <string>OIDScopeProfile</string>
        <string>OIDScopeOpenID</string>
    </array>

6. You will need to follow these steps for each native provider:
  * #### Facebook
    1. Download the Facebook SDK for iOS from this link:  https://developers.facebook.com/docs/ios
    2. Follow *ALL* of the steps on this page *EXCEPT* for Step 2 (Create a Facebook App): https://developers.facebook.com/docs/ios/getting-started/  In order for the Janrain Social Login Server to validate the provided Facebook oAuth token, the token must be provisioned from the same Facebook application that is configured for the Janrain Social Login application.  In most cases, the developer would simply add an iOS App Settings configuration to the existing Facebook App.
    3.  Use this page as a starting point for implementing native Facebook Login:  https://developers.facebook.com/docs/facebook-login/ios/v2.4
    4. Update the "SimpleCaptureDemoNative-Info.plist" file to use your Facebook App ID in the recommended places.  This should match the Facebook App ID that was used for configuring the Facebook provider in the Social Login Dashboard.
    5.  Make sure that the Permissions requested in the `logInWithReadPermissions` method include the required permissions.  In most cases these permissions need to mirror the Facebook app permissions configuration of the Engage Social Login application that is configured in the Janrain Social Login Dashboard.
    6.  Refer to the `RootViewControoler.m` file for an example of how this was done with the SimpleCaptureDemoNative application.

  * #### Google Sign-in
    1. Download the Google Sign-In SDK 4.1.0 SDK from this link: https://developers.google.com/identity/sign-in/ios/sdk/google_signin_sdk_4_1_0.zip.  Refer to this link for additional information: https://developers.google.com/identity/sign-in/ios/sdk/
    2. Follow *ALL* of the steps on this page that involve the XCode project configuration and Google app configuration: https://developers.google.com/identity/sign-in/ios/sdk/  In order for the Janrain Social Login Server to validate the provided Google Sign-In oAuth token, the token must be provisioned from the same Google application that is configured for the Janrain Social Login application.  In most cases, the developer would simply add an iOS App Client ID configuration to the existing Google App.
    3. Update the "SimpleCaptureDemoNative-Info.plist" file to use your Google App ID in the recommended places.  This should match the Google App ID that was used for configuring the Google provider in the Social Login Dashboard.
    4. Update the Google "GoogleService-Info.plist" file with your Google App Client ID and reversed Client ID.
    5. Update the "Classes/RootViewController.m" file to use your Google Client ID (Line 56).
    6. In the case of the SimpleCaptureDemoNative application the integration steps were implemented in the `RootViewControoler` files with minimal changes from the examples provided by Google at this link: https://developers.google.com/identity/sign-in/ios/sign-in
    7. Make sure that the Scopes requested by the `GPPSignIn` singleton includes the required scopes.  In most cases these scopes need to mirror the Google app permissions configuration of the Engage Social Login application that is configured in the Janrain Social Login Dashboard.
    8. Refer to the `RootViewControoler.m` file for an example of how this was done with the SimpleCaptureDemoNative application.

  * #### Twitter
    1. Download the Twitterkit SDK from this link: https://dev.twitter.com/twitterkit/ios/installation
    2. Configure your Twitter App: https://apps.twitter.com/ In order for the Janrain Social Login Server to validate the provided Twitter oAuth token, the token must be provisioned from the same Twitter application that is configured for the Janrain Social Login application.  In most cases, the developer would simply add an iOS App Client ID configuration to the existing Twitter App.
    3. Update the "SimpleCaptureDemoNative-Info.plist" file to use your Twitter API Key (or consumer key) in the recommended place.  This should match the Twitter App ID that was used for configuring the Twitter provider in the Social Login Dashboard.
    4. Edit the "Classes/AppDelegate.m" file to update the application with your Twitter Consumer Key and Consumer Secret. (Line 99)
    5. In the case of the SimpleCaptureDemoNative application the integration steps were implemented in the `RootViewControoler` files with minimal changes from the examples provided by Twitter at this link: https://dev.twitter.com/twitterkit/ios/log-in-with-twitter
    6. NOTE: In most default cases Twitter will not return an email address for an end user. This may cause account merging or linking issues if your Registration user experience relies heavily on merged social profiles.  This use-case is typically addressed by forcing Twitter account holders to use the "Account Linking" functionality of the SDK.  Customer's may choose to work with Twitter to get their application white-listed so it will attempt to return an email address from a user profile.  However, email addresses are not "required" for Twitter accounts, subsequently there is still no guarantee that an email address will be returned.

7. Refer to the `RootViewControoler.m` file for an example of how this was done with the SimpleCaptureDemoNative application.

8. Make sure to add/update the following method in your AppDelegate.m file accordingly (You may not need to handle the url scheme variations):

    -(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
        if(url.scheme != nil && [url.scheme hasPrefix:@"twitter"]) {
            return [[Twitter sharedInstance] application:app openURL:url options:options];
        }
        return NO;
    }

### Typical Misconfiguration Errors

*Error*:
`Undefined symbols for architecture x86_64:
"_OBJC_CLASS_$_JROpenIDAppAuth", referenced from:
objc-class-ref in JREngage.o
objc-class-ref in JRProvidersController.o`

*Resolution*: Delete the "Janrain" folder reference from your project and re-add the folder reference linking to the latest files.  New files have been added to the Janrain Libraries and they are not being referenced in your project.

*Error*:
`/jump.ios/Janrain/JREngage/Classes/JROpenIDAppAuthGoogle.m:28:9: 'AppAuth.h' file not found`

*Resolution*: Please follow the steps outlined above and include the OpenID AppAuth library to your workspace.

*Error*:
Linker error: ld: library not found for -lAppAuth

*Resolution*: You may have to remove and re-add the libApp-Auth or libAppAuth-ios library to your project's "Linked Frameworks and Libraries" includes a reference to the OpenID AppAuth for iOS Library ("libAppAuth.a")

*Error*:
`/jump.ios/Janrain/JREngage/Classes/JROpenIDAppAuthGoogle.m:53:59: Property 'googlePlusRedirectUri' not found on object of type 'AppDelegate *`

*Resolution*: Add the following to your AppDelegate.h file (see the Sample Application code for additional context):
`@property(nonatomic) NSString *googlePlusRedirectUri;`


*Error*:
`/jump.ios/Janrain/JREngage/Classes/JROpenIDAppAuthGoogle.m:74:80: Property 'googlePlusClientId' not found on object of type 'AppDelegate *'`

*Resolution*: Add the following to your AppDelegate.h file (see the Sample Application code for additional context):
`@property(nonatomic) NSString *googlePlusClientId;`


*Error*:
`/jump.ios/Janrain/JREngage/Classes/JROpenIDAppAuthGoogle.m:87:25: Property 'openIDAppAuthAuthorizationFlow' not found on object of type 'AppDelegate *'`

*Resolution*: Add the following to your AppDelegate.h file (see the Sample Application code for additional context):
`@property(nonatomic, strong) id<OIDAuthorizationFlowSession> openIDAppAuthAuthorizationFlow;`

*Error*:
`/jump.ios/Samples/SimpleCaptureDemo/SimpleCaptureDemo/Classes/AppDelegate.h:76:33: No type or protocol named 'OIDAuthorizationFlowSession'`

*Resolution*: Add the following to your AppDelegate.h file (see the Sample Application code for additional context):
`@protocol OIDAuthorizationFlowSession;`

*Errors*:
`(null): "_OBJC_CLASS_$_OIDAuthState", referenced from:`,
`(null): "_OBJC_CLASS_$_OIDAuthorizationRequest", referenced from:`,
`(null): "_OIDResponseTypeCode", referenced from:`,
`(null): "_OBJC_CLASS_$_OIDAuthorizationService", referenced from:`,
`(null): "_OIDScopeOpenID", referenced from:`,
`(null): "_OIDScopeProfile", referenced from:`

*Resolution*: Make sure your project's "Linked Frameworks and Libraries" includes a reference to the OpenID AppAuth for iOS Library ("libAppAuth.a")

*Error*:
`/jump.ios/Samples/SimpleCaptureDemoNative/SimpleCaptureDemoNative/Classes/AppDelegate.m:44:9: 'FBSDKCoreKit/FBSDKCoreKit.h' file not found`

*Resolution*: Add ~/Documents/FacebookSDK to the project's Framework Search Paths setting.

*Error*:
`object file (/Users/someuser/Documents/FacebookSDK/FBSDKLoginKit.framework/FBSDKLoginKit(FBSDKLoginButton.o)) was built for newer iOS version (8.0) than being linked (7.0)` Or a similar FBSDK file message.

*Resolution*: Either update your application's deployment target to iOS version 8.0 or use and older version of the Facebook SDK (i.e. 4.7.0)

*Error*:
/FacebookSDK/Bolts.framework/Bolts', framework linker option at /FacebookSDK/Bolts.framework/Bolts is not a dylib

*Resolution*: Go to where you extracted the FacebookSDK. If you're using Mac OSX, it should be available in Documents/FacebookSDK. Grab the Bolts.framework file and drop into your Frameworks folder in Xcode for your project.

*Errors*:
/jump.ios/Samples/SimpleCaptureDemoNative/SimpleCaptureDemoNative/Classes/AppDelegate.m:135:33: Use of undeclared identifier 'googlePlusClientId'; did you mean '_googlePlusClientId'?
/jump.ios/Samples/SimpleCaptureDemoNative/SimpleCaptureDemoNative/Classes/AppDelegate.m:136:36: Use of undeclared identifier 'googlePlusRedirectUri'; did you mean '_googlePlusRedirectUri'?

*Resolution*:
Make sure you are reading the data from your app's info.plist in your AppDelegate.m file, example:
`@synthesize googlePlusClientId;` and
`@synthesize googlePlusRedirectUri;` and
`if ([cfg objectForKey:@"googlePlusClientId"])
        self.googlePlusClientId = [cfg objectForKey:@"googlePlusClientId"];
if ([cfg objectForKey:@"googlePlusRedirectUri"])
    self.googlePlusRedirectUri = [cfg objectForKey:@"googlePlusRedirectUri"];`

*Error*:

`Failed to send AppEvents: Error Domain=com.facebook.sdk.core Code=8 "(null)" UserInfo={com.facebook.sdk:FBSDKGraphRequestErrorCategoryKey=0, com.facebook.sdk:FBSDKGraphRequestErrorHTTPStatusCodeKey=400, com.facebook.sdk:FBSDKErrorDeveloperMessageKey=Unsupported post request. Object with ID 'UPDATE' does not exist, cannot be loaded due to missing permissions, or does not support this operation. Please read the Graph API documentation at https://developers.facebook.com/docs/graph-api, com.facebook.sdk:FBSDKGraphRequestErrorGraphErrorCode=100, com.facebook.sdk:FBSDKGraphRequestErrorParsedJSONResponseKey={
    body =     {
        error =         {
            code = 100;
            "fbtrace_id" = HuZISP11ndF;
            message = "Unsupported post request. Object with ID 'UPDATE' does not exist, cannot be loaded due to missing permissions, or does not support this operation. Please read the Graph API documentation at https://developers.facebook.com/docs/graph-api";
            type = GraphMethodException;
        };
    };
    code = 400;
}}`

*Resolution*: Follow the steps above to configure the Facebook Native SDK.

*Error*:

`'NSInvalidArgumentException', reason: 'Your app is missing support for the following URL schemes: update'`

*Resolution*:  Make sure you have followed all the steps above to configure the native Social Providers (Facebook, Google, Twitter) with the appropriate updated client id's and settings that correlate to your application.
