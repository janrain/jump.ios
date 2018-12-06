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
#import "JRProfile.h"

/**
 * @brief A JRProfilesElement object
 **/
@interface JRProfilesElement : JRCaptureObject
@property (nonatomic, copy)     JRJsonObject *accessCredentials; /**< User's authorization credentials for this provider @note A ::JRJsonObject property is a property of type \ref typesTable "json", which can be an \e NSDictionary, \e NSArray, \e NSString, etc., and is therefore is a typedef of \e NSObject */ 
@property (nonatomic, copy)     NSString *domain; /**< The object's \e domain property */ 
@property (nonatomic, copy)     JRStringArray *followers; /**< User's followers @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c identifier */ 
@property (nonatomic, copy)     JRStringArray *following; /**< Who the user is following @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c identifier */ 
@property (nonatomic, copy)     JRStringArray *friends; /**< User's friends @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c identifier */ 
@property (nonatomic, copy)     NSString *identifier; /**< Profile provider unique identifier */ 
@property (nonatomic,strong)    JRProfile *profile; /**< The object's \e profile property */ 
@property (nonatomic, copy)     JRJsonObject *provider; /**< Provider for this profile @note A ::JRJsonObject property is a property of type \ref typesTable "json", which can be an \e NSDictionary, \e NSArray, \e NSString, etc., and is therefore is a typedef of \e NSObject */ 
@property (nonatomic, copy)     NSString *providerSpecifier; /**< Internal text field for identifying the provider in a unique and normalized manner. */ 
@property (nonatomic, copy)     NSString *remote_key; /**< PrimaryKey field from Engage */ 

/**
 * @name Constructors
 **/
/*@{*/
/**
 * Default instance constructor. Returns an empty JRProfilesElement object
 *
 * @return
 *   A JRProfilesElement object
 *
 * @note 
 * Method creates a object without the required properties: \e domain, \e identifier.
 * These properties are required when updating the object on Capture. That is, you must set them before calling
 * updateOnCaptureForDelegate:context:().
 **/
- (id)init;

/**
 * Default class constructor. Returns an empty JRProfilesElement object
 *
 * @return
 *   A JRProfilesElement object
 *
 * @note 
 * Method creates a object without the required properties: \e domain, \e identifier.
 * These properties are required when updating the object on Capture. That is, you must set them before calling
 * updateOnCaptureForDelegate:context:().
 **/
+ (id)profilesElement;

/**
 * Returns a JRProfilesElement object initialized with the given required properties: \c newDomain, \c newIdentifier
 *
 * @param newDomain
 *   The object's \e domain property
 *
 * @param newIdentifier
 *   Profile provider unique identifier
 *
 * @return
 *   A JRProfilesElement object initialized with the given required properties: \e newDomain, \e newIdentifier.
 *   If the required arguments are \e nil or \e [NSNull null], returns \e nil
 **/
- (id)initWithDomain:(NSString *)newDomain andIdentifier:(NSString *)newIdentifier;

/**
 * Returns a JRProfilesElement object initialized with the given required properties: \c domain, \c identifier
 *
 * @param domain
 *   The object's \e domain property
 *
 * @param identifier
 *   Profile provider unique identifier
 *
 * @return
 *   A JRProfilesElement object initialized with the given required properties: \e domain, \e identifier.
 *   If the required arguments are \e nil or \e [NSNull null], returns \e nil
 **/
+ (id)profilesElementWithDomain:(NSString *)domain andIdentifier:(NSString *)identifier;

/*@}*/

/**
 * @name Manage Remotely 
 **/
/*@{*/
/**
 * Use this method to replace the JRProfilesElement#followers array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfilesElement#followers property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfilesElement#followers property, and the name of the replaced array: \c "followers".
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
 * When successful, the new array will be added to the JRProfilesElement#followers property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRFollowersElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfilesElement#followers or JRFollowersElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRFollowersElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRFollowersElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRFollowersElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfilesElement#followers array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRFollowersElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfilesElement#followers array, but
 * you have locally updated the properties of a JRFollowersElement, you can just call
 * JRFollowersElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRFollowersElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceFollowersArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRProfilesElement#following array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfilesElement#following property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfilesElement#following property, and the name of the replaced array: \c "following".
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
 * When successful, the new array will be added to the JRProfilesElement#following property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRFollowingElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfilesElement#following or JRFollowingElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRFollowingElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRFollowingElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRFollowingElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfilesElement#following array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRFollowingElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfilesElement#following array, but
 * you have locally updated the properties of a JRFollowingElement, you can just call
 * JRFollowingElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRFollowingElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceFollowingArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRProfilesElement#friends array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfilesElement#friends property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfilesElement#friends property, and the name of the replaced array: \c "friends".
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
 * When successful, the new array will be added to the JRProfilesElement#friends property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRFriendsElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfilesElement#friends or JRFriendsElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRFriendsElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRFriendsElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRFriendsElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfilesElement#friends array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRFriendsElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfilesElement#friends array, but
 * you have locally updated the properties of a JRFriendsElement, you can just call
 * JRFriendsElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRFriendsElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceFriendsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

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
 * This method recursively checks all of the sub-objects of JRProfilesElement:
 *   - JRProfilesElement#profile
 * .
 * @par
 * If any of these objects are new, or if they need to be updated, this method returns \c YES.
 *
 * @warning
 * This object, or one of its ancestors, is an element of a plural. If any elements of the plural have changed,
 * (added or removed) the array must be replaced on Capture before the elements or their sub-objects can be
 * updated. Please use the appropriate <code>replace&lt;<em>ArrayName</em>&gt;ArrayOnCaptureForDelegate:context:</code>
 * method first. Even if JRCaptureObject#needsUpdate returns \c YES, this object cannot be updated on Capture unless
 * JRCaptureObject#canBeUpdatedOnCapture also returns \c YES.
 *
 * @par
 * This method recursively checks all of the sub-objects of JRProfilesElement
 * but does not check any of the arrays of the JRProfilesElement or the arrays' elements:
 *   - JRProfilesElement#followers, JRFollowersElement
 *   - JRProfilesElement#following, JRFollowingElement
 *   - JRProfilesElement#friends, JRFriendsElement
 * .
 * @par
 * If you have added or removed any elements from the arrays, you must call the following methods
 * to update the array on Capture: replaceFollowersArrayOnCaptureForDelegate:context:(),
 *   replaceFollowingArrayOnCaptureForDelegate:context:(),
 *   replaceFriendsArrayOnCaptureForDelegate:context:()
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
