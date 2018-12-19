# Native Authentication Guide

This guide describes the process of integrating with native iOS authentication systems. The Social Sign-in library has historically supported authentication by means of a UIWebView running a traditional web OAuth flow. Support is now introduced for authentication by means of native identity-provider libraries.

## Supported Providers

* OpenID AppAuth iOS 1.0.0.beta1 (both sample apps)
* TwitterKit 3.4.0 (Native Sample App only)
* Google SignIn 4.4.0 (Native Sample App only)
* Facebook 4.39.0 (Native Sample App only)

## Native Authentication for Janrain Mobile SDK version 4.0 or newer.

There are potentially *breaking* changes to the Janrain Mobile SDK with version 4.0.  All dependencies on third-party SDK's and libraries around native Social Provider support (Google Sign-In, Facebook, and Twitter) have been removed.

The Mobile SDK no longer integrates third-party Social Provider SDK's or libraries.  The SimpleCaptureDemo app has been upgraded to demonstrate how to retrieve a native provider's oAuth access token using the current(at the time of the SDK release) native provider's tools in as close a format to the native provider's sample code on their website.  The developer will now retrieve the native provider's oAuth access token using their preferred method and initiate the Janrain authentication process using `startEngageSignInWithNativeProviderToken:provider:withToken:andTokenSecret:withCustomInterfaceOverrides:mergeToken:forDelegate:`

### 10,000′ View
1. Configure the native authentication framework for the providers you want to support (Google Sign-In, Facebook, or Twitter)
1. Provide the user the option to sign in with a Native Provider or through a UIWebview Dialog for non-native Providers
1. If the user selects to login with a Native Provider, initiate the Native Provider's SDK and retrieve a properly scoped oAuth Access Token (and Token Secret for Twitter).
1. Pass the Native Provider's oAuth access token to the Janrain SDK where it will be posted to the Social Login server for verification and a Social Login access token will be returned.

### Facebook

As of SDK release 4.x the following Facebook SDK implementation steps were implemented in the SimpleCaptureDemo sample application in order to retrieve the Facebook oAuth access token from the iOS device:

1. Download the Facebook SDK for iOS from this link:  https://developers.facebook.com/docs/ios
1. Follow *ALL* of the steps on this page *EXCEPT* for Step 2 (Create a Facebook App): https://developers.facebook.com/docs/ios/getting-started/  In order for the Janrain Social Login Server to validate the provided Facebook oAuth token, the token must be provisioned from the same Facebook application that is configured for the Janrain Social Login application.  In most cases, the developer would simply add an iOS App Settings configuration to the existing Facebook App.
1.  Use this page as a starting point for implementing native Facebook Login:  https://developers.facebook.com/docs/ios/getting-started
1.  Make sure that the Permissions requested in the `logInWithReadPermissions` method include the required permissions.  In most cases these permissions need to mirror the Facebook app permissions configuration of the Engage Social Login application that is configured in the Janrain Social Login Dashboard.
1.  Refer to the `RootViewControoler.m` file for an example of how this was done with the SimpleCaptureDemo application.
1.  Once you have retrieved the oAuth access token from the Facebook SDK you can initiate the Janrain authentication process with `startEngageSignInWithNativeProviderToken:provider:withToken:andTokenSecret:withCustomInterfaceOverrides:mergeToken:forDelegate:`

### Google Sign-In

As of Janrain mobile libraries release 4.0 the following Google Sign-In SDK implementation steps were implemented in the SimpleCaptureDemo sample application in order to retrieve the Google oAuth access token from the iOS device:

1. Download the Google Sign-In SDK from this link: https://developers.google.com/identity/sign-in/ios/sdk/
1. Follow *ALL* of the steps on this page that involve the XCode project configuration: https://developers.google.com/identity/sign-in/ios/sign-in+/mobile/ios/getting-started  In order for the Janrain Social Login Server to validate the provided Google oAuth token, the token must be provisioned from the same Google application that is configured for the Janrain Social Login application.  In most cases, the developer would simply add an iOS App Client ID configuration to the existing Google App.
1. In the case of the SimpleCaptureDemo application the integration steps were implemented in the `RootViewControoler` files with minimal changes from the examples provided by Google at this link: https://developers.google.com/identity/sign-in/ios/sign-in
1. Make sure that the Scopes requested by the `GPPSignIn` singleton includes the required scopes.  In most cases these scopes need to mirror the Google app permissions configuration of the Engage Social Login application that is configured in the Janrain Social Login Dashboard.
1. Refer to the `RootViewControoler.m` file for an example of how this was done with the SimpleCaptureDemo application.
1. Once you have retrieved the oAuth access token from the Google Sign-In SDK you can initiate the Janrain authentication process with `startEngageSignInWithNativeProviderToken:provider:withToken:andTokenSecret:withCustomInterfaceOverrides:mergeToken:forDelegate:`

### Twitter

As of Janrain mobile libraries release 4.0 the following TwitterKit SDK implementation steps were implemented in the SimpleCaptureDemo sample application in order to retrieve the Twitter oAuth access token from the iOS device:

1. Download the TwitterKit SDK from this link: https://dev.twitter.com/twitterkit/ios/installation
1. Configure your Twitter App: https://apps.twitter.com/  In order for the Janrain Social Login Server to validate the provided Twitter oAuth token, the token must be provisioned from the same Twitter application that is configured for the Janrain Social Login application.  In most cases, the developer would simply add an iOS App Client ID configuration to the existing Twitter App.
1. In the case of the SimpleCaptureDemo application the integration steps were implemented in the `RootViewControoler` files with minimal changes from the examples provided by Twitter at this link: https://dev.twitter.com/twitterkit/ios/log-in-with-twitter
1. NOTE: In most default cases Twitter will not return an email address for an end user. This may cause account merging or linking issues if your Registration user experience relies heavily on merged social profiles.  This use-case is typically addressed by forcing Twitter account holders to use the "Account Linking" functionality of the SDK.  Customer's may choose to work with Twitter to get their application white-listed so it will attempt to return an email address from a user profile.  However, email addresses are not "required" for Twitter accounts, subsequently there is still no guarantee that an email address will be returned.
1. Refer to the `RootViewControoler.m` file for an example of how this was done with the SimpleCaptureDemo application.
1. Once you have retrieved the oAuth *access token AND token secret* from the TwitterKit SDK you can initiate the Janrain authentication process with `startEngageSignInWithNativeProviderToken:provider:withToken:andTokenSecret:withCustomInterfaceOverrides:mergeToken:forDelegate:`

NOTE: It is important to note that Twitter Kit 3.0 only supports iOS 9+.


## DEPRECATED: Native Authentication implementation for Janrain Mobile SDK versions prior to version 4.0

Prior versions (before version 4.0) of the Janrain Mobile SDK attempted to use reflection to call the native provider SDK's and retrieve the oAuth access token.  This presented a maintenance and compatibility issue with the Janrain SDK only able to support specific versions of the native provider sdk's.  The following documentation will be removed in a subsequent release but is preserved for customer's using older versions of the Janrain Mobile SDK.

Native Authentication is supported by the library, and is compatible with both Social Sign-in only and User Registration deployments.
At this time, native-authentication is available for authentication only, and not for social-identity-resource authorization (e.g. sharing.)
The SDK is not currently able to request the same scopes that are configured in the Engage dashboard when using Native Authentication. This will be available in a future release. For the time being Facebook requests basic_info and Google+ requests plus.login.

### 10,000′ View
1. Configure the native authentication framework
2. Start User Registration sign-in or Social Sign-in authentication
3. The library will delegate the authentication to the native authentication framework
4. The library delegate message will fire when native authentication completes

### Facebook

#### Configure the Native Authentication Framework

Follow the Facebook iOS SDK integration instructions. For native Facebook authentication to work via Social Sign-in both Janrain and the Facebook iOS SDK must be configured to use the same Facebook application.
Make sure that you use the same Facebook app ID as is configured in your application's dashboard.

#### Ensure that the Facebook sources are linked
Add the `-ObjC` flag to the app target's build settings: https://developer.apple.com/library/mac/qa/qa1490/_index.html

#### Handle the Facebook login callback

When authenticating the Facebook SDK will pass control to the Facebook iOS app or to Facebook in a mobile browser. Your app will need to handle the callback to finish signing in. Add the following to your application delegate:

    - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
             annotation:(id)annotation
    {
        return [JREngage application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }

It is possible that the redirect back to you app may be interrupted. If that happens the Janrain iOS SDK can do some cleanup and put your application in a position to restart the authentication. Add the following to your application delegate:

    - (void)applicationDidBecomeActive:(UIApplication *)application
    {
        [JREngage applicationDidBecomeActive:application];
    }

#### Begin Sign-In or Authentication

Start authentication or sign-in as normal. If the Facebook iOS SDK is compiled into your app, it will be used to perform all Facebook authentication.

#### Signing Out

Following Facebook's documentation we'll use `closeAndClearTokenInformation` to close the in-memory Facebook session.

In your view controller import the Facebook SDK

    #import <FacebookSDK/FacebookSDK.h>

Call `closeAndClearTokenInformation` when your sign-out button is pressed. For example, in the SimpleCaptureDemo, we add
the following to the signOutCurrentUser method of the RootViewController.

    - (void)signOutCurrentUser
    {
        ...

        // Sign out of the Facebook SDK
        [FBSession.activeSession closeAndClearTokenInformation];
    }

Note: This does not revoke the applications access to Facebook. So if a user has a Facebook account set up in their iOS
device's Settings app it will continue to be used to sign in without asking to be reauthorized.

### Google+

#### Configure the Native Authentication Framework
Follow the Google+ platform getting started guide. For native Google+ authentication to work via Social Sign-in both Janrain and the Google+ iOS SDK must be configured to use the same Google+ project in the Google Cloud Console.

#### Configure the Janrain SDK

If you are using Janrain's user registration add your iOS Google+ client ID to your JRCaptureConfig instance:

    config.googlePlusClientId = @"YOUR_CLIENT_ID";

If you are using social sign-in only, after your call to `+[JREngage setEngageAppId:tokenUrl:andDelegate:]` set your Google+ client ID:

    [JREngage setGooglePlusClientId:@"YOUR_CLIENT_ID"

#### Handle the Google+ login callback

When authenticating the Google+ SDK may pass control to Google+ in a mobile browser. Your app will need to handle the callback to finish signing in. Add the following to your application delegate:

    - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
             annotation:(id)annotation
    {
        return [JREngage application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    }

It is possible that the redirect back to you app may be interrupted. If that happens the Janrain iOS SDK can do some cleanup and put your application in a position to restart the authentication. Add the following to your application delegate:

    - (void)applicationDidBecomeActive:(UIApplication *)application
    {
        [JREngage applicationDidBecomeActive:application];
    }

#### Begin Sign-In or Authentication

Start authentication or sign-in as normal. If the Google+ iOS SDK is compiled into your app, it will be used to perform all Google+ authentication.

#### Signing out and disconnecting from the Google+ SDK

Follow the directions in https://developers.google.com/+/mobile/ios/sign-in under "Sign out the user" and "Revoking access tokens and Disconnecting the app".

### Twitter

#### Configure the Janrain SDK

Ensure that you have Accounts.framework, Social.framework linked to your target.

If you are using Janrain's user registration add your Twitter consumer key and consumer secret to your JRCaptureConfig instance:

    config.twitterConsumerKey = @"YOUR_CONSUMER_KEY";
    config.twitterConsumerSecret = @"YOUR_CONSUMER_SECRET";

or if you are using social sign-in only, after your call to `+[JREngage setEngageAppId:tokenUrl:andDelegate:]` set your Twitter consumer key and consumer secret:

    [JREngage setTwitterConsumerKey:@"YOUR_CONSUMER_KEY
                          andSecret:@"YOUR_CONSUMER_SECRET"];

Make sure that your Twitter consumer key and consumer secret match what you have configured in the Engage dashboard.

When a user has not given your application permission to access the Twitter accounts, then the `-[engageSignInDidFailWithError:]` method of your JRCaptureDelegate or the `-[authenticationDidFailWithError:forProvider:]` method of  your `JREngageSigninDelegate` will be called with an error. You can handle the error by checking to see if it's code is `JRAuthenticationNoAccessToTwitterAccountsError`. For example:

    #import "JREngageError.h"
    ...
        - (void)engageSignInDidFailWithError:(NSError *)error
        {
            DLog(@"error: %@", [error description]);
            if (error.code == JRAuthenticationNoAccessToTwitterAccountsError) {
                NSString *message = @"We weren't granted access to your accounts. "
                                @"Please change your Twitter settings.";
                UIAlertView *alertView = [[UIAlertView alloc]
                    initWithTitle:@"Twitter Error"
                              message:message
                             delegate:nil
                    cancelButtonTitle:@"Dismiss"
                    otherButtonTitles:nil];
                [alertView show];
            }
        }

#### Begin Sign-in or Authentication

Begin sign-in as usual and it will follow the below flow diagram.

**Note:** The iOS 6 simulator does not behave correctly with `+[SLComposeViewController isAvailableForServiceType:]` which is used to determine if there is at least one Twitter account in the first set of the diagram.

![Twitter Flow Diagram](images/iOS_twitter_sso_flow.png)
