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
 * @brief Person's body characteristics.
 **/
@interface JRBodyType : JRCaptureObject
/**
 * \c YES if this object can be updated on Capture with the method JRBodyType#updateOnCaptureForDelegate:context:().
 * \c NO if it can't.
 *
 * Use this property to determine if the object or element can be updated on Capture or if this object's parent array
 * needs to be replaced first. As this object, or one of its ancestors, is an element of a plural, this object may or
 * may not be updated on Capture. If an element of a plural was added locally (newly allocated on the client), then the
 * array must be replaced before the element can use the method JRBodyType#updateOnCaptureForDelegate:context:().
 * Even if JRBodyType#needsUpdate returns \c YES, this object cannot be updated on Capture unless
 * JRBodyType#canBeUpdatedOnCapture also returns \c YES.
 *
 * That is, if any elements of a plural have changed, (added, removed, or reordered) the array
 * must be replaced on Capture with the appropriate <code>replace&lt;<em>ArrayName</em>&gt;ArrayOnCaptureForDelegate:context:</code>
 * method, before updating the elements. As such, this should be done immediately.
 *
 * @note
 * Replacing the array will also update any local changes to the properties of a JRBodyType, including
 * sub-arrays and sub-objects.
 **/
@property (readonly) BOOL canBeUpdatedOnCapture;

@property (nonatomic, copy)     NSString *build; /**< The object's \e build property */ 
@property (nonatomic, copy)     NSString *color; /**< The object's \e color property */ 
@property (nonatomic, copy)     NSString *eyeColor; /**< The object's \e eyeColor property */ 
@property (nonatomic, copy)     NSString *hairColor; /**< The object's \e hairColor property */ 
@property (nonatomic, copy)     JRDecimal *height; /**< The object's \e height property @note A ::JRDecimal property is a property of type \ref typesTable "decimal" and a typedef of \e NSNumber. Accepted values can be, for example, <code>[NSNumber numberWithNumber:<em>myDecimal</em>]</code>, <code>nil</code>, etc. */ 

/**
 * @name Constructors
 **/
/*@{*/
/**
 * Default instance constructor. Returns an empty JRBodyType object
 *
 * @return
 *   A JRBodyType object
 **/
- (id)init;

/**
 * Default class constructor. Returns an empty JRBodyType object
 *
 * @return
 *   A JRBodyType object
 **/
+ (id)bodyType;

/*@}*/

/**
 * @name Manage Remotely 
 **/
/*@{*/
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
 * This object, or one of its ancestors, is an element of a plural. If any elements of the plural have changed,
 * (added or removed) the array must be replaced on Capture before the elements or their sub-objects can be
 * updated. Please use the appropriate <code>replace&lt;<em>ArrayName</em>&gt;ArrayOnCaptureForDelegate:context:</code>
 * method first. Even if JRCaptureObject#needsUpdate returns \c YES, this object cannot be updated on Capture unless
 * JRCaptureObject#canBeUpdatedOnCapture also returns \c YES.
 **/
- (BOOL)needsUpdate;

/**
 * TODO: Doxygen doc
 **/
- (void)updateOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;
/*@}*/

@end
