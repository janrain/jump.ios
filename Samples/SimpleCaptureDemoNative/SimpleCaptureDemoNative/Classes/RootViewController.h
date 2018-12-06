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

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
#import <UIKit/UIKit.h>
#import "JRCaptureObject.h"
#import <GoogleSignIn/GoogleSignIn.h>

extern NSString *const kGoogleClientID;

@interface RootViewController : UIViewController <GIDSignInUIDelegate, GIDSignInDelegate>{
    BOOL isMergingAccount;
}


- (IBAction)browseButtonPressed:(id)sender;
- (IBAction)tradRegButtonPressed:(id)sender;
- (IBAction)refreshButtonPressed:(id)sender;
- (IBAction)signInButtonPressed:(id)sender;
- (IBAction)facebookAuthButtonPressed:(id)sender;
- (IBAction)googleSignInAuthButtonPressed:(id)sender;
- (IBAction)twitterAuthButtonPressed:(id)sender;
- (IBAction)tradAuthButtonPressed:(id)sender;
- (IBAction)signOutButtonPressed:(id)sender;
- (IBAction)signOutAllButtonPressed:(id)sender;
- (IBAction)shareButtonPressed:(id)sender;
- (IBAction)refetchButtonPressed:(id)sender;
- (IBAction)forgotPasswordButtonPressed:(id)sender;
- (IBAction)linkAccountButtonPressed:(id)sender;
- (IBAction)unlinkAccountButtonPressed:(id)sender;
- (IBAction)resendVerificationButtonPressed:(id)sender;
- (IBAction)signInNavButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak) IBOutlet UILabel *currentUserLabel;
@property (weak) IBOutlet UIImageView *currentUserProviderIcon;
@property (weak) IBOutlet UIButton *browseButton;
@property (weak) IBOutlet UIButton *formButton;
@property (weak) IBOutlet UIButton *refreshButton;
@property (weak) IBOutlet UIButton *signInButton;
@property (weak) IBOutlet UIButton *signOutButton;
@property (weak) IBOutlet UIButton *signOutAllButton;
@property (weak) IBOutlet UIBarButtonItem *signInNavButton;
@property (weak, nonatomic) IBOutlet UIButton *tradAuthButton;
@property (weak, nonatomic) IBOutlet UIButton *directFacebookAuthButton;
@property (weak, nonatomic) IBOutlet UIButton *directGoogleplusAuthButton;
@property (weak, nonatomic) IBOutlet UIButton *directTwitterAuthButton;
@property (weak, nonatomic) IBOutlet UIButton *refetchButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *linkAccountButton;
@property (weak, nonatomic) IBOutlet UIButton *unlinkAccountButton;
@property (weak, nonatomic) IBOutlet UIButton *updateProfileButton;
@property (weak, nonatomic) IBOutlet UIButton *resendVerificationButton;
@property(nonatomic) NSDictionary *customUi;
@property NSString *currentProvider;
@property NSString *facebookToken;
@property NSString *googleplusToken;
@property NSString *twitterToken;
@property NSString *twitterTokenSecret;
@property NSString *activeMergeToken;
@property BOOL isMergingAccount;

@end
