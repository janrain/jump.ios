# Configuring the SimpleCaptureDemo application.

## IMPORTANT

Please read the Docs/Upgrade Guide.md and RELEASE_NOTES before attempting to run these applications.  There are important configuration steps that must be taken before these apps will run.

#### To run this demo with the provided configuration:

Due to Google's decision to not allow web-based authentication through webviews, support for web-based authentication for Google has been implemented using Google's recommended OpenID AppAuth (http://openid.github.io/AppAuth-iOS/) libraries.  These libraries are now a *required* dependency of the Janrain Mobile Libraries.

The OpenID AppAuth for iOS libraries (version 0.9.0 tested) can be installed using CocoaPods or as an Xcode Workspace library.  Please refer to this link for additional information on installing the OpenID AppAuth for iOS libraries: http://openid.github.io/AppAuth-iOS/ Make sure your project's "Linked Frameworks and Libraries" includes a reference to the OpenID AppAuth for iOS Library ("libAppAuth.a")

If you are linking to the OpenID AppAuth Library repo and not using CocoaPods you may need to add the OpenID AppAuth library source code location to your Xcode project's Build Settings -> Search Paths -> Header Search Paths value: example: `/GitHub/OpenIDAppAuth/AppAuth-iOS/Source` (use the "recursive" option if needed).

This sample application has been updated to use the Xcode Workspace library implementation method.  This *WILL* require re-linking of the libraries for your build environment. *NOTE:* You may have to convert your Xcode project to a workspace project if you do not want to use CocoaPods.

Once you have added the OpenID AppAuth libraries to your project or workspace the following settings will need to be added/updated in your application if you are planning on using Google as a web-based identity provider in your mobile application.  NOTE: These steps are not necessary if you are using Google Native authentication using the Google iOS SDK.


#### To run this demo with your own configuration:

1. Follow the steps above to add the OpenID AppAuth for iOS Libraries
3. Find janrain-config-default.plist
4. Copy it to janrain-config.plist
5. Edit the settings in the copy to reflect your Social Login and Registration Settings.
6. Edit the settings to include the correct form names as found in your flow file.
7. Make sure you have the OpenID AppAuth for iOS Libraries implemented/installed.
8. Update the corresponding Google Client for the AppAuth libraries:

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

### Typical Misconfiguration Errors

*Error*:
`Undefined symbols for architecture x86_64:
"_OBJC_CLASS_$_JROpenIDAppAuth", referenced from:
objc-class-ref in JREngage.o
objc-class-ref in JRProvidersController.o`

*Resolution*: Delete the "Janrain" folder reference from your project and re-add the folder reference linking to the latest files.  New files have been added to the Janrain Libraries and they are not being referenced in your project.

*Error*:
Linker error: ld: library not found for -lAppAuth

*Resolution*: You may have to remove and re-add the libApp-Auth or libAppAuth-ios library to your project's "Linked Frameworks and Libraries" includes a reference to the OpenID AppAuth for iOS Library ("libAppAuth.a")

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

*Resolution*: Make sure your project's "Linked Frameworks and Libraries" includes a reference to the OpenID AppAuth for iOS Library ("libAppAuth.a")

*Errors*:
`/jump.ios/Samples/SimpleCaptureDemoNative/SimpleCaptureDemoNative/Classes/AppDelegate.m:135:33: Use of undeclared identifier 'googlePlusClientId'; did you mean '_googlePlusClientId'?` OR
`/jump.ios/Samples/SimpleCaptureDemoNative/SimpleCaptureDemoNative/Classes/AppDelegate.m:136:36: Use of undeclared identifier 'googlePlusRedirectUri'; did you mean '_googlePlusRedirectUri'?`

*Resolution*:
Make sure you are reading the data from your app's info.plist in your AppDelegate.m file, example:
`@synthesize googlePlusClientId;` and
`@synthesize googlePlusRedirectUri;` and
`if ([cfg objectForKey:@"googlePlusClientId"])
        self.googlePlusClientId = [cfg objectForKey:@"googlePlusClientId"];
if ([cfg objectForKey:@"googlePlusRedirectUri"])
    self.googlePlusRedirectUri = [cfg objectForKey:@"googlePlusRedirectUri"];`

