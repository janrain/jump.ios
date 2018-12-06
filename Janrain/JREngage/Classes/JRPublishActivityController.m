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

 File:   JRPublishActivityController.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Tuesday, August 24, 2010
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "debug_log.h"
#import "JRSessionData.h"
#import "JRPublishActivityController.h"
#import "JRWebViewController.h"
#import "JREngage+CustomInterface.h"
#import "JREngageError.h"
#import "JRUserInterfaceMaestro.h"
#import "JRUserLandingController.h"
#import "JRCompatibilityUtils.h"
#import "UIAlertController+JRAlertController.h"

#define JRR_OUTER_STROKE_COLOR    [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]
#define JRR_INNER_STROKE_COLOR    JANRAIN_BLUE
#define JRR_OUTER_FILL_COLOR      [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]
#define JRR_INNER_FILL_COLOR      [UIColor clearColor]
#define JRR_OUTER_STROKE_WIDTH    0.1
#define JRR_INNER_STROKE_WIDTH    0.5
#define JRR_OUTER_CORNER_RADIUS   10.0
#define JRR_INNER_CORNER_RADIUS   9.0
#define JRR_INNER_RECT_INSET      6

@interface JRRoundedRect : UIView
@property(nonatomic) UIColor *outerStrokeColor;
@property(nonatomic) UIColor *innerStrokeColor;
@property(nonatomic) UIColor *outerFillColor;
@property(nonatomic) UIColor *innerFillColor;
@property CGFloat outerStrokeWidth;
@property CGFloat innerStrokeWidth;
@property CGFloat outerCornerRadius;
@property CGFloat innerCornerRadius;
@property BOOL drawInnerRect;
@end

@interface JRProvider (JRProvider_SocialSharingProperties)
- (BOOL)willThunkPublishToStatusForActivity:(JRActivityObject *)activity;

- (BOOL)isActivityUrlPartOfUserContent;

- (BOOL)canShareRichDataForActivity:(JRActivityObject *)activity;

- (BOOL)doesContentReplaceAction;

- (NSInteger)maxCharactersForSetStatus;

- (NSInteger)maxCharactersForPublishActivity;
@end

@implementation JRProvider (JRProvider_SocialSharingProperties)
- (BOOL)willThunkPublishToStatusForActivity:(JRActivityObject *)activity
{
    /* Right now, LinkedIn and Yahoo! */
    /* If the activity url is nil (or empty) certain providers will thunk from publish activity to set_status */
    return ((![activity url] || [[activity url] isEqualToString:@""]) &&
            [[self.socialSharingProperties objectForKey:@"uses_set_status_if_no_url"] isEqualToString:@"YES"]);
}


- (BOOL)isActivityUrlPartOfUserContent
{
    BOOL url_reduces_max_chars =
            [[self.socialSharingProperties objectForKey:@"url_reduces_max_chars"] isEqualToString:@"YES"];
    BOOL shows_url_as_url = [[self.socialSharingProperties objectForKey:@"shows_url_as"] isEqualToString:@"url"];

    /* Twitter/MySpace -> true */
    return (url_reduces_max_chars && shows_url_as_url);
}

- (BOOL)canShareRichDataForActivity:(JRActivityObject *)activity
{
    /* If the provider can share media (Facebook and LinkedIn) and we're not going to thunk
       to set_status (Yahoo! and LinkedIn when there's no activity url) */
    if ([[self.socialSharingProperties objectForKey:@"can_share_media"] isEqualToString:@"YES"] &&
            ![self willThunkPublishToStatusForActivity:activity])
        return YES;

    return NO;
}

- (BOOL)doesContentReplaceAction
{
    if ([[self.socialSharingProperties objectForKey:@"content_replaces_action"] isEqualToString:@"YES"])
        return YES;

    return NO;
}

- (NSInteger)maxCharactersForSetStatus
{
    id socialSharingProps = [[self socialSharingProperties] objectForKey:@"set_status_properties"];
    return [((NSString *) [((NSDictionary *) socialSharingProps) objectForKey:@"max_characters"]) intValue];
}

- (NSInteger)maxCharactersForPublishActivity
{
    return [((NSString *) [[self socialSharingProperties] objectForKey:@"max_characters"]) intValue];
}


@end

@implementation JRRoundedRect
@synthesize outerStrokeColor;
@synthesize innerStrokeColor;
@synthesize outerFillColor;
@synthesize innerFillColor;
@synthesize outerStrokeWidth;
@synthesize innerStrokeWidth;
@synthesize outerCornerRadius;
@synthesize innerCornerRadius;
@synthesize drawInnerRect;

- (id)initWithCoder:(NSCoder *)decoder
{
    DLog(@"");
    if ((self = [super initWithCoder:decoder]))
    {
        self.outerStrokeColor = JRR_OUTER_STROKE_COLOR;
        self.innerStrokeColor = JRR_INNER_STROKE_COLOR;
        self.outerFillColor = JRR_OUTER_FILL_COLOR;
        self.innerFillColor = JRR_INNER_FILL_COLOR;
        self.outerStrokeWidth = JRR_OUTER_STROKE_WIDTH;
        self.innerStrokeWidth = JRR_INNER_STROKE_WIDTH;
        self.outerCornerRadius = JRR_OUTER_CORNER_RADIUS;
        self.innerCornerRadius = JRR_INNER_CORNER_RADIUS;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    DLog(@"");
    if ((self = [super initWithFrame:frame]))
    {
        self.opaque = NO;
        self.outerStrokeColor = JRR_OUTER_STROKE_COLOR;
        self.innerStrokeColor = JRR_INNER_STROKE_COLOR;
        self.outerFillColor = JRR_OUTER_FILL_COLOR;
        self.innerFillColor = JRR_INNER_FILL_COLOR;
        self.outerStrokeWidth = JRR_OUTER_STROKE_WIDTH;
        self.innerStrokeWidth = JRR_INNER_STROKE_WIDTH;
        self.outerCornerRadius = JRR_OUTER_CORNER_RADIUS;
        self.innerCornerRadius = JRR_INNER_CORNER_RADIUS;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

/* Functions are necessary for Interface Builder, but we want to ignore any attempt at changing the background color
or opacity of our rounded rectangle. */
- (void)setBackgroundColor:(UIColor *)newBackgroundColor
{
}

- (void)setOpaque:(BOOL)newIsOpaque
{
}

- (void)drawRoundedRect:(CGRect)roundedRect withRadius:(CGFloat)radius strokeWidth:(CGFloat)strokeWidth
            strokeColor:(UIColor *)strokeColor andFillColor:(UIColor *)fillColor
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, strokeWidth);
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);

    CGFloat width = CGRectGetWidth(roundedRect);
    CGFloat height = CGRectGetHeight(roundedRect);

    /* We need to make sure corner radius isn't larger than half of the shorter side, or else we need to
       set that as the corner radius*/
    if (radius > width / 2.0)
        radius = width / 2.0;
    if (radius > height / 2.0)
        radius = height / 2.0;

    CGFloat minx = CGRectGetMinX(roundedRect);
    CGFloat midx = CGRectGetMidX(roundedRect);
    CGFloat maxx = CGRectGetMaxX(roundedRect);
    CGFloat miny = CGRectGetMinY(roundedRect);
    CGFloat midy = CGRectGetMidY(roundedRect);
    CGFloat maxy = CGRectGetMaxY(roundedRect);

    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)drawRect:(CGRect)rect
{
    DLog(@"");

    [self drawRoundedRect:self.bounds
               withRadius:outerCornerRadius strokeWidth:outerStrokeWidth
              strokeColor:outerStrokeColor andFillColor:outerFillColor];

    if (drawInnerRect)
        [self drawRoundedRect:CGRectMake(JRR_INNER_RECT_INSET, JRR_INNER_RECT_INSET,
                self.bounds.size.width - (2 * JRR_INNER_RECT_INSET),
                self.bounds.size.height - (2 * JRR_INNER_RECT_INSET))
                   withRadius:innerCornerRadius strokeWidth:innerStrokeWidth
                  strokeColor:innerStrokeColor andFillColor:innerFillColor];
}

- (void)dealloc
{
}
@end

@interface JRPublishActivityController ()
@property(nonatomic) IBOutlet UIView *myBackgroundView;
@property(nonatomic) IBOutlet UITabBar *myTabBar;
@property(nonatomic) IBOutlet UILabel *myLoadingLabel;
@property(nonatomic) IBOutlet UIActivityIndicatorView *myLoadingActivitySpinner;
@property(nonatomic) IBOutlet UIView *myLoadingGrayView;
@property(nonatomic) IBOutlet UIView *myPadGrayEditingViewTop;
@property(nonatomic) IBOutlet UIView *myPadGrayEditingViewMiddle;
@property(nonatomic) IBOutlet UIView *myPadGrayEditingViewBottom;
@property(nonatomic) IBOutlet UIView *myContentView;
@property(nonatomic) IBOutlet UIScrollView *myScrollView;
@property(nonatomic) IBOutlet UITextView *myUserCommentTextView;
@property(nonatomic) IBOutlet JRRoundedRect *myUserCommentBoundingBox;
@property(nonatomic) IBOutlet UILabel *myRemainingCharactersLabel;
@property(nonatomic) IBOutlet UIView *myEntirePreviewContainer;
@property(nonatomic) IBOutlet JRRoundedRect *myPreviewContainerRoundedRect;
@property(nonatomic) IBOutlet JRPreviewLabel *myPreviewOfTheUserCommentLabel;
@property(nonatomic) IBOutlet JRRoundedRect *myRichDataContainer;
@property(nonatomic) IBOutlet UIButton *myMediaThumbnailView;
@property(nonatomic) IBOutlet UIActivityIndicatorView *myMediaThumbnailActivityIndicator;
@property(nonatomic) IBOutlet UILabel *myTitleLabel;
@property(nonatomic) IBOutlet UILabel *myDescriptionLabel;
@property(nonatomic) IBOutlet UIButton *myInfoButton;
@property(nonatomic) IBOutlet UILabel *myPoweredByLabel;
@property(nonatomic) IBOutlet UIImageView *myProviderIcon;
@property(nonatomic) IBOutlet UIView *myShareToView;
@property(nonatomic) IBOutlet UIImageView *myTriangleIcon;
@property(nonatomic) IBOutlet UIButton *myConnectAndShareButton;
@property(nonatomic) IBOutlet UIButton *myJustShareButton;
@property(nonatomic) IBOutlet UIButton *myProfilePic;
@property(nonatomic) IBOutlet UIActivityIndicatorView *myProfilePicActivityIndicator;
@property(nonatomic) IBOutlet UILabel *myUserName;
@property(nonatomic) IBOutlet UIButton *mySignOutButton;
@property(nonatomic) IBOutlet UIImageView *mySharedCheckMark;
@property(nonatomic) IBOutlet UILabel *mySharedLabel;
@property(nonatomic) JRProvider *selectedProvider;
@property(nonatomic) JRAuthenticatedUser *loggedInUser;
@property(nonatomic) JRSessionData *sessionData;
@property(nonatomic) JRActivityObject *currentActivity;
@property(nonatomic) NSDictionary *customInterface;
@property(nonatomic) NSMutableSet *alreadyShared;
@property(nonatomic) NSMutableDictionary *cachedProfilePics;
@property(nonatomic) UIView *titleView;
@property(nonatomic) NSTimer *timer;
@property(nonatomic) BOOL weAreCurrentlyPostingSomething;
@property(nonatomic, copy) NSString *shortenedActivityUrl;
@property(nonatomic) NSInteger maxCharacters;
@property(nonatomic) BOOL activityHasRichData;
@property(nonatomic) float mediaBoxHeight;
@property(nonatomic) float previewLabelHeight;
@property(nonatomic) NSUInteger selectedTab;
@property(nonatomic) BOOL weAreCurrentlyEditing;
@property(nonatomic) BOOL hasEditedUserContentForActivityAlready;
@property(nonatomic) BOOL userIsAttemptingToSignOut;
@property(nonatomic) BOOL mediaThumbnailFailedToDownload;
@property(nonatomic) BOOL weHaveJustAuthenticated;
@property(nonatomic) int emailAndOrSmsIndex;
@property(nonatomic) BOOL weAreStillWaitingOnSocialProviders;

- (void)addProvidersToTabBar;

- (void)determineIfWeCanShareViaEmailAndOrSMS;

- (void)loadActivityToViewForFirstTime;

- (void)sendEmail;

- (void)sendSMS;

- (void)showViewIsLoading:(BOOL)loading;

- (void)setProfilePicToDefaultPic;

- (void)fetchProfilePicFromUrl:(NSString *)profilePicUrl forProvider:(NSString *)providerName;

- (void)setButtonImage:(UIButton *)button toData:(NSData *)data andSetLoading:(UIActivityIndicatorView *)actIndicator
             toLoading:(BOOL)loading;
@end

@implementation JRPublishActivityController
@synthesize selectedProvider;
@synthesize myBackgroundView, myTabBar, myLoadingLabel, myLoadingActivitySpinner, myLoadingGrayView,
myPadGrayEditingViewTop, myPadGrayEditingViewMiddle, myPadGrayEditingViewBottom, myContentView, myScrollView,
myUserCommentTextView, myUserCommentBoundingBox, myRemainingCharactersLabel, myEntirePreviewContainer,
myPreviewContainerRoundedRect, myPreviewOfTheUserCommentLabel, myRichDataContainer, myMediaThumbnailView,
myMediaThumbnailActivityIndicator, myTitleLabel, myDescriptionLabel, myInfoButton, myPoweredByLabel, myProviderIcon,
myShareToView, myTriangleIcon, myConnectAndShareButton, myJustShareButton, myProfilePic, myProfilePicActivityIndicator,
myUserName, mySignOutButton, mySharedCheckMark, mySharedLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
   andCustomInterface:(NSDictionary *)theCustomInterface
{
    DLog(@"");
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        self.sessionData = [JRSessionData jrSessionData];
        self.currentActivity = [self.sessionData activity];
        self.customInterface = theCustomInterface;
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

    self.alreadyShared = [[NSMutableSet alloc] initWithCapacity:[self.sessionData.sharingProviders count]];
    self.cachedProfilePics = [[NSMutableDictionary alloc] initWithCapacity:[self.sessionData.sharingProviders count]];

    if ([[self.customInterface objectForKey:kJRSocialSharingTitleString] isKindOfClass:[NSString class]])
        self.title = NSLocalizedString([self.customInterface objectForKey:kJRSocialSharingTitleString], @"");
    else
        self.title = NSLocalizedString(@"Share", nil);

    /* Load the custom background view, if there is one. */
    if ([self.customInterface objectForKey:kJRSocialSharingBackgroundImageView])
        [myBackgroundView addSubview:[self.customInterface objectForKey:kJRSocialSharingBackgroundImageView]];

    [myBackgroundView setAlpha:0.3];

    /* If there is a UIColor object set for the background color, use this */
    if ([self.customInterface objectForKey:kJRSocialSharingBackgroundColor])
        myBackgroundView.backgroundColor = [self.customInterface objectForKey:kJRSocialSharingBackgroundColor];

    self.titleView = [self.customInterface objectForKey:kJRSocialSharingTitleView];

    if (self.titleView)
        self.navigationItem.titleView = self.titleView;

    if (!self.hidesCancelButton)
    {
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                     target:self.sessionData
                                     action:@selector(triggerPublishingDidCancel:)];

        self.navigationItem.leftBarButtonItem = cancelButton;
        self.navigationItem.leftBarButtonItem.enabled = YES;

        self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStylePlain;
    }

    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                 target:self
                                 action:@selector(editButtonPressed:)];

    self.navigationItem.rightBarButtonItem = editButton;
    self.navigationItem.rightBarButtonItem.enabled = YES;

    self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStylePlain;

    if ([self.sessionData hidePoweredBy])
    {
        [myPoweredByLabel setHidden:YES];
        [myInfoButton setHidden:YES];
    }

    /* Set RoundedRect defaults */
    [myPreviewContainerRoundedRect setOuterFillColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]];
    [myPreviewContainerRoundedRect setDrawInnerRect:YES];
    [myRichDataContainer setOuterFillColor:[UIColor lightGrayColor]];
    [myRichDataContainer setOuterStrokeColor:[UIColor lightGrayColor]];
    [myRichDataContainer setOuterCornerRadius:5.0];
    [myUserCommentBoundingBox setOuterStrokeColor:[UIColor darkGrayColor]];
    [myUserCommentBoundingBox setOuterFillColor:[UIColor whiteColor]];
    [myUserCommentBoundingBox setOuterStrokeWidth:1.5];
    [myUserCommentBoundingBox setAlpha:0.5];
    [myPreviewContainerRoundedRect setNeedsDisplay];
    [myRichDataContainer setNeedsDisplay];
    [myUserCommentBoundingBox setNeedsDisplay];

    [self determineIfWeCanShareViaEmailAndOrSMS];
    [self loadActivityToViewForFirstTime];

    /* If the user calls the library before the session data object is done initializing -
    because either the requests for the base URL or provider list haven't returned -
    display the "Loading Providers" label and activity spinner.
    sessionData = nil when the call to get the base URL hasn't returned
    [sessionData.configuredProviders count] = 0 when the provider list hasn't returned */
    if ([self.sessionData.sharingProviders count] == 0)
    {
        DLog(@"[[sessionData socialProviders] count] == 0");
        self.weAreStillWaitingOnSocialProviders = YES;

        myLoadingLabel.font = [UIFont systemFontOfSize:18.0];
        myLoadingLabel.text = NSLocalizedString(@"Loading providers. Please wait...", nil);

        /* Since the method showViewIsLoading will disable the "Cancel" button, re-enable it for this case */
        [self showViewIsLoading:YES];
        self.navigationItem.leftBarButtonItem.enabled = YES;

        /* Now poll every few milliseconds, for about 16 seconds, until the provider list is loaded or we time out. */
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self
                                                    selector:@selector(checkSessionDataAndProviders:) userInfo:nil
                                                     repeats:NO];
    }
    else
    {
        self.weAreStillWaitingOnSocialProviders = NO;
        [self addProvidersToTabBar];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    DLog(@"");
    [super viewWillAppear:animated];
    [self jrSetContentSizeForViewInPopover:self.view.frame.size];

    if (!self.titleView)
    {
        if ([self.customInterface objectForKey:kJRSocialSharingTitleString])
            self.navigationItem.title =
                NSLocalizedString([self.customInterface objectForKey:kJRSocialSharingTitleString], nil);
        else if (selectedProvider)
            self.navigationItem.title = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Share on", nil),
                                                                             selectedProvider.friendlyName];
        else
            self.navigationItem.title = NSLocalizedString(@"Share", nil);
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    DLog(@"");
    [super viewDidAppear:animated];

    if (!self.weAreStillWaitingOnSocialProviders && !self.weAreCurrentlyPostingSomething)
        [self showViewIsLoading:NO];
}

#define CONFIGURATION_TIMEOUT 32.0

/* If the user calls the library before the session data object is done initializing -
 because either the requests for the base URL or provider list haven't returned -
 keep polling every few milliseconds, for about 16 seconds,
 until the provider list is loaded or we time out. */
- (void)checkSessionDataAndProviders:(NSTimer *)theTimer
{
    static NSTimeInterval interval = 0.5;
    interval = interval + 0.5;

    self.timer = nil;

    DLog (@"Social Providers so far: %lu", (unsigned long)[self.sessionData.sharingProviders count]);

    /* If we have our list of providers, stop the progress indicators and load the table. */
    if ([self.sessionData.sharingProviders count] > 0)
    {
        self.weAreStillWaitingOnSocialProviders = NO;

        [self showViewIsLoading:NO];

        /* Set the loading label font/text back to default "Sharing..." */
        myLoadingLabel.font = [UIFont systemFontOfSize:24.0];
        myLoadingLabel.text = NSLocalizedString(@"Sharing...", nil);

        [self addProvidersToTabBar];

        return;
    }

    /* Otherwise, keep polling until we've timed out. */
    if (interval >= CONFIGURATION_TIMEOUT)
    {
        DLog(@"No Available Providers");

        [self showViewIsLoading:NO];

        NSString *message = NSLocalizedString(@"There are no available providers. Either there is a problem connecting or no providers "
                "have been configured. Please try again later.",nil);
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            DLog(@"");
            [self.sessionData triggerPublishingDidTimeOutConfiguration];
        }];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Available Providers" message:message alertActions:okAction, nil];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }

    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self
                                                selector:@selector(checkSessionDataAndProviders:)
                                                userInfo:nil repeats:NO];
}

/* That is, cover the view with a transparent gray box and a large white activity indicator. */
- (void)showViewIsLoading:(BOOL)loading
{
    DLog(@"");

    /* Don't let the user edit or cancel while the activity is being shared */
    self.navigationItem.leftBarButtonItem.enabled = !loading;
    self.navigationItem.rightBarButtonItem.enabled = !loading;

    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = loading;

    /* Gray/un-gray out the window */
    [myLoadingGrayView setHidden:!loading];

    /* and start/stop the activity spinner */
    if (loading)
        [myLoadingActivitySpinner startAnimating];
    else
        [myLoadingActivitySpinner stopAnimating];
}

- (NSString *)uiName
{
    NSString *const provName = self.selectedProvider.name;
    if ([provName isEqualToString:@"facebook"] && self.loggedInUser.displayName)
        return self.loggedInUser.displayName;
    else if ([provName isEqualToString:@"twitter"])
        return self.loggedInUser.preferredUsername;
    else // not sure what would be best for yahoo, linkedin, myspace
        return self.loggedInUser.preferredUsername;
}

- (void)showUserAsLoggedIn:(BOOL)loggedIn
{
    if (loggedIn)
        [myPreviewOfTheUserCommentLabel setUsername:[self uiName]];
    else
        [myPreviewOfTheUserCommentLabel setUsername:NSLocalizedString(@"You",nil)];

    [UIView beginAnimations:@"buttonSlide" context:nil];
    [myJustShareButton setHidden:!loggedIn];
    [myConnectAndShareButton setHidden:loggedIn];

    [myTriangleIcon setFrame:CGRectMake(loggedIn ?
            ([myTriangleIcon superview].frame.size.width - 90) :
            ([myTriangleIcon superview].frame.size.width / 2) - 9, 0, 18, 18)];

    [myProfilePic setHidden:!loggedIn];
    [myUserName setHidden:!loggedIn];
    [mySignOutButton setHidden:!loggedIn];
    [UIView commitAnimations];
}

- (void)showActivityAsShared:(BOOL)shared
{
    DLog(@"");
    [mySharedLabel setHidden:!shared];
    [mySharedCheckMark setHidden:!shared];

    if (self.loggedInUser)
        [myJustShareButton setHidden:shared];
    else
        [myConnectAndShareButton setHidden:shared];

    [myTriangleIcon setFrame:CGRectMake(shared ? 25 : ((self.loggedInUser) ?
            ([myTriangleIcon superview].frame.size.width - 90) :
            ([myTriangleIcon superview].frame.size.width / 2) - 9), 0, 18, 18)];

    if (!self.hidesCancelButton)
    {
        UIBarButtonItem *barButton;
        if (shared)
        {
            SEL triggerPublishingDidComplete = sel_registerName("triggerPublishingDidComplete:");
            barButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close",nil)
                                                          style:UIBarButtonItemStyleDone
                                                         target:self.sessionData
                                                         action:triggerPublishingDidComplete];
        }
        else
        {
            SEL cancelSel = @selector(triggerPublishingDidCancel:);
            barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                       target:self.sessionData
                                                                       action:cancelSel];
            self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStylePlain;
        }

        self.navigationItem.leftBarButtonItem = barButton;
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
}

- (void)updatePreviewTextWhenContentReplacesAction
{
    DLog(@"");
    NSString *username = (self.loggedInUser) ? [self uiName] : NSLocalizedString(@"You",nil);

    NSString *url = (self.shortenedActivityUrl) ?
            self.shortenedActivityUrl :
            NSLocalizedString(@"shortening url...",nil);

    NSString *text = (![[myUserCommentTextView text] isEqualToString:@""]) ?
            [myUserCommentTextView text] :
            [self.currentActivity action];

    [myPreviewOfTheUserCommentLabel setUsername:username];
    [myPreviewOfTheUserCommentLabel setUserText:text];

    if ([selectedProvider isActivityUrlPartOfUserContent])
    { /* Twitter/MySpace -> true */

        // TODO: Add ability to set colors to preview label (Janrain blue for links)
        // TODO: Fix size of url when long and on own line (shouldn't trunk at 3/4)
        [myPreviewOfTheUserCommentLabel setUrl:url];
    }
    else
    {
        [myPreviewOfTheUserCommentLabel setUrl:nil];
    }
}

- (void)updatePreviewTextWhenContentDoesNotReplaceAction
{
    DLog(@"");
    NSString *username = (self.loggedInUser) ? [self uiName] : NSLocalizedString(@"You",nil);
    NSString *text = self.currentActivity.action;

    [myPreviewOfTheUserCommentLabel setUsername:username];
    myPreviewOfTheUserCommentLabel.userText = text;
    [myPreviewOfTheUserCommentLabel setUrl:nil];
}

- (BOOL)shouldHideRemainingCharacterCount
{
    if (self.maxCharacters == -1 || self.maxCharacters > 500)
        return YES;

    return NO;
}

- (void)updateCharacterCount
{
    // TODO: verify correctness of the 0 remaining characters edge case
    NSString *characterCountText;

    if ([self shouldHideRemainingCharacterCount])
        return;

    NSInteger chars_remaining = 0;
    if ([selectedProvider doesContentReplaceAction])
    {
        /* Twitter, MySpace, LinkedIn */
        if ([selectedProvider isActivityUrlPartOfUserContent] && self.shortenedActivityUrl == nil)
        {
            /* Twitter, MySpace */
            characterCountText = NSLocalizedString(@"Calculating remaining characters", nil);
        }
        else
        {
            NSUInteger preview_length = [[myPreviewOfTheUserCommentLabel text] length];
            chars_remaining = self.maxCharacters - preview_length;

            characterCountText = [NSString stringWithFormat:NSLocalizedString(@"Remaining characters: %d", nil),
                                                            chars_remaining]; // TODO: Make just character number red
        }
    }
    else
    { /* Facebook, Yahoo */
        NSUInteger comment_length = [[myUserCommentTextView text] length];
        chars_remaining = self.maxCharacters - comment_length;

        characterCountText = [NSString stringWithFormat:@"Remaining characters: %ld",
                                                        (long)chars_remaining]; // TODO: Make just character number red
    }

    [myRemainingCharactersLabel setText:characterCountText];

    if (chars_remaining < 0)
    {
        // TODO: Make just character number red with attributed label
        [myRemainingCharactersLabel setTextColor:[UIColor redColor]];
    }
    else
        [myRemainingCharactersLabel setTextColor:[UIColor darkGrayColor]];

    DLog(@"updateCharacterCount: %@", characterCountText);
}

- (void)adjustPreviewContainerLayout
{
    DLog(@"");

    if ([selectedProvider canShareRichDataForActivity:self.currentActivity] && self.activityHasRichData)
    {
        [myEntirePreviewContainer setFrame:
                                          CGRectMake(myEntirePreviewContainer.frame.origin.x,
                                                  myEntirePreviewContainer.frame.origin.y,
                                                  myEntirePreviewContainer.frame.size.width,
                                                  self.mediaBoxHeight + self.previewLabelHeight + 32.0)];
        [myRichDataContainer setHidden:NO];
    }
    else
    {
        [myRichDataContainer setHidden:YES];
        [myEntirePreviewContainer setFrame:
                                          CGRectMake(myEntirePreviewContainer.frame.origin.x,
                                                  myEntirePreviewContainer.frame.origin.y,
                                                  myEntirePreviewContainer.frame.size.width,
                                                  self.previewLabelHeight + 28.0)];
    }

    CGFloat scrollViewContentHeight = myEntirePreviewContainer.frame.origin.y +
            myEntirePreviewContainer.frame.size.height + 10;

    if (IS_IPAD && (scrollViewContentHeight < myScrollView.frame.size.height))
        scrollViewContentHeight = myScrollView.frame.size.height;

    if (IS_IPAD)
    {
        [myPadGrayEditingViewTop setFrame:
                                         CGRectMake(myPadGrayEditingViewTop.frame.origin.x,
                                                 myPadGrayEditingViewTop.frame.origin.y,
                                                 myPadGrayEditingViewTop.frame.size.width,
                                                 scrollViewContentHeight)];
    }

    [myScrollView setContentSize:CGSizeMake(myScrollView.frame.size.width, scrollViewContentHeight)];

    [myPreviewContainerRoundedRect setNeedsDisplay];
}

- (void)previewLabel:(JRPreviewLabel *)previewLabel didChangeContentHeightFrom:(CGFloat)fromHeight
                  to:(CGFloat)toHeight;
{
    DLog(@"fromHeight: %f toHeight: %f", fromHeight, toHeight);
    self.previewLabelHeight = toHeight;
    [myRichDataContainer setFrame:
                                 CGRectMake(myRichDataContainer.frame.origin.x,
                                         myRichDataContainer.frame.origin.y + (toHeight - fromHeight),
                                         myRichDataContainer.frame.size.width,
                                         myRichDataContainer.frame.size.height)];
    [self adjustPreviewContainerLayout];


}

- (void)loadUserNameAndProfilePicForUser:(JRAuthenticatedUser *)user forProvider:(NSString *)providerName
{
    DLog(@"");
    myUserName.text = [self uiName];

    NSData *cachedProfilePic = [self.cachedProfilePics objectForKey:providerName];

    if (cachedProfilePic)
        [self setButtonImage:myProfilePic toData:cachedProfilePic andSetLoading:myProfilePicActivityIndicator
                   toLoading:NO];
    else if (user.photo)
        [self fetchProfilePicFromUrl:user.photo forProvider:providerName];
    else
        [self setProfilePicToDefaultPic];
}

#define EDITING_HEIGHT_OFFSET                     24
#define USER_CONTENT_TEXT_VIEW_DEFAULT_HEIGHT     72
#define USER_CONTENT_TEXT_VIEW_EDITING_HEIGHT    (USER_CONTENT_TEXT_VIEW_DEFAULT_HEIGHT    + EDITING_HEIGHT_OFFSET)
#define PREVIEW_BOX_DEFAULT_Y_ORIGIN              97
#define PREVIEW_BOX_EDITING_Y_ORIGIN             (PREVIEW_BOX_DEFAULT_Y_ORIGIN             + EDITING_HEIGHT_OFFSET)
#define USER_CONTENT_BOUNDING_BOX_DEFAULT_HEIGHT  78
#define USER_CONTENT_BOUNDING_BOX_EDITING_HEIGHT (USER_CONTENT_BOUNDING_BOX_DEFAULT_HEIGHT + EDITING_HEIGHT_OFFSET)
#define CHARACTER_COUNT_DEFAULT_Y_ORIGIN          90
#define CHARACTER_COUNT_EDITING_Y_ORIGIN         (CHARACTER_COUNT_DEFAULT_Y_ORIGIN         + EDITING_HEIGHT_OFFSET)

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    DLog(@"");

#if JRENGAGE_INCLUDE_EMAIL_SMS
    if (item.tag == [self.sessionData.sharingProviders count])
    {
        
        UIAlertController *alertController;
        
        switch (self.emailAndOrSmsIndex)
        {
            case JR_EMAIL_ONLY:
                [self sendEmail];
                break;
            case JR_SMS_ONLY:
                [self sendSMS];
                break;
            case JR_EMAIL_AND_SMS:
                
                alertController = [UIAlertController alertControllerWithTitle:@"Share with Email or SMS"
                                              message:nil
                                       preferredStyle:UIAlertControllerStyleActionSheet];
                
                 [alertController addAction:
                 [UIAlertAction actionWithTitle:NSLocalizedString(@"SMS", nil)
                                          style:UIAlertActionStyleDestructive
                                        handler:^(UIAlertAction *action) {
                                            NSLog(@"Sending SMS");
                                            [self sendSMS];
                                        }]];
                 
                [alertController addAction:
                 [UIAlertAction actionWithTitle:@"Email"
                                          style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction *action) {
                                            NSLog(@"Sending Email");
                                            [self sendEmail];
                                        }]];
                [alertController addAction:
                 [UIAlertAction actionWithTitle:@"Cancel"
                                          style:UIAlertActionStyleCancel
                                        handler:^(UIAlertAction *action) {
                                            NSLog(@"Cancelled");
                                            // Cancel button tappped.
                                            [self dismissViewControllerAnimated:YES completion:^{
                                            }];
                                            
                                        }]];
                
                [self presentViewController:alertController
                                   animated:YES
                                 completion:NULL];
                break;

        }
    }
    else
#endif
    {
        id key = [self.sessionData.sharingProviders objectAtIndex:(NSUInteger) item.tag];
        self.selectedProvider = [[self.sessionData allProviders] objectForKey:key];
        [self.sessionData setCurrentProvider:selectedProvider];

        self.loggedInUser = [self.sessionData authenticatedUserForProvider:selectedProvider];

        self.selectedTab = (NSUInteger) item.tag;

        NSArray *colorArray = [selectedProvider.socialSharingProperties objectForKey:@"color_values"];
        if ([colorArray count] == 4)
        {
            UIColor *bgColor = [UIColor colorWithRed:[((NSString *) [colorArray objectAtIndex:0]) floatValue]
                                               green:[((NSString *) [colorArray objectAtIndex:1]) floatValue]
                                                blue:[((NSString *) [colorArray objectAtIndex:2]) floatValue]
                                               alpha:0.2];
            myShareToView.backgroundColor = bgColor;

            UIColor *innerColor = [UIColor colorWithRed:[((NSString *) [colorArray objectAtIndex:0]) floatValue]
                                                  green:[((NSString *) [colorArray objectAtIndex:1]) floatValue]
                                                   blue:[((NSString *) [colorArray objectAtIndex:2]) floatValue]
                                                  alpha:1.0];
            myPreviewContainerRoundedRect.innerStrokeColor = innerColor;
            [myPreviewContainerRoundedRect setNeedsDisplay];
        }

        NSString *buttonFileName = [NSString stringWithFormat:@"button_%@_280x40.png", selectedProvider.name];
        [myConnectAndShareButton setBackgroundImage:[UIImage imageNamed:buttonFileName] forState:UIControlStateNormal];

        NSString *buttonFileName2 = [NSString stringWithFormat:@"button_%@_135x40.png", selectedProvider.name];
        [myJustShareButton setBackgroundImage:[UIImage imageNamed:buttonFileName2] forState:UIControlStateNormal];

        NSString *providerIconFileName = [NSString stringWithFormat:@"icon_%@_30x30.png", selectedProvider.name];
        myProviderIcon.image = [UIImage imageNamed:providerIconFileName];

        if (![self.customInterface objectForKey:kJRSocialSharingTitleString] &&
                ![self.customInterface objectForKey:kJRSocialSharingTitleView])
        {
            NSString *newText = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Share on", nil),
                                                                     selectedProvider.friendlyName];
            if (self.titleView) {
                 ((UILabel *) self.titleView).text = newText;
            } else {
                self.navigationItem.title = newText;
            }
        }
;

        self.currentActivity.userGeneratedContent = myUserCommentTextView.text;

        if (self.loggedInUser)
        {
            [self showUserAsLoggedIn:YES];
            [self loadUserNameAndProfilePicForUser:self.loggedInUser forProvider:selectedProvider.name];
        }
        else
        {
            [self showUserAsLoggedIn:NO];
        }

        BOOL thunkable = [selectedProvider willThunkPublishToStatusForActivity:self.currentActivity];
        if (thunkable)
            self.maxCharacters = [selectedProvider maxCharactersForSetStatus];
        else
            self.maxCharacters = [selectedProvider maxCharactersForPublishActivity];

        CGFloat editing = self.weAreCurrentlyEditing ? PREVIEW_BOX_EDITING_Y_ORIGIN : PREVIEW_BOX_DEFAULT_Y_ORIGIN;
        if ([self shouldHideRemainingCharacterCount])
        {
            [myRemainingCharactersLabel setHidden:YES];
            CGRect frame = CGRectMake(myEntirePreviewContainer.frame.origin.x,
                    editing,
                    myEntirePreviewContainer.frame.size.width,
                    myEntirePreviewContainer.frame.size.height);
            [myEntirePreviewContainer setFrame:frame];
        }
        else
        {
            [myRemainingCharactersLabel setHidden:NO];
            CGRect frame = CGRectMake(myEntirePreviewContainer.frame.origin.x,
                    editing + 10,
                    myEntirePreviewContainer.frame.size.width,
                    myEntirePreviewContainer.frame.size.height);
            [myEntirePreviewContainer setFrame:
                                              frame];
        }

        if ([selectedProvider doesContentReplaceAction] || thunkable)
            [self updatePreviewTextWhenContentReplacesAction];
        else
            [self updatePreviewTextWhenContentDoesNotReplaceAction];

        [self updateCharacterCount];

        [self adjustPreviewContainerLayout];
        [self showActivityAsShared:([self.alreadyShared containsObject:selectedProvider.name] ? YES : NO)];
    }
}

- (void)doneButtonPressed:(id)sender
{
    [myUserCommentTextView resignFirstResponder];
}

- (void)editButtonPressed:(id)sender
{
    [myUserCommentTextView becomeFirstResponder];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    DLog(@"");

    self.weAreCurrentlyEditing = YES;

    /* If the user hasn't entered their own content already, then clear the text view.
       Otherwise, just leave what they've already written. */
    if (!self.hasEditedUserContentForActivityAlready)
    {
        myUserCommentTextView.text = @"";
        self.hasEditedUserContentForActivityAlready = YES;
    }

    CGFloat remainingCharacterOffset =
            ([self shouldHideRemainingCharacterCount] ? 0 : 10);

    [self.alreadyShared removeAllObjects];
    [self showActivityAsShared:NO];

    [UIView beginAnimations:@"editing" context:nil];

    [myUserCommentTextView setFrame:CGRectMake(myUserCommentTextView.frame.origin.x,
            myUserCommentTextView.frame.origin.y,
            myUserCommentTextView.frame.size.width,
            USER_CONTENT_TEXT_VIEW_EDITING_HEIGHT)];

    [myUserCommentBoundingBox setFrame:CGRectMake(myUserCommentBoundingBox.frame.origin.x,
            myUserCommentBoundingBox.frame.origin.y,
            myUserCommentBoundingBox.frame.size.width,
            USER_CONTENT_BOUNDING_BOX_EDITING_HEIGHT)];

    [myRemainingCharactersLabel setFrame:CGRectMake(myRemainingCharactersLabel.frame.origin.x,
            CHARACTER_COUNT_EDITING_Y_ORIGIN,
            myRemainingCharactersLabel.frame.size.width,
            myRemainingCharactersLabel.frame.size.height)];

    [myEntirePreviewContainer setFrame:CGRectMake(myEntirePreviewContainer.frame.origin.x,
            PREVIEW_BOX_EDITING_Y_ORIGIN + remainingCharacterOffset,
            myEntirePreviewContainer.frame.size.width,
            myEntirePreviewContainer.frame.size.height)];

    CGFloat scrollViewContentHeight = myEntirePreviewContainer.frame.origin.y +
            myEntirePreviewContainer.frame.size.height + 10;

    if (IS_IPAD && (scrollViewContentHeight < myScrollView.frame.size.height))
        scrollViewContentHeight = myScrollView.frame.size.height;

    [myPadGrayEditingViewTop setFrame:CGRectMake(myPadGrayEditingViewTop.frame.origin.x,
            myPadGrayEditingViewTop.frame.origin.y,
            myPadGrayEditingViewTop.frame.size.width,
            scrollViewContentHeight)];

    [myScrollView setContentSize:CGSizeMake(myScrollView.frame.size.width, scrollViewContentHeight)];

    DLog(@"scrollViewContentHeight: %f", scrollViewContentHeight);

    if (!IS_IPAD)
    {
        [UIView commitAnimations];
    }
    else
    {
        [myPadGrayEditingViewTop setHidden:NO];
        [myPadGrayEditingViewBottom setHidden:NO];
        [myPadGrayEditingViewTop setAlpha:0.6];
        [myPadGrayEditingViewBottom setAlpha:0.6];
        [myUserCommentBoundingBox setAlpha:1.0];
        [UIView commitAnimations];
    }

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                 target:self
                                 action:@selector(doneButtonPressed:)];

    self.navigationItem.rightBarButtonItem = doneButton;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStyleDone;

    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    DLog(@"");

    self.weAreCurrentlyEditing = NO;

    /* If the user started to enter something, but didn't end up keeping anything, set
    the text back to what the activity's action was. (Aside: We could also set
    hasEditedUserContentForActivityAlready to "NO", clearing the action the next time
    they go to edit.  Currently, on second edit, the action stays, which I kinda like) */
    if (myUserCommentTextView.text.length == 0)
    {
        myUserCommentTextView.text = self.currentActivity.action;
    }

    CGFloat remainingCharacterOffset = ([self shouldHideRemainingCharacterCount] ? 0 : 10);

    [UIView beginAnimations:@"editing" context:nil];
    [myUserCommentTextView setFrame:CGRectMake(myUserCommentTextView.frame.origin.x,
            myUserCommentTextView.frame.origin.y,
            myUserCommentTextView.frame.size.width,
            USER_CONTENT_TEXT_VIEW_DEFAULT_HEIGHT)];

    [myUserCommentBoundingBox setFrame:CGRectMake(myUserCommentBoundingBox.frame.origin.x,
            myUserCommentBoundingBox.frame.origin.y,
            myUserCommentBoundingBox.frame.size.width,
            USER_CONTENT_BOUNDING_BOX_DEFAULT_HEIGHT)];

    [myRemainingCharactersLabel setFrame:CGRectMake(myRemainingCharactersLabel.frame.origin.x,
            CHARACTER_COUNT_DEFAULT_Y_ORIGIN,
            myRemainingCharactersLabel.frame.size.width,
            myRemainingCharactersLabel.frame.size.height)];

    [myEntirePreviewContainer setFrame:CGRectMake(myEntirePreviewContainer.frame.origin.x,
            PREVIEW_BOX_DEFAULT_Y_ORIGIN + remainingCharacterOffset,
            myEntirePreviewContainer.frame.size.width,
            myEntirePreviewContainer.frame.size.height)];

    CGFloat scrollViewContentHeight = myEntirePreviewContainer.frame.origin.y +
            myEntirePreviewContainer.frame.size.height + 10;

    if (IS_IPAD && (scrollViewContentHeight < myScrollView.frame.size.height))
        scrollViewContentHeight = myScrollView.frame.size.height;

    DLog(@"scrollViewContentHeight: %f", scrollViewContentHeight);

    [myPadGrayEditingViewTop setFrame:
                                     CGRectMake(myPadGrayEditingViewTop.frame.origin.x,
                                             myPadGrayEditingViewTop.frame.origin.y,
                                             myPadGrayEditingViewTop.frame.size.width,
                                             scrollViewContentHeight)];

    [myScrollView setContentSize:CGSizeMake(myScrollView.frame.size.width, scrollViewContentHeight)];

    if (!IS_IPAD)
    {
        [UIView commitAnimations];
    }
    else
    {
        [myPadGrayEditingViewTop setHidden:YES];
        [myPadGrayEditingViewBottom setHidden:YES];
        [myPadGrayEditingViewTop setAlpha:0.0];
        [myPadGrayEditingViewBottom setAlpha:0.0];
        [myUserCommentBoundingBox setAlpha:0.3];
        [UIView commitAnimations];
    }

    [myPreviewContainerRoundedRect setNeedsDisplay];

    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                 target:self
                                 action:@selector(editButtonPressed:)];

    self.navigationItem.rightBarButtonItem = editButton;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStylePlain;

    if (myUserCommentTextView.text.length > 0)
        [myUserCommentTextView scrollRangeToVisible:NSMakeRange(0, 1)];

    self.currentActivity.userGeneratedContent = myUserCommentTextView.text;

    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([selectedProvider doesContentReplaceAction] ||
            [selectedProvider willThunkPublishToStatusForActivity:self.currentActivity])
        [self updatePreviewTextWhenContentReplacesAction];
    else
        [self updatePreviewTextWhenContentDoesNotReplaceAction];

    [self updateCharacterCount];
}

- (void)sendEmail
{
#if JRENGAGE_INCLUDE_EMAIL_SMS
    MFMailComposeViewController *email = [[MFMailComposeViewController alloc] init];

    if (!email)
        return;

    email.mailComposeDelegate = self;

    [email setSubject:self.currentActivity.email.subject];
    [email setMessageBody:self.currentActivity.email.messageBody isHTML:self.currentActivity.email.isHtml];

    [self jrPresentViewController:email animated:YES];
#endif
}

- (void)sendSMS
{
#if JRENGAGE_INCLUDE_EMAIL_SMS
    MFMessageComposeViewController *sms = [[MFMessageComposeViewController alloc] init];

    if (!sms)
        return;

    sms.messageComposeDelegate = self;
    sms.body = self.currentActivity.sms.message;

    [self jrPresentViewController:sms animated:YES];
#endif
}

- (void)logUserOutForProvider:(NSString *)provider
{
    [self.sessionData forgetAuthenticatedUserForProvider:selectedProvider.name];
    [self.cachedProfilePics removeObjectForKey:selectedProvider.name];
    [self.alreadyShared removeObject:provider];

    self.loggedInUser = nil;

    [self showUserAsLoggedIn:NO];
    [self showActivityAsShared:NO];
}

- (IBAction)signOutButtonPressed:(id)sender
{
    DLog(@"");

    self.userIsAttemptingToSignOut = YES;

    NSObject *nameString = ([self uiName]) ? [NSString stringWithFormat:@" as %@", [self uiName]] : @"";
    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"You are currently signed in to %@%@. Would you like to sign out?", nil),
                                                 selectedProvider.friendlyName,
                                                 nameString];
   
    UIAlertController *alertController
    = [UIAlertController alertControllerWithTitle:title
                                          message:nil
                                   preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:
     [UIAlertAction actionWithTitle:@"Sign Out"
                              style:UIAlertActionStyleDestructive
                            handler:^(UIAlertAction *action) {
                                NSLog(@"Signing Out");
                                [self logUserOutForProvider:selectedProvider.name];
                            }]];
    [alertController addAction:
     [UIAlertAction actionWithTitle:@"Cancel"
                              style:UIAlertActionStyleCancel
                            handler:^(UIAlertAction *action) {
                                NSLog(@"Cancelled");
                                // Cancel button tappped.
                                [self dismissViewControllerAnimated:YES completion:^{
                                }];
                            }]];
    
    [self presentViewController:alertController
                       animated:YES
                     completion:NULL];
    
}



- (void)setButtonImage:(UIButton *)button toData:(NSData *)data andSetLoading:(UIActivityIndicatorView *)actIndicator
             toLoading:(BOOL)loading
{
    DLog (@"");

    if (!data && !loading)
    DLog (@"Problem downloading image");

    if (!data)
    {
        [button setImage:nil forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor darkGrayColor]];
    }
    else
    {
        [button setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
        [button.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [button setBackgroundColor:[UIColor whiteColor]];
    }

    if (loading)
        [actIndicator startAnimating];
    else
        [actIndicator stopAnimating];
}

- (void)setProfilePicToDefaultPic
{
    [myProfilePic setImage:[UIImage imageNamed:@"profilepic_placeholder.png"] forState:UIControlStateNormal];
    myProfilePic.backgroundColor = [UIColor clearColor];
    [myProfilePicActivityIndicator stopAnimating];
}

- (void)fetchProfilePicFromUrl:(NSString *)profilePicUrl forProvider:(NSString *)providerName
{
    DLog(@"");
    [self setButtonImage:myProfilePic toData:nil andSetLoading:myProfilePicActivityIndicator toLoading:YES];

    NSURL *url = [NSURL URLWithString:profilePicUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSString *tag = [providerName copy];

    if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self returnFullResponse:YES withTag:tag])
        [self setProfilePicToDefaultPic];
}

- (void)downloadMediaThumbnailsForActivity
{
    JRMediaObject *media = [self.currentActivity.media objectAtIndex:0];
    if ([media isKindOfClass:[JRImageMediaObject class]])
    {
        DLog (@"Downloading image thumbnail: %@", ((JRImageMediaObject *) media).src);
        [self setButtonImage:myMediaThumbnailView toData:nil andSetLoading:myMediaThumbnailActivityIndicator
                   toLoading:YES];

        NSURL *url = [NSURL URLWithString:((JRImageMediaObject *) media).src];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        NSString *tag = @"getThumbnail";

        if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self returnFullResponse:YES
                                                      withTag:tag])
            [self setButtonImage:myMediaThumbnailView toData:nil andSetLoading:myMediaThumbnailActivityIndicator
                       toLoading:NO];
    }
    else if ([media isKindOfClass:[JRFlashMediaObject class]])
    {
        DLog (@"Downloading image thumbnail: %@", ((JRFlashMediaObject *) media).imgsrc);
        [self setButtonImage:myMediaThumbnailView toData:nil andSetLoading:myMediaThumbnailActivityIndicator
                   toLoading:YES];

        NSURL *url = [NSURL URLWithString:((JRFlashMediaObject *) media).imgsrc];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        NSString *tag = @"getThumbnail";

        if (![JRConnectionManager createConnectionFromRequest:request forDelegate:self returnFullResponse:YES
                                                      withTag:tag])
            [self setButtonImage:myMediaThumbnailView toData:nil andSetLoading:myMediaThumbnailActivityIndicator
                       toLoading:NO];
    }
    else
    {
        [self setButtonImage:myMediaThumbnailView
                      toData:UIImagePNGRepresentation([UIImage imageNamed:@"music_note.jpg"])
               andSetLoading:myMediaThumbnailActivityIndicator
                   toLoading:NO];
    }
}

- (void)determineIfWeCanShareViaEmailAndOrSMS
{
#if JRENGAGE_INCLUDE_EMAIL_SMS
#else
    return;
#endif

    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));

    /* Check if the activity has an email object, sms string, or both and if we can send either or both.
     If so, emailOrSms will be 0, 1, 2, or 3, accordingly. */
    if (self.currentActivity.email && [mailClass canSendMail])  /* Add 1. */
        self.emailAndOrSmsIndex += JR_EMAIL;
    if (self.currentActivity.sms && [messageClass canSendText]) /* Add 2. */
        self.emailAndOrSmsIndex += JR_SMS;

    return;// emailAndOrSmsIndex;
}

/* MBC = Media Box Content */
/* Max height of the whole box is 83 (including title and description heights,
   5 px top/bottom padding, and 2 px interior padding).  The MBC max height is
   73 (max height minus the padding) */
#define MBC_MAX_HEIGHT       73.0
#define MBC_EXTERIOR_PADDING 10.0
#define MBC_INTERIOR_PADDING 2.0

- (void)loadActivityToViewForFirstTime
{
    DLog(@"");

    /* If the activity doesn't have a url, set the shortened url to an empty string,
     * otherwise, if it's nil, the updatePreviewText func will say "shortening url..." */
    if (!self.currentActivity.url)
        self.shortenedActivityUrl = @"";

    /* Set the user-comment text view's text and preview label to the activity's action.
     * We are safe using "updatePreviewTextWhenContentReplacesAction" here, because at
     * this point the content IS the action*/
    myUserCommentTextView.text = self.currentActivity.action;
    [self updatePreviewTextWhenContentReplacesAction];

    /* Determine if the activity has rich data (media, a title, or a description) or not */
    if (![self.currentActivity.resourceTitle length] && (![self.currentActivity.resourceDescription length]) &&
            ([self.currentActivity.media count] == 0 || self.mediaThumbnailFailedToDownload))
        self.activityHasRichData = NO;
    else
        self.activityHasRichData = YES;

    /* If it doesn't, we're done */
    if (self.activityHasRichData == NO)
    {
        [myRichDataContainer setHidden:YES];
        return;
    }

    /* Now, determine the sizes and appearance of the media box components (title, description, and media) based on
       their size and presence */

    /* Set up the default coordinates for the title and description and default height of the media box */
    CGFloat title_x = 46.0, title_y = 5.0, title_w = 224.0, title_h = 15.0;
    CGFloat descr_x = 46.0, descr_y = 22.0, descr_w = 224.0, descr_h = 56.0;

    /* This is the minimum height of the media box needed for the media thumbnail and padding If the title and descr
    are large enough, this size grows, and if there is no media and the title and descr are small, it shrinks. */
    self.mediaBoxHeight = 48.0;

    /* If we have media, and downloading its thumbnail hasn't failed, download it */
    if ([self.currentActivity.media count] > 0 && !self.mediaThumbnailFailedToDownload)
    {
        [self downloadMediaThumbnailsForActivity];
    }

            /* Otherwise, reposition the title and descr so that their x position equals 8.0 and their width is 262.0 */
    else
    {
        title_x = descr_x = 8.0;
        title_w = descr_w = 262.0;
    }

    /* If there is a title, set the title label's text and determine how much space the
       activity's title will potentially need */
    CGFloat shouldBeTitleHeight = 0;
    if (self.currentActivity.resourceTitle)
    {
        myTitleLabel.text = self.currentActivity.resourceTitle;

        // TODO: Verify change made below
        CGSize shouldBeTitleSize = [JRCompatibilityUtils jrGetSizeOfString:myTitleLabel.text
                                                                      font:myTitleLabel.font
                                                         constrainedToSize:CGSizeMake(title_w, MBC_MAX_HEIGHT)
                                                             lineBreakMode:JR_LINE_BREAK_MODE_TAIL_TRUNCATION];

        shouldBeTitleHeight = shouldBeTitleSize.height;
    }

    /* If there is a description, set the description label's text and determine how much
       space the activity's description will potentially need */
    CGFloat shouldBeDescriptionHeight = 0;
    if (self.currentActivity.resourceDescription)
    {
        myDescriptionLabel.text = self.currentActivity.resourceDescription;

        CGSize shouldBeDescriptionSize = [JRCompatibilityUtils jrGetSizeOfString:myDescriptionLabel.text
                                                                            font:myDescriptionLabel.font
                                                               constrainedToSize:CGSizeMake(descr_w, MBC_MAX_HEIGHT)
                                                                   lineBreakMode:(int)JR_LINE_BREAK_MODE_TAIL_TRUNCATION];

        shouldBeDescriptionHeight = shouldBeDescriptionSize.height;
    }

    /* There is no title or description */
    if (shouldBeTitleHeight == 0 && shouldBeDescriptionHeight == 0)
    {
        [myTitleLabel setHidden:YES];
        [myDescriptionLabel setHidden:YES];

        //return;
    }

            /* There is no title but there is a description */
    else if (shouldBeTitleHeight == 0 && shouldBeDescriptionHeight != 0)
    {
        descr_y = 5.0;

        if (shouldBeDescriptionHeight <= MBC_MAX_HEIGHT)
            descr_h = shouldBeDescriptionHeight;
        else
            descr_h = 70.0; /* The height of 5 lines of 11.0 pt. font, which is the most we can fit when we
                               don't have a title */

        /* If the description label is taller than our media thumbnail, or if we don't have a media thumbnail, set the
        media box height to the description label plus padding */
        if ((descr_h > 38.0) || ([self.currentActivity.media count] == 0))
            self.mediaBoxHeight = descr_h + MBC_EXTERIOR_PADDING; /* The padding above and below the
            title/description */

        [myTitleLabel setHidden:YES];
    }

            /* There is no description but there is a title */
    else if (shouldBeDescriptionHeight == 0 && shouldBeTitleHeight != 0)
    {
        if (shouldBeTitleHeight <= MBC_MAX_HEIGHT)
            title_h = shouldBeTitleHeight;
        else
            title_h = 60.0; /* The height of 4 lines of 12.0 pt. bold font, which is the most we can fit when we
                               don't have a title */

        /* If the title label is taller than our media thumbnail, or if we don't have a media thumbnail, set the media
           box height to the title label plus padding */
        if ((title_h > 38.0) || ([self.currentActivity.media count] == 0))
            self.mediaBoxHeight = title_h + MBC_EXTERIOR_PADDING; /* The padding above and below the title / 
            description */

        [myDescriptionLabel setHidden:YES];
    }

            /* There is a title and a description*/
    else /* if (shouldBeDescriptionHeight != 0 && shouldBeTitleHeight !=0 ) */
    {
        /* If both the title and description labels fit into the media box content height */
        if (shouldBeTitleHeight + shouldBeDescriptionHeight + MBC_INTERIOR_PADDING < MBC_MAX_HEIGHT) //71)
        {
            /* Let them keep their heights, and position the description label */
            title_h = shouldBeTitleHeight;
            descr_h = shouldBeDescriptionHeight;
            descr_y = shouldBeTitleHeight + 7.0; /* Title height + top padding + interior padding */

            /* If the title label and description labels are together taller than our media thumbnail, or if we don't
               have a media thumbnail, set the media box height to the title label height plus the description label
               height plus padding */
            if ((shouldBeTitleHeight + shouldBeDescriptionHeight > 38.0) || ([self.currentActivity.media count] == 0))
                self.mediaBoxHeight = shouldBeTitleHeight + shouldBeDescriptionHeight + MBC_EXTERIOR_PADDING +
                        MBC_INTERIOR_PADDING;
        }

                /* If both the title and description labels DON'T fit into the media box content height */
        else if (shouldBeTitleHeight + shouldBeDescriptionHeight + MBC_INTERIOR_PADDING >= MBC_MAX_HEIGHT)
        {
            /* If the title height is taller than one line of text and the description height is taller than four
            lines... */
            if (shouldBeTitleHeight >= 15 && shouldBeDescriptionHeight >= 56)
            {
                /* ... then keep things as they are (i.e., 1 line and 4 lines) */
            }

                    /* If the title height is taller than one line of text and the description height is SHORTER than 
                    four lines... */
            else if (shouldBeTitleHeight >= 15 && shouldBeDescriptionHeight < 56)
            {
                /* ... then make the description as tall as it needs to be and adjust the title to fit (e.g., 2 lines
                and 3 lines) */
                CGSize titleSize =
                        CGSizeMake(title_w, MBC_MAX_HEIGHT - MBC_INTERIOR_PADDING - shouldBeDescriptionHeight);
                CGSize shouldBeTitleSize = [JRCompatibilityUtils jrGetSizeOfString:myTitleLabel.text
                                                                              font:myTitleLabel.font
                                                                 constrainedToSize:titleSize
                                                                     lineBreakMode:JR_LINE_BREAK_MODE_TAIL_TRUNCATION];

                shouldBeTitleHeight = shouldBeTitleSize.height;
                title_h = shouldBeTitleHeight;
                descr_h = shouldBeDescriptionHeight;
                descr_y = shouldBeTitleHeight + 7.0; /* Title height + top padding + interior padding */
            }
            else if (shouldBeTitleHeight < 15 && shouldBeDescriptionHeight >= 56)
            {
                /* only happens if there is no title */
            }
            else if (shouldBeTitleHeight < 15 && shouldBeDescriptionHeight < 56)
            {
                /* moot case */
            }

            /* Because when we have both a title and descr, their combined height will always be more than 30?? */
            self.mediaBoxHeight = title_h + descr_h + 12.0;
        }
    }

    /* Now actually set the frames */
    [myTitleLabel setFrame:CGRectMake(title_x, title_y, title_w, title_h)];
    [myDescriptionLabel setFrame:CGRectMake(descr_x, descr_y, descr_w, descr_h)];
    [myRichDataContainer setFrame:CGRectMake(myRichDataContainer.frame.origin.x,
            self.previewLabelHeight + 20.0,
            myRichDataContainer.frame.size.width,
            self.mediaBoxHeight)];
    [myRichDataContainer setNeedsDisplay];
    [myEntirePreviewContainer setFrame:CGRectMake(myEntirePreviewContainer.frame.origin.x,
            myEntirePreviewContainer.frame.origin.y,
            myEntirePreviewContainer.frame.size.width,
            self.mediaBoxHeight + self.previewLabelHeight + 37.0)];

    [self adjustPreviewContainerLayout];
}

- (void)addProvidersToTabBar
{
    DLog(@"");

    NSUInteger numberOfTabs = [self.sessionData.sharingProviders count];
    NSUInteger indexOfLastUsedProvider = 0;
    BOOL weShouldAddTabForEmailAndOrSms = (BOOL) self.emailAndOrSmsIndex;

    if (weShouldAddTabForEmailAndOrSms)
        numberOfTabs++;

    NSMutableArray *providerTabArr = [[NSMutableArray alloc] initWithCapacity:numberOfTabs];

    for (NSUInteger i = 0; i < [self.sessionData.sharingProviders count]; i++)
    {
        JRProvider *provider =
                [self.sessionData.allProviders objectForKey:[self.sessionData.sharingProviders objectAtIndex:i]];

        if (!provider)
            break;

        NSString *imagePath = [NSString stringWithFormat:@"icon_bw_%@_30x30.png", provider.name];
        UITabBarItem *providerTab = [[UITabBarItem alloc] initWithTitle:provider.friendlyName
                                                                   image:[UIImage imageNamed:imagePath]
                                                                     tag:[providerTabArr count]];

        [providerTabArr insertObject:providerTab atIndex:[providerTabArr count]];

        if ([provider isEqualToReturningProvider:[self.sessionData returningSharingProvider]])
            indexOfLastUsedProvider = i;
    }

    if (weShouldAddTabForEmailAndOrSms)
    {

        NSString *simpleStrArray[6] = {
                NSLocalizedString(@"Email", nil),
                NSLocalizedString(@"Sms", nil),
                NSLocalizedString(@"Email/SMS", nil),
                NSLocalizedString(@"mail", nil),
                NSLocalizedString(@"sms", nil),
                NSLocalizedString(@"mail_sms", nil)};

        NSString *fileName = [NSString stringWithFormat:@"icon_bw_%@_30x30.png",
                                                        simpleStrArray[self.emailAndOrSmsIndex + 2]];
        UITabBarItem *emailTab = [[UITabBarItem alloc] initWithTitle:simpleStrArray[self.emailAndOrSmsIndex - 1]
                                                                image:[UIImage imageNamed:fileName]
                                                                  tag:[providerTabArr count]];

        [providerTabArr insertObject:emailTab atIndex:[providerTabArr count]];
    }

    [myTabBar setItems:providerTabArr animated:YES];

    // Question to self: Should we make the default selected social provider be the provider most commonly used
    if ([providerTabArr count])
    {
        myTabBar.selectedItem = [providerTabArr objectAtIndex:indexOfLastUsedProvider];
        [self tabBar:myTabBar didSelectItem:[providerTabArr objectAtIndex:indexOfLastUsedProvider]];
        self.selectedTab = indexOfLastUsedProvider;
    }
}

- (void)shareActivity
{
    DLog(@"");

    if ([selectedProvider willThunkPublishToStatusForActivity:self.currentActivity])
        [self.sessionData setStatusForUser:self.loggedInUser];
    else
        [self.sessionData shareActivityForUser:self.loggedInUser];
}

- (IBAction)shareButtonPressed:(id)sender
{
    DLog(@"");

    self.weAreCurrentlyPostingSomething = YES;

    if (myUserCommentTextView.text && self.hasEditedUserContentForActivityAlready)
        self.currentActivity.userGeneratedContent = myUserCommentTextView.text;

    [self.sessionData setCurrentProvider:selectedProvider];
    [self showViewIsLoading:YES];

    if (!self.loggedInUser)
    {
        /* Set weHaveJustAuthenticated to YES, so that when this view returns (for whatever reason... successful auth
           user canceled, etc), the view will know that we just went through the authentication process. */
        self.weHaveJustAuthenticated = YES;

        /* If the selected provider requires input from the user, go to the user landing view. Or if
           the user started on the user landing page, went back to the list of providers, then selected
           the same provider as their last-used provider, go back to the user landing view. */
        if (selectedProvider.requiresInput)
        {
            JRUserLandingController *landing = [JRUserInterfaceMaestro sharedMaestro].myUserLandingController;
            [[self navigationController] pushViewController:landing animated:YES];
        }
        else /* Otherwise, go straight to the web view. */
        {
            [[JRUserInterfaceMaestro sharedMaestro] pushWebViewFromViewController:self];
        }
    }
    else
    {
        [self shareActivity];
    }
}



- (void)connectionDidFinishLoadingWithPayload:(NSString *)payload request:(NSURLRequest *)request
                                       andTag:(id)userdata
{
}

- (void)connectionDidFinishLoadingWithFullResponse:(NSURLResponse *)fullResponse unencodedPayload:(NSData *)payload
                                           request:(NSURLRequest *)request andTag:(id)userdata
{
    DLog(@"");
    NSString *tag = (NSString *) userdata;

    if ([tag isEqualToString:@"getThumbnail"])
    {
        [self setButtonImage:myMediaThumbnailView toData:payload andSetLoading:myMediaThumbnailActivityIndicator
                   toLoading:NO];
    }
    else
    {
        if ([tag isEqualToString:selectedProvider.name])
        {
            [self setButtonImage:myProfilePic toData:payload andSetLoading:myProfilePicActivityIndicator toLoading:NO];
        }

        [self.cachedProfilePics setValue:payload forKey:tag];
    }
}

- (void)connectionDidFailWithError:(NSError *)error request:(NSURLRequest *)request andTag:(id)userdata
{
    DLog(@"");
    NSString *tag = (NSString *) userdata;

    if ([tag isEqualToString:@"getThumbnail"])
    {
        [self setButtonImage:myMediaThumbnailView toData:nil andSetLoading:myMediaThumbnailActivityIndicator
                   toLoading:NO];
        self.mediaThumbnailFailedToDownload = YES;
    }
    else
    {
        if ([tag isEqualToString:selectedProvider.name])
        {
            [self setProfilePicToDefaultPic];
        }
    }
}

- (void)connectionWasStoppedWithTag:(id)userdata
{
}

- (void)urlShortenedToNewUrl:(NSString *)url forActivity:(JRActivityObject *)activity
{
    DLog(@"");
    if (self.currentActivity == activity && url != nil)
    {
        self.shortenedActivityUrl = url;

        if (selectedProvider == nil)
            return;

        BOOL willThunk = [selectedProvider willThunkPublishToStatusForActivity:self.currentActivity];
        if ([selectedProvider doesContentReplaceAction] || willThunk)
            [self updatePreviewTextWhenContentReplacesAction];
        else
            [self updatePreviewTextWhenContentDoesNotReplaceAction];

        [self updateCharacterCount];
    }
}

- (void)authenticationDidRestart
{
    self.weAreCurrentlyPostingSomething = NO;
    self.weHaveJustAuthenticated = NO;
}

// Note to self: Probably need to comment this out, as authenticationDidCancel is something that publish activity
// should never have to worry about
- (void)authenticationDidCancel
{
    self.weAreCurrentlyPostingSomething = NO;
    self.weHaveJustAuthenticated = NO;
}

- (void)authenticationDidFailWithError:(NSError *)error forProvider:(NSString *)provider
{
    self.weHaveJustAuthenticated = NO;
    self.weAreCurrentlyPostingSomething = NO;
}

- (void)authenticationDidCompleteForUser:(NSDictionary *)profile forProvider:(NSString *)provider
{
    DLog(@"");

    myLoadingLabel.text = NSLocalizedString(@"Sharing...",nil);

    self.loggedInUser = [self.sessionData authenticatedUserForProvider:selectedProvider];

    // Question to self: Would we ever expect this to not be the case?
    if (self.loggedInUser)
    {
        [self showViewIsLoading:YES];
        [self loadUserNameAndProfilePicForUser:self.loggedInUser forProvider:provider];
        [self showUserAsLoggedIn:YES];

        [self shareActivity];
    }
    else
    {
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Shared",nil) message:NSLocalizedString(@"There was an error while sharing this activity.",nil) alertActions:okAction, nil];
        [self presentViewController:alertController animated:YES completion:nil];
        
        [self showViewIsLoading:NO];
        self.weAreCurrentlyPostingSomething = NO;
        self.weHaveJustAuthenticated = NO;
    }
}

- (void)publishingActivityDidSucceed:(JRActivityObject *)theActivity forProvider:(NSString *)provider;
{
    DLog(@"");

    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"You have successfully shared this activity.",nil)];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Shared",nil) message:message alertActions:okAction, nil];
    [self presentViewController:alertController animated:YES completion:nil];

    [self.alreadyShared addObject:provider];

    [self showViewIsLoading:NO];
    [self showActivityAsShared:YES];

    self.weAreCurrentlyPostingSomething = NO;
    self.weHaveJustAuthenticated = NO;
}

- (void)publishingDidCancel
{
    self.weAreCurrentlyPostingSomething = NO;
}

- (void)publishingDidComplete
{
    self.weAreCurrentlyPostingSomething = NO;
}

- (void)publishingActivity:(JRActivityObject *)activity didFailWithError:(NSError *)error
               forProvider:(NSString *)provider
{
    DLog(@"");
    NSString *errorMessage = nil;
    BOOL reauthenticate = NO;

    [self showViewIsLoading:NO];

    switch (error.code)
    {
        case JRPublishFailedError:
            errorMessage = [NSString stringWithFormat:
                    NSLocalizedString(@"There was an error while sharing this activity.", nil)];
            break;
        case JRPublishErrorDuplicateTwitter:
            errorMessage = [NSString stringWithFormat:
                    NSLocalizedString(@"There was an error while sharing this activity: Twitter does not allow duplicate status updates.", nil)];
            break;
        case JRPublishErrorCharacterLimitExceeded: /* ... was "JRPublishErrorLinkedInCharacterExceeded" */
            errorMessage = [NSString stringWithFormat:
                    NSLocalizedString(@"There was an error while sharing this activity: Status was too long.", nil)];
            break;
        case JRPublishErrorMissingApiKey:
            errorMessage = [NSString stringWithFormat:
                    NSLocalizedString(@"There was an error while sharing this activity.", nil)];
            reauthenticate = YES;
            break;
        case JRPublishErrorInvalidFacebookSession:  /* ... was "JRPublishErrorInvalidOauthKey" */
            errorMessage = [NSString stringWithFormat:
                    NSLocalizedString(@"There was an error while sharing this activity.", nil)];
            reauthenticate = YES;
            break;
        case JRPublishErrorMissingParameter:
            errorMessage = [NSString stringWithFormat:
                    NSLocalizedString(@"There was an error while sharing this activity.", nil)];
            break;
        default:
            errorMessage = [NSString stringWithFormat:
                    NSLocalizedString(@"There was an error while sharing this activity.", nil)];
            break;
    }

    /* OK, if this gets called right after authentication succeeds, then the navigation controller won't be done
       animating back to this view.  If this view isn't loaded yet, and we call shareButtonPressed, then the library
       will end up trying to push the WebView controller onto the navigation controller while the navigation controller
       is still trying to pop the WebView.  This creates craziness, hence we check for [self isViewLoaded].
       Also, this prevents an infinite loop of reauthing-failed publishing-reauthing-failed publishing.
       So, only try and reauthenticate is the publishing activity view is already loaded, which will only happen if we
       didn't JUST try and authorize, or if sharing took longer than the time it takes to pop the view controller. */
    if (reauthenticate && !self.weHaveJustAuthenticated)
    {
        [self logUserOutForProvider:provider];
        [self shareButtonPressed:nil];

        return;
    }

    self.weAreCurrentlyPostingSomething = NO;
    self.weHaveJustAuthenticated = NO;

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", nil)
                                                          message:errorMessage
                                                     alertActions:okAction, nil];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertController *alertController;
    switch (result)
    {
        case MFMailComposeResultSent:
            [self.sessionData triggerEmailSharingDidComplete];
            alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Success", nil)
                                                                  message:NSLocalizedString(@"You have successfully sent this email.", nil)
                                                             alertActions:okAction, nil];
            [self presentViewController:alertController animated:YES completion:nil];
            break;
        case MFMailComposeResultFailed:
            alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", nil)
                                                                  message:NSLocalizedString(@"Could not send email.  Please try again later.", nil)
                                                             alertActions:okAction, nil];
            [self presentViewController:alertController animated:YES completion:nil];
            break;
        default:
            break;
    }

    myTabBar.selectedItem = [myTabBar.items objectAtIndex:self.selectedTab];
    [self tabBar:myTabBar didSelectItem:[myTabBar.items objectAtIndex:self.selectedTab]];

    [self jrDismissViewControllerAnimated:YES];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertController *alertController;
    switch (result)
    {
        case MessageComposeResultSent:
            [self.sessionData triggerSmsSharingDidComplete];
            alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Success", nil)
                                                                  message:NSLocalizedString(@"You have successfully sent this text.", nil)
                                                             alertActions:okAction, nil];
            [self presentViewController:alertController animated:YES completion:nil];
            break;
        case MessageComposeResultFailed:
            alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", nil)
                                                                  message:NSLocalizedString(@"Could not send text.  Please try again later.", nil)
                                                             alertActions:okAction, nil];
            [self presentViewController:alertController animated:YES completion:nil];
            break;
        default:
            break;
    }

    myTabBar.selectedItem = [myTabBar.items objectAtIndex:self.selectedTab];
    [self tabBar:myTabBar didSelectItem:[myTabBar.items objectAtIndex:self.selectedTab]];

    [self jrDismissViewControllerAnimated:YES];
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

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    [myTriangleIcon setFrame:CGRectMake([self.alreadyShared containsObject:selectedProvider.name] ?
            25 :
            ((self.loggedInUser) ?
                    ([myTriangleIcon superview].frame.size.width - 90) :
                    ([myTriangleIcon superview].frame.size.width / 2) - 9), 0, 18, 18)];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [myUserCommentBoundingBox setNeedsDisplay];
    [myPreviewContainerRoundedRect setNeedsDisplay];
    [myRichDataContainer setNeedsDisplay];
}

- (void)viewWillDisappear:(BOOL)animated
{
    DLog(@"");
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    DLog(@"");
    [super viewDidDisappear:animated];
}

- (void)userInterfaceWillClose
{
    DLog(@"");

    [self showViewIsLoading:NO];
    [self.timer invalidate];

    [self loadActivityToViewForFirstTime];
}

- (void)userInterfaceDidClose
{
}

- (void)dealloc
{
    DLog(@"");

    self.loggedInUser = nil;
    self.currentActivity = nil;
    self.customInterface = nil;
    self.cachedProfilePics = nil;
    self.alreadyShared = nil;
    self.titleView = nil;
}
@end
