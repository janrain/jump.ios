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

 File:   JRCaptureInterface.h
 Author: Lilli Szafranski - lilli@janrain.com, lillialexis@gmail.com
 Date:   Thursday, January 26, 2012
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#import <Foundation/Foundation.h>

#define JRCaptureInterfaceDelegate JRCaptureInternalDelegate

@protocol JRCaptureDelegate;

FOUNDATION_EXPORT NSString *const kJRTradAuthUrlPath;

/**
 * @internal
 */
@protocol JRCaptureInternalDelegate <NSObject>
@optional
- (void)signInCaptureUserDidSucceedWithResult:(NSString *)result context:(NSObject *)context;

- (void)signInCaptureUserDidFailWithResult:(NSError *)error context:(NSObject *)context;

- (void)getCaptureUserDidSucceedWithResult:(NSDictionary *)result context:(NSObject *)context;

- (void)getCaptureUserDidFailWithResult:(NSDictionary *)result context:(NSObject *)context;

- (void)getCaptureObjectDidSucceedWithResult:(NSObject *)result context:(NSObject *)context;

- (void)getCaptureObjectDidFailWithResult:(NSObject *)result context:(NSObject *)context;

- (void)updateCaptureObjectDidSucceedWithResult:(NSObject *)result context:(NSObject *)context;

- (void)updateCaptureObjectDidFailWithResult:(NSDictionary *)result context:(NSObject *)context;

- (void)replaceCaptureObjectDidSucceedWithResult:(NSObject *)result context:(NSObject *)context;

- (void)replaceCaptureObjectDidFailWithResult:(NSDictionary *)result context:(NSObject *)context;

- (void)replaceCaptureArrayDidSucceedWithResult:(NSObject *)result context:(NSObject *)context;

- (void)replaceCaptureArrayDidFailWithResult:(NSDictionary *)result context:(NSObject *)context;
@end

@protocol JRConnectionManagerDelegate;

/**
 * @internal
 */
@interface JRCaptureApidInterface : NSObject

/**
 * @deprecated
 * Use +[JRCaptureApidInterface signInCaptureUserWithCredentials:forDelegate:withContext:] instead
 */
+ (void)signInCaptureUserWithCredentials:(NSDictionary *)credentials
                                  ofType:(NSString *)signInType
                             forDelegate:(id)delegate
                             withContext:(NSObject *)context __attribute__((deprecated));

+ (void)signInCaptureUserWithCredentials:(NSDictionary *)credentials
                             forDelegate:(id <JRCaptureInternalDelegate>)delegate withContext:(NSObject *)context;

+ (void)getCaptureUserWithToken:(NSString *)token
                    forDelegate:(id <JRCaptureInternalDelegate>)delegate
                    withContext:(NSObject *)context;

+ (void)getCaptureObjectAtPath:(NSString *)entityPath
                     withToken:(NSString *)token
                   forDelegate:(id <JRCaptureInternalDelegate>)delegate
                   withContext:(NSObject *)context __unused;

+ (void)updateCaptureObject:(NSDictionary *)captureObject
                     atPath:(NSString *)entityPath
                  withToken:(NSString *)token
                forDelegate:(id <JRCaptureInternalDelegate>)delegate
                withContext:(NSObject *)context;

+ (void)replaceCaptureObject:(NSDictionary *)captureObject
                      atPath:(NSString *)entityPath
                   withToken:(NSString *)token
                 forDelegate:(id <JRCaptureInternalDelegate>)delegate
                 withContext:(NSObject *)context;

+ (void)replaceCaptureArray:(NSArray *)captureArray
                     atPath:(NSString *)entityPath
                  withToken:(NSString *)token
                forDelegate:(id <JRCaptureInternalDelegate>)delegate
                withContext:(NSObject *)context;

+ (NSMutableDictionary *)tradAuthParamsWithParams:(NSDictionary *)paramsDict refreshSecret:(NSString *)refreshSecret
                                         delegate:(id)delegate;
@end
