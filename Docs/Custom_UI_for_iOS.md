Custom UI for iOS
=================

Custom Interface API
--------------------

The Registation SDK provides the ability to customize the look and feel
of the user interface, as well as the ability to add your own native
login experience through the Custom Interface API. You can change the
fonts, colors, and background images, of many of the views; you can
change the default behavior of the modal dialog on both iPhone and iPad,
and you can add your own conventional login experience, integrated
seamlessly with Social Login.

### Overview

The SDK uses a dictionary of [pre-defined
keys](https://rpxnow.com/docs/iphone_api/group__custom_interface.html)
and values to configure many of the elements of the user interface.
There are two places where your application can change the default
values:

-   by passing an `NSMutableDictionary` to the
    `setCustomInterfaceDefaults:` method before login or social sharing,
    or
-   by passing an `NSDictionary` to the
    `showAuthenticationDialogWithCustomInterfaceOverrides:` or
    `showSocialPublishingDialogWithActivity:andCustomInterfaceOverrides:`
    methods

Using this interface, you can change titles, fonts, colors, headers, and
footers; set custom views for the login dialog’s table of social
providers, and change the default behavior of the dialog’s navigation
controller.

For a list of the pre-defined keys, please see the [Custom User
Interface](https://rpxnow.com/docs/iphone_api/group__custom_interface.html)
section of the Social Login API documentation.

### Using the setCustomInterfaceDefaults: Method

To configure the SDK programmatically, create an `NSMutableDictionary`
object, indexed by the Custom Interface’s [pre-defined set of
keys](https://rpxnow.com/docs/iphone_api/group__custom_interface.html)
and pass this to the library through the `setCustomInterfaceDefaults:`
method.

    NSMutableDictionary *customInterface;
    customInterface = [[NSMutableDictionary alloc]
     initWithObjectsAndKeys:
                          @"stones.png", kJRProviderTableBackgroundImageName,
                          @"stones.png", kJRUserLandingBackgroundImageName,
                          @"stones.png", kJRSocialSharingBackgroundImageName,
                          @"Sign in to Example App", kJRProviderTableTitle,
                          @"Share Example App Purchase", kJRSocialSharingTitle, nil]
    ;
    [jrEngage setCustomInterfaceDefaults:customInterface]
    ;

### Using the show… Methods

You can also launch login and social sharing with a custom interface
dictionary through the
`showAuthenticationDialogWithCustomInterfaceOverrides:` or
`showSocialPublishingDialogWithActivity:andCustomInterfaceOverrides:`
methods.

    NSDictionary *customInterface;
    customInterface = [[NSDictionary alloc]
     initWithObjectsAndKeys:
                          @"stones.png", kJRProviderTableBackgroundImageName,
                          @"stones.png", kJRUserLandingBackgroundImageName,
                          @"stones.png", kJRSocialSharingBackgroundImageName,
                          @"Sign in to Example App", kJRProviderTableTitle,
                          @"Share Example App Purchase", kJRSocialSharingTitle, nil]
    ;
    [jrEngage showAuthenticationDialogWithCustomInterfaceOverrides:customInterface]
    ;

Any values passed into any of the `show...Dialog` methods will override
the corresponding values passed into the `setCustomInterfaceDefaults:`
method.

The Navigation Controller
-------------------------

The default behavior for the
[JREngage](http://janrain.github.com/jump.ios/gh_docs/engage/html/interface_j_r_engage.html "JREngage")
library is to present its dialogs modally, using the
`UIModalTransitionStyleCoverVertical` transition style on the iPhone and
the `UIModalTransitionStyleFlipHorizontal` transition style combined
with the `UIModalPresentationFormSheet` presentation style on the iPad.
Once loaded, the dialogs views are pushed onto and popped from a
navigation controller owned by the library.

On the iPhone, if you want the library’s views to be pushed on to your
application’s navigation controller, set
`kJRApplicationNavigationController` to your application’s navigation
controller. If you want to push your own views onto the library’s
navigation controller or customize the library’s navigation controller,
you can achieve this with the `kJRCustomModalNavigationController` key.

### Using Your Application’s Navigation Controller

If you want the library’s views to be pushed on to your application’s
navigation controller, pass the pointer to your application’s navigation
controller to the library with the `kJRApplicationNavigationController`
key.

    [myEngageCustomizations setObject:self.navigationController
                               forKey:kJRApplicationNavigationController]
    ;

By using your application’s navigation controller, you can push your own
views onto the navigation stack, such as if you wanted to integrate
native login with Social Login.

Do not cancel social sharing or login by popping the navigation
controller back to one of your views, as this could potentially leave
the library in an unexpected state. Please use the
`cancelAuthentication` or `cancelPublishing` methods instead.

#### Considerations

Before presenting its dialogs, the library checks to see if the provided
navigation controller’s view is loaded. If it is not, the library
reverts to the default behavior.

Setting this value on the iPad has no effect. The library will either
use a custom navigation controller, if provided, or the default
navigation controller when presenting its views.

### Using a Custom Navigation Controller

If you want to push your own views onto the library’s navigation
controller, but your application does not have a navigation controller,
or your application is running on the iPad, or if you want the library’s
dialogs to present themselves using the
`UIModalTransitionStyleCoverVertical` transition style, you can use the
`kJRCustomModalNavigationController` key. This is also necessary if you
want to tint the navigation bar’s color.

To do this, create a navigation controller that your application owns,
change the tint, if desired, and pass a pointer to the navigation
controller to the library with the `kJRCustomModalNavigationController`
key.

    UINavigationController *myNewNav = [[UINavigationController alloc]
     init]
    ;
    [myNewNav.navigationBar setTintColor:[UIColor redColor]]
    ;
    [myEngageCustomizations setObject:myNewNav forKey:kJRApplicationNavigationController]
    ;

Because you own this navigation controller, you can push your own views
onto the navigation stack, if for instance, you want to integrate native
login with Social Login.

Do not cancel social sharing or login by manipulating the navigation
controller, as this could potentially leave the library in an unexpected
state. Please use the `cancelAuthentication` or `cancelPublishing`
methods instead.

#### Considerations

If, on the iPhone, you also passed a pointer to your application’s
navigation controller with the `kJRApplicationNavigationController` key
and its view is loaded, the library will use this value. On the iPad,
the `kJRApplicationNavigationController` will be ignored.

If you are developing a universal application, you can push the
library’s views and your own views onto your application’s navigation
controller on the iPhone and you can push your own views onto a custom
navigation controller on the iPad.

### Tinting the Navigation Bar

If you want to tint the library’s navigation controller, you must use
the `kJRCustomModalNavigationController` key. Create a navigation
controller, change the tint, and pass a pointer to the navigation
controller to the library with the `kJRCustomModalNavigationController`
key.

    UINavigationController *myNewNav = [[[UINavigationController alloc]
     init]
     autorelease]
    ;
    [myNewNav.navigationBar setTintColor:[UIColor redColor]]
    ;
    [myEngageCustomizations setObject:myNewNav forKey:kJRApplicationNavigationController]
    ;

If you want to push your own views to this navigation controller, such
as when integrating native login with Social Login, you should retain a
pointer to the navigation controller object.

Do not cancel social sharing or login by manipulating the navigation
controller, as this could potentially leave the library in an unexpected
state. Please use the `cancelAuthentication` or `cancelPublishing`
methods instead.

Fonts, Colors, and Background Images
------------------------------------

There are several ways in which you can configure the library’s words,
fonts, colors, and image to better fit your application’s branding. You
may not, however, remove the “Powered by Janrain” attribution view
unless given specific permission to do so by Janrain.

### Changing Titles, Headers, and Footers

If you wish to change only the text of the titles of the library’s
Provider Table and Social Sharing views, you can do so by passing the
library `NSString` pointers with the `kJRProviderTableTitleString` and
`kJRSocialSharingTitleString` keys.

    [myEngageCustomizations setObject:@"Sign in to Janrain"
                               forKey:kJRProviderTableTitleString]
    ;
    [myEngageCustomizations setObject:@"Share this score!"
                               forKey:kJRProviderTableTitleString]
    ;

You can also change the section header and section footer text of the
Provider Table by passing `NSString` pointers to the library with the
`kJRProviderTableSectionHeaderTitleString` and
`kJRProviderTableSectionFooterTitleString` keys. This will change only
the header and footer of the table section of Social Login providers. To
add more content to this view, follow the steps described in
[Conventional login with Social Login](#nativeloginwithsociallogin).

If you want to change more than just the text of the view’s titles or
the Provider Table’s section header and section footer, you must create
a `UIView` object, add your customizations or subviews, and pass a
pointer to this view to the library with the
`kJRProviderTableTitleView`, `kJRSocialSharingTitleView`,
`kJRProviderTableSectionHeaderView`, and
`kJRProviderTableSectionFooterView` keys. You can also do this to
customize the Provider Table’s table header and table footer views.

    UILabel *myNewTitle = [[UILabel alloc]
     initWithFrame:CGRectMake(40, 0, 140, 44)]
    ;
    [myNewTitle setFont:[UIFont boldSystemFontOfSize:20.0]]
    ;
    [myNewTitle setBackgroundColor:[UIColor clearColor]]
    ;
    [myNewTitle setTextColor:[UIColor whiteColor]]
    ;
    [myNewTitle setShadowColor:[UIColor colorWithWhite:0.0 alpha:0.5]]
    ;
    [myNewTitle setTextAlignment:UITextAlignmentCenter]
    ;
    [myNewTitle setText:@"Sign in to McSpillz"]
    ;
    [myEngageCustomizations setObject:myNewTitle forKey: kJRProviderTableTitleView]
    ;

If your customization dictionary contains values for both a “string” key
and a “view” key (like `kJRProviderTableSectionHeaderTitleString` and
`kJRProviderTableSectionHeaderView`), the view will be used. Although,
if both a string and view is given for the title of the Provider Table
and the Social Sharing views, the provided view is used on the
navigation bar but the string is used as the text on the “Back” button.

If you want to make any customizations to the navigation bar beyond
changing the title view of the Provider Table and Social Sharing views,
you should create your own navigation controller, set one of your
classes as the navigation controller’s `UINavigationControllerDelegate`,
and pass it to the library with the
`kJRCustomModalNavigationController`. If you implement the
`navigationController:willShowViewController:animated:` or
`navigationController:didShowViewController:animated:` method, you can
listen as the library loads its views and change the visual details as
needed.

### Setting Background Colors and Images

If you want to change the background color of the login or social
sharing views, you can do so by passing a pointer to a `UIColor` object
with the `kJRAuthenticationBackgroundColor` or
`kJRSocialSharingBackgroundColor` keys.

    [myEngageCustomizations setObject:[UIColor blueColor]
                               forKey:kJRAuthenticationBackgroundColor]
    ;
    [myEngageCustomizations setObject:[UIColor greenColor]
                               forKey:kJRSocialSharingBackgroundColor]
    ;

If you want to set a background image, create a `UIImageView`, set the
image, set the properties as desired, and pass a pointer to the
`UIImageView` to the library with the keys
`kJRAuthenticationBackgroundImageView` or
`kJRSocialSharingBackgroundImageView` keys.

    UIImageView *myBackgroundImage =
                     [[UIImageView alloc]
     initWithFrame:CGRectMake(0, 0, 320, 480)]
    ;
    [myBackgroundImage setImage:[UIImage imageNamed:@"background.png"]]
    ;
    [myBackgroundImage setContentMode:UIViewContentModeCenter]
    ;
    [myEngageCustomizations setObject:myBackgroundImage
    forKey:kJRProviderTableBackgroundImageView]
    ;

Dialog Presentation on the iPad
-------------------------------

The
[JREngage](http://janrain.github.com/jump.ios/gh_docs/engage/html/interface_j_r_engage.html "JREngage")
library works beautifully on iPhone-only, iPad-only, and universal
applications, without any configuration necessary. The library detects
the device and displays its dialogs appropriately. Regardless of device
or presentation style, the size of the library’s views is kept at 320 px
by 480 px, ignoring any adjustments due to changes in device rotation,
status bar size, or the presence of the on-screen keyboard. Therefore,
any custom views added to the custom interface should work for
applications that run on both devices.

### Default Behavior

By default, when displaying dialogs on the iPad, the library uses a
modal view controller, presenting it with the
`UIModalTransitionStyleFlipHorizontal` transition style and the
`UIModalPresentationFormSheet` presentation style. The form sheet dialog
appears in the center of the screen and the surrounding, uncovered areas
of your application are dimmed. As is the standard behavior of modal
dialogs presented as a form sheet, the user is unable to interact with
any of the controls contained in the view behind the dialog. Also,
unlike a `UIPopoverController`, clicking in this area will not dismiss
this view.

If you wish to enable this behavior, you should configure the library to
use a `UIPopoverController`.

### Using a Popover Controller

You can configure the library to present itself in a
`UIPopoverController`, from either a bar button item or from any other
rectangle on the screen, by setting a value for either the
`kJRPopoverPresentationBarButtonItem` key or
`kJRPopoverPresentationFrameValue` key, respectively.

To display the dialog in a `UIPopoverController` from a bar button item
(the left button of your application’s navigation controller), pass a
pointer to this button to the library with the
`kJRPopoverPresentationBarButtonItem` key.

    [myEngageCustomizations setObject:self.navigationItem.rightBarButtonItem
                               forKey:kJRPopoverPresentationBarButtonItem]
    ;

To display the dialog from some other rectangle on the screen (like the
frame of a button), pass this rectangle to the library with the
`kJRPopoverPresentationFrameValue` key. To do so, you must take a
`CGRect` rectangle and set the `NSValue` representation of this
rectangle in your `NSDictionary`. Make sure that the rectangle is
relative to the frame of the entire screen.

    CGRect relativeFrame =
                [containingView convertRect:signInButton.frame
                                     toView:[[UIApplication sharedApplication]
     keyWindow]]
    ;
    NSValue *frameValue = [NSValue valueWithCGRect:relativeFrame]
    ;
    [myEngageCustomizations setObject:frameValue forKey:kJRPopoverPresentationFrameValue]
    ;

The default arrow direction of the `UIPopoverController` is
`UIPopoverArrowDirectionDown`, but you can also change this value by
using the `kJRPopoverPresentationArrowDirection` key. To use this key,
you need convert a `UIPopoverArrowDirection` enumeration to an
`NSNumber` before setting this value in your `NSDictionary`.

    NSNumber arrowDirection = [NSNumber numberWithInt:UIPopoverArrowDirectionDown]
    ;
    [myEngageCustomizations setObject:arrowDirection
                               forKey:kJRPopoverPresentationArrowDirection]
    ;

If your dictionary contains values for both the
`kJRPopoverPresentationBarButtonItem` and
`kJRPopoverPresentationFrameValue` keys, the item specified with the
`kJRPopoverPresentationBarButtonItem` key will be used. If there is no
item specified for the `kJRPopoverPresentationBarButtonItem` and
`kJRPopoverPresentationFrameValue` keys, the library will present the
dialog in a modal form sheet.

#### Considerations

Clicking outside of the `UIPopoverController` will dismiss the library’s
dialogs. Presently, the library does not display the
`UIPopoverController` modally (that is, the owning `UIViewController`
property `modalInPopover` is set to `NO`). To achieve this behavior, you
should use the default modal form sheet presentation.

Likewise, the library’s `UIPopoverController` does not currently support
`passthroughViews`. That is, interactions with other views are disabled
until the popover is dismissed.

When presenting the library’s dialogs in a `UIPopoverController`,
particularly when presenting the popover from a rectangle on the screen,
be aware of how rotations to the device and the appearance of the
on-screen keyboard may affect the layout of the popover controller in
relation to your application’s view below the dialog. You should do your
best to present it from a bar button item or rectangle in the top half
of the screen.

Conventional login with Social Login
------------------------------------

The Social Login SDK provides a mechanism whereby you can customize
certain aspects of the library’s user interface, including the ability
to add native login above or below the Social Login providers.

This can be achieved by taking the following steps:

-   Create a `UIViewController` subclass, specify the views to be
    managed by the controller (either manually or using a nib file), and
    add any code needed to handle events.
-   Create an `NSDictionary` object, and add a pointer to your view
    controller’s view with the keys `kJRProviderTableHeaderView` or
    `kJRProviderTableFooterView`.
-   Pass the dictionary to the library through the library’s Custom
    Interface API.

The library will add your view controller’s view as the
`tableHeaderView` of the provider-table\*. You can also customize the
titles/views used as the provider-table’s section headers and section
footers, giving you the ability further differentiate your login and the
Social Login.

If you want to add your native login as a `UITableView` Section — above
or below the provider-table’s social provider section — you can simulate
this by creating your own grouped `UITableView`, and passing this to the
Custom Interface API as the provider-table header or footer view.

![](/wp-content/uploads/2012/03/8ddf62fdb6863f5a9ceec8dbfebf6ebf.png)

![](/wp-content/uploads/2012/03/7145f07ca1726c49cc5e75c5b946b6f8.png)

That is, create a `UIViewController` subclass that is the delegate and
dataSource of a grouped `UITableView`, and pass the table view to the
library. If you want section headers, you can specify the section header
of your table view in your table view’s `UITableViewController`
subclass, and you can pass in the provider-table’s section header
through the custom interface API.

\* The Social Login providers are presented as a grouped `UITableView`,
referred to as the provider-table.

### Implementation

Create a `UIViewController` subclass that contains a `UITableView`:

    @interface MyViewController : UIViewController
    {
        UITableView *myTableView;
    }
    @end

Set the table view’s origin at (0, 0), make your table view 320 pixels
wide (for portrait orientation) and set the `backgroundColor` to clear:

    @implementation EmbeddedTableViewController

    - (void)loadView
    {
        myTableView = [[UITableView alloc]
     initWithFrame:CGRectMake(0, 0, 320, 170)
                                                   style:UITableViewStyleGrouped]
    ;
        myTableView.backgroundColor = [UIColor clearColor]
    ;

        ...
    }

Set your view controller as the `delegate` and `dataSource`, and set the
table view as your view controller’s view:

    - (void)loadView
    {
        ...

        myTableView.dataSource = self;
        myTableView.delegate = self;

        self.view = myTableView;
    }

If required, create other views, set your view controller as the target
responder for events, and set these as the `tableHeaderView` or
`tableFootView`:

    - (void)loadView
    {
        ...

        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect]
    ;
        
    ;
        
    ;

        UIView *footerView = [[[UIView alloc]
                               initWithFrame:CGRectMake(0, 0, 320, 50)]
                                 autorelease]
    ;
        [footerView addSubview:button]
    ;

        myTableView.tableFooterView = footerView;

        ...
    }

Return **one** as the number of sections in the table view, return the
number of rows, the row height, and the table view cells:

    - (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
    {
        return 1;
    }

    - (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
    {
        return 2;
    }

    - (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
    {
        return 40.0;
    }

    - (UITableViewCell *)tableView:(UITableView *)tableView
             cellForRowAtIndexPath:(NSIndexPath*)indexPath
    {
        static NSString *cellId = @"Cell";

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId]
    ;
        if (cell == nil)
        { ... }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

If desired, set the section header title for your table, or return a
custom view:

    - (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
    {
        return @"Example native login";
    }

Additionally, you can set the section header title or custom view for
the provider table, by adding it to the custom interface dictionary:

    NSMutableDictionary *customInterface = [NSMutableDictionary dictionaryWithCapacity:2]
    ;
    [customInterface setValue:@"Social Providers"
                       forKey:kJRProviderTableSectionHeaderTitleString]
    ;

Add your table view to the custom interface dictionary with the provider
table header view key, and pass this dictionary to the library:

    [customInterface setValue:myTableView forKey:kJRProviderTableHeaderView]
    ;
    [jrEngage setCustomInterface:customInterface]
    ;

If your user chooses to use your native login, and you want to push
additional views onto the navigation stack, you must pass a pointer to
your navigation controller to the library before you begin
authentication:

    [jrEngage setCustomNavigationController:self.navigationController]
    ;

Finally, begin authentication:

    [jrEngage showAuthenticationDialog]
    ;

-   by passing an `NSMutableDictionary` to the
    `setCustomInterfaceDefaults:` method before login or social sharing,
    or
-   by passing an `NSDictionary` to the
    `showAuthenticationDialogWithCustomInterfaceOverrides:` or
    `showSocialPublishingDialogWithActivity:andCustomInterfaceOverrides:`
    methods

Using this interface, you can change titles, fonts, colors, headers, and
footers, and set custom views for the login dialog’s table of social
providers and change the default behavior of the dialog’s navigation
controller.

For a list of the pre-defined keys, please see the [Custom User
Interface](https://rpxnow.com/docs/iphone_api/group__custom_interface.html)
section of the Social Login API documentation.

Copyright © 2016 Janrain, Inc. All Rights Reserved.

