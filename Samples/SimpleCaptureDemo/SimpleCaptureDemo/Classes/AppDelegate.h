/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2012, Janrain, Inc.

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
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import <UIKit/UIKit.h>
#import "JROpenIDAppAuthGoogleDelegate.h"

#define cJRCurrentProvider  @"simpleCaptureDemo.currentProvider"
#define cJRCaptureUser      @"simpleCaptureDemo.captureUser"

@class AppDelegate;
@class JRCaptureUser;

extern AppDelegate *appDelegate;

@interface AppDelegate : UIResponder <UIApplicationDelegate, JROpenIDAppAuthGoogleDelegate>
@property (nonatomic) UIWindow *window;

@property NSUserDefaults *prefs;
@property JRCaptureUser *captureUser;
@property BOOL isNotYetCreated;
@property NSString *currentProvider;
@property(nonatomic) NSString *captureClientId;
@property(nonatomic) NSString *captureDomain;
@property(nonatomic) NSString *captureLocale;
@property(nonatomic) NSString *captureFlowName;
@property(nonatomic) NSString *captureTraditionalSignInFormName;
@property(nonatomic) BOOL captureEnableThinRegistration;
@property(nonatomic) NSString *captureFlowVersion;
@property(nonatomic) NSString *captureTraditionalRegistrationFormName;
@property(nonatomic) NSString *captureSocialRegistrationFormName;
@property(nonatomic) NSString *captureAppId;
@property(nonatomic) NSString *captureFlowURL;
@property(nonatomic) NSString *engageAppId;
@property(nonatomic) NSString *registrationToken;
@property(nonatomic) NSDictionary *customProviders;
@property(nonatomic) NSString *captureForgottenPasswordFormName;
@property(nonatomic) NSString *captureEditProfileFormName;
@property(nonatomic) NSString *resendVerificationFormName;

- (void)saveCaptureUser;

@end
