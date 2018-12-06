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

/**
 * @brief A JRProperties object
 **/
@interface JRProperties : JRCaptureObject
@property (nonatomic, copy)     JRStringArray *managedBy; /**< The object's \e managedBy property @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c clientId */ 

/**
 * @name Constructors
 **/
/*@{*/
/**
 * Default instance constructor. Returns an empty JRProperties object
 *
 * @return
 *   A JRProperties object
 **/
- (id)init;

/**
 * Default class constructor. Returns an empty JRProperties object
 *
 * @return
 *   A JRProperties object
 **/
+ (id)properties;

/*@}*/

/**
 * @name Manage Remotely 
 **/
/*@{*/
/**
 * Use this method to replace the JRProperties#managedBy array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProperties#managedBy property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProperties#managedBy property, and the name of the replaced array: \c "managedBy".
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
 * When successful, the new array will be added to the JRProperties#managedBy property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRManagedByElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProperties#managedBy or JRManagedByElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRManagedByElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRManagedByElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRManagedByElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProperties#managedBy array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRManagedByElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProperties#managedBy array, but
 * you have locally updated the properties of a JRManagedByElement, you can just call
 * JRManagedByElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRManagedByElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceManagedByArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

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
 * @warning
 * This method recursively checks all of the sub-objects of JRProperties
 * but does not check any of the arrays of the JRProperties or the arrays' elements:
 *   - JRProperties#managedBy, JRManagedByElement
 * .
 * @par
 * If you have added or removed any elements from the arrays, you must call the following methods
 * to update the array on Capture: replaceManagedByArrayOnCaptureForDelegate:context:()
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
