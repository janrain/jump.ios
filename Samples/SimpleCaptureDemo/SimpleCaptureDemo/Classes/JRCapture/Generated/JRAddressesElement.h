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
 * @brief A physical mailing address for this Contact.
 **/
@interface JRAddressesElement : JRCaptureObject
@property (nonatomic, copy)     NSString *country; /**< The country name component. */ 
@property (nonatomic, copy)     NSString *extendedAddress; /**< The object's \e extendedAddress property */ 
@property (nonatomic, copy)     NSString *formatted; /**< The full mailing address, formatted for display or use with a mailing label. */ 
@property (nonatomic, copy)     JRDecimal *latitude; /**< The object's \e latitude property @note A ::JRDecimal property is a property of type \ref typesTable "decimal" and a typedef of \e NSNumber. Accepted values can be, for example, <code>[NSNumber numberWithNumber:<em>myDecimal</em>]</code>, <code>nil</code>, etc. */ 
@property (nonatomic, copy)     NSString *locality; /**< The city or locality component. */ 
@property (nonatomic, copy)     JRDecimal *longitude; /**< The object's \e longitude property @note A ::JRDecimal property is a property of type \ref typesTable "decimal" and a typedef of \e NSNumber. Accepted values can be, for example, <code>[NSNumber numberWithNumber:<em>myDecimal</em>]</code>, <code>nil</code>, etc. */ 
@property (nonatomic, copy)     NSString *poBox; /**< The object's \e poBox property */ 
@property (nonatomic, copy)     NSString *postalCode; /**< The zipcode or postal code component. */ 
@property (nonatomic, copy)     JRBoolean *primary; /**< The object's \e primary property @note A ::JRBoolean property is a property of type \ref typesTable "boolean" and a typedef of \e NSNumber. The accepted values can only be <code>[NSNumber numberWithBool:<em>myBool</em>]</code> or <code>nil</code> */ 
@property (nonatomic, copy)     NSString *region; /**< The state or region component. */ 
@property (nonatomic, copy)     NSString *streetAddress; /**< The full street address component, which may include house number, street name, PO BOX, and multi-line extended street address information. */ 
@property (nonatomic, copy)     NSString *type; /**< The object's \e type property */ 

/**
 * @name Constructors
 **/
/*@{*/
/**
 * Default instance constructor. Returns an empty JRAddressesElement object
 *
 * @return
 *   A JRAddressesElement object
 **/
- (id)init;

/**
 * Default class constructor. Returns an empty JRAddressesElement object
 *
 * @return
 *   A JRAddressesElement object
 **/
+ (id)addressesElement;

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

/**
 * @name Primitive Getters/Setters 
 **/
/*@{*/
/**
 * Returns the primitive boolean value stored in the primary property. Will return \c NO if the
 * primary is  nil. **/
- (BOOL)getPrimaryBoolValue;

/**
 * Sets the primary property to a the primitive boolean value.
 **/
- (void)setPrimaryWithBool:(BOOL)boolVal;
/*@}*/

@end
