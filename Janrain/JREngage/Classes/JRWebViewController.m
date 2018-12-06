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

 File:   JRWebViewController.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Tuesday, June 1, 2010
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "debug_log.h"
#import "JRWebViewController.h"
#import "JRInfoBar.h"
#import "JREngageError.h"
#import "JRUserInterfaceMaestro.h"
#import "JRJsonUtils.h"
#import "JRCompatibilityUtils.h"
#import "UIAlertController+JRAlertController.h"


@interface JRWebViewController ()
- (void)loadUrlInWebView:(NSURL *)url;
@end

@implementation JRWebViewController
{
    JRSessionData *sessionData;
    NSDictionary *customInterface;

    UIView *myBackgroundView;
    //WKWebView *myBackgroundView;
    UIWebView *myWebView;
    //WKWebView *myWebView;

    JRInfoBar *infoBar;

    BOOL keepProgress;
    BOOL userHitTheBackButton;
}

@synthesize myBackgroundView;
@synthesize myWebView;
@synthesize originalCustomUserAgent;

#pragma mark UIView overrides

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
   andCustomInterface:(NSDictionary *)theCustomInterface
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        sessionData = [JRSessionData jrSessionData];
        customInterface = theCustomInterface;
    }

    return self;
}

- (void)viewDidLoad
{
    DLog(@"");
    [super viewDidLoad];

    myWebView.backgroundColor = [UIColor clearColor];

    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }

    self.navigationItem.backBarButtonItem.target = sessionData;
    self.navigationItem.backBarButtonItem.action = @selector(triggerAuthenticationDidStartOver:);
}

- (void)viewWillAppear:(BOOL)animated
{
    DLog(@"");
    [super viewWillAppear:animated];
    [self jrSetContentSizeForViewInPopover:self.view.frame.size];

    self.title = (sessionData.currentProvider) ? sessionData.currentProvider.friendlyName : NSLocalizedString(@"Loading", nil);

    if (!infoBar)
    {
        CGRect infoFrame = CGRectMake(0, self.view.frame.size.height - 30, self.view.frame.size.width, 30);
        infoBar = [[JRInfoBar alloc] initWithFrame:infoFrame andStyle:(JRInfoBarStyle) [sessionData hidePoweredBy]];

        if ([sessionData hidePoweredBy] == JRInfoBarStyleShowPoweredBy)
            [myWebView setFrame:CGRectMake(myWebView.frame.origin.x,
                    myWebView.frame.origin.y,
                    myWebView.frame.size.width,
                    myWebView.frame.size.height - infoBar.frame.size.height)];

        [self.view addSubview:infoBar];
    }
}
/*
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    [self dismissViewControllerAnimated:true completion:nil];
}
*/
+ (NSString *)getCustomUa
{
    NSString *customUa = nil;
    JRSessionData *sessionData = [JRSessionData jrSessionData];
    if (sessionData.currentProvider.customUserAgentString)
    {
        customUa = sessionData.currentProvider.customUserAgentString;
    }
    else if (IS_IPAD && (sessionData.currentProvider.usesPhoneUserAgentString ||
            [sessionData.currentProvider.name isEqualToString:@"facebook"] ||
            [sessionData.currentProvider.name isEqualToString:@"yahoo"]))
    {
        UIWebView *dummy = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        NSString *padUa = [dummy stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        customUa = [padUa stringByReplacingOccurrencesOfString:@"iPad" withString:@"iPhone"
                                                       options:NSCaseInsensitiveSearch
                                                         range:NSMakeRange(0, [padUa length])];
    }
    return customUa;
}

- (void)maybeAddCancelButton
{
    // Add a cancel button if there's no back button
    if (!self.navigationController.navigationBar.backItem && !sessionData.socialSharing)
    {
        UIBarButtonItem *cancelButton =
                [[UIBarButtonItem alloc]
                        initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                             target:self
                                             action:@selector(cancelButtonPressed:)];

        self.navigationItem.rightBarButtonItem = cancelButton;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStylePlain;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self maybeAddCancelButton];

    DLog(@"%@", [myWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"]);
    
    //[myWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id __nullable userAgent, NSError * __nullable error) {
    //DLog(@"%@", userAgent);
        // iOS 8.3
        // Mozilla/5.0 (iPhone; CPU iPhone OS 8_3 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Mobile/12F70
        // iOS 9.0
        // Mozilla/5.0 (iPhone; CPU iPhone OS 9_0 like Mac OS X) AppleWebKit/601.1.32 (KHTML, like Gecko) Mobile/13A4254v
    //}];
    [super viewDidAppear:animated];

    /* We need to figure out if the user canceled authentication by hitting the back button or the cancel button,
       or if it stopped because it failed or completed successfully on its own.  Assume that the user did hit the
       back button until told otherwise. */
    userHitTheBackButton = YES;

    if (!sessionData.currentProvider)
    {
        NSError *error = [JREngageError errorWithMessage:@"There was an error authenticating with the selected provider."
                                                 andCode:JRAuthenticationFailedError];

        [sessionData triggerAuthenticationDidFailWithError:error];

        return;
    }

    [self loadUrlInWebView:[sessionData startUrlForCurrentProvider]];
    [myWebView becomeFirstResponder];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    DLog(@"");
    [myWebView stopLoading];

    [JRConnectionManager stopConnectionsForDelegate:self];
    [self stopProgress];

    // The WebView disappears when authentication completes successfully or fails or if the user cancels by hitting
    // the "back" button or the "cancel" button.  We don't know when a user hits the back button, but we do
    // know when all the other events occur, so we keep track of those events by changing the "userHitTheBackButton"
    // variable to "NO".
    //
    // If the view is disappearing because the user hit the cancel button, we already to send sessionData the
    // triggerAuthenticationDidStartOver event.  What we need to do it send the triggerAuthenticationDidStartOver
    // message if we're popping to the publishActivity controller (i.e., if we're publishing an activity), so that
    // the publishActivity controller gets the message from sessionData, and can hide the grayed-out activity indicator
    // view.
    //
    // If the userHitTheBackButton variable is set to "YES" and we're publishing an activity ([sessionData social] is
    // "YES"),
    // send the triggerAuthenticationDidStartOver message.  Otherwise, hitting the back button should just pop back
    // to the last controller, the providers or userLanding controller (i.e., behave normally)
    if (userHitTheBackButton)
    {
        if ([sessionData socialSharing])
            [sessionData triggerAuthenticationDidStartOver:nil];
        else if ([JRUserInterfaceMaestro sharedMaestro].directProviderName)
            [sessionData triggerAuthenticationDidCancel];
    }

    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    DLog(@"");

    [myWebView loadHTMLString:@"" baseURL:[NSURL URLWithString:@"/"]];

    [super viewDidDisappear:animated];
}

#pragma mark custom implementation

- (void)fixPadWindowSize
{
    DLog(@"");
    if (!IS_IPAD) return;

    if (![sessionData.currentProvider.name isEqualToString:@"google"]) return;

    /* This fixes the UIWebView's display of IDP sign-in pages to make them fit the iPhone sized dialog on the iPad.
     * It's broken up into separate JS injections in case one statement fails (e.g. there is no document element),
     * so that the others execute. */
    
    [myWebView stringByEvaluatingJavaScriptFromString:@""
            "window.innerHeight = 480; window.innerWidth = 320;"
            "document.documentElement.clientWidth = 320; document.documentElement.clientHeight = 480;"
            "document.body.style.minWidth = \"320px\";"
            "document.body.style.width = \"auto\";"
            "document.body.style.minHeight = \"0px\";"
            "document.body.style.height = \"auto\";"
            "document.body.children[0].style.minHeight = \"0px\";"];
     
    /*
    NSString *jsString = @""
    "window.innerHeight = 480; window.innerWidth = 320;"
    "document.documentElement.clientWidth = 320; document.documentElement.clientHeight = 480;"
    "document.body.style.minWidth = \"320px\";"
    "document.body.style.width = \"auto\";"
    "document.body.style.minHeight = \"0px\";"
    "document.body.style.height = \"auto\";"
    "document.body.children[0].style.minHeight = \"0px\";";
    
    [myWebView evaluateJavaScript:jsString completionHandler:^(id __nullable evalResult, NSError * __nullable error) {
        DLog(@"%@", evalResult);
    }];
     */
    NSString *jsString = [NSString stringWithFormat:@""
            "(function(){"
              "var m = document.querySelector('meta[name=viewport]');"
              "if (m === null) { m = document.createElement('meta'); document.head.appendChild(m); }"
              "m.name = 'viewport';"
              "m.content = 'width=%i, height=%i';"
            "})()",
            (int) myWebView.frame.size.width,
            (int) myWebView.frame.size.height];
    [myWebView stringByEvaluatingJavaScriptFromString:jsString];
    /*
    [myWebView evaluateJavaScript:jsString completionHandler:^(id __nullable evalResult, NSError * __nullable error) {
         DLog(@"%@", evalResult);
     }];
     */
}

- (void)cancelButtonPressed:(id)sender
{
    userHitTheBackButton = NO;
    [sessionData triggerAuthenticationDidCancel];
}

- (void)startProgress
{
    ([UIApplication sharedApplication]).networkActivityIndicatorVisible = YES;
    [infoBar startProgress];
}

- (void)stopProgress
{
    if ([JRConnectionManager openConnections] == 0)
    {
        ([UIApplication sharedApplication]).networkActivityIndicatorVisible = NO;
    }

    keepProgress = NO;
    [infoBar stopProgress];
}

#pragma mark JRConnectionManagerDelegate implementation

- (void)connectionDidFinishLoadingWithPayload:(NSString *)payload request:(NSURLRequest *)request andTag:(id)tag
{
    DLog(@"");
    [self stopProgress];

    if ([tag isEqualToString:MEU_CONNECTION_TAG])
    {
        DLog(@"payload: %@", payload);
        DLog(@"tag:     %@", tag);

        NSDictionary *payloadDict = [payload JR_objectFromJSONString];

        NSString *errorMessage = [NSString stringWithFormat:@"Authentication failed: %@", payload];
        if (!payloadDict)
        {
            NSError *error = [JREngageError errorWithMessage:errorMessage andCode:JRAuthenticationFailedError];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK",nil) style:UIAlertActionStyleCancel handler:nil];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Log In Failed", nil)
                                                                                     message:NSLocalizedString(@"An error occurred while attempting to sign you in.  Please try again.", nil)
                                                                                alertActions:okAction, nil];
            [self presentViewController:alertController animated:YES completion:nil];

            userHitTheBackButton = NO; /* Because authentication failed for whatever reason. */
            [sessionData triggerAuthenticationDidFailWithError:error];
        }
        else if ([[[payloadDict objectForKey:@"rpx_result"] objectForKey:@"stat"] isEqualToString:@"ok"])
        {
            userHitTheBackButton = NO; /* Because authentication completed successfully. */
            [sessionData triggerAuthenticationDidCompleteWithPayload:payloadDict];
        }
        else
        {
            if ([[[payloadDict objectForKey:@"rpx_result"] objectForKey:@"error"]
                    isEqualToString:@"Discovery failed for the OpenID you entered"])
            {
                NSString *alertMessage;
                if (sessionData.currentProvider.requiresInput)
                    alertMessage = [NSString stringWithFormat:NSLocalizedString(@"The %@ you entered was not valid. Please try again.", nil),
                        sessionData.currentProvider.shortText];
                else
                    alertMessage = NSLocalizedString(@"There was a problem authenticating with this provider. Please try again.", nil);

                DLog(@"Discovery failed for the OpenID you entered: %@", alertMessage);
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [[self navigationController] popViewControllerAnimated:YES];
                }];
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Invalid Input", nil)
                                                                                         message:alertMessage
                                                                                    alertActions:okAction, nil];
                
                userHitTheBackButton = NO; /* Because authentication failed for whatever reason. */
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else if ([[[payloadDict objectForKey:@"rpx_result"] objectForKey:@"error"]
                    isEqualToString:@"The URL you entered does not appear to be an OpenID"])
            {
                NSString *alertMessage;
                if (sessionData.currentProvider.requiresInput)
                    alertMessage = [NSString stringWithFormat:NSLocalizedString(@"The %@ you entered was not valid. Please try again.", nil),
                                                              sessionData.currentProvider.shortText];
                else
                    alertMessage = NSLocalizedString(@"There was a problem authenticating with this provider. Please try again.", nil);

                DLog(@"The URL you entered does not appear to be an OpenID: %@", alertMessage);
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [[self navigationController] popViewControllerAnimated:YES];
                }];
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Invalid Input", nil)
                                                                                         message:alertMessage
                                                                                    alertActions:okAction, nil];
                [self presentViewController:alertController animated:YES completion:nil];
                userHitTheBackButton = NO; /* Because authentication failed for whatever reason. */
            }
            else if ([[[payloadDict objectForKey:@"rpx_result"] objectForKey:@"error"]
                    isEqualToString:@"Please enter your OpenID"])
            {
                NSError *error = [JREngageError errorWithMessage:errorMessage andCode:JRAuthenticationFailedError];

                userHitTheBackButton = NO; /* Because authentication failed for whatever reason. */
                [sessionData triggerAuthenticationDidFailWithError:error];
            }
            else
            {
                NSError *error = [JREngageError errorWithMessage:errorMessage andCode:JRAuthenticationFailedError];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK",nil) style:UIAlertActionStyleCancel handler:nil];
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Log In Failed", nil)
                                                                                         message:NSLocalizedString(@"An error occurred while attempting to sign you in.  Please try again.", nil)
                                                                                    alertActions:okAction, nil];
                [self presentViewController:alertController animated:YES completion:nil];

                userHitTheBackButton = NO; /* Because authentication failed for whatever reason. */
                [sessionData triggerAuthenticationDidFailWithError:error];
            }
        }
    }
    else if ([tag isEqualToString:WINDOWS_LIVE_LOAD])
    {
        [myWebView loadHTMLString:payload baseURL:[request URL]];
    }
}

- (void)connectionDidFailWithError:(NSError *)error request:(NSURLRequest *)request andTag:(id)tag
{
    DLog(@"tag: %@", tag);

    [self stopProgress];

    if ([tag isEqualToString:MEU_CONNECTION_TAG])
    {
        userHitTheBackButton = NO; /* Because authentication failed for whatever reason. */
        [sessionData triggerAuthenticationDidFailWithError:error];
    }
    else if ([tag isEqualToString:WINDOWS_LIVE_LOAD])
    {
        userHitTheBackButton = NO; /* Because authentication failed for whatever reason. */
        [sessionData triggerAuthenticationDidFailWithError:error];
    }
}

- (void)connectionWasStoppedWithTag:(id)tag
{
}

#pragma mark UIWebViewDelegate implementation

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    DLog(@"request: %@", [[request URL] absoluteString]);

    NSString *customUa = [JRWebViewController getCustomUa];
    if (customUa)
    {
        if ([request respondsToSelector:@selector(setValue:forHTTPHeaderField:)])
        {
            [((NSMutableURLRequest *) request) setValue:customUa forHTTPHeaderField:@"User-Agent"];
        }
    }

    NSString *mobileEndpointUrl = [NSString stringWithFormat:@"%@/signin/device", [sessionData baseUrl]];
    if ([[[request URL] absoluteString] hasPrefix:mobileEndpointUrl])
    {
        DLog(@"request url has prefix: %@", [sessionData baseUrl]);

        [JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:MEU_CONNECTION_TAG];

        keepProgress = YES;
        return NO;
    }

    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    DLog(@"");
    [self fixPadWindowSize];
    [self startProgress];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    DLog(@"");
    [self fixPadWindowSize];
    if (!keepProgress)
        [self stopProgress];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    DLog(@"");
    DLog(@"error message: %@", [error localizedDescription]);

    if (error.code != NSURLErrorCancelled) /* Error code -999 */
    {
        [self stopProgress];

        NSError *newError = [JREngageError errorWithMessage:[NSString stringWithFormat:@"Authentication failed: %@",
                                                                                       [error localizedDescription]]
                                                    andCode:JRAuthenticationFailedError];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK",nil) style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Log In Failed", nil)
                                                                                 message:NSLocalizedString(@"An error occurred while attempting to sign you in.  Please try again.", nil)
                                                                            alertActions:okAction, nil];
        [self presentViewController:alertController animated:YES completion:nil];

        userHitTheBackButton = NO; /* Because authentication failed for whatever reason. */
        
        [sessionData triggerAuthenticationDidFailWithError:newError];
    }
}

- (void)loadUrlInWebView:(NSURL *)url
{
    DLog(@"");
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //UIWebview/WKWebView
    [myWebView loadRequest:request];
    //Safari - doesn't return to app
    //[[UIApplication sharedApplication] openURL:[request URL]];
    //Safari View Controller
    //SFSafariViewController *svc = [[SFSafariViewController alloc] initWithURL:[request URL]];
    //svc.delegate = self;
    //[self presentViewController:svc animated:YES completion:nil];
    
    
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
    // Must set delegate to nil to avoid this controller being called after
    // it has been freed by the web view.
    //myWebView.delegate = nil;
}
@end
