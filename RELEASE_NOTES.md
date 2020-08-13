v5.5
* The library now supports the China region for Capture and social sign in.
* The configuration files (.plist) require new keys if your application needs to work in China (these keys are optional for any other region):
  * The required keys are: `captureFlowDomain` and `engageDomain`.  
  With these keys you don't need to modify the library source code; you only need to modify your configuration file.   
  Here is a brief example of a configuration file using these new keys:
  ```xml
  ...
  <!--Other keys your file may have -->
  ...
  <key>engageAppId</key>
	<string>{YoutEngageAppId}</string>
	<key>engageDomain</key>
	<string>yourengage.domain.com</string> 
	<key>engageWhitelistedDomain</key>
	<string>{YourWhitelistedDomain}</string>
	<key>captureDomain</key>
	<string>{YourCaptureDomain}</string>
	<key>captureClientId</key>
	<string>{YourCaptureClientId}</string>
	<key>captureFlowName</key>
	<string>{FlowName}</string>
	<key>captureAppId</key>
	<string>{YourCaptureAppId}</string>
	<key>captureFlowDomain</key>
	<string>yourcaptureflow.domain.com</string>
	<key>captureForgottenPasswordFormName</key>
	<string>forgotPasswordForm</string>
    ...
  <!--Other keys your file may have -->
  ...
  ```

> **Remember:** These new keys are optional if your application is used in regions other than China.

* Changed the NSNotifications sent when there is a problem with the URL that downloads the flow; the posting style has been changed to NSPostNow. This change was made in *JRCaptureData.m*
*  Added the file [China_Configuration_Guide.md](Docs/China_Configuration_Guide.md) explaining the process that uses these new keys.

v5.4.2
* Added the "applicationId" parameter in the provider URL for social sign in. This parameter is required for the China region and is optional for other regions.


v5.4.1
* Fix URL encoding for special characters like ?,+,=,&.

v5.4
* Now you can use Line as a provider for your application in the social sign ins.

v5.3
* Add Sign in with Apple. Now you can sign in with Apple as a provider in your applications. You can do the sign in by web (for any iOS version) or with the native button `ASAUthorizationAppleIDButton` (for iOS 13+).

v5.2

* Refactored `JRWebViewController` class, now it uses WKWebView (goodbye UIWebView). 
* Now you need to add, in your configuration `.plist` file, a new key called `engageWhitelistedDomain` with the white listed domain that you registered in your Social Login app. (See the SimpleCaptureDemo project for this).
  * To add a whitelisted domain, go to your [Social Login dashboard](https://dashboard.janrain.com/) and select the Engage App that you are using in your project. Select *Domains* in the Settings section.
  * Add the domain name (no protocol is needed) in *Domain Whitelist*. The domain format added should be `[WhitelistedDomain]://*` with the `://*` at the end. 
  * In Xcode, assign this new allow-listed domain to the `engageWhitelistedDomain` key with a path after the `://`. Like this `[WhitelistedDomain]]://[Path]` in your configuration .plist file.
  
    The whitelisted domain in your configuration file should look like this:
            
    ```xml
    <key>engageWhitelistedDomain</key>
    <string>[WhitelistedDomain]]://[Path]</string>
    ```

* Add submodules to the repository, now in *SimpleCaptureDemo* you don't need to add the AppAuth library to the project, every time. The *submodules* folder is located at the root of this repository.
  * To make sure you are using AppAuth from the *submodule* folder in the project, don't forget to run the next command in your terminal.
  ```
   $ git submodule update --init --recursive
   ```
* Tested Sample app with version 1.0.0beta of the OpenID AppAuth iOS libraries.


v5.1.2

* Merged PR: Removed Semaphores to make requests asynchronous (https://github.com/janrain/jump.ios/pull/57/files)
* Merged PR: Return error to delegates when authInfo request for native token returns error (https://github.com/janrain/jump.ios/pull/51)
* Updated deprecated code in the `JRUserInterfaceMaestro.m` specifically related to orientation and view resizing.
* Tested with the following supporting libraries/frameworks:

  * OpenID AppAuth iOS 1.0.0.beta1 (both sample apps)
  * TwitterKit 3.4.0 (Native Sample App only)
  * Google SignIn 4.4.0 (Native Sample App only)
  * Facebook 4.39.0 (Native Sample App only)

v5.1.1

* Added support for future changes to the Social Login platform
* Keychain storage now uses the kSecAttrAccessibleWhenUnlockedThisDeviceOnly global variable.  https://developer.apple.com/documentation/security/ksecattraccessiblewhenunlockedthisdeviceonly
* Updated CocoaPods support and resolved some file naming conflicts for XCode 9's new build system(preview)
* Tested with the following supporting libraries/frameworks:

  * OpenID AppAuth iOS 0.90.0 (both sample apps)
  * TwitterKit 3.3.0 (Native Sample App only)
  * Google SignIn 4.1.2 (Native Sample App only) * Note as of 11/17/17 there were missing framework files in the Google download zip file.  Use the missing framework files (GoogleAppUtilities.framework and GoogleSymbolUtilities.framework) from the 4.0.1 SDK download.
  * Facebook 4.31.1 (Native Sample App only)

v5.1

* OS 8.x support has been deprecated. All code has been updated to support iOS 9.x and newer.
  * NOTE: Due to the large amount of code modifications required to address iOS 9.x deprecations it is important to test any integrations thoroughly.
* Updated to support XCode 9
* Tested with the following supporting libraries/frameworks:

  * OpenID AppAuth iOS 0.90.0 (both sample apps)
  * TwitterKit 3.2.1 (Native Sample App only)
  * Google SignIn 4.1.0 (Native Sample App only) * Note as of 11/17/17 there were missing framework files in the Google download zip file.  Use the missing framework files (GoogleAppUtilities.framework and GoogleSymbolUtilities.framework) from the 4.0.1 SDK download.
  * Facebook 4.28.0

* The demo applications have been heavily refactored to support the latest Janrain "standard" flow and "user" schema.  The registration and profile pages have been updated to match the form configurations in the standard flow.  These pages now demonstrate how to use date pickers, scroll/spinner selectors, and switches for boolean fields.
* If you are using CocoaPods, the CocoaPods `Janrain.podspec` file will now include a set of reference 'Generated' classes in order to resolve dependency warnings and issues.  Developers that are using CocoaPods will have to manually remove the classes imported into the `Pods/Development Pods/Janrain/JRCapture/Generated` folder (in the XCode Project files folder view) and replace them with the Generated class files for their schema as described in the `Xcode Project Setup Guide` (found in the same folder as this document).  Please see the section titled: `Generating the Capture User Model`.

v5.0.4

* Added code and examples to support the change password functionality of flow forms.  This includes a new method that allow the developer to build up a simple Map of flow form names and values and submit the form to any Janrain "oauth/" compatible endpoint.  This method does no validation that the submitted data is accurate for the flow form configuration.  All validation of the submitted data and error reporting will be done server-side.

  ```
  /**
   * Posts the provided form data to the provided endpoint with the provided form name.
   * NOTE: This method does not validate the provided data contents * errors will be returned
   * from the server-side api and must be handled by the integration developer.
   */
  +(void)postFormWithFormDataProvided:(JRCaptureUser *)user
                    toCaptureEndpoint: (NSString *)endpointUrl
                         withFormName:(NSString *)formName
                         andFieldData:(NSMutableDictionary *)fieldData
                             delegate:(id <JRCaptureDelegate>)delegate;
  ```

* Resolved bug where initiating the Link Account process would generate and store a new Refresh Secret and subsequently disrupt future token refresh attempts.
* Improved LinkAccount click behavior in the sample apps.
* Improved error message parsing in several areas.  NOTE: the `JRCaptureError.m` file's `errorFromResult` method will now initially use the "message" attribute from the Capture response and then fall back to the "error_description" attribute if no "message" data was found.  In general the "message" attribute provides a more user friendly and useful error message.

v5.0.3

* Resolved issue where optional `engageAppUrl` setting wasn't actually optional during native authentication causing native authentication to fail.
* Updated SimpleDemoNative app's AppDelegate to use

  `* (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation` for all URL redirection handlers instead of `* (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *, id> *)options`

* Tested Sample apps with version 0.8.0 of the OpenID AppAuth iOS libraries.
* Tested the SimpleDemoNative sample app with the FacebookSDK version 4.20.2 and version 2.8.1 of TwitterKit

v5.0.2

 * Set the default scopes for Google OpenID AppAuth requests to include all available scopes.
 * Added an optional janrain-config.plist setting that allows you to define the OpenID Scopes that will be requested during the Google OpenID request process. Please refer to the Upgrade Guide for additional information.

v5.0.1

 * Resolved Cocoapods incompatibility.  Implemented JROpenIDAppAuthGoogleDelegate Protocol to remove reference to AppDelegate.h from JROpenIDAppAuthGoogle.m
 * Updated sample apps and documentation to demonstrate implementation of the JROpenIDAppAuthGoogleelegate protocol.

v5.0

 * Dropped support for iOS 7, now only supports iOS 8+
 * Implemented OpenID AppAuth Libraries(Required) to support Google WebView Deprecation.
 * Added support for non-standard Engage server URLs
 * Added support for custom flow download location URLs
 * Added support for Native Authentication using the WeChat application
 * Updated sample applications as needed to implement new changes.

v4.0

 * Dropped support for iOS 6, now only supports iOS 7+
 * Removed Native Authentication Provider (Facebook, Google, Twitter) SDK dependencies from the SDK.
 * Added example code to the SimpleCaptureDemo app for implementing the current releases of Native Authentication Provider's SDK's to retrieve provider authentication tokens and pass them to the SDK.
 * Added/Updated missing images for Instagram, Google+, PayPal OpenID Connect and a future provider.
 * Bugfix: Improved error handling in SimpleCaptureDemo app.
 * Added: updateProfileForUserWithForm:withEditProfileForm:delegate * convenience method for updating a user profile with any Registration configuration form that is compatible with the update_profile_native endpoint.
* NOTE:  Account Linking no longer integrates with Native Authentication.  Only webview based authentication is supported in the link account workflow.
 * Updated Native Provider documentation

v3.9.0

* iOS 8.3 compatibility

v3.8.0

 * iOS 8 Compatibility
 * Support for 64bit architectures
 * Improved ARC support in Capture model generation script

v3.7.2

 * Fixes bug that would replace plurals with an empty array when the array
   should be non-empty

v3.7.1

 * Added notification for when flow download succeeds or fails

v3.7.0

 * SDK now uses Automatic Reference Counting
 * Removed unused backplane support
 * Added icon support for Microsoft Account provider
 * User landing screen now uses square provider icons
 * Fixed bug with SMS URL shortening (Thanks hanvic)
 * Fixed crash when flow references field that does not exist in user record
 * User facing strings are now localizable

