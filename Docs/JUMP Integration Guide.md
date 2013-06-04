# JUMP for iOS Integration Guidx

This guide describes integrating the Janrain User Management Platform into your iOS app. For Engage-only
integrations see `Engage-Only Integration Guide.md`

## Features

* Engage social sign-in (includes OpenID, and many OAuth identity providers, e.g. Google, Facebook, etc.)
* Sign-in to Capture accounts
    * Either via Engage social sign-in or via traditional username/password sign-in
    * Including the Capture "merge account flow" (which links two social accounts by verified email address at sign-in
      time)
* Register new Capture accounts
    * Traditional accounts (e.g. authenticated via password)
    * Social accounts (with pre-populated registration forms.)
    * "Thin" social registration -- automatic account creation for social sign-in users without a registration form.
* Capture account record updates

### In the Pipeline

* Profile updates (including password and email address updates)
* In app password reset initiation
* Social account linking (like the "merge account" sign-in flow, but after a user is signed in.)
* Session refreshing.

## 10,000' View

1. Gather your configuration details
2. Generate the Objective-C Capture User Model source code
3. [Add the JUMP for iOS SDK to your Xcode project](http://developers.janrain.com/documentation/mobile-libraries/jump-for-ios/adding-to-xcode/).
4. Initialize the library
5. Start a sign-in
6. Modify the profile
7. Push the update

## Gather your Configuration Details

1. Sign in to your Engage Dashboard - https://rpxnow.com
    1. Configure the providers you wish to use for authentication ("Deployment" drop down menu -> "Engage for
       iOS").
    2. Retrieve your 20-character Application ID from the Engage Dashboard (In the right column of the "Home"
       page on the dashboard.)
2. Ask your deployment engineer or account manager for your Capture domain.
3. Create a new Capture API client for you iOS app:
    1. Sign in to the Capture dashboard and provision a new API client for your mobile app.
    2. Use the [set_features API](http://developers.janrain.com/documentation/api-methods/capture/clients/set_features/)
       to add the "login_client" feature to your new API client.
    3. Use the [setAccessSchema API](http://developers.janrain.com/documentation/api-methods/capture/entitytype/setaccessschema/)
       to set the subset of the schema you wish your mobile app to be able to update.
       **Warning** If you do not include the attributes your client will write to in the its write access
       schema you will receive missing attribute errors when attempting to update attributes.
4. Configure your flow settings:
    1. Ask your deployment engineer or account manager which "flow" you should use.
    2. Ask for the appropriate values for default_flow_name and default_flow_version.
    3. Set those settings for your new API client.
5. Coordinate with your deployment engineer or account manager for the correct value for your "flow locale."
   The commonly used value for US English is en-US.
6. Ask your deployment engineer or account manager for the name of the sign-in form in your flow.

Note: You _must_ create a new API client with the correct login_client feature for operation of the JUMP for iOS SDK.

## Generating the Capture User Model

Get the [JUMP for iOS library](http://developers.janrain.com/documentation/mobile-libraries/ios-v2/getting-the-library/) and
the required [JSON-2.53+](http://search.cpan.org/~makamaka/JSON-2.53/lib/JSON.pm) perl module.

1. Change into the script directory: `$ cd jump.ios/Janrain/JRCapture/Script`

2. Run the `CaptureSchemaParser.pl` script, passing in your Capture schema as an argument with the `-f` flag, and the
   path to your Xcode project with the `-o` flag:

   `$ ./CaptureSchemaParser.pl -f PATH_TO_YOUR_SCHEMA.JSON -o PATH_TO_YOUR_XCODE_PROJECT_DIRECTORY`

The script outputs to:

`PATH_TO_YOUR_XCODE_PROJECT_DIRECTORY/JRCapture/Classes/CaptureUserModel/Generated/`

That directory contains the Janrain Capture user record model for your iOS application.

After you have generated the user record model, you can
[add the library to Xcode](http://developers.janrain.com/documentation/mobile-libraries/jump-for-ios/adding-to-xcode/).

**Note**: If you've already added the library to Xcode, see
[Adding the Generated User Model](http://developers.janrain.com/documentation/mobile-libraries/jump-for-ios/adding-to-xcode/#adding-the-generated-capture-user-model).

## Import the Library and Declare a Record Reference

In your application, decide where you want to manage the authenticated Capture user object. You will want to implement
your Capture library interface code in an object that won't go away, such as the `AppDelegate` or a singleton object
that manages your application's data model.

1. Import the Capture header:
    
   `#import "JRCapture.h"`

2. Modify your class to conform to
   [JRCaptureSigninDelegate](http://janrain.github.com/jump.ios/gh_docs/capture/html/protocol_j_r_capture_signin_delegate-p.html),
   by adding it to the list of delegates. (All the messages of the protocol are optional.)

   `@interface MyDataModel : NSObject <JRCaptureSigninDelegate>`

3. Add a captureUser property to your delegate's header (see
   [JRCaptureUser](http://janrain.github.com/jump.ios/gh_docs/capture/html/interface_j_r_capture_user.html)):

   `@property (retain, nonatomic) JRCaptureUser *captureUser;`

4. And synthesize that property in your application delegate's implementation:

   `@synthesize captureUser;`

## Initialize the Library

To configure the library, pass your:

- Engage Application ID,
- Capture domain,
- Capture Client ID,
- Capture Flow Locale,
- Capture Flow Name (optional),
- Capture Flow Form Name and
- Capture Traditional Sign-In Type

... to the class method:

`+[JRCapture setEngageAppId:captureDomain:captureClientId:captureLocale:captureFlowName:captureSignInFormName:captureTraditionalSignInType:]`
        
... of the `JRCapture` class. For example:

    ... // Your existing initialization logic here
    
    NSString *engageAppId = @"your_engage_app_id";
    NSString *captureDomain = @"your_capture_ui_base_url";
    NSString *captureClientId = @"your_capture_client_id";
    NSString *captureLocale = @"en-US"; // e.g.
    NSString *captureFlowName = nil; // e.g.
    NSString *captureSignInFormName = @"signinForm"; // e.g.
    JRConventionalSigninType captureTraditionalSignInType =
        JRConventionalSigninEmailPassword; // e.g.    

       [JRCapture setEngageAppId:engageAppId captureDomain:captureDomain
                 captureClientId:captureClientId captureLocale:captureLocale
                 captureFlowName:captureFlowName captureSignInFormName:captureSignInFormName
    captureTraditionalSignInType:captureTraditionalSignInType];

**Note**: See the Capture API doc for [`/oauth/auth_native`](http://developers.janrain.com/documentation/api-methods/capture/oauth/auth_native/)
for more information on the default Capture flow name, and default flow version. Contact your Janrain Deployment
Engineer or Janrain Support for help configuring the flow parameters.

## Start the User Sign-In Flow

To start the authentication and sign-in flow, send the `startEngageSigninForDelegate:` message to the `JRCapture` class:

    [JRCapture startEngageSigninForDelegate:self];

This starts the Engage user authentication flow, the result of which is used to sign-in to Capture. Once a user is
signed in, the library instantiates a user record model (which is an instance of
[JRCaptureUser](http://janrain.github.com/jump.ios/gh_docs/capture/html/interface_j_r_capture_user.html).)

The [JRCaptureSigninDelegate](http://janrain.github.com/jump.ios/gh_docs/capture/html/protocol_j_r_capture_signin_delegate-p.html)
protocol defines a set of (optional) messages your Capture delegate can respond to. As the flow proceeds, a series of
delegate messages will be sent to your delegate.

First, your delegate will receive 
[engageSigninDidSucceedForUser:forProvider:](http://janrain.github.com/jump.ios/gh_docs/capture/html/protocol_j_r_capture_signin_delegate-p.html#a39eb082986c4a029cbc8545cc8029c18)
when Engage authentication is complete. At this point, the library will close the authentication dialog and then
complete sign-in to Capture headlessly. This message contains limited data which can be used to update UI while your
app waits for Capture to complete authentication.

To receive the user's basic profile data (the
[auth_info](http://developers.janrain.com/documentation/api/auth_info/) data) have your delegate respond to
[engageSigninDidSucceedForUser:forProvider:](http://janrain.github.com/jump.ios/gh_docs/capture/html/protocol_j_r_capture_signin_delegate-p.html#a39eb082986c4a029cbc8545cc8029c18):

    - (void)engageSigninDidSucceedForUser:(NSDictionary *)engageAuthInfo
                              forProvider:(NSString *)provider
    {
        self.currentDisplayName = [self getDisplayNameFromProfile:engageAuthInfo];
    
        // Update the UI to show that authentication is completing...
        [self showCompletingSigninVisualAffordance];
    
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }

The basic profile data is included for your information while sign-in completes. Once the authentication token reaches
Capture, Capture automatically adds the profile data to the Capture record.

### More

- For more information on what is returned by Engage, please see the
  [auth_info](http://developers.janrain.com/documentation/api/auth_info/) section of the Engage API docs.
- For a broader look at the Capture sign-in flow, please see
  [Capture Sign-In Flow](http://developers.janrain.com/documentation/mobile-libraries/#capture-sign-in).

## Finish the User Sign-In Flow

Once the the user record is retrieved from Capture, the
[captureAuthenticationDidSucceedForUser:status:](http://janrain.github.com/jump.ios/gh_docs/capture/html/protocol_j_r_capture_signin_delegate-p.html#aa5dc2ae621394b1a97b55eb3fca6b2ef)
message is sent to your delegate. This message delivers the
[JRCaptureUser](http://janrain.github.com/jump.ios/gh_docs/capture/html/interface_j_r_capture_user.html) instance, and
also the state of the record.

    - (void)captureAuthenticationDidSucceedForUser:(JRCaptureUser *)newCaptureUser
                                            status:(JRCaptureRecordStatus)captureRecordStatus
    {
        // Retain a reference to the user object
        self.captureUser = newCaptureUser;
    
        // User records can come back with one of two states
        if (captureRecordStatus == JRCaptureRecordNewlyCreated)
        {
            // The user has not signed in to this Capture instance before and a new record
            // has been automatically created. This is called a "thin registration"
    
            // You may wish to collect additional data from the user and add it
            // to the user's record, e.g. an avatar image URL, T.O.S. acceptance, etc. 
        }
        else if (captureRecordStatus == JRCaptureRecordExists)
        {
            // The user had a pre-existing Capture user record
        }
    }

There are two possible values for
[captureRecordStatus:](http://janrain.github.com/jump.ios/gh_docs/capture/html/_j_r_capture_8h.html#a3de9970dfc3458baae757eb39c61da6e)

[JRCaptureRecordExists](http://janrain.github.com/jump.ios/gh_docs/capture/html/_j_r_capture_8h.html#a3de9970dfc3458baae757eb39c61da6e)
indicates that the user had an existing Capture record and that record has been retrieved. Your application should
update its state to reflect the user being signed-in.

[JRCaptureRecordNewlyCreated](http://janrain.github.com/jump.ios/gh_docs/capture/html/_j_r_capture_8h.html#a3de9970dfc3458baae757eb39c61da6e)
indicates that this is a new user and that a new Capture record has been automatically created. (This is called "thin
registration.") Because this is a new user, your application may wish to collect additional profile information and
push that information back to Capture.

### Traditional Sign-In and Social Sign-In

The Capture part of the SDK supports both social sign-in via Engage (e.g. Facebook) as well as traditional sign-in (i.e.
username and password or email and password sign-in.) There are four main ways to start sign-in:

- `+[JRCapture startEngageSigninDialogForDelegate:]`: Starts the Engage social sign-in process for all currently
  configured social sign-in providers, displaying a list of them initially, and guiding the user through the
  authentication.
- `+[JRCapture startEngageSigninDialogOnProvider:withCustomInterfaceOverrides:mergeToken:forDelegate:]`: Starts the
   Engage social sign-in process beginning directly with the specified social sign-in identity provider (skipping the
   list of configured social sign-in providers)
- `+[JRCapture startEngageSigninDialogWithConventionalSignin:forDelegate:]`: Start the Engage social sign-in process
  for all currently configured social sign-in providers, preceding the list with a traditional sign-in form.
- `+[JRCapture startCaptureConventionalSigninForUser:withPassword:withSigninType:mergeToken:forDelegate:]`: Starts
  the traditional sign-in flow headlessly.

The first two methods start social sign-in only (either by presenting a list of configured providers, or by starting
the sign-in flow directly on a configured provider.) The fourth method performs a headless traditional sign-in -
useful if your host app wishes to present it's own traditional sign-in UI. The third method combines social sign-in
with a stock traditional sign-in UI.

The merge token parameters are used in the second part of the Merge Account Flow, described below.

### Handling the Merge Sign-In Flow

Sometimes a user will have created a record with one means of sign-in (e.g. a traditional username and password record)
and will later attempt to sign-in with a different means (e.g. with Facebook.)

When this happens the sign-in does not succeed, because there is no Capture record associated with the Social sign-in
identity and the email address from the identity is already in use. Before being able to sign-in with the identity,
the user must merge the identity into their existing record. This is called the "Merge Account Flow."

The merge is achieved at the conclusion of a second sign-in flow authenticated by the record's existing associated
identity. The second sign-in is initiated upon the failure of the first sign-in flow, and also includes a merge token
which Capture uses to merge the identity from the first (failed) sign-in into the record.

Capture SDK time-line for Merge Account Flow:

 1. User attempts to sign-in with social identity provider, A.
 2. Capture sign-in fails because there is an existing Capture record sharing some protected attributes with identity A,
    e.g. the same email address.
 3. The `-[JRCaptureSigninDelegate captureAuthenticationDidFailWithError:]` delegate message is sent with an error
    representing this state. This state is to be discerned via the `-[NSError isJRMergeFlowError]` class category
    message.
 4. The host application (your iOS app) notifies the user of the conflict and advises the user to merge the accounts
 5. The user elects to take action
 6. the merge sign-in is started by invoking either
    `+[JRCapture startEngageSigninDialogOnProvider:withCustomInterfaceOverrides:mergeToken:forDelegate:]` or
    `+[JRCapture startCaptureConventionalSigninForUser:withPassword:withSigninType:mergeToken:forDelegate:]` depending
    on the existing identity provider for the record.

    The existing identity provider of the record is retrieved with the `-[NSError JRMergeFlowExistingProvider]` message,
    and the merge token with the `-[NSError JRMergeToken]` message.

Example:

    - (void)captureAuthenticationDidFailWithError:(NSError *)error
    {
        if ([error code] == JRCaptureErrorGenericBadPassword)
        {
            [self handleBadPasswordError]; // Advises the user to try again.
        }
        else if ([error isJRMergeFlowError])
        {
            [self handleMergeFlowError:error];
        }
    }
    
    - (void)handleMergeFlowError:(NSError *)error
    {
        NSString *existingAccountProvider = [error JRMergeFlowExistingProvider];
        void (^mergeAlertCompletion)(UIAlertView *, BOOL, NSInteger) =
                ^(UIAlertView *alertView, BOOL cancelled, NSInteger buttonIndex)
                {
                    if (cancelled) return;

                    if ([existingAccountProvider isEqualToString:@"capture"]) // Traditional sign-in required
                    {
                        [self handleTradMerge:error];

                    }
                    else
                    {
                        // Social sign-in required:
                        [JRCapture startEngageSigninDialogOnProvider:existingAccountProvider
                                        withCustomInterfaceOverrides:self.customUi
                                                          mergeToken:[error JRMergeToken]
                                                         forDelegate:self];
                    }
                };

        [self showMergeAlertDialog:existingAccountProvider mergeAlertCompletion:mergeAlertCompletion];

    }

    - (void)handleTradMerge:(NSError *)error
    {
        void (^signInCompletion)(UIAlertView *, BOOL, NSInteger) =
                ^(UIAlertView *alertView_, BOOL cancelled_, NSInteger buttonIndex_)
                {
                    if (cancelled_) return;
                    NSString *user = [[alertView_ textFieldAtIndex:0] text];
                    NSString *password = [[alertView_ textFieldAtIndex:1] text];
                    [JRCapture startCaptureConventionalSigninForUser:user withPassword:password
                                                      withSigninType:JRConventionalSigninEmailPassword
                                                          mergeToken:[error JRMergeToken]
                                                         forDelegate:self];
                };

        [[[AlertViewWithBlocks alloc] initWithTitle:@"Sign in" message:nil completion:signInCompletion
                                              style:UIAlertViewStyleLoginAndPasswordInput
                                  cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:@"Sign-in", nil] show];
    }

**Note**: This example makes use of the `AlertViewWithBlocks` subclass of `UIAlertView` (which provides an interface
to `UIAlertView` with a block handler, as opposed to a delegate object handler.) See the SimpleCaptureDemo project in
the Samples directory of the SDK for source code.

This example checks for the merge-flow error, it prompts the user to merge, and it start authentication.

**Note**: That the "existing provider" of the merge flow can be Capture itself. This happens when the merge-failure was
a conflict with an existing record created with traditional sign-in. This case is handled in the `handleTradMerge:`
method.

## Making Changes in a Capture User Record

Capture user records are defined by the Capture schema, which defines the attributes of the record. An attribute is
either a primitive value (a number, a string, a date, or similar) an object, or a plural.

Primitive attribute values are the actual data that make up your user record. For example, they are your user's
identifier, or their email address, or birthday.

Objects and plurals make up the structure of your user record. For example, in the default Capture schema, the user's
name is represented by an object with six primitive values (strings) used to contain the different parts of the name.
(The six values are `familyName`, `formatted`, `givenName`, `honorificPrefix`, `honorificSuffix`, `middleName`.)
Objects can contain primitive values, sub-objects, or plurals, and those attributes are defined in the schema.

Plurals contain collections of objects. Each element in a plural is an object or another plural. Every element in a
plural has the same set of attributes, which are defined in the schema. Think of a plural as an object that may have
zero-or-more instances.

Generating your Capture user model produces Objective-C classes for all your objects and non--string-plural plural
elements. For example, you will have a `JRName` class which contains `NSString` properties for the six attributes
noted above.

Internally, Capture user record updates occur through one of two mechanisms: updating and replacing. Both updating and
replacing are limited in scope to part of the record, depending on the object from which they are called. Broadly
speaking, parts of the record that are limited to objects can be updated, but to change the plural elements in a plural
you must replace the plural. For example, `JRName` (the user's name) is an object and can be updated if the user changes
part of their name, but `JRInterests` (a plural of strings holding the user's interests) must be replaced if the user
adds or removes an interest.

### Updating Record Entities (Non-plurals)

Conform to the
[JRCaptureObjectDelegate](http://janrain.github.com/jump.ios/gh_docs/capture/html/protocol_j_r_capture_object_delegate-p.html)
protocol in your class:

    @interface MyDataModel : UIResponder <JRCaptureSigninDelegate, JRCaptureObjectDelegate>

Update the object's non-plural properties, and then send the object the
[updateOnCaptureForDelegate:context:](http://janrain.github.com/jump.ios/gh_docs/capture/html/interface_j_r_capture_object.html#a307b20b8cb70eec684e7197550c9f4c3)
message. For example:

    captureUser.aboutMe = @"Hello. My name is Inigo Montoya.";
    [captureUser updateOnCaptureForDelegate:self context:nil];

**Note**: Context arguments are used across most of the asynchronous Capture methods to facilitate correlation of the
response messages with the calling code. Use of the context is entirely optional. You can use any object which conforms
to `<NSObject>`.

You may respond to
[updateDidSucceedForObject:context:](http://janrain.github.com/jump.ios/gh_docs/capture/html/protocol_j_r_capture_object_delegate-p.html#afa043773e69351fc3115d7ae765986db)
for notification of success:

    - (void)updateDidSucceedForObject:(JRCaptureObject *)object context:(NSObject *)context
    {
        // Successful update
    }

Similarly
[updateDidFailForObject:withError:context:](http://janrain.github.com/jump.ios/gh_docs/capture/html/protocol_j_r_capture_object_delegate-p.html#affff9e5fe9d03312a4d5db8b39ba5ff0)
will be sent on failure. See
[Capture Errors](http://janrain.github.com/jump.ios/gh_docs/capture/html/group__capture_errors.html#ggabc7274cb58c13d8cda35a6554a013de9ac24c5311be2739cfa10797413b2023ca)
in the API documentation for possible errors.

You can send the `updateOnCaptureForDelegate:context:` message to the top-level object (an instance of
[JRCaptureUser](http://janrain.github.com/jump.ios/gh_docs/capture/html/interface_j_r_capture_user.html)
instance), or a sub-object of that object.

**Warning**: When you update an object, the update _does not_ affect plurals inside of that object.

### Replacing Plurals

To add or remove the elements of a plural send the `replace_ArrayName_ArrayOnCaptureForDelegate:context:` message to
the parent-object of the plural, where _ArrayName_ is the name of the plural attribute.

For example, if you have a schema with a plural attribute named `photos`, the user model generator generates a method
named `replacePhotosArrayOnCaptureForDelegate:context:`. In this case the _ArrayName_ is `Photos`.

Once the values in the plural element attribute have been updated in the local instance of the user record model,
Capture can be updated by called `replace_ArrayName_ArrayOnCaptureForDelegate:context:`.

For example:

    // Make a new photos plural element:
    JRPhotosElement *newPhoto = [[JRPhotosElement alloc] init];
    newPhoto.value = @"http://janrain.com/wp-content/uploads/drupal/janrain-logo.png";
    
    // Make a new array with the new element added:
    NSMutableArray *newPhotos = [NSMutableArray  arrayWithArray:captureUser.photos];
    [newPhotos addObject:newPhoto];
    
    // Assign the new array to the photos plural property:
    captureUser.photos = newPhotos;
    
    // ... And update Capture:
    [captureUser replacePhotosArrayOnCaptureForDelegate:self context:nil];

**Warning**: The `NSArray` properties used to model plurals are copy-on-set. This means that to modify the array you
must create a new mutable array with the existing array, then modify the mutable array, then assign the mutable array
to the property. (Because the property is copy-on-set further modifications to the copied array will not change the
property.) See the above example for an example of this technique.

## Persisting the Capture User Record

When your application terminates, you should save your active user record to local storage. For example, from your
[UIApplicationDelegate](http://developer.apple.com/library/ios/#DOCUMENTATION/UIKit/Reference/UIApplicationDelegate_Protocol/Reference/Reference.html):

    #define cJRCaptureUser @"jr_capture_user"
    
    - (void)applicationWillTerminate:(UIApplication *)application
    {
        // Store the Capture user record for use when your app restarts;
        // JRCaptureUser objects conform to NSCoding so you can serialize them with the
        // rest of your app state
        NSUserDefaults *myPreferences = [NSUserDefaults standardUserDefaults];
        [myPreferences setObject:[NSKeyedArchiver archivedDataWithRootObject:captureUser]
                          forKey:cJRCaptureUser];
    }

Likewise, load the saved user record state when your application launches. For example, from the
`UIApplicationDelegate`:

    - (BOOL)          application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
        NSUserDefaults *myPreferences = [NSUserDefaults standardUserDefaults];
        NSData *encodedUser = [myPreferences objectForKey:cJRCaptureUser];
        self.captureUser = [NSKeyedUnarchiver unarchiveObjectWithData:encodedUser];
    }

**Note**: While your application is responsible for saving and restoring the user record, the Capture library will
automatically save and restore the session token.

## Troubleshooting

Sign-ins fail with an error message indicating that the client doesn't have the necessary permissions.

Ensure that the API client ID you are using is for an API client with the "login_client" API client feature. To
configure this see the clients/set_features Capture API and also the clients/list Capture API to get the set of
configured API client features.

`code: 223 error: unknown_attribute description: attribute does not exist: /your_attr_name`

Use [entityType.setAccessSchema](http://developers.janrain.com/documentation/api-methods/capture/entitytype/setaccessschema)
to add write-access to this attribute to your native API client.
