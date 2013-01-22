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

#import "JRWebViewController.h"
#import "JRSessionData.h"
#import "JRInfoBar.h"
#import "JREngageError.h"


#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

@interface JREngageError (JREngageError_setError)
+ (NSError*)setError:(NSString*)message withCode:(NSInteger)code;
@end

@interface JRWebViewController ()
- (void)webViewWithUrl:(NSURL*)url;
@end

@implementation JRWebViewController
@synthesize myBackgroundView;
@synthesize myWebView;
@synthesize originalUserAgent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
   andCustomInterface:(NSDictionary*)theCustomInterface
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        sessionData     = [JRSessionData jrSessionData];
        customInterface = [theCustomInterface retain];
    }

    return self;
}

- (void)setUserAgentDefault:(NSString *)userAgent
{
    DLog(@"UA: %@", userAgent);
    if (userAgent)
    {
        NSDictionary *uAdefault = [[NSDictionary alloc] initWithObjectsAndKeys:userAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:uAdefault];
        [uAdefault release];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserAgent"];
    }
}

- (void)viewDidLoad
{
    DLog(@"");
    [super viewDidLoad];

    myWebView.backgroundColor = [UIColor clearColor];

    self.navigationItem.backBarButtonItem.target = sessionData;
    self.navigationItem.backBarButtonItem.action = @selector(triggerAuthenticationDidStartOver:);

    if (!infoBar)
    {
        infoBar = [[JRInfoBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 30,
                self.view.frame.size.width, 30)
                                          andStyle:(JRInfoBarStyle)[sessionData hidePoweredBy]];

        if ([sessionData hidePoweredBy] == JRInfoBarStyleShowPoweredBy)
            [myWebView setFrame:CGRectMake(myWebView.frame.origin.x,
                                           myWebView.frame.origin.y,
                                           myWebView.frame.size.width,
                                           myWebView.frame.size.height - infoBar.frame.size.height)];

        [self.view addSubview:infoBar];
    }

    // TODO: This test is here for the case where the sign-in flow opens straight to the webview (auth on just one
    // provider),
    // but it seems to be evaluating to 'true' when we are sharing as well... Why!?
    // Will this always be a reliable test?
    if (!self.navigationController.navigationBar.backItem && !sessionData.socialSharing)
    {
        DLog(@"no back button");
        UIBarButtonItem *cancelButton =
                [[[UIBarButtonItem alloc]
                        initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                             target:sessionData
                                             action:@selector(triggerAuthenticationDidCancel:)] autorelease];

        self.navigationItem.rightBarButtonItem         = cancelButton;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.navigationItem.rightBarButtonItem.style   = UIBarButtonItemStyleBordered;
    }
    else
    {
        DLog(@"back button");
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    DLog(@"");

    if ([sessionData.currentProvider.name isEqualToString:@"yahoo"])
    {
        [self setOriginalUserAgent:[[NSUserDefaults standardUserDefaults] stringForKey:@"UserAgent"]];
        [self setUserAgentDefault:@"Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3_3 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5"];
    }

    [super viewWillAppear:animated];

    self.contentSizeForViewInPopover = CGSizeMake(320, 416);

    self.title = [NSString stringWithFormat:@"%@",
                           (sessionData.currentProvider) ? sessionData.currentProvider.friendlyName : @"Loading"];
}

- (void)viewDidAppear:(BOOL)animated
{
    DLog(@"");
    [super viewDidAppear:animated];

 /* We need to figure out if the user canceled authentication by hitting the back button or the cancel button,
    or if it stopped because it failed or completed successfully on its own.  Assume that the user did hit the
    back button until told otherwise. */
    userHitTheBackButton = YES;

    if (!sessionData.currentProvider)
    {
        NSError *error = [JREngageError setError:@"There was an error authenticating with the selected provider."
                                        withCode:JRAuthenticationFailedError];

        [sessionData triggerAuthenticationDidFailWithError:error];

        return;
    }

    //[self webViewWithUrl:[NSURL URLWithString:@"http://whatsmyuseragent.com"]];
    [self webViewWithUrl:[sessionData startUrlForCurrentProvider]];
    [myWebView becomeFirstResponder];
    //DLog(@"scalePagesToFit: %i", myWebView.scalesPageToFit);
    // Defaults to YES on iPhone, iPad
    //myWebView.scalesPageToFit = YES;

    [infoBar fadeIn];
}

- (void)cancelButtonPressed:(id)sender
{
    userHitTheBackButton = NO;
    [sessionData triggerAuthenticationDidStartOver:sender];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex { }

- (void)startProgress
{
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    [infoBar startProgress];
}

- (void)stopProgress
{
    if ([JRConnectionManager openConnections] == 0)
    {
        UIApplication* app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = NO;
    }

    keepProgress = NO;
    [infoBar stopProgress];
}

- (void)connectionDidFinishLoadingWithUnEncodedPayload:(NSData*)payload
                                               request:(NSURLRequest*)request
                                                andTag:(id)userdata { }

- (void)connectionDidFinishLoadingWithPayload:(NSString*)payload request:(NSURLRequest*)request andTag:(id)userdata
{
    DLog(@"");
    [self stopProgress];

    NSString* tag = (NSString*)userdata;

    if ([tag isEqualToString:MEU_CONNECTION_TAG])
    {
        DLog(@"payload: %@", payload);
        DLog(@"tag:     %@", tag);

        NSDictionary *payloadDict = [payload objectFromJSONString];

        if(!payloadDict)
        {
            NSError *error = [JREngageError setError:[NSString stringWithFormat:@"Authentication failed: %@", payload]
                                            withCode:JRAuthenticationFailedError];

            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Log In Failed"
                                                             message:@"An error occurred while attempting to sign you in.  Please try again."
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil] autorelease];
            [alert show];

            userHitTheBackButton = NO; /* Because authentication failed for whatever reason. */
            [sessionData triggerAuthenticationDidFailWithError:error];
        }
        else if ([((NSString*)[((NSDictionary*)[payloadDict objectForKey:@"rpx_result"]) objectForKey:@"stat"])
                isEqualToString:@"ok"])
        {
            userHitTheBackButton = NO; /* Because authentication completed successfully. */
            [sessionData triggerAuthenticationDidCompleteWithPayload:payloadDict];
        }
        else
        {
            if ([((NSString*)[((NSDictionary*)[payloadDict objectForKey:@"rpx_result"]) objectForKey:@"error"])
                    isEqualToString:@"Discovery failed for the OpenID you entered"])
            {
                NSString *message;
                if (sessionData.currentProvider.requiresInput)
                    message = [NSString stringWithFormat:@"The %@ you entered was not valid. Please try again.",
                                        sessionData.currentProvider.shortText];
                else
                    message = @"There was a problem authenticating with this provider. Please try again.";

                DLog(@"Discovery failed for the OpenID you entered: %@", message);

                UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Invalid Input"
                                                                 message:message
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil] autorelease];

                userHitTheBackButton = NO; /* Because authentication failed for whatever reason. */
                [[self navigationController] popViewControllerAnimated:YES];

                [alert show];
            }
            else if ([((NSString*)[((NSDictionary*)[payloadDict objectForKey:@"rpx_result"]) objectForKey:@"error"])
                    isEqualToString:@"The URL you entered does not appear to be an OpenID"])
            {
                NSString *message;
                if (sessionData.currentProvider.requiresInput)
                    message = [NSString stringWithFormat:@"The %@ you entered was not valid. Please try again.",
                                        sessionData.currentProvider.shortText];
                else
                    message = @"There was a problem authenticating with this provider. Please try again.";

                DLog(@"The URL you entered does not appear to be an OpenID: %@", message);

                UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Invalid Input"
                                                                 message:message
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil] autorelease];

                userHitTheBackButton = NO; /* Because authentication failed for whatever reason. */
                [[self navigationController] popViewControllerAnimated:YES];

                [alert show];
            }
            else if ([((NSString*)[((NSDictionary*)[payloadDict objectForKey:@"rpx_result"]) objectForKey:@"error"])
                    isEqualToString:@"Please enter your OpenID"])
            {
                NSError *error = [JREngageError setError:[NSString stringWithFormat:@"Authentication failed: %@", payload]
                                                withCode:JRAuthenticationFailedError];

                userHitTheBackButton = NO; /* Because authentication failed for whatever reason. */
                [sessionData triggerAuthenticationDidFailWithError:error];
            }
            else
            {
                NSError *error = [JREngageError setError:[NSString stringWithFormat:@"Authentication failed: %@", payload]
                                                withCode:JRAuthenticationFailedError];

                UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Log In Failed"
                                                                 message:@"An error occurred while attempting to sign you in.  Please try again."
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil] autorelease];
                [alert show];

                userHitTheBackButton = NO; /* Because authentication failed for whatever reason. */
                [sessionData triggerAuthenticationDidFailWithError:error];
            }
        }
    }
    else if ([tag isEqualToString:WINDOWS_LIVE_LOAD])
    {
        connectionDataAlreadyDownloadedThis = YES;
        [myWebView loadHTMLString:payload baseURL:[request URL]];
    }
}

- (void)connectionDidFailWithError:(NSError*)error request:(NSURLRequest*)request andTag:(id)userdata
{
    DLog(@"");
    NSString* tag = (NSString*)userdata;
    DLog(@"tag:     %@", tag);

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

- (void)connectionWasStoppedWithTag:(id)userdata { }

#define SKIP_THIS_WORK_AROUND 0
#define WEBVIEW_SHOULDNT_LOAD 0
- (BOOL)webviewShouldntLoadRequestDueToTheWindowsLiveFix:(NSURLRequest*)request
{
    if (![[sessionData currentProvider].name isEqualToString:@"live_id"])
        return SKIP_THIS_WORK_AROUND;

    if (connectionDataAlreadyDownloadedThis)
    {
        connectionDataAlreadyDownloadedThis = NO;
        return SKIP_THIS_WORK_AROUND;
    }

    DLog("Sending request to connection manager: %@", request);

    [JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:WINDOWS_LIVE_LOAD];
    return YES;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
                                                 navigationType:(UIWebViewNavigationType)navigationType
{
    DLog(@"request: %@", [[request URL] absoluteString]);

    NSString *mobileEndpointUrl = [NSString stringWithFormat:@"%@/signin/device", [sessionData baseUrl]];

    if ([[[request URL] absoluteString] hasPrefix:mobileEndpointUrl])
    {
        DLog(@"request url has prefix: %@", [sessionData baseUrl]);

        [JRConnectionManager createConnectionFromRequest:request forDelegate:self withTag:MEU_CONNECTION_TAG];

        keepProgress = YES;
        return NO;
    }

    if ([self webviewShouldntLoadRequestDueToTheWindowsLiveFix:request])
        return WEBVIEW_SHOULDNT_LOAD;

    return YES;
}

- (void)fixPadWindowSize
{
    DLog(@"");
    //return;
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) return;

    if (!([sessionData.currentProvider.name isEqualToString:@"google"] ||
          [sessionData.currentProvider.name isEqualToString:@"yahoo"])) return;

    /* This fixes the UIWebView's display of IDP sign-in pages to make them fit the iPhone sized dialog on the iPad.
     * It's broken up into separate JS injections in case one statement fails (e.g. there is no document element),
     * so that the others execute. */
    [myWebView stringByEvaluatingJavaScriptFromString:@""
            "window.innerHeight = 480; window.innerWidth = 320;"
            //"window.screen.height = 480; window.screen.width = 320;"
            "document.documentElement.clientWidth = 320; document.documentElement.clientHeight = 480;"
            "document.body.style.minWidth = \"320px\";"
            "document.body.style.width = \"auto\";"
            "document.body.style.minHeight = \"0px\";"
            "document.body.style.height = \"auto\";"
            "document.body.children[0].style.minHeight = \"0px\";"];

    [myWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@""
            "(function(){"
              "var m = document.querySelector('meta[name=viewport]');"
              "if (m === null) { m = document.createElement('meta'); document.head.appendChild(m); }"
              "m.name = 'viewport';"
              "m.content = 'width=%i, height=%i';"
            "})()",
            (int) myWebView.frame.size.width,
            (int) myWebView.frame.size.height]];
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

        NSError *newError = [JREngageError setError:[NSString stringWithFormat:@"Authentication failed: %@",
                                                              [error localizedDescription]]
                                           withCode:JRAuthenticationFailedError];

        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Log In Failed"
                                                         message:@"An error occurred while attempting to sign you in.  Please try again."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil] autorelease];
        [alert show];

        userHitTheBackButton = NO; /* Because authentication failed for whatever reason. */
        [sessionData triggerAuthenticationDidFailWithError:newError];
    }
}

- (void)webViewWithUrl:(NSURL*)url
{
    DLog(@"");
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [myWebView loadRequest:request];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    BOOL b;
    if (sessionData.canRotate)
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

    // Must set delegate to nil to avoid this controller being called after
    // it has been freed by the web view.
    myWebView.delegate = nil;

    [JRConnectionManager stopConnectionsForDelegate:self];
    [self stopProgress];

    [infoBar fadeOut];

 /* The webview disappears when authentication completes successfully or fails or if the user cancels by hitting
    the "back" button or the "cancel" button.  We don't know when a user hits the back button, but we do
    know when all the other events occur, so we keep track of those events by changing the "userHitTheBackButton"
    variable to "NO".

    If the view is disappearing because the user hit the cancel button, we already to send sessionData the
    triggerAuthenticationDidStartOver event.  What we need to do it send the triggerAuthenticationDidStartOver
    message if we're popping to the publishActivity controller (i.e., if we're publishing an activity), so that
    the publishActivity controller gets the message from sessionData, and can hide the grayed-out activity indicator
    view.

    If the userHitTheBackButton variable is set to "YES" and we're publishing an activity ([sessionData social] is
    "YES"),
    send the triggerAuthenticationDidStartOver message.  Otherwise, hitting the back button should just pop back
    to the last controller, the providers or userLanding controller (i.e., behave normally) */
    if (userHitTheBackButton && [sessionData socialSharing])
        [sessionData triggerAuthenticationDidStartOver:nil];

    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    DLog(@"");

    if ([sessionData.currentProvider.name isEqualToString:@"yahoo"])
        [self setUserAgentDefault:self.originalUserAgent];

    [myWebView loadHTMLString:@"" baseURL:[NSURL URLWithString:@"/"]];

    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    DLog(@"");
    [super viewDidUnload];
}

- (void)userInterfaceWillClose { }
- (void)userInterfaceDidClose  { }

- (void)dealloc {
    DLog(@"");

    [customInterface release];
    [myBackgroundView release];
    [originalUserAgent release];
    [myWebView release];
    [infoBar release];

    [super dealloc];
}
@end
