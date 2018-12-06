# Xcode Project Setup Guide

This guide guides you through integrating the JUMP SDK into an existing Xcode project.

## Get the Library

If you haven't already, clone the JUMP for iOS library from GitHub: `git clone git://github.com/janrain/jump.ios.git`

**Important**: If you are upgrading from an earlier version of the library, see the `Upgrade Guide.md`.

## Add the Library to Your Xcode Project

1. Open your project in Xcode.
2. Make sure that the **Project Navigator** pane is showing. (**View > Navigators > Show Project Navigator**)
3. Open the **Finder** and navigate to the location where you cloned the repository. Drag the **Janrain**
   folder into your Xcode project’s **Project Navigator** pane, and drop it below the root project node.

   **Warning**: Do not drag the `jump.ios` folder into your project, drag the `Janrain` folder in.
4. In the dialog, do **not** check the **Copy items into destination group’s folder (if needed)** box. Ensure that the
   **Create groups for any added folders** radio button is selected, and that the **Add to targets** check box is
   selected for your application’s targets.
5. Click **Finish**.
6. **Warning**: If you are doing a social-sign-in-only (i.e. Engage-only) integration, you must now remove the
   JRCapture project group from the Janrain project group.
7. You must also add the **Security** framework, **QuartzCore** framework, and the **MessageUI** framework to your
   project. As the **MessageUI** framework is not available on all iOS devices and versions, you must designate the
   framework as "optional." As of JUMP iOS v4.0 you must also add the **Accounts** framework and the **Social**
   framework.
8. Ensure that your deployment target is at least iOS 7.0 and not higher than iOS 8.4 (This is required as of JUMP iOS v4.0) In order to maintain the broadest range of iOS version compatibility the SDK still implements some features that are deprecated in iOS 9.0 and higher.  Setting a deployment target of iOS9 or higher will prevent the SDK from successful compilation.

### Frameworks:

* Security - This framework is used to store session tokens in the devices security framework so that they are stored
  securely.
* QuartCore - This framework is used for animations when running on the iPad.
* MessageUI - This framework is used to integrate with the iOS device's native SMS and email capabilities, to allow
  your end-user's to share your content via email or SMS.

### Localization

The JUMP SDK uses NSLocalizedString for all user-facing strings. String values are loaded from the ios_internal/Janrain/JREngage/Resources/en.lproj folder in the Localizable.strings file. Only English strings are provided in the SDK.  You can, however, provide your own translations:

1. Create a folder in the ios_internal/Janrain/JREngage/Resources/ folder named for the language you are localizing to (for instance, for a French translation create fr.lproj) and in that folder add a new file named 'Localizable.strings'.
2. Copy the contents of ios_internal/Janrain/JREngage/Resources/en.lproj/Localizable.strings to your newly created fr.lproj/Localizable.strings file.
3. Strings are formatted as "key":"value" pairs where the key is always the english version of the string and the value is the localized translation. For your French strings file, translate each "value", but do not edit the "key".
4. Don't forget to add the file to the project.

.nib, .xib, and .storyboard files can also be localized. However, there is only one such file in the JUMP SDK that is localizable: JRPublishActivityController.xib. To localize this file in your own project use XCode's "Use Base Internationalization" feature to select this file and the target language.  The output of this operation is a copy of JRPublishActivityController.xib in a subfolder of ./JREngage/Resources/xibs/ named with the language code of the target language.

For a list of language codes, see http://xml.coverpages.org/iso639a.html or buy the ISO standard at http://www.iso.org/iso/catalogue_detail.htm?csnumber=4766.

## Generating the Capture User Model

**Warning**: If you are integrating with social-sign-in-only (i.e. Engage-only), or integrating via the Phonegap
plugin, you do not generate the Capture user model. Instead, follow `Engage-Only Integration Guide.md`.

You will need the [JSON](http://search.cpan.org/~makamaka/JSON-2.53/lib/JSON.pm (version 2.53 or above) perl module. To
install the perl JSON module:

1. Make sure that perl is installed on your system. If it is not, consider using MacPorts or Homebrew to install perl.
2. With Perl installed, install cpanm: *sudo cpan App::cpanminus*
3. Install the JSON perl module by running: *sudo cpanm  --with-recommends JSON*

Once you have the perl JSON module installed you will run the schema parsing perl script to generate the Capture user
model:

1. Go to the Capture dashboard, and sign-in. (https://janraincapture.com)
2. Use the **App** drop-down menu to select your Capture app.
3. Select the **Schema** tab.
4. Use the Entity Types drop-down menu to select the correct schema. Wait for the page to reload. (If you are already
   on the correct schema, the page will not reload.)
5. Click **Download schema**.

With the schema downloaded, generate the user model:

1. Change into the script directory: `$ cd jump.ios/Janrain/JRCapture/Script`
   **Warning** `CaptureSchemaParser.pl` must be executed while from its directory.
2. Run the `CaptureSchemaParser.pl` script, passing in your Capture schema as an argument with the `-f` flag, and the
   path to your Xcode project with the `-o` flag:

   `$ ./CaptureSchemaParser.pl -f PATH_TO_YOUR_SCHEMA.JSON -o PATH_TO_YOUR_XCODE_PROJECT_DIRECTORY`

The script writes its output to:

`PATH_TO_YOUR_XCODE_PROJECT_DIRECTORY/JRCapture/Generated/`

## Adding the Generated Capture User Model

Once generated, the user model must be added to your Xcode project:

1. Choose **File** > **Add Files to "Project Name"...** then select the folder containing the generated user
   model.
2. Click **Add**.
3. Make sure that your project builds.

## Working with ARC

As of v3.7.0 the JUMP iOS SDK uses ARC for object memory management.


## Upgrading from an Earlier Version of the JUMP SDK

To update the library references in Xcode, remove the JREngage group and re-add it.

1. Open your project in Xcode.
2. In the **Project Navigator** pane locate the **JREngage** folder (group) of your Xcode project.
3. Right-click the **JREngage** project group and click **Delete** from the context menu.
4. Do the same for the **Janrain** project group.
5. In the dialog, make sure you select the **Remove References** button.
6. Re-add the project groups, following the instructions in this guide.

### Next

If you are integrating the JUMP platform (which includes Engage and Capture), see `JUMP Integration Guide.md`.

If you are doing an social-sign-in-only integration (i.e. an Engage-only integration,) see
`Engage-Only Integration Guide.md`.
