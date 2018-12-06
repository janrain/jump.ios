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

 File:   JRUserLandingController.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Tuesday, June 1, 2010
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "JRUserLandingController.h"
#import "JREngage+CustomInterface.h"
#import "JREngageError.h"
#import "JRUserInterfaceMaestro.h"
#import "JRWebViewController.h"
#import "debug_log.h"
#import "JRCompatibilityUtils.h"
#import "UIAlertController+JRAlertController.h"

#define frame_w(a) a.frame.size.width
#define frame_h(a) a.frame.size.height

@interface JRUserLandingController ()

@end

@implementation JRUserLandingController
@synthesize myBackgroundView;
@synthesize myTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
   andCustomInterface:(NSDictionary *)theCustomInterface
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        sessionData = [JRSessionData jrSessionData];
        customInterface = theCustomInterface;

        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            iPad = YES;
        else
            iPad = NO;
    }

    return self;
}

- (void)viewDidLoad
{
    DLog(@"");
    [super viewDidLoad];

    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }

    myTableView.backgroundColor = [UIColor clearColor];

    /* If there is a UIColor object set for the background color, use this */
    if ([customInterface objectForKey:kJRAuthenticationBackgroundColor])
        myBackgroundView.backgroundColor = [customInterface objectForKey:kJRAuthenticationBackgroundColor];

    /* Weird hack necessary on the iPad, as the iPad table views have some background view that is always gray */
    if ([myTableView respondsToSelector:@selector(setBackgroundView:)])
        [myTableView setBackgroundView:nil];

    if (!infoBar)
    {
        infoBar = [[JRInfoBar alloc] initWithFrame:CGRectMake(0, frame_h(self.view) - 30, frame_w(self.view), 30)
                                          andStyle:((JRInfoBarStyle) [sessionData hidePoweredBy])];

        [self.view addSubview:infoBar];
    }

    if (!self.navigationController.navigationBar.backItem)
    {
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                     target:sessionData
                                     action:@selector(triggerAuthenticationDidCancel:)];

        self.navigationItem.rightBarButtonItem = cancelButton;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStylePlain;
    }
    else
    {
        self.navigationItem.backBarButtonItem.target = sessionData;
        self.navigationItem.backBarButtonItem.action = @selector(triggerAuthenticationDidStartOver:);
    }
}

- (NSString *)customTitle
{
    DLog(@"");
    if (!sessionData.currentProvider.requiresInput) return NSLocalizedString(@"Welcome Back!", nil);

    return sessionData.currentProvider.shortText;
}

- (void)viewWillAppear:(BOOL)animated
{
    DLog(@"");
    [super viewWillAppear:animated];

    /* Load the custom background view, if there is one. */
    if ([customInterface objectForKey:kJRAuthenticationBackgroundImageView])
        [myBackgroundView addSubview:[customInterface objectForKey:kJRAuthenticationBackgroundImageView]];

    if (!sessionData.currentProvider)
    {
        NSString *message = @"There was an error authenticating with the selected provider.";
        NSError *error = [JREngageError errorWithMessage:message andCode:JRAuthenticationFailedError];
        [sessionData triggerAuthenticationDidFailWithError:error];

        return;
    }

    self.title = [self customTitle];

    if (titleView) {
        titleView.text = [NSString stringWithString:sessionData.currentProvider.friendlyName];
        self.navigationItem.titleView = titleView;
    } else {
        self.navigationItem.title = [NSString stringWithString:sessionData.currentProvider.friendlyName];
    }

    [myTableView reloadData];
    [self adjustTableViewFrame:self.view.frame.size];
}

- (void)viewDidAppear:(BOOL)animated
{
    DLog(@"");
    [super viewDidAppear:animated];

    [self jrSetContentSizeForViewInPopover:self.view.frame.size];

    UITableViewCell *cell = [self getTableCell];
    UITextField *textField = [self getTextField:cell];

    // Only make the cell's text field the first responder (and show the keyboard) in certain situations
    if ([sessionData weShouldBeFirstResponder] && !textField.text)
        [textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    DLog(@"");
    [super viewWillDisappear:animated];
}

#pragma mark Table view methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

enum
{
    LOGO_TAG = 1,
    WELCOME_LABEL_TAG,
    TEXT_FIELD_TAG,
    SIGN_IN_BUTTON_TAG,
    BACK_TO_PROVIDERS_BUTTON_TAG,
    BIG_SIGN_IN_BUTTON_TAG,
    PROVIDER_NAME_LABEL_TAG,
    FIRST_SUBVIEW_TAG,
};

/*
 * The following definitions are used to place subviews in the UITableViewCell.
 * Positioning within a cell is absolute. Positioning of the subviews is dynamic
 */
//                                      X       Y       Width   Height

#define CELL_FRAME                      10,     0,      300,    180

//      FIRST SUBVIEW - logo + provider name
#define FIRST_SUBVIEW_FRAME             10,     10,     280,    30
#define LOGO_FRAME                      0,      0,       30,    30
#define PROVIDERNAME_LABEL_FRAME        40,     0,      150,    30

//      SECOND SUBVIEW - welcome + optional text box
#define SECOND_SUBVIEW_FRAME            10,     75,     280,    25
#define WELCOME_LABEL_FRAME             0,      0,      280,    25
#define TEXT_FIELD_FRAME                0,      0,      280,    25

//      THIRD SUBVIEW - buttons
#define THIRD_SUBVIEW_FRAME             10,     125,    280,    40
#define BIG_SIGN_IN_BUTTON_FRAME        0,      0,      280,    40
#define BACK_TO_PROVIDERS_BUTTON_FRAME  0,      0,      135,    40
#define SMALL_SIGN_IN_BUTTON_FRAME      145,    0,      135,    40

- (UITableViewCell *)getTableCell
{
    return [myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (UIImageView *)getLogo:(UITableViewCell *)cell
{
    if (cell)
        return (UIImageView *) [cell.contentView viewWithTag:LOGO_TAG];

    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(LOGO_FRAME)];

    logo.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
            UIViewAutoresizingFlexibleLeftMargin;

    logo.tag = LOGO_TAG;

    return logo;
}

- (UILabel *)getProviderNameLabel:(UITableViewCell *)cell
{
    if (cell)
    {
        return (UILabel *) [cell.contentView viewWithTag:PROVIDER_NAME_LABEL_TAG];
    }

    UILabel *providerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(PROVIDERNAME_LABEL_FRAME)];

    providerNameLabel.font = [UIFont boldSystemFontOfSize:24.0];

    providerNameLabel.adjustsFontSizeToFitWidth = YES;
    providerNameLabel.textColor = [UIColor blackColor];
    providerNameLabel.backgroundColor = [UIColor clearColor];
    providerNameLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
            UIViewAutoresizingFlexibleLeftMargin;

    providerNameLabel.tag = PROVIDER_NAME_LABEL_TAG;

    NSString *providerName = [sessionData currentProvider].friendlyName;
    NSString *nameWithCapital = [NSString stringWithFormat:@"%@%@",
            [[providerName substringToIndex:1] capitalizedString],
            [providerName substringFromIndex:1]];
    providerNameLabel.text = nameWithCapital;
    [providerNameLabel sizeToFit];
    CGRect rect = CGRectMake(PROVIDERNAME_LABEL_FRAME);
    CGRect newRect = CGRectMake(rect.origin.x, rect.origin.y, [providerNameLabel frame].size.width, rect.size.height);
    [providerNameLabel setFrame:newRect];

    return providerNameLabel;
}

- (UILabel *)getWelcomeLabel:(UITableViewCell *)cell
{
    if (cell)
        return (UILabel *) [cell.contentView viewWithTag:WELCOME_LABEL_TAG];

    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(WELCOME_LABEL_FRAME)];

    welcomeLabel.font = [UIFont boldSystemFontOfSize:20.0];

    welcomeLabel.adjustsFontSizeToFitWidth = YES;
    welcomeLabel.textColor = [UIColor blackColor];
    welcomeLabel.backgroundColor = [UIColor clearColor];
    welcomeLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
            UIViewAutoresizingFlexibleLeftMargin;

    welcomeLabel.tag = WELCOME_LABEL_TAG;

    welcomeLabel.text = [sessionData authenticatedUserForProvider:sessionData.currentProvider].welcomeString;
    [welcomeLabel setTextAlignment:NSTextAlignmentCenter];

    return welcomeLabel;
}

- (UITextField *)getTextField:(UITableViewCell *)cell
{
    if (cell)
        return (UITextField *) [cell.contentView viewWithTag:TEXT_FIELD_TAG];

    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(TEXT_FIELD_FRAME)];

    textField.font = [UIFont systemFontOfSize:15.0];

    textField.adjustsFontSizeToFitWidth = YES;
    textField.textColor = [UIColor blackColor];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.clearsOnBeginEditing = YES;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.keyboardType = UIKeyboardTypeURL;
    textField.returnKeyType = UIReturnKeyDone;
    textField.enablesReturnKeyAutomatically = YES;
    textField.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
            UIViewAutoresizingFlexibleLeftMargin;

    textField.delegate = self;
    textField.tag = TEXT_FIELD_TAG;

    [textField setHidden:YES];

    return textField;
}

- (UIButton *)getSignInButton:(UITableViewCell *)cell
{
    if (cell)
        return (UIButton *) [cell.contentView viewWithTag:SIGN_IN_BUTTON_TAG];

    UIButton *signInButton = [UIButton buttonWithType:UIButtonTypeCustom];

    [signInButton setFrame:CGRectMake(SMALL_SIGN_IN_BUTTON_FRAME)];
    [signInButton setBackgroundImage:[UIImage imageNamed:@"button_iosblue_135x40.png"]
                            forState:UIControlStateNormal];

    [signInButton setTitle:NSLocalizedString(@"Sign In", nil) forState:UIControlStateNormal];
    [signInButton setTitleColor:[UIColor whiteColor]
                       forState:UIControlStateNormal];
    [signInButton setTitleShadowColor:[UIColor grayColor]
                             forState:UIControlStateNormal];

    [signInButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];

    [signInButton addTarget:self
                     action:@selector(signInButtonTouchUpInside:)
           forControlEvents:UIControlEventTouchUpInside];

    signInButton.tag = SIGN_IN_BUTTON_TAG;

    return signInButton;
}

- (UIButton *)getBackToProvidersButton:(UITableViewCell *)cell
{
    if (cell)
        return (UIButton *) [cell.contentView viewWithTag:BACK_TO_PROVIDERS_BUTTON_TAG];

    UIButton *backToProvidersButton = [UIButton buttonWithType:UIButtonTypeCustom];

    [backToProvidersButton setFrame:CGRectMake(BACK_TO_PROVIDERS_BUTTON_FRAME)];
    [backToProvidersButton setBackgroundImage:[UIImage imageNamed:@"button_black_135x40.png"]
                                     forState:UIControlStateNormal];

    [backToProvidersButton setTitle:NSLocalizedString(@"Switch Accounts", nil) forState:UIControlStateNormal];
    [backToProvidersButton setTitleColor:[UIColor whiteColor]
                                forState:UIControlStateNormal];
    [backToProvidersButton setTitleShadowColor:[UIColor grayColor]
                                      forState:UIControlStateNormal];

    [backToProvidersButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];

    [backToProvidersButton addTarget:self
                              action:@selector(backToProvidersTouchUpInside)
                    forControlEvents:UIControlEventTouchUpInside];

    backToProvidersButton.tag = BACK_TO_PROVIDERS_BUTTON_TAG;

    return backToProvidersButton;
}

- (UIButton *)getBigSignInButton:(UITableViewCell *)cell
{
    if (cell)
        return (UIButton *) [cell.contentView viewWithTag:BIG_SIGN_IN_BUTTON_TAG];

    UIButton *bigSignInButton = [UIButton buttonWithType:UIButtonTypeCustom];

    [bigSignInButton setFrame:CGRectMake(BIG_SIGN_IN_BUTTON_FRAME)];
    [bigSignInButton setBackgroundImage:[UIImage imageNamed:@"button_iosblue_280x40.png"]
                               forState:UIControlStateNormal];

    [bigSignInButton setTitle:NSLocalizedString(@"Sign In", nil) forState:UIControlStateNormal];
    [bigSignInButton setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
    [bigSignInButton setTitleShadowColor:[UIColor grayColor]
                                forState:UIControlStateNormal];

    [bigSignInButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];

    [bigSignInButton addTarget:self
                        action:@selector(signInButtonTouchUpInside:)
              forControlEvents:UIControlEventTouchUpInside];

    [bigSignInButton setHidden:YES];

    bigSignInButton.tag = BIG_SIGN_IN_BUTTON_TAG;
    return bigSignInButton;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"");

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cachedCell"];

    /*
     * The size of providerNameLabel changes depending on the text to be displayed.
     * Therefore, we trash the cell and re-create it each time it is displayed. Okay
     * for a table with one cell.
     */
    if (cell)
    {
        [cell removeFromSuperview];
    }
    cell = [[UITableViewCell alloc]
            initWithStyle:UITableViewCellStyleDefault
          reuseIdentifier:@"cachedCell"];

    CGRect cellFrameRect = CGRectMake(CELL_FRAME);
    [cell.contentView setFrame:cellFrameRect];

    // pass nil the first time to alloc the views
    UIImageView *logo = [self getLogo:nil];
    UILabel *label = [self getProviderNameLabel:nil];

    // Set the size of the frame
    CGRect subViewFrameRect = CGRectMake(FIRST_SUBVIEW_FRAME);
    int width = logo.frame.size.width + label.frame.size.width;
    if (width > cell.frame.size.width)
    {
        width = cell.frame.size.width - 10;
    }

    CGRect newSubViewFrameRect = CGRectMake(
            CGRectGetMidX(cellFrameRect) - width/2 - 15,
            subViewFrameRect.origin.y,
            width,
            subViewFrameRect.size.height);

    // Add first SubView
    UIView *firstSubView = [[UIView alloc] initWithFrame:newSubViewFrameRect];
    [firstSubView setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin |
            UIViewAutoresizingFlexibleLeftMargin];

    [firstSubView addSubview:logo];
    [firstSubView addSubview:label];

    [firstSubView setTag:FIRST_SUBVIEW_TAG];
    [cell.contentView addSubview:firstSubView];

    // Second SubView will be placed below the first
    UIView *secondSubView = [[UIView alloc] initWithFrame:CGRectMake(SECOND_SUBVIEW_FRAME)];
    [secondSubView setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin |
            UIViewAutoresizingFlexibleLeftMargin];
    [secondSubView addSubview:[self getWelcomeLabel:nil]];
    [secondSubView addSubview:[self getTextField:nil]];
    [cell.contentView addSubview:secondSubView];

    // Third SubView will be placed below the second
    UIView *thirdSubView = [[UIView alloc] initWithFrame:CGRectMake(THIRD_SUBVIEW_FRAME)];
    [thirdSubView setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin |
            UIViewAutoresizingFlexibleLeftMargin];
    [thirdSubView addSubview:[self getSignInButton:nil]];
    [thirdSubView addSubview:[self getBackToProvidersButton:nil]];
    [thirdSubView addSubview:[self getBigSignInButton:nil]];
    [cell.contentView addSubview:thirdSubView];

    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSString *imagePath = [NSString stringWithFormat:@"icon_%@_30x30.png",
                    sessionData.currentProvider.name];
    [self getLogo:cell].image = [UIImage imageNamed:imagePath];

    /* If the provider requires input, we need to enable the textField, and set the text/placeholder text to the
    appropriate string */
    if (sessionData.currentProvider.requiresInput)
    {
        DLog(@"current provider requires input");

        if (sessionData.currentProvider.userInput)
        {
            [[self getTextField:cell] resignFirstResponder];
            [[self getTextField:cell] setText:[NSString stringWithString:sessionData.currentProvider.userInput]];
        }
        else
        {
            [[self getTextField:cell] setText:nil];
        }

        [self getTextField:cell].placeholder = [NSString stringWithString:sessionData.currentProvider.placeholderText];

        [[self getTextField:cell] setHidden:NO];
        [[self getTextField:cell] setEnabled:YES];
        [[self getWelcomeLabel:cell] setHidden:YES];
        [[self getBigSignInButton:cell] setHidden:NO];
    }
    else
    {
        /* If the provider doesn't require input, then we are here because this is the return experience screen and
        only for basic providers */
        DLog(@"current provider does not require input");

        [[self getTextField:cell] setHidden:YES];
        [[self getTextField:cell] setEnabled:NO];
        [[self getWelcomeLabel:cell] setHidden:NO];
        [[self getProviderNameLabel:cell] setHidden:NO];
        [[self getBigSignInButton:cell] setHidden:YES];
    }

    return cell;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    BOOL b;
    if ([JRUserInterfaceMaestro sharedMaestro].canRotate)
        b = interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    else
        b = interfaceOrientation == UIInterfaceOrientationPortrait;
    DLog(@"%d", b);
    return b;
}

#define TABLE_VIEW_FRAME_LANDSCAPE_SMALL    0,  0,  self.view.frame.size.width,  120
#define TABLE_VIEW_FRAME_LANDSCAPE_BIG      0,  0,  self.view.frame.size.width,  268
// TABLE_VIEW_FRAME_PORTRAIT seems OK on 4" iPhone despite screen specific 416px spec
#define TABLE_VIEW_FRAME_PORTRAIT           0,  0,  self.view.frame.size.width,  416

- (void)shrinkTableViewLandscape
{
    [myTableView setFrame:CGRectMake(TABLE_VIEW_FRAME_LANDSCAPE_SMALL)];
    [myTableView scrollRectToVisible:CGRectMake(THIRD_SUBVIEW_FRAME) animated:YES];
}

- (void)growTableViewLandscape
{
    [myTableView setFrame:CGRectMake(TABLE_VIEW_FRAME_LANDSCAPE_BIG)];
}

- (void)growTableViewPortrait
{
    [myTableView setFrame:CGRectMake(TABLE_VIEW_FRAME_PORTRAIT)];
}

- (void)adjustTableViewFrame:(CGSize)size
{
    if (size.width > size.height && !iPad)
    {
        if ([[self getTextField:[self getTableCell]] isFirstResponder])
            [self shrinkTableViewLandscape];
        else
            [self growTableViewLandscape];
    }
    else
    {
        
        [self growTableViewPortrait];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self adjustTableViewFrame:self.view.frame.size];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    DLog(@"");
    [self callWebView:textField];

    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    DLog(@"");
    [self adjustTableViewFrame:self.view.frame.size];
}

- (void)callWebView:(UITextField *)textField
{
    DLog(@"");
    DLog(@"user input: %@", textField.text);
    [self startWebViewAuthentication:textField];
}

- (void)startWebViewAuthentication:(UITextField *)textField {
    if (sessionData.currentProvider.requiresInput)
    {
        if (textField.text.length > 0)
        {
            [textField resignFirstResponder];
            [self adjustTableViewFrame:self.view.frame.size];

            sessionData.currentProvider.userInput = [NSString stringWithString:textField.text];
        }
        else
        {
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Invalid Input", nil) message:NSLocalizedString(@"The input you have entered is not valid. Please try again.", nil) alertActions:okAction, nil];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
    }

    [[JRUserInterfaceMaestro sharedMaestro] pushWebViewFromViewController:self];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    DLog(@"");
    [textField resignFirstResponder];
    [self adjustTableViewFrame:self.view.frame.size];
}

- (void)backToProvidersTouchUpInside
{
    DLog(@"");

    /* This should work, because this button will only be visible during the return experience of a basic provider */
    [sessionData forgetAuthenticatedUserForProvider:sessionData.currentProvider.name];

    [sessionData setCurrentProvider:nil];
    [sessionData clearReturningAuthenticationProvider];

    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)signInButtonTouchUpInside:(UIButton *)button
{
    DLog(@"");
    [self callWebView:[self getTextField:[self getTableCell]]];
}

- (void)userInterfaceWillClose
{
}

- (void)userInterfaceDidClose
{
}

- (void)dealloc
{
    DLog(@"");
}
@end
