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


#import <Foundation/Foundation.h>

@protocol JRConnectionManagerDelegate;
@class JRCaptureUser;

/**
 * @file
 * @defgroup captureErrors Capture Errors
 *
 * Capture-related error codes and explanations that you may receive through the delegate methods of the
 * JRCaptureObjectDelegate, JRCaptureUserDelegate, and JRCaptureDelegate protocols.
 *
 * @{
 **/

FOUNDATION_EXPORT NSString *const kJRCaptureErrorDomain;
#define GENERIC_ERROR_RANGE 1000
#define LOCAL_APID_ERROR_RANGE 2000
#define APID_ERROR_RANGE 3000
#define CAPTURE_WRAPPED_ENGAGE_ERROR_RANGE 4000
#define LOCAL_CAPTURE_ERROR_RANGE 5000

/**
 * Generic Capture errors
 **/
typedef enum
{
    JRCaptureErrorGeneric            = GENERIC_ERROR_RANGE,         /**< Generic Capture error */
    JRCaptureErrorGenericBadPassword = JRCaptureErrorGeneric + 100,
    JRCaptureErrorWhileParsingJson   = JRCaptureErrorGeneric + 101, /**< Error Parsing JSON Flow */
} JRCaptureGenericError;

/**
 * Errors received from the JRCaptureObjectDelegate, JRCaptureUserDelegate, and JRCaptureDelegate protocols
 * when they fail locally
 **/
typedef enum
{
    JRCaptureLocalApidErrorGeneric              = LOCAL_APID_ERROR_RANGE,               /**< Generic error */
    JRCaptureLocalApidErrorInvalidArrayElement  = JRCaptureLocalApidErrorGeneric + 101, /**< Error returned when an object or its parent is an element of an array, and the array needs to be replaced on Capture first. @sa JRCaptureObject#canBeUpdatedOnCapture */
    JRCaptureLocalApidErrorUrlConnection        = JRCaptureLocalApidErrorGeneric + 201, /**< Error returned when a URL connection could not be established */
    JRCaptureLocalApidErrorConnectionDidFail    = JRCaptureLocalApidErrorGeneric + 202, /**< Error returned when a URL connection failed */
    JRCaptureLocalApidErrorInvalidArgument      = JRCaptureLocalApidErrorGeneric + 203, /**< Error returned when an invalid parameter has been passed to a Capture method */
    JRCaptureLocalApidErrorInvalidResultClass   = JRCaptureLocalApidErrorGeneric + 301, /**< Error returned when the JSON returned by Capture wasn't the expected structure (e.g., a string when expecting a plural) */
    JRCaptureLocalApidErrorInvalidResultStat    = JRCaptureLocalApidErrorGeneric + 302, /**< Error returned when the stat returned by Capture is missing or something unexpected */
    JRCaptureLocalApidErrorInvalidResultData    = JRCaptureLocalApidErrorGeneric + 303, /**< Error returned when the data returned by Capture was unexpected or incorrect */
    JRCaptureLocalApidErrorMissingAccessToken   = JRCaptureLocalApidErrorGeneric + 400, /**< Error returned when some of the JRCaptureObject or JRCaptureUser methods are called, require an \c access_token and there is no valid \c access_token */
    JRCaptureLocalApidErrorSelectorNotAvailable = JRCaptureLocalApidErrorGeneric + 500, /**< Error returned when a selector is not available */
} JRCaptureLocalApidError;

/**
 * Local Capture client errors which are not apid specific
 */
typedef enum
{
    JRCaptureLocalErrorGeneric = LOCAL_CAPTURE_ERROR_RANGE,
    JRCaptureLocalErrorInvalidInternalState = JRCaptureLocalErrorGeneric + 101, /**< The internal Capture client state has become corrupted */
} JRCaptureLocalError;

/**
 * Errors received from the JRCaptureObjectDelegate, JRCaptureUserDelegate, and JRCaptureDelegate protocols
 * when they fail on the Capture server. These errors correspond to the errors listed on the
 * <a href="http://developers.janrain.com/documentation/capture/api-use-and-error-codes/">
 *     Capture RESTful API Documentation Page</a>
 **/
typedef enum
{
    JRCaptureApidErrorGeneric                  = APID_ERROR_RANGE,
    JRCaptureApidErrorMissingArgument          = JRCaptureApidErrorGeneric + 100, /**< Error returned when a required argument was not supplied */
    JRCaptureApidErrorInvalidArgument          = JRCaptureApidErrorGeneric + 200, /**< Error returned when the argument was malformed, or its value was invalid for some other reason */
    JRCaptureApidErrorDuplicateArgument        = JRCaptureApidErrorGeneric + 201, /**< Error returned when two or more supplied arguments may not have been included in the same call; for example, both \c id and \c uuid in \c entity.update */
    JRCaptureApidErrorInvalidAuthMethod        = JRCaptureApidErrorGeneric + 205, /**< Error returned when the request used an http auth method other than Basic or OAuth */
    JRCaptureApidErrorUnknownApplication       = JRCaptureApidErrorGeneric + 221, /**< Error returned when the application id does not exist */
    JRCaptureApidErrorUnknownEntityType        = JRCaptureApidErrorGeneric + 222, /**< Error returned when the entity type does not exist */
    JRCaptureApidErrorUnknownAttribute         = JRCaptureApidErrorGeneric + 223, /**< Error returned when an attribute does not exist. This can occur when trying to create or update a record, or when modifying an attribute */
    JRCaptureApidErrorEntityTypeExists         = JRCaptureApidErrorGeneric + 232, /**< Error returned when the client attempts to create an entity type that already exists */
    JRCaptureApidErrorAttributeExists          = JRCaptureApidErrorGeneric + 233, /**< Error returned when the client attempts to create an attribute that already exists */
    JRCaptureApidErrorReservedAttribute        = JRCaptureApidErrorGeneric + 234, /**< Error returned when the client attempts to modify a reserved attribute; can occur if you try to delete, rename, or write to a reserved attribute */
    JRCaptureApidErrorRecordNotFound           = JRCaptureApidErrorGeneric + 310, /**< Error returned when the client refers to an entity or plural element that does not exist */
    JRCaptureApidErrorIdInNewRecord            = JRCaptureApidErrorGeneric + 320, /**< Error returned when the client attempts to specify a record id in a new entity or plural element */
    JRCaptureApidErrorTimestampMismatch        = JRCaptureApidErrorGeneric + 330, /**< Error returned when the \c created or \c lastUpdated value does not match the supplied argument */
    JRCaptureApidErrorInvalidDataFormat        = JRCaptureApidErrorGeneric + 340, /**< Error returned when a JSON value was not formatted correctly according to the attribute type in the schema */
    JRCaptureApidErrorInvalidJsonType          = JRCaptureApidErrorGeneric + 341, /**< Error returned when a value did not match the expected JSON type according to the schema */
    JRCaptureApidErrorInvalidDateTime          = JRCaptureApidErrorGeneric + 342, /**< Error returned when a \c date or \c dateTime value was not valid, for example if it was not formatted correctly or was out of range */
    JRCaptureApidErrorConstraintViolation      = JRCaptureApidErrorGeneric + 360, /**< Error returned when a constraint was violated */
    JRCaptureApidErrorUniqueViolation          = JRCaptureApidErrorGeneric + 361, /**< Error returned when a unique or locally-unique constraint was violated */
    JRCaptureApidErrorMissingRequiredAttribute = JRCaptureApidErrorGeneric + 362, /**< Error returned when an attribute with the required constraint was either missing or set to null */
    JRCaptureApidErrorLengthViolation          = JRCaptureApidErrorGeneric + 363, /**< Error returned when a string value violated an attribute’s length constraint */
    JRCaptureApidErrorEmailAddressInUse        = JRCaptureApidErrorGeneric + 380, /**< Error returned when thin registration fails because the email address is already in use */
    JRCaptureApidErrorFormValidation           = JRCaptureApidErrorGeneric + 390, /**< Error returned when thin registration fails because the email address is already in use */
    JRCaptureApidErrorInvalidClientCredentials = JRCaptureApidErrorGeneric + 402, /**< Error returned when the client id does not exist or the client secret was wrong */
    JRCaptureApidErrorClientPermissionError    = JRCaptureApidErrorGeneric + 403, /**< Error returned when the client does not have permission to perform the action; needs a feature */
    JRCaptureApidErrorAccessTokenExpired       = JRCaptureApidErrorGeneric + 414, /**< Error returned when the supplied \c access_token has expired */
    JRCaptureApidErrorAuthorizationCodeExpired = JRCaptureApidErrorGeneric + 415, /**< Error returned when the supplied \c authorization_code has expired */
    JRCaptureApidErrorVerificationCodeExpired  = JRCaptureApidErrorGeneric + 416, /**< Error returned when the supplied \c verification_code has expired */
    JRCaptureApidErrorCreationTokenExpired     = JRCaptureApidErrorGeneric + 417, /**< Error returned when the supplied \c creation_token has expired */
    JRCaptureApidErrorRedirectUriMismatch      = JRCaptureApidErrorGeneric + 420, /**< Error returned when the redirectUri did not match. Occurs in the oauth/token API call with the \c authorization_code grant type */
    JRCaptureApidErrorApiFeatureDisabled       = JRCaptureApidErrorGeneric + 480, /**< Error returned when the API call was temporarily disabled for maintenance, and will be available again shortly */
    JRCaptureApidErrorUnexpectedError          = JRCaptureApidErrorGeneric + 500, /**< Error returned when an unexpected internal error; Janrain is notified when this occurs */
    JRCaptureApidErrorApiLimitError            = JRCaptureApidErrorGeneric + 510, /**< Error returned when the limit on total number of simultaneous API calls has been reached */
} JRCaptureApidError;

/**
 * Generic errors received from the JRCaptureDelegate protocols when sign-in through Engage fails
 **/
typedef enum
{
    /**
    *
    */
    JRCaptureWrappedEngageErrorGeneric                = CAPTURE_WRAPPED_ENGAGE_ERROR_RANGE,

    /**
    * Malformed API request response
    */
    JRCaptureWrappedEngageErrorInvalidEndpointPayload = JRCaptureWrappedEngageErrorGeneric + 100
} JRCaptureWrappedEngageError;

/**
 * NSError subclass for errors from the Capture library
 **/
@interface JRCaptureError : NSError

- (BOOL)isMergeFlowError;

+ (JRCaptureError *)connectionCreationErr:(NSURLRequest *)request
                              forDelegate:(id <JRConnectionManagerDelegate>)delegate
                                  withTag:(id)tag;

- (NSString *)existingProvider;
- (NSString *)conflictedProvider;

- (NSString *)mergeToken;

- (BOOL)isFormValidationError;

- (id)validationFailureMessages;
@end
/** @}*/

/**
* @internal
*/
@interface JRCaptureError (JRCaptureError_Builders)
+ (JRCaptureError *)invalidArgumentErrorWithParameterName:(NSString *)parameterName;
+ (JRCaptureError *)invalidInternalStateErrorWithDescription:(NSString *)description;

+ (JRCaptureError *)errorFromResult:(NSDictionary *)result
                         onProvider:(NSString *)onProvider
                        engageToken:(NSString *)mergeToken;

/*
 *  Factory method to create a generic JRCaptureError
 *
 *  @param error
 *      short description of error. The 'value' of the key
 *      NSLocalizedDescriptionKey in the userInfo dictionary
 *  @param code
 *      A JRCaptureError enum value defined in HRCaptureError.h
 *  @param description
 *      full description of error. The 'value' of the key
 *      NSLocalizedFailureReasonErrorKey in the userInfo dictionary
 *  @param extraFields
 *      Optional error data. Can be nil.
 */
+ (JRCaptureError *)errorWithErrorString:(NSString *)error
                                    code:(NSInteger)code
                             description:(NSString *)description
                             extraFields:(NSDictionary *)extraFields;

+ (JRCaptureError *)invalidApiResponseErrorWithString:(NSString *)rawResponse;
+ (JRCaptureError *)invalidApiResponseErrorWithObject:(id)rawResponse;
@end

/**
* @internal
*/
@interface JRCaptureError (JRCaptureError_Helpers)
+ (NSDictionary *)invalidClassErrorDictForResult:(NSObject *)result;
+ (NSDictionary *)invalidStatErrorDictForResult:(NSObject *)result;
+ (NSDictionary *)invalidDataErrorDictForResult:(NSObject *)result;

+ (NSDictionary *)invalidParameterErrorDictWithParam:(NSString *)param;
@end

/**
* NSError class categories to help with use of JRCaptureError instances
*/
@interface NSError (JRCaptureError_Extensions)
- (BOOL)isJRMergeFlowError;
- (BOOL)isJRTwoStepRegFlowError;
- (BOOL)isJRFormValidationError;
- (NSString *)JRMergeFlowConflictedProvider __unused;
- (NSString *)JRMergeFlowExistingProvider;
- (NSString *)JRMergeToken;
- (JRCaptureUser *)JRPreregistrationRecord;

- (NSString *)JRSocialRegistrationToken;

- (NSDictionary *)JRValidationFailureMessages;
@end
