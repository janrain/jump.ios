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

 File:   JRUserInterfaceMaestro.h
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Tuesday, August 24, 2010
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class JRSessionData;
@class JRModalViewController;
@class JRProvidersController;
@class JRUserLandingController;
@class JRWebViewController;
@class JRPublishActivityController;

#define MODAL_SIZE_FRAME (CGRectMake(0, 0, 320, 548))
#define JANRAIN_BLUE    ([UIColor colorWithRed:0.102 green:0.33 blue:0.48 alpha:1.0])
#define JANRAIN_BLUE_20 ([UIColor colorWithRed:0.102 green:0.33 blue:0.48 alpha:0.2])
#define IS_IPAD ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
#define IS_IPHONE (!IS_IPAD)
//#define IOS6_OR_ABOVE ([[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] >= NSOrderedSame)
#define IOS5_OR_ABOVE ([[[UIDevice currentDevice] systemVersion] compare:@"5.0" options:NSNumericSearch] >= NSOrderedSame)
//#define IOS4_OR_ABOVE ([[[UIDevice currentDevice] systemVersion] compare:@"4.0" options:NSNumericSearch] >= NSOrderedSame)
//#define IS_PORTRAIT (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
//#define IS_LANDSCAPE (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
    typedef NSLineBreakMode JRLineBreakMode;

#  define JR_TEXT_ALIGN_CENTER (NSTextAlignmentCenter)
#  define JR_TEXT_ALIGN_LEFT (NSTextAlignmentLeft)
#  define JR_LINE_BREAK_MODE_TAIL_TRUNCATION (NSLineBreakByTruncatingTail)
#  define JR_LINE_BREAK_MODE_WORD_WRAP (NSLineBreakByWordWrapping)
#else
    typedef UILineBreakMode JRLineBreakMode;

#  define JR_TEXT_ALIGN_CENTER (UITextAlignmentCenter)
#  define JR_TEXT_ALIGN_LEFT (UITextAlignmentLeft)
#  define JR_LINE_BREAK_MODE_TAIL_TRUNCATION (UILineBreakModeTailTruncation)
#  define JR_LINE_BREAK_MODE_WORD_WRAP (UILineBreakModeWordWrap)
#endif


typedef enum
{
    PadPopoverModeNone,
    PadPopoverFromBar,
    PadPopoverFromFrame,
} PadPopoverMode;


@protocol JRExternalDialogControllerDelegate <NSObject>
@optional
- (void)authenticationDidComplete;
- (void)showLoading;
- (void)hideLoading;
@end

@interface JRUserInterfaceMaestro : NSObject

+ (JRUserInterfaceMaestro *)jrUserInterfaceMaestroWithSessionData:(JRSessionData *)newSessionData;
+ (JRUserInterfaceMaestro *)sharedMaestro;

- (void)loadModalNavigationControllerWithViewController:(UIViewController *)rootViewController;
- (void)loadApplicationNavigationControllerWithViewController:(UIViewController *)rootViewController;
- (void)showAuthenticationDialogWithCustomInterface:(NSDictionary *)customizations;
- (void)showPublishingDialogForActivityWithCustomInterface:(NSDictionary *)customizations;
- (void)unloadUserInterfaceWithTransitionStyle:(UIModalTransitionStyle)style;

- (void)authenticationRestarted;
- (void)authenticationCompleted;
- (void)authenticationFailed;
- (void)authenticationCanceled;
- (void)publishingCompleted;
- (void)publishingCanceled;

- (void)startWebAuthWithCustomInterface:(NSDictionary *)customInterfaceOverrides provider:(NSString *)provider;

- (void)pushWebViewFromViewController:(UIViewController *)viewController;

@property(nonatomic, strong) NSMutableDictionary *customInterfaceDefaults;
@property(readonly) JRProvidersController *myProvidersController;
@property(readonly) JRUserLandingController *myUserLandingController;
@property(readonly) JRWebViewController *myWebViewController;
@property(readonly) JRPublishActivityController *myPublishActivityController;
@property(copy) NSString *directProviderName;

- (void)buildCustomInterface:(NSDictionary *)customizations;

- (void)setUpDialogPresentation;


- (BOOL)canRotate;
@end
