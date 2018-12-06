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

 File:   JRUserInterfaceMaestro.m
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Tuesday, August 24, 2010
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import "JREngage.h"
#import "debug_log.h"
#import "QuartzCore/QuartzCore.h"

#import "JRUserInterfaceMaestro.h"
#import "JREngage+CustomInterface.h"

#import "JRSessionData.h"
#import "JRProvidersController.h"
#import "JRUserLandingController.h"
#import "JRWebViewController.h"
#import "JRPublishActivityController.h"
#import "JRCompatibilityUtils.h"

static void handleCustomInterfaceException(NSException* exception, NSString* kJRKeyString)
{
    NSLog (@"*** Exception thrown. Problem is most likely with jrEngage custom interface object %@ : Caught %@ : %@",
                 (kJRKeyString ? [NSString stringWithFormat:@" possibly from kJRKeyString, %@", kJRKeyString] : @""),
                 [exception name],
                 [exception reason]);

#ifdef DEBUG
    @throw exception;
#else
    NSLog (@"*** Ignoring value and using defaults if possible.");
#endif
}

static CATransform3D normalizedCATransform3D(CATransform3D d);

// get the app window with some fallbacks for legacy bad behavior?
static UIWindow *getWindow()
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window) window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    return window;
}

// return the center of a view in it's own coordinate system
static CGPoint centerOfView(UIView *v)
{
    return CGPointMake(v.bounds.origin.x + v.bounds.size.width / 2, v.bounds.origin.y + v.bounds.size.height / 2);
}

// for each view in a chain of views from a view to a root view (:= a view with no superview),
// center the view in it's superview
static void centerViewChain(UIView *view)
{
    NSMutableArray *views = [NSMutableArray array];
    UIView *v = view;
    while (v && ![v isKindOfClass:[UIWindow class]])
    {
        [views insertObject:v atIndex:0];
        v = v.superview;
    }
    for (NSUInteger i = 0; i < [views count]; i++)
    {
        v = [views objectAtIndex:i];
        v.center = centerOfView(v.superview);
    }
}

static UIView *findUIDimmingView(UIView *v)
{
    while (v && ![v isKindOfClass:[UIWindow class]]) v = v.superview;
    if (![v isKindOfClass:[UIWindow class]]) return nil;
    UIWindow *window = (UIWindow *) v;
    for (UIView *subview in window.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UIDimmingView")]) return subview;
    }

    return nil;
}

static UIView *findUIDropShadowView(UIView *v)
{
    while (v && ![v isKindOfClass:NSClassFromString(@"UIDropShadowView")]) v = v.superview;
    if ([v isKindOfClass:NSClassFromString(@"UIDropShadowView")]) return v;
    return nil;
}

static CATransform3D computeTransformMatrix(CGRect rect, CGPoint p1, CGPoint p2, CGPoint p3, CGPoint p4)
{
    CGFloat X = rect.origin.x;
    CGFloat Y = rect.origin.y;
    CGFloat W = rect.size.width;
    CGFloat H = rect.size.height;
    CGFloat x1 = p1.x;
    CGFloat y1 = p1.y;
    CGFloat x2 = p2.x;
    CGFloat y2 = p2.y;
    CGFloat x3 = p3.x;
    CGFloat y3 = p3.y;
    CGFloat x4 = p4.x;
    CGFloat y4 = p4.y;

    CGFloat y21 = y2 - y1;
    CGFloat y32 = y3 - y2;
    CGFloat y43 = y4 - y3;
    CGFloat y14 = y1 - y4;
    CGFloat y31 = y3 - y1;
    CGFloat y42 = y4 - y2;

    CGFloat a = -H * (x2 * x3 * y14 + x2 * x4 * y31 - x1 * x4 * y32 + x1 * x3 * y42);
    CGFloat b = W * (x2 * x3 * y14 + x3 * x4 * y21 + x1 * x4 * y32 + x1 * x2 * y43);
    CGFloat c = H * X * (x2 * x3 * y14 + x2 * x4 * y31 - x1 * x4 * y32 + x1 * x3 * y42)
            - H * W * x1 * (x4 * y32 - x3 * y42 + x2 * y43)
            - W * Y * (x2 * x3 * y14 + x3 * x4 * y21 + x1 * x4 * y32 + x1 * x2 * y43);

    CGFloat d = H * (-x4 * y21 * y3 + x2 * y1 * y43 - x1 * y2 * y43 - x3 * y1 * y4 + x3 * y2 * y4);
    CGFloat e = W * (x4 * y2 * y31 - x3 * y1 * y42 - x2 * y31 * y4 + x1 * y3 * y42);
    CGFloat f = -(W * (x4 * (Y * y2 * y31 + H * y1 * y32) - x3 * (H + Y) * y1 * y42 + H * x2 * y1 * y43
            + x2 * Y * (y1 - y3) * y4 + x1 * Y * y3 * (-y2 + y4))
            - H * X * (x4 * y21 * y3 - x2 * y1 * y43 + x3 * (y1 - y2) * y4 + x1 * y2 * (-y3 + y4)));

    CGFloat g = H * (x3 * y21 - x4 * y21 + (-x1 + x2) * y43);
    CGFloat h = W * (-x2 * y31 + x4 * y31 + (x1 - x3) * y42);
    CGFloat i = W * Y * (x2 * y31 - x4 * y31 - x1 * y42 + x3 * y42) + H * (X * (-(x3 * y21)
            + x4 * y21 + x1 * y43 - x2 * y43) + W * (-(x3 * y2) + x4 * y2 + x2 * y3 - x4 * y3
            - x2 * y4 + x3 * y4));

    CATransform3D r;
    r.m11 = a; r.m12 = d; r.m13 = 0; r.m14 = g;
    r.m21 = b; r.m22 = e; r.m23 = 0; r.m24 = h;
    r.m31 = 0; r.m32 = 0; r.m33 = 1; r.m34 = 0;
    r.m41 = c; r.m42 = f; r.m43 = 0; r.m44 = i;

    return r;
}

static CATransform3D normalizedCATransform3D(CATransform3D d)
{
    CATransform3D r;
    r = d;
    CGFloat i = r.m44;
    r.m11 = r.m11/i; r.m12 = r.m12/i; r.m13 = r.m13/i; r.m14 = r.m14/i;
    r.m21 = r.m21/i; r.m22 = r.m22/i; r.m23 = r.m23/i; r.m24 = r.m24/i;
    r.m31 = r.m31/i; r.m32 = r.m32/i; r.m33 = r.m33/i; r.m34 = r.m34/i;
    r.m41 = r.m41/i; r.m42 = r.m42/i; r.m43 = r.m43/i; r.m44 = r.m44/i;
    return r;
}

@interface UIWindow (JRUtils)
-(BOOL)hasRvc;
@end

@implementation UIWindow (JRUtils)
-(BOOL)hasRvc
{
    return [self respondsToSelector:@selector(rootViewController)] && self.rootViewController;
}
@end

@interface UIViewController (JRUtils)
-(BOOL)hasPresentedViewController;
@end

@implementation UIViewController (JRUtils)
-(BOOL)hasPresentedViewController
{
    return [self respondsToSelector:@selector(presentedViewController)] && self.presentedViewController;
}
@end

// Provides a hand-made cover-vertical mimic animation to accommodate for iOS6 breaking the animation of the FormSheet
// size hacks
// Also forwards appearance and rotation events for iOS 4 iPads
@interface CustomAnimationController : UIViewController
@property  UIViewController *jrPresentingViewController;
@property  UIViewController *jrChildViewController;
@property  UIView *dropShadow;
@property  UIView *windowDimmingView;
@property(nonatomic) BOOL animating;
@property(nonatomic) BOOL delayedRotationWhileAnimating;
@property(nonatomic) BOOL havePerformedFirstAnimation;
@property(nonatomic) UIView *modalDimmingView;
@property(nonatomic) CATransform3D originalTransform;
@property(nonatomic) UIColor *originalDimmingViewColor;
@property(nonatomic) CGFloat originalZPosition;
@end

@implementation CustomAnimationController
@synthesize jrPresentingViewController;
@synthesize jrChildViewController;
@synthesize animating = _animating;
@synthesize delayedRotationWhileAnimating = _delayedRotationWhileAnimating;
@synthesize havePerformedFirstAnimation = _havePerformedFirstAnimation;
@synthesize modalDimmingView = _modalDimmingView;
@synthesize originalTransform = _originalTransform;
@synthesize originalDimmingViewColor = _originalDimmingViewColor;


- (void)loadView
{
    [self setView:[[UIView alloc] initWithFrame:MODAL_SIZE_FRAME]];
    self.view.backgroundColor = jrChildViewController.view.backgroundColor;
}

- (void)viewDidAppear:(BOOL)animated
{
    DLog(@"");
    [super viewDidAppear:animated];
    [jrChildViewController viewDidAppear:animated];
    if (animated) return;

    self.dropShadow = findUIDropShadowView(self.view);
    self.windowDimmingView = findUIDimmingView(self.view);

    // hack to resize platform provided dropshadow view that's inserted
    // into the view hierarchy above the modally presented VC when you use presentModalViewController
    // related to this SO q:
    // http://stackoverflow.com/questions/2457947/how-to-resize-a-uipresentationformsheet/4271364#4271364

    self.dropShadow.bounds = MODAL_SIZE_FRAME;

    centerViewChain(self.view);

    if (self.havePerformedFirstAnimation) return;
    self.havePerformedFirstAnimation = YES;

    // only do an animation if we found the Apple private views that we're going to tickle.
    if (self.dropShadow && self.windowDimmingView
            && [UIView respondsToSelector:@selector(animateWithDuration:delay:options:animations:completion:)])
        [self mimicFlipHorizontal];
}

- (void)mimicFlipHorizontal
{
    DLog(@"");
    self.animating = YES;
    self.originalTransform = self.dropShadow.layer.transform;
    self.originalZPosition = self.dropShadow.layer.zPosition;

    CGFloat height = MODAL_SIZE_FRAME.size.height + 20;
    CGFloat halfHeight = height / 2;
    CGFloat width = MODAL_SIZE_FRAME.size.height + 20;
    CGFloat halfWidth = width / 2;
    CGRect origRect = CGRectMake(-halfWidth, -halfHeight, width, height);
    CGPoint smushedP1 = CGPointMake(-halfWidth, -50);
    CGPoint smushedP2 = CGPointMake(halfWidth, -50);
    CGPoint smushedP3 = CGPointMake(-(halfWidth - 20), 50);
    CGPoint smushedP4 = CGPointMake(halfWidth - 20, 50);
    CGPoint unsmushedP1 = CGPointMake(-halfWidth, -halfHeight);
    CGPoint unsmushedP2 = CGPointMake(halfWidth, -halfHeight);
    CGPoint unsmushedP3 = CGPointMake(-halfWidth, halfHeight);
    CGPoint unsmushedP4 = CGPointMake(halfWidth, halfHeight);
    // calculate a smush transform that's like oglFlip
    CATransform3D smushed = computeTransformMatrix(origRect, smushedP1, smushedP2, smushedP3, smushedP4);
    // for some reason animating back to the original transform does some unwanted flips and rotations, so we make
    // this matrix, which allows the animation to interpolate correctly.
    CATransform3D unsmushed = computeTransformMatrix(origRect, unsmushedP1, unsmushedP2, unsmushedP3, unsmushedP4);
    unsmushed = CATransform3DConcat(normalizedCATransform3D(unsmushed), self.originalTransform);
    smushed = CATransform3DConcat(normalizedCATransform3D(smushed), self.originalTransform);

    // push it out in front of things
    self.dropShadow.layer.zPosition = 500;

    // smush
    self.dropShadow.layer.transform = smushed;

    // un-dim the background
    self.originalDimmingViewColor = self.windowDimmingView.backgroundColor;
    self.windowDimmingView.backgroundColor = [UIColor clearColor];

    // dim the modal
    self.modalDimmingView = [[UIView alloc] initWithFrame:MODAL_SIZE_FRAME];
    self.modalDimmingView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.modalDimmingView.backgroundColor = self.originalDimmingViewColor;
    [self.dropShadow addSubview:self.modalDimmingView];

    [UIView animateWithDuration:0.5 delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         // animate back
                         self.dropShadow.layer.transform = unsmushed;
                         self.windowDimmingView.backgroundColor = self.originalDimmingViewColor;
                         self.modalDimmingView.backgroundColor = [UIColor clearColor];
                     }
                     completion:^(BOOL finished) {
                         DLog(@"finished: %i animating:%i delayedRot: %i", finished, self.animating,
                             self.delayedRotationWhileAnimating);
                         if (!finished || !self.animating) return;
                         self.animating = NO;
                         // restore the transform because the computed matrix might not be equal to the original
                         // because of matrix homogenization and ...? and parts of the rest of the UI framework may
                         // rely on the original transforms numerical value
                         self.dropShadow.layer.transform = self.originalTransform;
                         self.dropShadow.layer.zPosition = self.originalZPosition;
                         
                         [self.modalDimmingView removeFromSuperview];
                         if (self.delayedRotationWhileAnimating)
                             [self attemptRotationWithoutAnimation];
                     }];
}

- (void)attemptRotationWithoutAnimation
{
    DLog(@"");
    // http://stackoverflow.com/questions/8594111/forcing-orientation-change
    [self.jrPresentingViewController jrDismissViewControllerAnimated:NO];
    [self.jrPresentingViewController jrPresentViewController:self animated:NO];
}

- (BOOL)shouldAutomaticallyForwardRotationMethods
{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    //return YES;
    BOOL b = [jrChildViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    //DLog(@"b:%i animating:%i orientation:%i", b, self.animating, toInterfaceOrientation);
    if (self.animating)
    {
        //DLog(@"delayed");
        self.delayedRotationWhileAnimating = b;
        return NO;
    }
    return b;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [jrChildViewController supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotate
{
    BOOL b = [jrChildViewController respondsToSelector:@selector(shouldAutorotate)] ?
         [jrChildViewController shouldAutorotate] : YES;
    //DLog(@"b: %i animating:%i", b, self.animating);
    if (self.animating)
    {
        //DLog(@"delayed");
        self.delayedRotationWhileAnimating = b;
        return NO;
    }
    return b;
}

- (void)cancelAnimation
{
    DLog(@"canceling");
    if (!_animating) return;
    self.animating = NO;
    CATransform3D zeros = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
    self.dropShadow.layer.transform = zeros;
    self.windowDimmingView.backgroundColor = [UIColor whiteColor];
    self.modalDimmingView.backgroundColor = [UIColor whiteColor];
    [UIView animateWithDuration:0 delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^()
                     {
                         self.dropShadow.layer.transform = self.originalTransform;
                         self.windowDimmingView.backgroundColor = self.originalDimmingViewColor;
                         self.modalDimmingView.backgroundColor = [UIColor clearColor];
                     }
                     completion:^(BOOL finished)
                     {
                         [self.modalDimmingView removeFromSuperview];
                     }];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    DLog(@"animating: %i", self.animating);
    [self cancelAnimation];
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [jrChildViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    DLog(@"animating: %i", self.animating);
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [jrChildViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [jrChildViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [jrChildViewController viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [jrChildViewController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [jrChildViewController viewDidDisappear:animated];
}

- (void)dealloc
{
}

@end

// Terrible, terrible hacks.
@interface JRModalViewController : UIViewController <UIPopoverControllerDelegate>
{
    BOOL shouldUnloadSubviews;
}
@property  CustomAnimationController *animationController;
@property  UINavigationController *myNavigationController;
@property UIPopoverPresentationController *myPopoverPresentationController;
@property  UIViewController *vcToPresent;
@end

@interface JRUserInterfaceMaestro () <UIPopoverPresentationControllerDelegate>
@property JRModalViewController *jrModalViewController;
@property UINavigationController *customModalNavigationController;
@property UINavigationController *applicationNavigationController;
@property UINavigationController *savedNavigationController;
@property NSDictionary *janrainInterfaceDefaults;
@property(nonatomic) NSDictionary *customInterface;
@end

@implementation JRModalViewController
@synthesize myNavigationController;
@synthesize animationController;
@synthesize vcToPresent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.animationController = [[CustomAnimationController alloc] initWithNibName:nil bundle:nil];
    }

    return self;
}

- (void)loadView
{
    DLog (@"");
    UIView *view = [[UIView alloc] initWithFrame:getWindow().frame];

    [view setAutoresizingMask:
            UIViewAutoresizingNone
            | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
            | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleLeftMargin |
            UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
    ];

    shouldUnloadSubviews = NO;

    [self setView:view];
}

- (void)presentModalNavigationController
{
    DLog (@"");
    UIViewController *rvc = [getWindow() hasRvc] ? getWindow().rootViewController : nil;

    myNavigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    myNavigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    animationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    animationController.modalPresentationStyle = myNavigationController.modalPresentationStyle;

    // Figure out what to present & set it up
    if (IS_IPAD)
    {
        self.vcToPresent = animationController;
        [animationController.view addSubview:myNavigationController.view];
        animationController.jrChildViewController = myNavigationController;
    }
    else
    {
        self.vcToPresent = myNavigationController;
    }

    // Figure out how to present & record how
    UIViewController *vcToPresentFrom;
    NSDictionary *customUi = [[JRUserInterfaceMaestro sharedMaestro] customInterface];
    if ([customUi objectForKey:kJRModalDialogPresentationViewController])
    {
        vcToPresentFrom = [customUi objectForKey:kJRModalDialogPresentationViewController];
    }
    else if (rvc && IOS5_OR_ABOVE)
    {
        // If we can, do it the right way, and do the animation by hand
        vcToPresentFrom = rvc;
        while ([vcToPresentFrom hasPresentedViewController]) vcToPresentFrom = vcToPresentFrom.presentedViewController;
    }
    else
    {
        // Do it the old, hack way
        [getWindow() addSubview:self.view];
        vcToPresentFrom = self;
    }
    animationController.jrPresentingViewController = vcToPresentFrom;

    [vcToPresentFrom jrPresentViewController:vcToPresent animated:!IS_IPAD];
}

- (void)viewDidAppear:(BOOL)animated
{
    DLog (@"");

    if (shouldUnloadSubviews)
        [self.view removeFromSuperview];

    [super viewDidAppear:animated];
}

- (void)dismissModalNavigationController:(UIModalTransitionStyle)style
{
    DLog (@"");

    if (self.myPopoverPresentationController)
    {
        [self.myNavigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        animationController.modalTransitionStyle = myNavigationController.modalTransitionStyle = style;
        [animationController.jrPresentingViewController jrDismissViewControllerAnimated:YES];
    }

    shouldUnloadSubviews = YES;

    [self.view removeFromSuperview];
}

// iOS >= 6
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

// iOS >= 6
-(BOOL)shouldAutorotate
{
    return YES;
}

// iOS <= 5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    DLog(@"");
    return YES;
}

- (void)dealloc
{
    DLog (@"");
}
@end

@implementation JRUserInterfaceMaestro
{
    JRSessionData *sessionData;
    NSMutableArray *delegates;

    PadPopoverMode padPopoverMode;
    // Pushing JUMP dialog VCs onto the host application's UINavigationController
    BOOL usingAppNav;
    BOOL isAppNavTranslucent;
    // Presenting custom UINavigationController and pushing JUMP dialog VCs onto it
    BOOL usingCustomNav;
    UIViewController *viewControllerToPopTo;
    NSDictionary *customInterface;
}

@synthesize myProvidersController;
@synthesize myUserLandingController;
@synthesize myWebViewController;
@synthesize myPublishActivityController;
@synthesize jrModalViewController;
@synthesize customModalNavigationController;
@synthesize applicationNavigationController;
@synthesize savedNavigationController;
@synthesize customInterfaceDefaults;
@synthesize janrainInterfaceDefaults;
@synthesize directProviderName;
@synthesize customInterface = customInterface;

static JRUserInterfaceMaestro *singleton = nil;

+ (JRUserInterfaceMaestro *)sharedMaestro
{
    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedMaestro];
}

- (id)copyWithZone:(__unused NSZone *)zone __unused
{
    return self;
}

- (NSDictionary*)loadJanrainInterfaceDefaults
{
    NSDictionary *infoPlist = [NSDictionary dictionaryWithContentsOfFile:
                               [[[NSBundle mainBundle] resourcePath]
                                stringByAppendingPathComponent:@"/JREngage-Info.plist"]];

    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                 [[infoPlist objectForKey:@"JREngage.CustomInterface"]
                                  objectForKey:@"DefaultValues"]];

    UIColor *backgroundColor = JANRAIN_BLUE_20;

    if (backgroundColor)
        [dict setObject:backgroundColor forKey:kJRAuthenticationBackgroundColor];

    return dict;
}

- (id)initWithSessionData:(JRSessionData*)newSessionData
{
    if ((self = [super init]))
    {
        singleton = self;
        sessionData = newSessionData;
        janrainInterfaceDefaults = [self loadJanrainInterfaceDefaults];
    }

    return self;
}

+ (id)jrUserInterfaceMaestroWithSessionData:(JRSessionData *)newSessionData
{
    if(singleton)
        return singleton;

    if (newSessionData == nil)
        return nil;

    return [((JRUserInterfaceMaestro *)[super allocWithZone:nil]) initWithSessionData:newSessionData];
}

- (void)buildCustomInterface:(NSDictionary *)customizations
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    [dict addEntriesFromDictionary:janrainInterfaceDefaults];
    [dict addEntriesFromDictionary:customInterfaceDefaults];
    [dict addEntriesFromDictionary:customizations];

    NSArray *nullKeys = [dict allKeysForObject:[NSNull null]];
    for (NSString *key in nullKeys)
        [dict removeObjectForKey:key];

    self.customInterface = [NSDictionary dictionaryWithDictionary:dict];
}

- (void)setUpDialogPresentation {
    if ([customInterface objectForKey:kJRApplicationNavigationController])
        self.applicationNavigationController = [customInterface objectForKey:kJRApplicationNavigationController];

    /* Added for backwards compatibility */
    if (savedNavigationController)
        self.applicationNavigationController = savedNavigationController;

    if ([customInterface objectForKey:kJRCustomModalNavigationController])
        self.customModalNavigationController = [customInterface objectForKey:kJRCustomModalNavigationController];

    usingAppNav = NO;
    usingCustomNav = NO;
    if (IS_IPAD) {
        if ([customInterface objectForKey:kJRPopoverPresentationBarButtonItem])
            padPopoverMode = PadPopoverFromBar;
        else if ([customInterface objectForKey:kJRPopoverPresentationFrameValue])
            padPopoverMode = PadPopoverFromFrame;
        else
            padPopoverMode = PadPopoverModeNone;

        @try {
            if (customModalNavigationController)
                usingCustomNav = YES;
            else
                usingCustomNav = NO;
        } @catch (NSException *exception) {
            handleCustomInterfaceException(exception, @"kJRUseCustomModalNavigationController");
        }
    } else {
        @try {
            if (applicationNavigationController && [applicationNavigationController isViewLoaded]) {
                usingAppNav = YES;
            } else if (customModalNavigationController) {
                usingCustomNav = YES;
            }
        }
        @catch (NSException *exception)
        { handleCustomInterfaceException(exception, @"kJRUseApplicationNavigationController"); }
    }
}

- (BOOL)canRotate
{
    return usingAppNav || IS_IPAD || [getWindow() hasRvc];
}

- (void)tearDownDialogPresentation
{
    padPopoverMode = PadPopoverModeNone;
    usingAppNav = NO;
    usingCustomNav = NO;

    viewControllerToPopTo = nil;
    self.applicationNavigationController = nil;
    self.customModalNavigationController = nil;
}

- (void)setUpViewControllers
{
    DLog(@"");
    myProvidersController       = [[JRProvidersController alloc] initWithNibName:@"JRProvidersController"
                                                                          bundle:[NSBundle mainBundle]
                                                              andCustomInterface:customInterface];

    myUserLandingController     = [[JRUserLandingController alloc] initWithNibName:@"JRUserLandingController"
                                                                            bundle:[NSBundle mainBundle]
                                                                andCustomInterface:customInterface];

    myWebViewController         = [[JRWebViewController alloc] initWithNibName:@"JRWebViewController"
                                                                        bundle:[NSBundle mainBundle]
                                                            andCustomInterface:customInterface];

    myPublishActivityController = [[JRPublishActivityController alloc] initWithNibName:@"JRPublishActivityController"
                                                                                bundle:[NSBundle mainBundle]
                                                                    andCustomInterface:customInterface];

    @try
    {
        // We do this here, because sometimes we pop straight to the user landing controller and we need the
        // back-button's title to be correct
        if ([customInterface objectForKey:kJRProviderTableTitleString] &&
            ((NSString *)[customInterface objectForKey:kJRProviderTableTitleString]).length)
            myProvidersController.title = [customInterface objectForKey:kJRProviderTableTitleString];
        else
            myProvidersController.title = @"Providers";
    }
    @catch (NSException *exception)
    {
        handleCustomInterfaceException(exception, @"kJRProviderTableTitleString");
        myProvidersController.title = @"Providers";
    }

    if (/*usingAppNav || */(IS_IPAD && padPopoverMode != PadPopoverModeNone) ||
        [[customInterface objectForKey:kJRNavigationControllerHidesCancelButton] boolValue])
    {
        myProvidersController.hidesCancelButton = YES;
        myPublishActivityController.hidesCancelButton = YES;
    }

    delegates = [[NSMutableArray alloc] initWithObjects:myProvidersController,
                 myUserLandingController,
                 myWebViewController,
                 myPublishActivityController, nil];
}

- (void)tearDownViewControllers
{
    DLog(@"");

    [[NSNotificationCenter defaultCenter] postNotificationName:@"JRTearingDownViewControllers" object:self];

    [delegates removeAllObjects];
    delegates = nil;

    myProvidersController = nil;
    myUserLandingController = nil;
    myWebViewController = nil;
    myPublishActivityController = nil;

    jrModalViewController = nil;
    customModalNavigationController = nil;

    self.customInterface = nil;
    directProviderName = nil;

    sessionData.authenticationFlowIsInFlight = NO;
}

- (void)setUpSocialPublishing
{
    DLog(@"");
    [sessionData setSocialSharing:YES];

    if (myPublishActivityController)
        [sessionData addDelegate:myPublishActivityController];
}

- (void)tearDownSocialPublishing
{
    DLog(@"");
    [sessionData setSocialSharing:NO];
    [sessionData setActivity:nil];

    if (myPublishActivityController)
        [sessionData removeDelegate:myPublishActivityController];
}

- (UINavigationController *)createDefaultNavigationControllerWithRootViewController:(UIViewController *)root
{
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:root];

    navigationController.navigationBar.barStyle = UIBarStyleBlack;
    navigationController.navigationBar.clipsToBounds = YES;

    navigationController.view.autoresizingMask =
            UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
            | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    navigationController.view.bounds = MODAL_SIZE_FRAME;

    return navigationController;
}

-(UIPopoverPresentationController *)createPopoverPresentationControllerWithController:(UINavigationController *) navigationController {
    navigationController.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popoverPC = [navigationController popoverPresentationController];
    popoverPC.delegate = self;
    popoverPC.barButtonItem = [self.customInterface objectForKey:kJRPopoverPresentationBarButtonItem];
    
    return popoverPC;
}

- (BOOL)shouldOpenToUserLandingPage
{
   /* Test to see if we should open the authentication dialog to the returning user landing page.
    *
    * We will only open to the user landing page if the following conditions are met:
    *   a. If we have a returning provider (the provider the user most recently signed in with);
    *   b. if there is a saved user for the returning provider (the only time this wouldn't be the case
    *         is when upgrading the library and the saved users couldn't be deserialized);
    *   c. if we don't have a currently selected provider (which will be the case when we're signing in directly
    *         to one provider);
    *   d. if alwaysForceReauth isn't set to 'true'
    *   e. if the returning provider (the provider the user most recently signed in with) isn't set to
    *         alwaysForceReath
    *   f. if we aren't opening the social sharing dialog (i.e., we are only authenticating);
    *   g. the returning provider is still in the list of providers configured with the RP (between the last
    *        time they logged in and now);
    *   h. and the returning provider hasn't been excluded from the list of providers.
    *
    * The last two cases will only happen if the user signs in with a particular provider once (which is then set as
    * the returningBasicProvider), and then the list of providers changes between the first sign in and when they
    * log in again.  If the RP's configuration has changed and their last-used provider has been dropped, but the
    * configuration call hasn't returned from the server yet, then this case may fall through the cracks (although
    * this case is very unlikely to happen). */
    if (sessionData.returningAuthenticationProvider                                                      /* a */
        && [sessionData authenticatedUserForProviderNamed:sessionData.returningAuthenticationProvider]   /* b */
        && !sessionData.currentProvider                                                         /* c */
        && !sessionData.alwaysForceReauth                                                       /* d */
        && ![sessionData getProviderNamed:sessionData.returningAuthenticationProvider].forceReauthStartUrlFlag       /* e */
        && !sessionData.socialSharing                                                           /* f */
        && [sessionData.authenticationProviders containsObject:sessionData.returningAuthenticationProvider]       /* g */
        && ![((NSArray *)[customInterface objectForKey:kJRRemoveProvidersFromAuthentication])    /* h */
                    containsObject:sessionData.returningAuthenticationProvider])
        return YES;

    return NO;
}

- (void)loadModalNavigationControllerWithViewController:(UIViewController *)rootViewController
{
    DLog(@"");

    self.jrModalViewController = [[JRModalViewController alloc] initWithNibName:nil bundle:nil];

    if (usingCustomNav)
    {
        jrModalViewController.myNavigationController = customModalNavigationController;
        jrModalViewController.myNavigationController.navigationBar.clipsToBounds = YES;
        jrModalViewController.myNavigationController.view.autoresizingMask =
                UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
                | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        jrModalViewController.myNavigationController.view.bounds = MODAL_SIZE_FRAME;
        [jrModalViewController.myNavigationController pushViewController:rootViewController animated:NO];
    }
    else
    {
        jrModalViewController.myNavigationController =
                [self createDefaultNavigationControllerWithRootViewController:rootViewController];
    }

    if (padPopoverMode) {
        self.jrModalViewController.myPopoverPresentationController = [self createPopoverPresentationControllerWithController:jrModalViewController.myNavigationController];
        
    }

    /* If the code is used by a universal application and is compiled for versions of iOS that don't
       support UIPopoverControllers (i.e., iOS < v3.2), this will return nil;  If it does, fall back
       to modal dialog presentation. This might never happen, because the above code wouldn't be called
       on the iPhone anyway... */
    if (!jrModalViewController.myPopoverPresentationController)
        padPopoverMode = PadPopoverModeNone;

    
    // Deprecated - value not used
    /*
    UIPopoverArrowDirection arrowDirection = UIPopoverArrowDirectionAny;
    if ([customInterface objectForKey:kJRPopoverPresentationArrowDirection])
    {
        arrowDirection = (UIPopoverArrowDirection)
                [[customInterface objectForKey:kJRPopoverPresentationArrowDirection] intValue];
    }
    */

    if ([self shouldOpenToUserLandingPage])
    {
        [sessionData setCurrentProvider:[sessionData getProviderNamed:sessionData.returningAuthenticationProvider]];
        [jrModalViewController.myNavigationController pushViewController:myUserLandingController animated:NO];
    }

    if (padPopoverMode == PadPopoverFromBar)
    {
        [[self.customInterface objectForKey:kJRApplicationNavigationController]
         presentViewController:self.jrModalViewController.myNavigationController animated:YES completion:nil];
    }
    else
    {
        [jrModalViewController presentModalNavigationController];
    }
    
    
}

- (void)loadApplicationNavigationControllerWithViewController:(UIViewController *)rootViewController
{
    DLog(@"");
    if (!viewControllerToPopTo)
    {
        viewControllerToPopTo = [applicationNavigationController topViewController];
    }

    if ([self shouldOpenToUserLandingPage])
    {
        [sessionData setCurrentProvider:[sessionData getProviderNamed:sessionData.returningAuthenticationProvider]];
        [applicationNavigationController pushViewController:rootViewController animated:NO];
        [applicationNavigationController pushViewController:myUserLandingController animated:YES];
    }
    else
    {
        [applicationNavigationController pushViewController:rootViewController animated:YES];
    }
}

- (JRProvider *)directProvider
{
    if (directProviderName)
        return [sessionData getProviderNamed:directProviderName];

    return nil;
}

- (void)showAuthenticationDialogWithCustomInterface:(NSDictionary *)customizations
{
    DLog(@"");
    [self buildCustomInterface:customizations];
    [self setUpDialogPresentation];
    [self setUpViewControllers];

    UIViewController *dialogVcToPresent;
    if ((sessionData.currentProvider = [self directProvider]))
        dialogVcToPresent = sessionData.currentProvider.requiresInput ? myUserLandingController : myWebViewController;
    else
        dialogVcToPresent = myProvidersController;

    if (dialogVcToPresent == myWebViewController)
        [sessionData.currentProvider forceReauth];

    if (usingAppNav)
        [self loadApplicationNavigationControllerWithViewController:dialogVcToPresent];
    else
        [self loadModalNavigationControllerWithViewController:dialogVcToPresent];
}

- (void)showPublishingDialogForActivityWithCustomInterface:(NSDictionary *)customizations
{
    DLog(@"");
    [self buildCustomInterface:customizations];
    [self setUpDialogPresentation];
    [self setUpViewControllers];
    [self setUpSocialPublishing];

    if (usingAppNav)
        [self loadApplicationNavigationControllerWithViewController:myPublishActivityController];
    else
        [self loadModalNavigationControllerWithViewController:myPublishActivityController];
}

- (void)unloadApplicationNavigationController
{
    DLog(@"");
    [applicationNavigationController popToViewController:viewControllerToPopTo animated:YES];
}

- (void)unloadUserInterfaceWithTransitionStyle:(UIModalTransitionStyle)style
{
    DLog(@"");
    if (!(sessionData.authenticationFlowIsInFlight || [sessionData socialSharing]))
        return;

    if ([sessionData socialSharing])
        [self tearDownSocialPublishing];

    for (id <JRUserInterfaceDelegate> delegate in delegates)
        [delegate userInterfaceWillClose];

    if (usingAppNav) {
        [self unloadApplicationNavigationController];
    } else {
        DLog(@"");
        [jrModalViewController dismissModalNavigationController:style];
    }

    for (id<JRUserInterfaceDelegate> delegate in delegates)
        [delegate userInterfaceDidClose];

    [self tearDownViewControllers];
    [self tearDownDialogPresentation];
}

- (void)popToOriginalRootViewController
{
    DLog(@"");
    UIViewController *originalRootViewController = nil;

    if ([sessionData socialSharing])
        originalRootViewController = myPublishActivityController;
    else
        originalRootViewController = myProvidersController;

    if (usingAppNav && applicationNavigationController && [applicationNavigationController isViewLoaded])
    {
        if ([[applicationNavigationController viewControllers] containsObject:originalRootViewController])
            [applicationNavigationController popToViewController:originalRootViewController animated:YES];
        else
            [self unloadUserInterfaceWithTransitionStyle:UIModalTransitionStyleCoverVertical];
    }
    else
    {
        if ([jrModalViewController.myNavigationController.viewControllers containsObject:originalRootViewController])
            [jrModalViewController.myNavigationController popToRootViewControllerAnimated:YES];
        else
            [self unloadUserInterfaceWithTransitionStyle:UIModalTransitionStyleCoverVertical];
    }
}

- (void)authenticationRestarted
{
    DLog(@"");
    [self popToOriginalRootViewController];
}

- (void)authenticationCompleted
{
    DLog(@"");
    if (![sessionData socialSharing]) {
        [self unloadUserInterfaceWithTransitionStyle:UIModalTransitionStyleCrossDissolve];
    } else {
        [self popToOriginalRootViewController];
    }
}

- (void)authenticationFailed
{
    DLog(@"");
    [self popToOriginalRootViewController];
}

- (void)authenticationCanceled
{
    DLog(@"");
    [self unloadUserInterfaceWithTransitionStyle:UIModalTransitionStyleCoverVertical];
}

- (void)publishingCompleted
{
    DLog(@"");
    [self unloadUserInterfaceWithTransitionStyle:UIModalTransitionStyleCoverVertical];
}

- (void)publishingCanceled
{
    DLog(@"");
    [self unloadUserInterfaceWithTransitionStyle:UIModalTransitionStyleCoverVertical];
}

- (void)dealloc
{
}

- (void)startWebAuthWithCustomInterface:(NSDictionary *)customInterfaceOverrides provider:(NSString *)provider
{
    self.directProviderName = provider;
    sessionData.authenticationFlowIsInFlight = YES;

    [self showAuthenticationDialogWithCustomInterface:customInterfaceOverrides];
}

- (void)pushWebViewFromViewController:(UIViewController *)viewController
{
    if (viewController != myUserLandingController)
        [sessionData.currentProvider forceReauth];
    [[viewController navigationController] pushViewController:[JRUserInterfaceMaestro sharedMaestro].myWebViewController
                                                     animated:YES];
}

#pragma mark - UIPopoverPresentationControllerDelegate
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    DLog (@"");
    
    if ([sessionData socialSharing])
        [sessionData triggerPublishingDidCancel];
    else
        [sessionData triggerAuthenticationDidCancel];
}
@end
