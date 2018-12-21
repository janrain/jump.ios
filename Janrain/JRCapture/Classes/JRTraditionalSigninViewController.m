/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2010, Janrain, Inc.

 All rights reserved.

 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:

 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation and/or
   other materials provided with the distribution.
 * Neither the name of the Janrain, Inc. nor the names of its
   contributors may be used to endorse or promote products derived from this
   software without specific prior written permission.


 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 File:   EmbeddedNativeSignInViewController.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Tuesday, June 1, 2010
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "debug_log.h"
#import "JRCaptureApidInterface.h"
#import "JRTraditionalSigninViewController.h"
#import "JREngage.h"
#import "JREngageWrapper.h"
#import "JRUserInterfaceMaestro.h"
#import "JRCaptureData.h"
#import "JRCapture.h"
#import "JRCaptureFlow.h"
#import "UIAlertController+JRAlertController.h"

@interface JREngageWrapper (JREngageWrapper_InternalMethods)
- (void)authenticationDidReachTokenUrl:(NSString *)tokenUrl withResponse:(NSURLResponse *)response
                            andPayload:(NSData *)tokenUrlPayload forProvider:(NSString *)provider;
@end

@interface JRTraditionalSignInViewController () <JRCaptureInternalDelegate,  JRCaptureDelegate>
@property  NSString *titleString;
@property  UIView   *titleView;
@property JRTraditionalSignInType signInType;
@property  JREngageWrapper *wrapper;
@end

@implementation JRTraditionalSignInViewController
@synthesize signInType;
@synthesize titleString;
@synthesize titleView;
@synthesize wrapper;
@synthesize delegate;
@synthesize firstResponder;

- (id)initWithTraditionalSignInType:(JRTraditionalSignInType)theSignInType titleString:(NSString *)theTitleString
                          titleView:(UIView *)theTitleView
                      engageWrapper:(JREngageWrapper *)theWrapper
{
    if ((self = [super init]))
    {
        signInType = theSignInType;
        titleString = theTitleString;
        titleView = theTitleView;
        wrapper = theWrapper;
    }

    return self;
}

+ (id)traditionalSignInViewController:(JRTraditionalSignInType)theSignInType titleString:(NSString *)theTitleString
                            titleView:(UIView *)theTitleView engageWrapper:(JREngageWrapper *)theWrapper
{
    return [[JRTraditionalSignInViewController alloc]
            initWithTraditionalSignInType:theSignInType
                              titleString:theTitleString
                                titleView:theTitleView engageWrapper:theWrapper];
}

- (void)loadView
{
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 170) style:UITableViewStyleGrouped];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.scrollEnabled   = NO;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];

    [button setFrame:CGRectMake(10, 2, 300, 40)];
    [button setBackgroundImage:[UIImage imageNamed:@"button_janrain_280x40.png"]
                      forState:UIControlStateNormal];

    [button setTitle:NSLocalizedString(@"Sign In", nil) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];

    button.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];

    [button addTarget:self
               action:@selector(signInButtonTouchUpInside:)
     forControlEvents:UIControlEventTouchUpInside];

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [footerView addSubview:button];

    myTableView.tableFooterView = footerView;
    myTableView.dataSource = self;
    myTableView.delegate = self;

    self.view = myTableView;

    [self.view setClipsToBounds:NO];

//    [self createLoadingView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [myTableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.titleView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.titleString;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (titleView)
        return titleView.frame.size.height;

    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        return 40;
    } else {
        return 25;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

#define  NAME_TEXTFIELD_TAG 1000
#define  PWD_TEXTFIELD_TAG 2000

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    UITextField *textField;

    NSString *const cellId = indexPath.row == 0 ? @"cellForName" : @"cellForPwd";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];

        textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 7, 280, 26)];

        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;

        [cell.contentView addSubview:textField];

        if (indexPath.row == 0)
        {
            NSString *const placedHolder = self.signInType == JRTraditionalSignInEmailPassword ?
                    NSLocalizedString(@"Enter your email", nil) :
                    NSLocalizedString(@"Enter your username", nil);
            textField.placeholder = placedHolder;
            textField.delegate = self;
            textField.tag = NAME_TEXTFIELD_TAG;
        }
        else
        {
            textField.placeholder = NSLocalizedString(@"Enter your password", nil);
            textField.secureTextEntry = YES;

            textField.delegate = self;
            textField.tag = PWD_TEXTFIELD_TAG;
        }
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.firstResponder = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.firstResponder = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)signInButtonTouchUpInside:(UIButton*)button
{
    UITableViewCell *nameCell = [myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITableViewCell *pwdCell  = [myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *user = ((UITextField *) [nameCell viewWithTag:NAME_TEXTFIELD_TAG]).text;
    NSString *password = ((UITextField *) [pwdCell viewWithTag:PWD_TEXTFIELD_TAG]).text;
    if (!user) user = @"";
    if (!password) password = @"";

    NSDictionary *credentials = [NSDictionary
            dictionaryWithObjectsAndKeys:user,
                    @"user", password, @"password", nil];

    [JRCaptureApidInterface signInCaptureUserWithCredentials:credentials forDelegate:self withContext:nil];

    [self.firstResponder resignFirstResponder];
    [self setFirstResponder:nil];

    [delegate showLoading];
}

- (void)signInCaptureUserDidSucceedWithResult:(NSString *)result context:(NSObject *)context
{
    [delegate hideLoading];

    [wrapper authenticationDidReachTokenUrl:@"/oath/auth_native_traditional" withResponse:nil
                                 andPayload:[result dataUsingEncoding:NSUTF8StringEncoding] forProvider:nil];

    [delegate authenticationDidComplete];
}

- (void)signInCaptureUserDidFailWithResult:(NSError *)error context:(NSObject *)context
{
    DLog(@"error: %@", [error description]);
    NSString const *type = self.signInType == JRTraditionalSignInEmailPassword ?
            NSLocalizedString(@"Email", nil) :
            NSLocalizedString(@"Username", nil);
    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"Incorrect %@ or Password", nil), type];
    //NSString *const message = [result objectForKey:@"error"];

    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Dismiss", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *forgotPasswordAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Forgot Password", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showForgottenPasswordAlert];
    }];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil alertActions:dismissAction, forgotPasswordAction, nil];
    [self presentViewController:alertController animated:YES completion:nil];

    [delegate hideLoading];
    // XXX hack to skirt the side effects thrown off by the client's sign-in APIs:
    [JREngage updateTokenUrl:[JRCaptureData captureTokenUrlWithMergeToken:nil delegate:self]];
}

- (void)showForgottenPasswordAlert
{
    __weak __block UIAlertController *alertController;

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];

    UIAlertAction *sendAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Send", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *nameOrEmailtextField = alertController.textFields.firstObject;
        [self.delegate showLoading];
        [JRCapture startForgottenPasswordRecoveryForField:nameOrEmailtextField.text
                                                 delegate:self];

    }];

    alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Confirm Your Email Address", nil)
                                                                             message:NSLocalizedString(@"We'll send you a link to create a new password.", nil)
                                                                        alertActions:cancelAction, sendAction, nil];
    [self addTexFieldConfigurationForAlertController:alertController];

    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)addTexFieldConfigurationForAlertController:(UIAlertController *)alertController {
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        UITableViewCell *nameCell = [self->myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSString *nameOrEmail = ((UITextField *) [nameCell viewWithTag:NAME_TEXTFIELD_TAG]).text;

        if (nameOrEmail && ![nameOrEmail isEqualToString:@""]) {
            textField.text = nameOrEmail;
        } else {
            JRCaptureData *data = [JRCaptureData sharedCaptureData];
            NSString *fieldName = [data getForgottenPasswordFieldName];
            NSDictionary *field = [[data.captureFlow objectForKey:@"fields"] objectForKey:fieldName];
            NSString *placeholder = [field objectForKey:@"placeholder"];
            if (!placeholder)
            {
                placeholder = (self.signInType == JRTraditionalSignInEmailPassword) ?
                NSLocalizedString(@"Enter your email", nil) :
                NSLocalizedString(@"Enter your username", nil);
            }
            textField.placeholder = placeholder;
        }
    }];

}

- (void)forgottenPasswordRecoveryDidSucceed
{
    [delegate hideLoading];

    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Dismiss", nil) style:UIAlertActionStyleDefault handler:nil];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Reset Password email Sent", nil)
                                                                            message:@""
                                                                        alertActions:dismissAction, nil];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)forgottenPasswordRecoveryDidFailWithError:(NSError *)error
{
    [delegate hideLoading];
    NSString *errorMessage;

    NSDictionary *msg = [error.userInfo objectForKey:@"invalid_fields"];
    if (msg)
    {
        // The form name comes from config data, which is store by JRCaptureData
        NSString *formName = [[JRCaptureData sharedCaptureData] captureForgottenPasswordFormName];
        if (formName)
        {
            NSArray *form = [msg objectForKey:formName];
            if (form && form.count)
            {
                // use the first invalid field.
                errorMessage = form[0];
            }
        }
    }
    if (!errorMessage)
    {
        errorMessage = [error.userInfo objectForKey:NSLocalizedFailureReasonErrorKey];
    }

    if ([errorMessage length] > 0)
    {
        DLog(@"Forgot Password Recovery error: %@", errorMessage);
    }

    // read the localized error string from JRCaptureError.
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Dismiss", nil) style:UIAlertActionStyleDefault handler:nil];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Could Not Reset Password", nil)
                                                                             message:@""
                                                                        alertActions:dismissAction, nil];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([super respondsToSelector:aSelector]) {
        return YES;
    } else if (@selector(captureDidSucceedWithCode:) == aSelector) {
        return [[JREngageWrapper getDelegate] respondsToSelector:aSelector];
    }
    return NO;
}

- (void)dealloc
{
}
@end

