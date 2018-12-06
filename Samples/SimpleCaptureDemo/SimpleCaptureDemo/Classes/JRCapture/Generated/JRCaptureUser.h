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
#import "JRCaptureObject.h"
#import "JRCaptureTypes.h"
#import "JRNSDate+ISO8601_CaptureDateTimeString.h"
#import "JRClientsElement.h"
#import "JRJanrain.h"
#import "JROptIn.h"
#import "JRPhotosElement.h"
#import "JRPrimaryAddress.h"
#import "JRProfilesElement.h"
#import "JRStatusesElement.h"

/**
 * @brief A JRCaptureUser object
 **/
@interface JRCaptureUser : JRCaptureObject
@property (nonatomic, copy)     NSString *aboutMe; /**< The object's \e aboutMe property */ 
@property (nonatomic, copy)     JRDate *birthday; /**< The object's \e birthday property @note A ::JRDate property is a property of type \ref typesTable "date" and a typedef of \e NSDate. The accepted format should be an ISO 8601 date string (e.g., <code>yyyy-MM-dd</code>) */ 
@property (nonatomic, copy)     NSArray *clients; /**< The object's \e clients property @note This is an array of JRClientsElement objects */ 
@property (nonatomic, copy)     NSString *currentLocation; /**< The object's \e currentLocation property */ 
@property (nonatomic, copy)     JRDateTime *deactivateAccount; /**< The object's \e deactivateAccount property @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, copy)     JRJsonObject *display; /**< The object's \e display property @note A ::JRJsonObject property is a property of type \ref typesTable "json", which can be an \e NSDictionary, \e NSArray, \e NSString, etc., and is therefore is a typedef of \e NSObject */ 
@property (nonatomic, copy)     NSString *displayName; /**< The name of this Contact, suitable for display to end-users. */ 
@property (nonatomic, copy)     NSString *email; /**< The object's \e email property */ 
@property (nonatomic, copy)     JRDateTime *emailVerified; /**< The object's \e emailVerified property @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, copy)     NSString *externalId; /**< The object's \e externalId property */ 
@property (nonatomic, copy)     NSString *familyName; /**< The object's \e familyName property */ 
@property (nonatomic, copy)     NSString *gender; /**< The object's \e gender property */ 
@property (nonatomic, copy)     NSString *givenName; /**< The object's \e givenName property */ 
@property (nonatomic,strong)    JRJanrain *janrain; /**< The object's \e janrain property */ 
@property (nonatomic, copy)     JRDateTime *lastLogin; /**< The object's \e lastLogin property @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, copy)     NSString *middleName; /**< The object's \e middleName property */ 
@property (nonatomic,strong)    JROptIn *optIn; /**< The object's \e optIn property */ 
@property (nonatomic, copy)     JRPassword *password; /**< The object's \e password property @note A ::JRPassword property is a property of type \ref typesTable "password", which can be either an \e NSString or \e NSDictionary, and is therefore is a typedef of \e NSObject */ 
@property (nonatomic, copy)     NSArray *photos; /**< The object's \e photos property @note This is an array of JRPhotosElement objects */ 
@property (nonatomic,strong)    JRPrimaryAddress *primaryAddress; /**< The object's \e primaryAddress property */ 
@property (nonatomic, copy)     NSArray *profiles; /**< The object's \e profiles property @note This is an array of JRProfilesElement objects */ 
@property (nonatomic, copy)     NSArray *statuses; /**< The object's \e statuses property @note This is an array of JRStatusesElement objects */ 
@property (nonatomic, readonly) JRObjectId *captureUserId; /**< Simple identifier for this entity @note The \e id of the object should not be set. */ 
@property (nonatomic, readonly) JRDateTime *created; /**< When this entity was created @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, readonly) JRDateTime *lastUpdated; /**< When this entity was last updated @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, readonly) JRUuid *uuid; /**< Globally unique indentifier for this entity @note A ::JRUuid property is a property of type \ref typesTable "uuid" and a typedef of \e NSString */ 

/**
 * @name Constructors
 **/
/*@{*/
/**
 * Default instance constructor. Returns an empty JRCaptureUser object
 *
 * @return
 *   A JRCaptureUser object
 **/
- (id)init;

/**
 * Default class constructor. Returns an empty JRCaptureUser object
 *
 * @return
 *   A JRCaptureUser object
 **/
+ (id)captureUser;

/*@}*/

/**
 * @name Manage Remotely 
 **/
/*@{*/
/**
 * Use this method to replace the JRCaptureUser#clients array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRCaptureUser#clients property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRCaptureUser#clients property, and the name of the replaced array: \c "clients".
 *
 * If unsuccessful, the method JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:
 * will be called on your delegate.
 *
 * @param delegate
 *   The JRCaptureObjectDelegate that implements the optional delegate methods JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 *   and JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:.
 *
 * @param context
 *   Any NSObject that you would like to send through the asynchronous network call back to your delegate, or \c nil.
 *   This object will be passed back to your JRCaptureObjectDelegate as is. Contexts are used across most of the
 *   asynchronous Capture methods to facilitate correlation of the response messages with the calling code. Use of the
 *   context is entirely optional and at your discretion.
 *
 * @warning
 * When successful, the new array will be added to the JRCaptureUser#clients property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRClientsElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRCaptureUser#clients or JRClientsElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRClientsElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRClientsElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRClientsElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRCaptureUser#clients array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRClientsElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRCaptureUser#clients array, but
 * you have locally updated the properties of a JRClientsElement, you can just call
 * JRClientsElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRClientsElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceClientsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRCaptureUser#photos array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRCaptureUser#photos property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRCaptureUser#photos property, and the name of the replaced array: \c "photos".
 *
 * If unsuccessful, the method JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:
 * will be called on your delegate.
 *
 * @param delegate
 *   The JRCaptureObjectDelegate that implements the optional delegate methods JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 *   and JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:.
 *
 * @param context
 *   Any NSObject that you would like to send through the asynchronous network call back to your delegate, or \c nil.
 *   This object will be passed back to your JRCaptureObjectDelegate as is. Contexts are used across most of the
 *   asynchronous Capture methods to facilitate correlation of the response messages with the calling code. Use of the
 *   context is entirely optional and at your discretion.
 *
 * @warning
 * When successful, the new array will be added to the JRCaptureUser#photos property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRPhotosElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRCaptureUser#photos or JRPhotosElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRPhotosElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRPhotosElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRPhotosElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRCaptureUser#photos array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRPhotosElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRCaptureUser#photos array, but
 * you have locally updated the properties of a JRPhotosElement, you can just call
 * JRPhotosElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRPhotosElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replacePhotosArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRCaptureUser#profiles array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRCaptureUser#profiles property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRCaptureUser#profiles property, and the name of the replaced array: \c "profiles".
 *
 * If unsuccessful, the method JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:
 * will be called on your delegate.
 *
 * @param delegate
 *   The JRCaptureObjectDelegate that implements the optional delegate methods JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 *   and JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:.
 *
 * @param context
 *   Any NSObject that you would like to send through the asynchronous network call back to your delegate, or \c nil.
 *   This object will be passed back to your JRCaptureObjectDelegate as is. Contexts are used across most of the
 *   asynchronous Capture methods to facilitate correlation of the response messages with the calling code. Use of the
 *   context is entirely optional and at your discretion.
 *
 * @warning
 * When successful, the new array will be added to the JRCaptureUser#profiles property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRProfilesElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRCaptureUser#profiles or JRProfilesElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRProfilesElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRProfilesElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRProfilesElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRCaptureUser#profiles array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRProfilesElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRCaptureUser#profiles array, but
 * you have locally updated the properties of a JRProfilesElement, you can just call
 * JRProfilesElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRProfilesElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceProfilesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRCaptureUser#statuses array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRCaptureUser#statuses property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRCaptureUser#statuses property, and the name of the replaced array: \c "statuses".
 *
 * If unsuccessful, the method JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:
 * will be called on your delegate.
 *
 * @param delegate
 *   The JRCaptureObjectDelegate that implements the optional delegate methods JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 *   and JRCaptureObjectDelegate#replaceArrayDidFailForObject:arrayNamed:withError:context:.
 *
 * @param context
 *   Any NSObject that you would like to send through the asynchronous network call back to your delegate, or \c nil.
 *   This object will be passed back to your JRCaptureObjectDelegate as is. Contexts are used across most of the
 *   asynchronous Capture methods to facilitate correlation of the response messages with the calling code. Use of the
 *   context is entirely optional and at your discretion.
 *
 * @warning
 * When successful, the new array will be added to the JRCaptureUser#statuses property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRStatusesElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRCaptureUser#statuses or JRStatusesElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRStatusesElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRStatusesElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRStatusesElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRCaptureUser#statuses array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRStatusesElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRCaptureUser#statuses array, but
 * you have locally updated the properties of a JRStatusesElement, you can just call
 * JRStatusesElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRStatusesElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceStatusesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to determine if the object or element needs to be updated remotely.
 * That is, if there are local changes to any of the object/elements's properties or
 * sub-objects, then this object will need to be updated on Capture. You can update
 * an object on Capture by using the method updateOnCaptureForDelegate:context:().
 *
 * @return
 * \c YES if this object or any of it's sub-objects have any properties that have changed
 * locally. This does not include properties that are arrays, if any, or the elements contained
 * within the arrays. \c NO if no non-array properties or sub-objects have changed locally.
 *
 * @note
 * This method recursively checks all of the sub-objects of JRCaptureUser:
 *   - JRCaptureUser#janrain
 *   - JRCaptureUser#optIn
 *   - JRCaptureUser#primaryAddress
 * .
 * @par
 * If any of these objects are new, or if they need to be updated, this method returns \c YES.
 *
 * @warning
 * This method recursively checks all of the sub-objects of JRCaptureUser
 * but does not check any of the arrays of the JRCaptureUser or the arrays' elements:
 *   - JRCaptureUser#clients, JRClientsElement
 *   - JRCaptureUser#photos, JRPhotosElement
 *   - JRCaptureUser#profiles, JRProfilesElement
 *   - JRCaptureUser#statuses, JRStatusesElement
 * .
 * @par
 * If you have added or removed any elements from the arrays, you must call the following methods
 * to update the array on Capture: replaceClientsArrayOnCaptureForDelegate:context:(),
 *   replacePhotosArrayOnCaptureForDelegate:context:(),
 *   replaceProfilesArrayOnCaptureForDelegate:context:(),
 *   replaceStatusesArrayOnCaptureForDelegate:context:()
 *
 * @par
 * Otherwise, if the array elements' JRCaptureObject#canBeUpdatedOnCapture and JRCaptureObject#needsUpdate returns \c YES, you can update
 * the elements by calling updateOnCaptureForDelegate:context:().
 **/
- (BOOL)needsUpdate;

/**
 * TODO: Doxygen doc
 **/
- (void)updateOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;
/*@}*/

@end
