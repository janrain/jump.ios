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
* Updated Cocoapods support and resolved some file naming conflicts for XCode 9's new build system(preview)
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
 * Added support for non-standard Engage server url's
 * Added support for custom flow download location url's
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

