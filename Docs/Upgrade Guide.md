# Janrain iOS SDK Upgrade Guide

This guide describes the steps required to upgrade from different versions of the library.

## Generalized Upgrade Process

A less desirable but more reliable and more general upgrade strategy:

1. Remove existing Janrain project groups
2. Remove generated Capture user model project groups
3. Follow the process described JUMP Integration Guide

### Upgrading from v5.0.4 (ONLY) to v5.1.1 or greater

iOS 8.x support has been deprecated. All code has been updated to support iOS 9.x and newer.

*NOTE:* Due to the large amount of code modifications required to address iOS 9.x deprecations it is important to test any integrations thoroughly.

Tested with the following supporting libraries/frameworks:

* OpenID AppAuth iOS 0.90.0 (both sample apps)
* TwitterKit 3.2.1 (Native Sample App only)
* Google SignIn 4.1.0 (Native Sample App only) - Note as of 11/17/17 there were missing framework files in the Google download zip file.  Use the missing framework files (GoogleAppUtilities.framework and GoogleSymbolUtilities.framework) from the 4.0.1 SDK download.
* Facebook 4.28.0

The demo applications have been heavily refactored to support the latest Janrain "standard" flow and "user" schema.  The registration and profile pages have been updated to match the form configurations in the standard flow.  These pages now demonstrate how to use date pickers, scroll/spinner selectors, and switches for boolean fields.

If you are using CocoaPods, the CocoaPods `Janrain.podspec` file will now include a set of reference 'Generated' classes in order to resolve dependency warnings and issues.  Developers that are using CocoaPods will have to manually remove the classes imported into the `Pods/Development Pods/Janrain/JRCapture/Generated` folder (in the XCode Project files folder view) and replace them with the Generated class files for their schema as described in the `Xcode Project Setup Guide` (found in the same folder as this document).  Please see the section titled: `Generating the Capture User Model`.


### Upgrading from v5.0.0 (ONLY) to v5.0.1 or greater

Ensure your Janrain libraries includes a reference to the Janrain/JREngage/Classes/JROpenIDAppAuthGoogleDelegate.h file

#### Update your application's AppDelegate.h
REMOVE the following to your AppDelegate.h file (see the Sample Application code for additional context):
`@protocol OIDAuthorizationFlowSession;`
AND REMOVE
`
@property(nonatomic) NSString *googlePlusClientId;
@property(nonatomic) NSString *googlePlusRedirectUri;
@property(nonatomic, strong) id<OIDAuthorizationFlowSession> openIDAppAuthAuthorizationFlow;
`
AND REMOVE
`#import "AppAuth.h"`

ADD the following import:
`#import "JROpenIDAppAuthGoogleDelegate.h"`
ADD the JROpenIDAppAuthGoogleDelegate Protocol:
`@interface AppDelegate : UIResponder <UIApplicationDelegate, JROpenIDAppAuthGoogleDelegate>`

#### Update your application's AppDelegate.m

Synthesize the variables:
`@synthesize googlePlusClientId;` and
`@synthesize googlePlusRedirectUri;` and
`@synthesize openIDAppAuthAuthorizationFlow;`

In the `- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions` method make sure to REMOVE the following values:
`config.googlePlusClientId = googlePlusClientId;` and `config.googlePlusRedirectUri = googlePlusRedirectUri;`

UPDATE the following method so it is as follows:

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

NOTE: the SimpleDemoNative app ues the following method instead to ensure compatibility with the Native Provider libraries:
    - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation

### Upgrading from v5.0.1 to v5.0.2 or greater

There is now an optional janrain-config.plist setting that allows you to define the OpenID Scopes that will be requested during the Google OpenID request process.  The full list of scopes available is as follows:

    <key>googlePlusOpenIDScopes</key>
    <array>
        <string>OIDScopeAddress</string>
        <string>OIDScopePhone</string>
        <string>OIDScopeEmail</string>
        <string>OIDScopeProfile</string>
        <string>OIDScopeOpenID</string>
    </array>

You may have to update your initialization code to populate these values in to the JROpenIDAppAuthGoogleDelegate's googlePlusOpenIDScopes property:

    if ([cfg objectForKey:@"googlePlusOpenIDScopes"])
        self.googlePlusOpenIDScopes = [cfg objectForKey:@"googlePlusOpenIDScopes"];

In general "OIDScopeEmail", "OIDScopeOpenID", and "OIDScopeProfile" should always be requested. Not including or populating this setting will result in all five scopes being requested.

### Upgrading from any version PRIOR to v5.0.0 to v5.0.1 or greater

There are potentially *breaking* changes to the Janrain Mobile SDK with version 5.0.  Due to Google's decision to not allow web-based authentication through webviews, support for web-based authentication for Google has been implemented using Google's recommended OpenID AppAuth (http://openid.github.io/AppAuth-iOS/) libraries.  These libraries are now a *required* dependency of the Janrain Mobile Libraries.'

If you are using CocoaPods your podfile should include something similar to the following (adjust the tag version accordingly):

```
platform :ios, '8.0'
target 'yourappname' do
    use_frameworks!

    #other pods
    pod 'AppAuth'
    pod 'Janrain', :git => 'https://github.com/janrain/jump.ios.git', :tag => '5.0.4'
end
```

The OpenID AppAuth for iOS libraries (version 0.7.1 tested) can be installed using CocoaPods or as an Xcode Workspace library.  Please refer to this link for additional information on installing the OpenID AppAuth for iOS libraries: http://openid.github.io/AppAuth-iOS/ Make sure your project's "Linked Frameworks and Libraries" includes a reference to the OpenID AppAuth for iOS Library ("libAppAuth.a" or "libAppAuth-iOS.a")

If you are linking to the OpenID AppAuth Library repo and not using CocoaPods you may need to add the OpenID AppAuth library source code location to your Xcode project's Build Settings -> Search Paths -> Header Search Paths value: example: `/GitHub/OpenIDAppAuth/AppAuth-iOS/Source` (use the "recursive" option if needed).

The sample applications provided as part of the Janrain Mobile Libraries repository have been updated to use the Xcode Workspace library implementation method.  This may require re-linking of the libraries for your build environement. *NOTE:* You may have to convert your Xcode project to a workspace project if you do not want to use CocoaPods.

Once you have added the OpenID AppAuth libraries to your project or workspace the following settings will need to be added/updated in your application if you are planning on using Google as a web-based identity provider in your mobile application.  NOTE: These steps are not necessary if you are using Google Native authentication using the Google iOS SDK.

#### Create an iOS Google OAuth Client

Visit https://console.developers.google.com/apis/credentials?project=_ and find the project that correlates to the Google Web OAuth client that is being used with the *same* Engage application being used by the Janrain Mobile Libraries. Then tap "Create credentials" and select "OAuth client ID".  Follow the instructions to configure the consent screen (just the Product Name is needed).

Then, complete the OAuth client creation by selecting "iOS" as the Application type.  Enter the Bundle ID of the project (`com.janrain.simpledemo.example` for example, but you must change this in the project and use your own Bundle ID).

Copy the client ID to the clipboard or a location for future use.

#### Update Janrain Library configuration
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

#### Update your application's AppDelegate.h

ADD the following import:
`#import "JROpenIDAppAuthGoogleDelegate.h"`
ADD the JROpenIDAppAuthGoogleDelegate Protocol:
`@interface AppDelegate : UIResponder <UIApplicationDelegate, JROpenIDAppAuthGoogleDelegate>`

#### Update your application's AppDelegate.m

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

#### New optional configuration items

1. `config.engageAppUrl` If this value is set when intializing the Mobile Libraries the libraries will attempt to use the url provided for all Social Login (Engage) communications.  This setting should only be used when advised to do so by a Janrain technical resource.

2. `config.downloadFlowUrl` If this value is set when intializing the Mobile Libraries the libraries will attempt to use the url provided for all download the Registration flow configuration file.  This setting should only be used when advised to do so by a Janrain technical resource.

#### Update Misconfiguration Errors

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

*Resolution*: Make sure your project's "Linked Frameworks and Libraries" includes a reference to the OpenID AppAuth for iOS Library ("libAppAuth.a" or "libAppAuth-iOS.a")

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

### Upgrading from any version to v4.0 or greater

There are potentially *breaking* changes to the Janrain Mobile SDK with version 4.0.  All dependencies on third-party SDK's and libraries around native Social Provider support (Google+, Facebook, and Twitter) have been removed.

The Mobile SDK no longer integrates third-party SDK's or libraries.  The SimpleCaptureDemo app has been upgraded to demonstrate how to retrieve a native provider's oAuth access token using the current(at the time of the SDK release) native provider's tools in as close a format to the native provider's sample code on their website.  The developer will now retrieve the native provider's oAuth access token using their preferred method and initiate the Janrain authentication process using `startEngageSignInWithNativeProviderToken:provider:withToken:andTokenSecret:withCustomInterfaceOverrides:mergeToken:forDelegate:`

Please refer to the `Native Authentication Guide` for full details on how to implement native authentication with the above changes.

Several provider images and icons were updated in this release.  Please refresh the files in the Resources folder.

### Upgrading from any version to v3.7 or greater
The Janrain iOS SDK now requires Automatic Reference Counting (ARC). Follow the generalized upgrade process but do
*NOT* add the `-fno-objc-arc` compiler flag to the Janrain sources. If your project does not use ARC, be sure to set
the "Objective-C Automatic Reference Counting" build setting to "YES" and add the `-fno-objc-arc` compiler flag to
any of your sources that do not support ARC.

#### Solutions
* **no known class method for selector 'startForgottenPasswordRecoveryForField:recoverUri:delegate:'**

    The `recoverUri` parameter has been removed from this method. Use the `password_recover_url` Capture dashboard
    setting instead and call the method `[JRCapture startForgottenPasswordRecoveryForField:delegate:]`.

### Upgrading from any version to v3.6 or greater
1. Ensure that the **Accounts** and **Social** frameworks have been added to your project.
2. Ensure that your deployment target is at least iOS 6.


### Solutions for upgrading from v2.5.2-v3.1.4 to v3.4.0
* **'JSONKit.h' file not found**
    Remove `#import "JSONKit.h` it is no longer required for JUMP.

* **no visible @interface for 'NSDictionary' declares the selector 'JSONString'**

    Import `JRJsonUtils.h` and change `JSONString` to `JR_jsonString`.

* **no visible @interface for 'NSArray' declares the selector 'JSONString'**

    Import `JRJsonUtils.h` and change `JSONString` to `JR_jsonString`.

* **no visible @interface for 'NSString' declares the selector 'objectFromJSONString'**

    Import `JRJsonUtils.h` and change `objectFromJSONString` to `JR_objectFromJSONString`


### Solutions for upgrading v3.1.4 to v3.4.0
* **no visible @interface for 'NSError' declares the selector 'JRMergeFlowExistingProvider'**

    Import `JREngageError.h`

* **no visible @interface for 'NSError' declares the selector 'JRMergeToken'**

    Import `JREngageError.h`

* **no visible @interface for 'NSError' declares the selector 'isJRMergeFlowError'**

    Import `JREngageError.h`

* **use of undeclared identifier 'JRCaptureErrorGenericBadPassword'**

    Import `JREngageError.h`


### Solutions for upgrading v2.5.2 to v3.4.0

* **no visible @interface for 'JRCaptureUser' declares the selector 'createOnCaptureForDelegate:context:'**
    Use `+[JRCapture registerNewUser:socialRegistrationToken:forDelegate:]` instead

* **Use of undeclared identifier 'JRCaptureErrorGenericBadPassword'**

    Import `JREngageError.h`

* **use of undeclared identifier 'JRCaptureRecordMissingRequiredFields'**

    `JRCaptureRecordMissingRequiredFields` has been removed.

* **no known class method for selector 'setEngageAppId:captureApidDomain:captureUIDomain:clientId:andEntityTypeName:'**

    Use `+[JRCapture +setCaptureConfig:]` instead. For example, if you had:

            [JRCapture setEngageAppId:engageAppId captureApidDomain:captureApidDomain
                      captureUIDomain:captureUIDomain clientId:captureClientId andEntityTypeName:nil];

    Then do the following instead:

            JRCaptureConfig *config = [JRCaptureConfig emptyCaptureConfig];
            config.engageAppId = engageAppId;
            config.captureDomain = captureDomain;
            config.captureClientId = captureClientId;
            config.captureLocale = @"en-US";
            [JRCapture setCaptureConfig:config];


## Upgrading from v2.2.0-v2.3.x to v3.4.0

1. Delete the **JREngage** group from Xcode.
2. Get the latest version of the SDK from GitHub `git clone https://github.com/janrain/jump.ios.git`
3. Make sure that the **Project Navigator** pane is showing.
4. Open **Finder** and navigate to the location where you cloned the `jump.ios` repository. Drag the **Janrain**
   folder into your Xcode project's **Project Navigator** and drop it below the root project node.

       **Warning**: Do not drag the **jump.ios** folder into your project, drag the **Janrain** folder in.
5. In the dialog, do **not** check the **Copy items is not destination group's folder (if needed)**. Ensure that the
   **Create groups for any added folders** radio button is selected, and that the **Add to targets** check box is
   selected for you application's target.
6. v2.2.0 and v2.3.0 did support Capture so you need to remove the **JRCapture** project group from the **Janrain**
   project group.
7. You must also add the **QuartzCore** framework, and the **MessageUI** framework to your project.  As the
   **MessageUI** framework is not available on all iOS devices and versions, you must designate the framework as
   "optional."
8. Ensure that your **Deployment Target** is *iOS 5.0* or higher.

### Solutions for upgrading from v2.2.0-v2.3.x to v3.4.0

* **Delegate methods are not being called**

    Delegate method names are no longer prepended with 'jr'. For example:

    * `jrEngageDialogDidFailToShowWithError:` has been replaced with `engageDialogDidFailToShowWithError:`
    * `jrAuthenticationDidSucceedForUser:forProvider` has been replaced with
      `authenticationDidSucceedForUser:forProvider:`
    * `jrAuthenticationDidReachTokenUrl:withPayload:forProvider:` has been replaced with
      `authenticationDidReachTokenUrl:withResponse:andPayload:forProvider:`
    * `jrAuthenticationDidReachTokenUrl:withResponse:andPayload:forProvider:` has been replaced with
      `authenticationDidReachTokenUrl:withResponse:andPayload:forProvider:`
    * `jrAuthenticationDidNotComplete` has been replaced with `authenticationDidNotComplete`
    * `jrAuthenticationDidFailWithError:forProvider:` has been replaced with
      `authenticationDidFailWithError:forProvider:`
    * `jrAuthenticationCallToTokenUrl:didFailWithError:forProvider:` has been replaced with
      `authenticationCallToTokenUrl:didFailWithError:forProvider:`

* **cannot find protocol declaration for 'JREngageDelegate'**

    Change `<JREngageDelegate>` to `<JREngageSigninDelegate>`

* **Use of undeclared identifier 'JRDialogShowingError'**

    Import `JREngageError.h`

* **class method '+jrEngage' not found (return type defaults to 'id')**

    This method has been removed some of the instance methods that you might be trying to use have been replaced with
    class methods.

* **Instance method '-authenticationDidCancel' not found (return type defaults to 'id')**

    Use the class method `+[JREngage cancelAuthentication]` instead

* **instance method '-cancelPublishing' not found (return type defaults to 'id')**
    Use the class method `+[JREngage cancelSharing]` instead


### Solutions for upgrading v2.3.x to v3.4.0

* **Instance method '-showAuthenticationDialogWithCustomInterfaceOverrides:' not found (return type defaults to 'id')**

    Use `+[JREngage showAuthenticationDialogWithCustomInterfaceOverrides:]` instead.


### Solutions for upgrading v2.2.0 to v3.4.0

* **Instance method '-setCustomNavigationController:' not found (return type defaults to 'id')**

    **Instance method '-setCustomInterfaceDefaults:' not found (return type defaults to 'id')**

    Use `+[JREngage showAuthenticationDialogWithCustomInterfaceOverrides:]` instead. For example if you had:

            NSDictionary *myCustomInterface = @{
                    kJRProviderTableHeaderView : embeddedTable.view,
                    kJRProviderTableSectionHeaderTitleString : @"Sign in with a social provider"
            };
            [myJREngageInstance setCustomNavigationController:myNavigationController]
            [customInterface addEntriesFromDictionary:myCustomInterface];
            [myJREngageInstance setCustomInterfaceDefaults:customInterface];
            [myJREngageInstance showAuthenticationDialog];

    Then do the following:

            NSDictionary *myCustomInterface = @{
                    kJRProviderTableHeaderView : embeddedTable.view,
                    kJRProviderTableSectionHeaderTitleString : @"Sign in with a social provider",
                    kJRApplicationNavigationController : myNavigationController
            };
            [JREngage showAuthenticationDialogWithCustomInterfaceOverrides:myCustomInterface];


## Upgrading from 3.0.x to 3.1

The signature to the JRCapture initialization method added a new parameter to its selector, `customIdentityProviders:`,
which describes custom identity providers to configure the library with. See `Engage Custom Provider Guide.md` for more
details.

## Upgrading from 3.1.x to 3.2

The signature to the JRCapture initialization method added several new parameters to its selector.  See the selector
in `JRCapture.h` which begins "setEngageAppId:" for the current list of parameters.
