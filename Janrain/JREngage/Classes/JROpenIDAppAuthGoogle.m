/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 Copyright (c) 2016, Janrain, Inc.
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

#import "JROpenIDAppAuthGoogle.h"
#import "debug_log.h"
#import "AppAuth.h"


/*! @brief The OIDC issuer from which the configuration will be discovered.
 */
static NSString *const kIssuer = @"https://accounts.google.com";

/*! @brief NSCoding key for the authState property.
 */
static NSString *const kAppAuthExampleAuthStateKey = @"authState";

@interface JROpenIDAppAuthGoogle () <OIDAuthStateChangeDelegate, OIDAuthStateErrorDelegate>
@end

@implementation JROpenIDAppAuthGoogle
@synthesize jrOpenIDAppAuthGoogleDelegate;

- (NSString *)provider {
    return @"googleplus";
}


- (void)startAuthenticationWithCompletion:(OpenIDAppAuthCompletionBlock)completion {
    [super startAuthenticationWithCompletion:completion];
    
    if( !jrOpenIDAppAuthGoogleDelegate ) {
        id appDelegate = [[UIApplication sharedApplication] delegate];
        if( ![appDelegate conformsToProtocol: @protocol(JROpenIDAppAuthGoogleDelegate)] ) {
            DLog( @"The JROpenIDAppAuthGoogleDelegate is not set and the AppDelegate does not conform to the JROpenIDAppAuthGoogleDelegate protocol." );
        } else {
            jrOpenIDAppAuthGoogleDelegate = appDelegate;
        }
    }
    
    NSURL *issuer = [NSURL URLWithString:kIssuer];
    NSURL *redirectURI = [NSURL URLWithString:jrOpenIDAppAuthGoogleDelegate.googlePlusRedirectUri];
    
    DLog(@"Fetching configuration for issuer: %@", issuer);
    
    // discovers endpoints
    [OIDAuthorizationService discoverServiceConfigurationForIssuer:issuer
        completion:^(OIDServiceConfiguration *_Nullable configuration, NSError *_Nullable error) {
            
            if (!configuration) {
                DLog(@"Error retrieving discovery document: %@", [error localizedDescription]);
                [self setAuthState:nil];
                return;
            }
            
            DLog(@"Got configuration: %@", configuration);
            
            //populate scopes from janrain configuration plist
            NSArray *openIDScopes;
            if (self.jrOpenIDAppAuthGoogleDelegate.googlePlusOpenIDScopes == nil || [self.jrOpenIDAppAuthGoogleDelegate.googlePlusOpenIDScopes count] == 0) {
                openIDScopes = @[OIDScopeOpenID, OIDScopeProfile, OIDScopeEmail, OIDScopeAddress, OIDScopePhone];
            }else{
                NSMutableArray *tempScopes = [[NSMutableArray alloc] init];
                for (NSString* scope in self.jrOpenIDAppAuthGoogleDelegate.googlePlusOpenIDScopes){
                    if([scope isEqualToString:@"OIDScopeOpenID"]) {
                        [tempScopes addObject:OIDScopeOpenID];
                    } else if([scope isEqualToString:@"OIDScopeProfile"]) {
                        [tempScopes addObject:OIDScopeProfile];
                    } else if([scope isEqualToString:@"OIDScopeEmail"]) {
                        [tempScopes addObject:OIDScopeEmail];
                    } else if([scope isEqualToString:@"OIDScopeAddress"]) {
                        [tempScopes addObject:OIDScopeAddress];
                    } else if([scope isEqualToString:@"OIDScopePhone"]) {
                        [tempScopes addObject:OIDScopePhone];
                    }
                }
                if(tempScopes != nil && [tempScopes count] > 0){
                    openIDScopes = [tempScopes copy];
                }
            }
            
            // builds authentication request
            OIDAuthorizationRequest *request =
            [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration
                                                          clientId:self.jrOpenIDAppAuthGoogleDelegate.googlePlusClientId
                                                            scopes:openIDScopes
                                                       redirectURL:redirectURI
                                                      responseType:OIDResponseTypeCode
                                              additionalParameters:nil];
            // performs authentication request
            DLog(@"Initiating authorization request with scopes: %@", request.scope);
            
            UIViewController *current = [UIApplication sharedApplication].keyWindow.rootViewController;
            
            while (current.presentedViewController) {
                current = current.presentedViewController;
            }
            self.jrOpenIDAppAuthGoogleDelegate.openIDAppAuthAuthorizationFlow =
            [OIDAuthState authStateByPresentingAuthorizationRequest:request
                                           presentingViewController:current
                                                           callback:^(OIDAuthState *_Nullable authState,
                                                                      NSError *_Nullable error) {
                                                               if (authState) {
                                                                   [self setAuthState:authState];
                                                                   DLog(@"Got authorization tokens. Access token: %@",
                                                                        authState.lastTokenResponse.accessToken);
                                                                   [self getAuthInfoTokenForAccessToken:(NSString *)authState.lastTokenResponse.accessToken];
                                                                   
                                                               } else {
                                                                   DLog(@"Google+ Authorization error: %@", [error localizedDescription]);
                                                                   [self setAuthState:nil];
                                                                   self.completion(error);
                                                               }
                                                           }];
        }];
}




+ (BOOL)handleURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(NSString *)annotation {
    return YES;
}


/*! @brief Saves the @c OIDAuthState to @c NSUSerDefaults.
 */
- (void)saveState {
    // for production usage consider using the OS Keychain instead
    NSData *archivedAuthState = [ NSKeyedArchiver archivedDataWithRootObject:_authState];
    [[NSUserDefaults standardUserDefaults] setObject:archivedAuthState
                                              forKey:kAppAuthExampleAuthStateKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*! @brief Loads the @c OIDAuthState from @c NSUSerDefaults.
 */
- (void)loadState {
    // loads OIDAuthState from NSUSerDefaults
    NSData *archivedAuthState =
    [[NSUserDefaults standardUserDefaults] objectForKey:kAppAuthExampleAuthStateKey];
    OIDAuthState *authState = [NSKeyedUnarchiver unarchiveObjectWithData:archivedAuthState];
    [self setAuthState:authState];
}

- (void)setAuthState:(nullable OIDAuthState *)authState {
    if (_authState == authState) {
        return;
    }
    _authState = authState;
    _authState.stateChangeDelegate = self;
    [self stateChanged];
}

- (void)stateChanged {
    [self saveState];
}

- (void)didChangeState:(OIDAuthState *)state {
    [self stateChanged];
}

- (void)authState:(OIDAuthState *)state didEncounterAuthorizationError:(nonnull NSError *)error {
    DLog(@"OpenID AppAuth Google+ Received authorization error: %@", error);
}


@end
