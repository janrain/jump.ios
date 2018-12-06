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

 File:   JRProvidersController.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Tuesday, June 1, 2010
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "debug_log.h"
#import "JRSessionData.h"
#import "JRUserInterfaceMaestro.h"
#import "JREngage+CustomInterface.h"
#import "JRProvidersController.h"
#import "JRInfoBar.h"
#import "JRUserLandingController.h"
#import "JREngageError.h"
#import "JRCompatibilityUtils.h"
#import "JROpenIDAppAuth.h"
#import "JROpenIDAppAuthProvider.h"
#import "UIAlertController+JRAlertController.h"


@interface UITableViewCellProviders : UITableViewCell
@end

@implementation UITableViewCellProviders

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {}

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.imageView.frame = CGRectMake(10, 10, 30, 30);
    self.textLabel.frame = CGRectMake(50, 15, 200, 22);
}
@end

@interface JRProvidersController ()
- (void)createTraditionalSignInLoadingView;

@property NSMutableArray *providers;
@property UIView *myTraditionalSignInLoadingView;
@property(nonatomic) JROpenIDAppAuthProvider *openIDAppAuthProvider;
@end

@implementation JRProvidersController
{
    JRSessionData   *sessionData;
    NSDictionary    *customInterface;

    UIView      *titleView;
    UITableView *myTableView;

    /* Activity Spinner and Label displayed while the list of configured providers is empty */
    NSTimer *timer;
    UILabel                 *myLoadingLabel;
    //UIActivityIndicatorView *myActivitySpinner;

    JRInfoBar   *infoBar;
}

@synthesize providers;
@synthesize hidesCancelButton;
@synthesize myBackgroundView;
@synthesize myTableView;
@synthesize myLoadingLabel;
@synthesize myActivitySpinner;
@synthesize myTraditionalSignInLoadingView;

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
    myTableView.backgroundColor = [UIColor clearColor];

    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }

    // If there is a UIColor object set for the background color, use this
    if ([customInterface objectForKey:kJRAuthenticationBackgroundColor])
        myBackgroundView.backgroundColor = [customInterface objectForKey:kJRAuthenticationBackgroundColor];

    // Weird hack necessary on the iPad, as the iPad table views have some background view that is always gray
    if ([myTableView respondsToSelector:@selector(setBackgroundView:)])
        [myTableView setBackgroundView:nil];

    titleView = [customInterface objectForKey:kJRProviderTableTitleView];

    if (titleView) {
        self.navigationItem.titleView = titleView;
    } else {
        NSString *l10n = ([customInterface objectForKey:kJRProviderTableTitleString]) ?
            [customInterface objectForKey:kJRProviderTableTitleString] : NSLocalizedString(@"Sign in with...",nil);
        self.navigationItem.title = l10n;
    }

    myTableView.tableHeaderView = [customInterface objectForKey:kJRProviderTableHeaderView];
    myTableView.tableFooterView = [customInterface objectForKey:kJRProviderTableFooterView];

    [self resizeTableHeaderView];

    id const maybeCaptureSignInVc = [customInterface objectForKey:kJRCaptureTraditionalSignInViewController];
    if ([maybeCaptureSignInVc isKindOfClass:NSClassFromString(@"JRTraditionalSignInViewController")])
    {
        if ([maybeCaptureSignInVc respondsToSelector:@selector(setDelegate:)]){
            [maybeCaptureSignInVc setDelegate:((id<NSFileManagerDelegate>)self)];
        } else {
            DLog(@"setDelegate selector not found on object %@", maybeCaptureSignInVc);
            // TODO: NSAssert here?
        }
        [self createTraditionalSignInLoadingView];

    }

    if (!hidesCancelButton)
    {
        UIBarButtonItem *cancelButton =
                [[UIBarButtonItem alloc]
                        initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                             target:sessionData
                                             action:@selector(triggerAuthenticationDidCancel:)];

        self.navigationItem.leftBarButtonItem = cancelButton;
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStylePlain;
    }

    if (!infoBar)
    {
        CGRect frame = CGRectMake(0, self.view.frame.size.height - 30, self.view.frame.size.width, 30);
        infoBar = [[JRInfoBar alloc] initWithFrame:frame andStyle:(JRInfoBarStyle) [sessionData hidePoweredBy]];

        [self.view addSubview:infoBar];
    }
}

- (void)resizeTableHeaderView {
    if (myTableView.tableHeaderView && [myTableView.tableHeaderView isKindOfClass:[UIScrollView class]]) {
        UIScrollView *tableHeaderView = (UIScrollView *)myTableView.tableHeaderView;

        CGFloat height = tableHeaderView.contentSize.height;
        CGFloat maxHeight = tableHeaderView.superview.frame.size.height - tableHeaderView.frame.origin.y;
        if (height > maxHeight) height = maxHeight;

        CGRect frame = tableHeaderView.frame;
        frame.size.height = height;
        myTableView.tableHeaderView.frame = frame;

        // Force the tableHeaderView to be redrawn
        myTableView.tableHeaderView = myTableView.tableHeaderView;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    DLog(@"");
    [super viewWillAppear:animated];
    [self jrSetContentSizeForViewInPopover:self.view.frame.size];

    // Load the custom background view, if there is one.
    if ([customInterface objectForKey:kJRAuthenticationBackgroundImageView])
        [myBackgroundView addSubview:[customInterface objectForKey:kJRAuthenticationBackgroundImageView]];

    CGFloat tableAndSectionHeaderHeight = 0;
    if (myTableView.tableHeaderView)
        tableAndSectionHeaderHeight += myTableView.tableHeaderView.frame.size.height;

    tableAndSectionHeaderHeight += [self tableView:myTableView heightForHeaderInSection:0];

    if (tableAndSectionHeaderHeight)
    {
        CGFloat loadingLabelAndSpinnerVerticalOffset =
                ((self.view.frame.size.height - tableAndSectionHeaderHeight) / 2) + tableAndSectionHeaderHeight;

        [myLoadingLabel setFrame:CGRectMake(myLoadingLabel.frame.origin.x,
                loadingLabelAndSpinnerVerticalOffset - 40,
                myLoadingLabel.frame.size.width,
                myLoadingLabel.frame.size.height)];
        [myActivitySpinner setFrame:CGRectMake(myActivitySpinner.frame.origin.x,
                loadingLabelAndSpinnerVerticalOffset,
                myActivitySpinner.frame.size.width,
                myActivitySpinner.frame.size.height)];
    }

    if ([sessionData.authenticationProviders count] > 0)
    {
        self.providers = [NSMutableArray arrayWithArray:sessionData.authenticationProviders];
        [providers removeObjectsInArray:[customInterface objectForKey:kJRRemoveProvidersFromAuthentication]];
        [self stopActivityIndicator];

        // Load the table with the list of providers.
        [myTableView reloadData];
    }
    else
    {
        //DLog(@"prov count = %d", [sessionData.authenticationProviders count]);

        // If the user calls the library before the session data object is done initializing -
        // because either the requests for the base URL or provider list haven't returned -
        // display the "Loading Providers" label and activity spinner.
        // sessionData = nil when the call to get the base URL hasn't returned
        // [sessionData.configuredProviders count] = 0 when the provider list hasn't returned
        [myActivitySpinner setHidden:NO];
        [myLoadingLabel setHidden:NO];

        [myActivitySpinner startAnimating];

        // Poll
        timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self
                                               selector:@selector(checkSessionDataAndProviders:)
                                               userInfo:nil repeats:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)checkSessionDataAndProviders:(NSTimer *)theTimer
{
    DLog(@"");
    static NSTimeInterval interval = 0.5;
    interval = interval + 0.5;

    timer = nil;

    DLog(@"prov count = %lu", (unsigned long)[sessionData.authenticationProviders count]);
    DLog(@"interval = %f", interval);

    if ([sessionData.authenticationProviders count] > 0)
    {
        // Stop polling
        self.providers = [NSMutableArray arrayWithArray:sessionData.authenticationProviders];
        [providers removeObjectsInArray:[customInterface objectForKey:kJRRemoveProvidersFromAuthentication]];

        [self stopActivityIndicator];

        [myTableView reloadData];

        return;
    }

    if (interval >= 16.0)
    {
        // Polling has timed out
        DLog(@"No Available Providers");

        [self stopActivityIndicator];

        UIApplication *app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;

        NSString *message = NSLocalizedString(@"There are no available providers. Either there is a problem connecting or no providers "
                "have been configured. Please try again later.", nil);
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [sessionData triggerAuthenticationDidTimeOutConfiguration];
        }];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"No Available Providers",nil) message:message alertActions:okAction, nil];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }

    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkSessionDataAndProviders:)
                                           userInfo:nil repeats:NO];
}

#define LOADING_VIEW_TAG         555
#define LOADING_VIEW_LABEL_TAG   666
#define LOADING_VIEW_SPINNER_TAG 777

- (void)authenticationDidComplete
{
    [sessionData triggerAuthenticationDidCancel];
}

- (void)showLoading
{
    UIActivityIndicatorView *myTraditionalSignInLoadingSpinner =
            (UIActivityIndicatorView *) [myTraditionalSignInLoadingView viewWithTag:LOADING_VIEW_SPINNER_TAG];

    [myTraditionalSignInLoadingView setHidden:NO];
    [myTraditionalSignInLoadingSpinner startAnimating];

    [UIView beginAnimations:@"fade" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelay:0.0];
    myTraditionalSignInLoadingView.alpha = 0.8;
    [UIView commitAnimations];
}

- (void)hideLoading
{
    UIActivityIndicatorView *myTraditionalSignInLoadingSpinner =
            (UIActivityIndicatorView *) [myTraditionalSignInLoadingView viewWithTag:LOADING_VIEW_SPINNER_TAG];

    [UIView beginAnimations:@"fade" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelay:0.0];
    myTraditionalSignInLoadingView.alpha = 0.0;
    [UIView commitAnimations];

    [myTraditionalSignInLoadingView setHidden:YES];
    [myTraditionalSignInLoadingSpinner stopAnimating];
}

- (void)createTraditionalSignInLoadingView
{
    self.myTraditionalSignInLoadingView = [[UIView alloc] initWithFrame:self.view.frame];

    [self.myTraditionalSignInLoadingView setBackgroundColor:[UIColor blackColor]];

    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 180, 320, 30)];

    [loadingLabel setText:NSLocalizedString(@"Completing Sign-In...",nil)];
    [loadingLabel setFont:[UIFont systemFontOfSize:20.0]];
    [loadingLabel setTextAlignment:(int)JR_TEXT_ALIGN_CENTER];
    [loadingLabel setTextColor:[UIColor whiteColor]];
    [loadingLabel setBackgroundColor:[UIColor clearColor]];
    [loadingLabel setAutoresizingMask:UIViewAutoresizingNone |
            UIViewAutoresizingFlexibleTopMargin |
            UIViewAutoresizingFlexibleBottomMargin |
            UIViewAutoresizingFlexibleRightMargin |
            UIViewAutoresizingFlexibleLeftMargin];

    UIActivityIndicatorView *loadingSpinner =
            [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

    [loadingSpinner setFrame:CGRectMake(142, self.view.frame.size.height / 2 - 16, 37, 37)];
    [loadingLabel setAutoresizingMask:UIViewAutoresizingNone |
            UIViewAutoresizingFlexibleTopMargin |
            UIViewAutoresizingFlexibleBottomMargin |
            UIViewAutoresizingFlexibleRightMargin |
            UIViewAutoresizingFlexibleLeftMargin];

    [loadingLabel setTag:LOADING_VIEW_LABEL_TAG];
    [loadingSpinner setTag:LOADING_VIEW_SPINNER_TAG];

    [myTraditionalSignInLoadingView addSubview:loadingLabel];
    [myTraditionalSignInLoadingView addSubview:loadingSpinner];

    [myTraditionalSignInLoadingView setTag:LOADING_VIEW_TAG];
    [myTraditionalSignInLoadingView setHidden:YES];
    [myTraditionalSignInLoadingView setAlpha:0.0];

    [self.view addSubview:myTraditionalSignInLoadingView];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedString([customInterface objectForKey:kJRProviderTableSectionHeaderTitleString], @"");
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([customInterface objectForKey:kJRProviderTableSectionHeaderView])
        return ((UIView *) [customInterface objectForKey:kJRProviderTableSectionHeaderView]).frame.size.height;
    else if ([customInterface objectForKey:kJRProviderTableSectionHeaderTitleString])
        return 35;

    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [customInterface objectForKey:kJRProviderTableSectionHeaderView];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return NSLocalizedString([customInterface objectForKey:kJRProviderTableSectionFooterTitleString], @"");
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat infoBarHeight = sessionData.hidePoweredBy ? 0.0 : infoBar.frame.size.height;

    if ([customInterface objectForKey:kJRProviderTableSectionFooterView])
        return ((UIView *) [customInterface objectForKey:kJRProviderTableSectionFooterView]).frame.size.height +
                infoBarHeight;
    else if ([customInterface objectForKey:kJRProviderTableSectionFooterTitleString])
        return 35 + infoBarHeight;

    return 0 + infoBarHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ([customInterface objectForKey:kJRProviderTableSectionFooterView])
    {
        return [customInterface objectForKey:kJRProviderTableSectionFooterView];
    }
    else if (![customInterface objectForKey:kJRProviderTableSectionFooterTitleString])
    {
        CGRect frame = CGRectMake(0, 0, myTableView.frame.size.width, infoBar.frame.size.height);
        return [[UIView alloc] initWithFrame:frame];
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [providers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellProviders *cell =
            (UITableViewCellProviders *) [tableView dequeueReusableCellWithIdentifier:@"cachedCell"];

    if (cell == nil)
        cell = [[UITableViewCellProviders alloc]
                initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cachedCell"];

    JRProvider *provider = [sessionData getProviderNamed:[providers objectAtIndex:(NSUInteger) indexPath.row]];

    if (!provider)
        return cell;

    NSString *imagePath = [NSString stringWithFormat:@"icon_%@_30x30.png", provider.name];

    cell.textLabel.text = provider.friendlyName;
    cell.imageView.image = [UIImage imageNamed:imagePath];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    [cell layoutSubviews];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"");
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // Let sessionData know which provider the user selected
    JRProvider *provider = [sessionData getProviderNamed:[providers objectAtIndex:(NSUInteger) indexPath.row]];
    if ([JROpenIDAppAuth canHandleProvider:provider.name])
    {
        [UIView animateWithDuration:0.3 animations:^() {
            myTableView.hidden = YES;
            [myActivitySpinner setHidden:NO];
            [myLoadingLabel setHidden:NO];
            [myActivitySpinner startAnimating];
            myLoadingLabel.text = NSLocalizedString(@"Signing in ...",nil);
        }];
        
        [sessionData setCurrentProvider:provider];
        
        self.openIDAppAuthProvider = [JROpenIDAppAuth openIDAppAuthProviderNamed:provider.name];
        [self.openIDAppAuthProvider startAuthenticationWithCompletion:^(NSError *e) {
            if (e) {
                if ([e.domain isEqualToString:JREngageErrorDomain] && e.code == JRAuthenticationCanceledError) {
                    [sessionData triggerAuthenticationDidCancel];
                } else if ([e.domain isEqualToString:JREngageErrorDomain]
                           && e.code == JRAuthenticationShouldTryWebViewError) {
                    self.myTableView.hidden = NO;
                    [self stopActivityIndicator];
                    [self startWebViewAuthOnProvider:provider];
                } else {
                    myTableView.hidden = NO;
                    [self stopActivityIndicator];
                    [sessionData triggerAuthenticationDidFailWithError:e];
                }
            }
        }];
    }
    else
    {
        [self startWebViewAuthOnProvider:provider];
    }
}
- (void)startWebViewAuthOnProvider:(JRProvider *)provider
{
    [sessionData setCurrentProvider:provider];

    if (provider.requiresInput || ([sessionData authenticatedUserForProvider:provider]
            && !(provider.forceReauthStartUrlFlag || sessionData.alwaysForceReauth)))
    {
        // If the selected provider requires input from the user, to the user landing view.
        // Or if the user started on the user landing page, went back to the list of providers, then selected
        // the same provider as their last-used provider, go back to the user landing view.
        [[self navigationController] pushViewController:[JRUserInterfaceMaestro sharedMaestro].myUserLandingController
                                               animated:YES];
    }
    else
    {
        // Otherwise, straight to the web view.
        [[JRUserInterfaceMaestro sharedMaestro] pushWebViewFromViewController:self];
    }

}

- (void)stopActivityIndicator {
    [myActivitySpinner stopAnimating];
    [myActivitySpinner setHidden:YES];
    [myLoadingLabel setHidden:YES];
}

- (void)userInterfaceWillClose
{
    [timer invalidate];
}

- (void)userInterfaceDidClose
{
}

- (void)dealloc
{
    DLog(@"");
}
@end
