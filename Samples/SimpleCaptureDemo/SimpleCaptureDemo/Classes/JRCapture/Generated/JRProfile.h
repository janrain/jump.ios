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
#import "JRAccountsElement.h"
#import "JRAddressesElement.h"
#import "JRBodyType.h"
#import "JRCurrentLocation.h"
#import "JREmailsElement.h"
#import "JRImsElement.h"
#import "JRName.h"
#import "JROrganizationsElement.h"
#import "JRPhoneNumbersElement.h"
#import "JRProfilePhotosElement.h"
#import "JRUrlsElement.h"

/**
 * @brief A JRProfile object
 **/
@interface JRProfile : JRCaptureObject
/**
 * \c YES if this object can be updated on Capture with the method JRProfile#updateOnCaptureForDelegate:context:().
 * \c NO if it can't.
 *
 * Use this property to determine if the object or element can be updated on Capture or if this object's parent array
 * needs to be replaced first. As this object, or one of its ancestors, is an element of a plural, this object may or
 * may not be updated on Capture. If an element of a plural was added locally (newly allocated on the client), then the
 * array must be replaced before the element can use the method JRProfile#updateOnCaptureForDelegate:context:().
 * Even if JRProfile#needsUpdate returns \c YES, this object cannot be updated on Capture unless
 * JRProfile#canBeUpdatedOnCapture also returns \c YES.
 *
 * That is, if any elements of a plural have changed, (added, removed, or reordered) the array
 * must be replaced on Capture with the appropriate <code>replace&lt;<em>ArrayName</em>&gt;ArrayOnCaptureForDelegate:context:</code>
 * method, before updating the elements. As such, this should be done immediately.
 *
 * @note
 * Replacing the array will also update any local changes to the properties of a JRProfile, including
 * sub-arrays and sub-objects.
 **/
@property (readonly) BOOL canBeUpdatedOnCapture;

@property (nonatomic, copy)     NSString *aboutMe; /**< A general statement about the person. */ 
@property (nonatomic, copy)     NSArray *accounts; /**< Describes an account held by this Contact, which MAY be on the Service Provider's service, or MAY be on a different service. @note This is an array of JRAccountsElement objects */ 
@property (nonatomic, copy)     JRStringArray *activities; /**< Person's activities @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c activity */ 
@property (nonatomic, copy)     NSArray *addresses; /**< A physical mailing address for this Contact. @note This is an array of JRAddressesElement objects */ 
@property (nonatomic, copy)     JRDate *anniversary; /**< The wedding anniversary of this contact. @note A ::JRDate property is a property of type \ref typesTable "date" and a typedef of \e NSDate. The accepted format should be an ISO 8601 date string (e.g., <code>yyyy-MM-dd</code>) */ 
@property (nonatomic, copy)     NSString *birthday; /**< The birthday of this contact. */ 
@property (nonatomic,strong)    JRBodyType *bodyType; /**< Person's body characteristics. */ 
@property (nonatomic, copy)     JRStringArray *books; /**< Person's favorite books. @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c book */ 
@property (nonatomic, copy)     JRStringArray *cars; /**< Person's favorite cars. @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c car */ 
@property (nonatomic, copy)     JRStringArray *children; /**< Description of the person's children. @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c value */ 
@property (nonatomic,strong)    JRCurrentLocation *currentLocation; /**< The object's \e currentLocation property */ 
@property (nonatomic, copy)     NSString *displayName; /**< The name of this Contact, suitable for display to end-users. */ 
@property (nonatomic, copy)     NSString *drinker; /**< Person's drinking status. */ 
@property (nonatomic, copy)     NSArray *emails; /**< E-mail address for this Contact. @note This is an array of JREmailsElement objects */ 
@property (nonatomic, copy)     NSString *ethnicity; /**< Person's ethnicity. */ 
@property (nonatomic, copy)     NSString *fashion; /**< Person's thoughts on fashion. */ 
@property (nonatomic, copy)     JRStringArray *food; /**< Person's favorite food. @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c food */ 
@property (nonatomic, copy)     NSString *gender; /**< The gender of this contact. */ 
@property (nonatomic, copy)     NSString *happiestWhen; /**< Describes when the person is happiest. */ 
@property (nonatomic, copy)     JRStringArray *heroes; /**< Person's favorite heroes. @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c hero */ 
@property (nonatomic, copy)     NSString *humor; /**< Person's thoughts on humor. */ 
@property (nonatomic, copy)     NSArray *ims; /**< Instant messaging address for this Contact. @note This is an array of JRImsElement objects */ 
@property (nonatomic, copy)     JRStringArray *interestedInMeeting; /**< The object's \e interestedInMeeting property @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c interest */ 
@property (nonatomic, copy)     JRStringArray *interests; /**< Person's interests, hobbies or passions. @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c interest */ 
@property (nonatomic, copy)     JRStringArray *jobInterests; /**< Person's favorite jobs, or job interests and skills. @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c jobInterest */ 
@property (nonatomic, copy)     JRStringArray *languages; /**< The object's \e languages property @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c language */ 
@property (nonatomic, copy)     JRStringArray *languagesSpoken; /**< List of the languages that the person speaks as ISO 639-1 codes. @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c languageSpoken */ 
@property (nonatomic, copy)     NSString *livingArrangement; /**< Description of the person's living arrangement. */ 
@property (nonatomic, copy)     JRStringArray *lookingFor; /**< Person's statement about who or what they are looking for, or what they are interested in meeting people for. @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c value */ 
@property (nonatomic, copy)     JRStringArray *movies; /**< Person's favorite movies. @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c movie */ 
@property (nonatomic, copy)     JRStringArray *music; /**< Person's favorite music. @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c music */ 
@property (nonatomic,strong)    JRName *name; /**< The object's \e name property */ 
@property (nonatomic, copy)     NSString *nickname; /**< The casual way to address this Contact in real life */ 
@property (nonatomic, copy)     NSString *note; /**< Notes about this person, with an unspecified meaning or usage. */ 
@property (nonatomic, copy)     NSArray *organizations; /**< Describes a current or past organizational affiliation of this contact. @note This is an array of JROrganizationsElement objects */ 
@property (nonatomic, copy)     JRStringArray *pets; /**< Description of the person's pets @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c value */ 
@property (nonatomic, copy)     NSArray *phoneNumbers; /**< Phone number for this Contact. @note This is an array of JRPhoneNumbersElement objects */ 
@property (nonatomic, copy)     NSArray *profilePhotos; /**< URL of a photo of this contact. @note This is an array of JRProfilePhotosElement objects */ 
@property (nonatomic, copy)     NSString *politicalViews; /**< Person's political views. */ 
@property (nonatomic, copy)     NSString *preferredUsername; /**< The preferred username of this contact on sites that ask for a username. */ 
@property (nonatomic, copy)     NSString *profileSong; /**< URL of a person's profile song. */ 
@property (nonatomic, copy)     NSString *profileUrl; /**< Person's profile URL, specified as a string. */ 
@property (nonatomic, copy)     NSString *profileVideo; /**< URL of a person's profile video. */ 
@property (nonatomic, copy)     JRDateTime *published; /**< The date this Contact was first added to the user's address book or friends list. @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, copy)     JRStringArray *quotes; /**< Person's favorite quotes @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c quote */ 
@property (nonatomic, copy)     NSString *relationshipStatus; /**< Person's relationship status. */ 
@property (nonatomic, copy)     JRStringArray *relationships; /**< A bi-directionally asserted relationship type that was established between the user and this contact by the Service Provider. @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c relationship */ 
@property (nonatomic, copy)     NSString *religion; /**< Person's religion or religious views. */ 
@property (nonatomic, copy)     NSString *romance; /**< Person's comments about romance. */ 
@property (nonatomic, copy)     NSString *scaredOf; /**< What the person is scared of. */ 
@property (nonatomic, copy)     NSString *sexualOrientation; /**< Person's sexual orientation. */ 
@property (nonatomic, copy)     NSString *smoker; /**< Person's smoking status. */ 
@property (nonatomic, copy)     JRStringArray *sports; /**< Person's favorite sports @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c sport */ 
@property (nonatomic, copy)     NSString *status; /**< Person's status, headline or shoutout. */ 
@property (nonatomic, copy)     JRStringArray *tags; /**< A user-defined category or label for this contact. @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c tag */ 
@property (nonatomic, copy)     JRStringArray *turnOffs; /**< Person's turn offs. @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c turnOff */ 
@property (nonatomic, copy)     JRStringArray *turnOns; /**< Person's turn ons. @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c turnOn */ 
@property (nonatomic, copy)     JRStringArray *tvShows; /**< Person's favorite TV shows. @note  A ::JRStringArray property is a plural (array) that holds a list of \e NSStrings. As it is an array, it is therefore a typedef of \e NSArray. This array of \c NSStrings represents a list of \c tvShow */ 
@property (nonatomic, copy)     JRDateTime *updated; /**< The most recent date the details of this Contact were updated. @note A ::JRDateTime property is a property of type \ref typesTable "dateTime" and a typedef of \e NSDate. The accepted format should be an ISO 8601 dateTime string (e.g., <code>yyyy-MM-dd HH:mm:ss.SSSSSS ZZZ</code>) */ 
@property (nonatomic, copy)     NSArray *urls; /**< URL of a web page relating to this Contact. @note This is an array of JRUrlsElement objects */ 
@property (nonatomic, copy)     NSString *utcOffset; /**< The offset from UTC of this Contact's current time zone. */ 

/**
 * @name Constructors
 **/
/*@{*/
/**
 * Default instance constructor. Returns an empty JRProfile object
 *
 * @return
 *   A JRProfile object
 **/
- (id)init;

/**
 * Default class constructor. Returns an empty JRProfile object
 *
 * @return
 *   A JRProfile object
 **/
+ (id)profile;

/*@}*/

/**
 * @name Manage Remotely 
 **/
/*@{*/
/**
 * Use this method to replace the JRProfile#accounts array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfile#accounts property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfile#accounts property, and the name of the replaced array: \c "accounts".
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
 * When successful, the new array will be added to the JRProfile#accounts property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRAccountsElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfile#accounts or JRAccountsElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRAccountsElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRAccountsElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRAccountsElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfile#accounts array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRAccountsElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfile#accounts array, but
 * you have locally updated the properties of a JRAccountsElement, you can just call
 * JRAccountsElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRAccountsElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceAccountsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRProfile#activities array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfile#activities property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfile#activities property, and the name of the replaced array: \c "activities".
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
 * When successful, the new array will be added to the JRProfile#activities property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRActivitiesElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfile#activities or JRActivitiesElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRActivitiesElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRActivitiesElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRActivitiesElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfile#activities array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRActivitiesElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfile#activities array, but
 * you have locally updated the properties of a JRActivitiesElement, you can just call
 * JRActivitiesElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRActivitiesElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceActivitiesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRProfile#addresses array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfile#addresses property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfile#addresses property, and the name of the replaced array: \c "addresses".
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
 * When successful, the new array will be added to the JRProfile#addresses property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRAddressesElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfile#addresses or JRAddressesElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRAddressesElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRAddressesElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRAddressesElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfile#addresses array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRAddressesElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfile#addresses array, but
 * you have locally updated the properties of a JRAddressesElement, you can just call
 * JRAddressesElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRAddressesElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceAddressesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRProfile#books array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfile#books property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfile#books property, and the name of the replaced array: \c "books".
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
 * When successful, the new array will be added to the JRProfile#books property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRBooksElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfile#books or JRBooksElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRBooksElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRBooksElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRBooksElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfile#books array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRBooksElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfile#books array, but
 * you have locally updated the properties of a JRBooksElement, you can just call
 * JRBooksElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRBooksElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceBooksArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRProfile#cars array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfile#cars property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfile#cars property, and the name of the replaced array: \c "cars".
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
 * When successful, the new array will be added to the JRProfile#cars property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRCarsElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfile#cars or JRCarsElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRCarsElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRCarsElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRCarsElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfile#cars array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRCarsElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfile#cars array, but
 * you have locally updated the properties of a JRCarsElement, you can just call
 * JRCarsElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRCarsElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceCarsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRProfile#children array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfile#children property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfile#children property, and the name of the replaced array: \c "children".
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
 * When successful, the new array will be added to the JRProfile#children property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRChildrenElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfile#children or JRChildrenElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRChildrenElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRChildrenElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRChildrenElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfile#children array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRChildrenElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfile#children array, but
 * you have locally updated the properties of a JRChildrenElement, you can just call
 * JRChildrenElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRChildrenElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceChildrenArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRProfile#emails array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfile#emails property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfile#emails property, and the name of the replaced array: \c "emails".
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
 * When successful, the new array will be added to the JRProfile#emails property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JREmailsElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfile#emails or JREmailsElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JREmailsElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JREmailsElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JREmailsElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfile#emails array on Capture. Replacing the array will also
 * update any local changes to the properties of a JREmailsElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfile#emails array, but
 * you have locally updated the properties of a JREmailsElement, you can just call
 * JREmailsElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JREmailsElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceEmailsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRProfile#food array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfile#food property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfile#food property, and the name of the replaced array: \c "food".
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
 * When successful, the new array will be added to the JRProfile#food property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRFoodElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfile#food or JRFoodElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRFoodElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRFoodElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRFoodElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfile#food array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRFoodElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfile#food array, but
 * you have locally updated the properties of a JRFoodElement, you can just call
 * JRFoodElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRFoodElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceFoodArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRProfile#heroes array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfile#heroes property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfile#heroes property, and the name of the replaced array: \c "heroes".
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
 * When successful, the new array will be added to the JRProfile#heroes property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRHeroesElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfile#heroes or JRHeroesElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRHeroesElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRHeroesElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRHeroesElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfile#heroes array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRHeroesElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfile#heroes array, but
 * you have locally updated the properties of a JRHeroesElement, you can just call
 * JRHeroesElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRHeroesElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceHeroesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRProfile#ims array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfile#ims property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfile#ims property, and the name of the replaced array: \c "ims".
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
 * When successful, the new array will be added to the JRProfile#ims property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRImsElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfile#ims or JRImsElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRImsElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRImsElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRImsElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfile#ims array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRImsElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfile#ims array, but
 * you have locally updated the properties of a JRImsElement, you can just call
 * JRImsElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRImsElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceImsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRProfile#interestedInMeeting array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfile#interestedInMeeting property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfile#interestedInMeeting property, and the name of the replaced array: \c "interestedInMeeting".
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
 * When successful, the new array will be added to the JRProfile#interestedInMeeting property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRInterestedInMeetingElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfile#interestedInMeeting or JRInterestedInMeetingElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRInterestedInMeetingElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRInterestedInMeetingElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRInterestedInMeetingElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfile#interestedInMeeting array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRInterestedInMeetingElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfile#interestedInMeeting array, but
 * you have locally updated the properties of a JRInterestedInMeetingElement, you can just call
 * JRInterestedInMeetingElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRInterestedInMeetingElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceInterestedInMeetingArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRProfile#interests array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfile#interests property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfile#interests property, and the name of the replaced array: \c "interests".
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
 * When successful, the new array will be added to the JRProfile#interests property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRInterestsElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfile#interests or JRInterestsElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRInterestsElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRInterestsElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRInterestsElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfile#interests array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRInterestsElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfile#interests array, but
 * you have locally updated the properties of a JRInterestsElement, you can just call
 * JRInterestsElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRInterestsElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceInterestsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRProfile#jobInterests array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfile#jobInterests property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfile#jobInterests property, and the name of the replaced array: \c "jobInterests".
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
 * When successful, the new array will be added to the JRProfile#jobInterests property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRJobInterestsElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfile#jobInterests or JRJobInterestsElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRJobInterestsElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRJobInterestsElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRJobInterestsElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfile#jobInterests array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRJobInterestsElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfile#jobInterests array, but
 * you have locally updated the properties of a JRJobInterestsElement, you can just call
 * JRJobInterestsElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRJobInterestsElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceJobInterestsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRProfile#languages array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfile#languages property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfile#languages property, and the name of the replaced array: \c "languages".
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
 * When successful, the new array will be added to the JRProfile#languages property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRLanguagesElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfile#languages or JRLanguagesElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRLanguagesElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRLanguagesElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRLanguagesElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfile#languages array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRLanguagesElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfile#languages array, but
 * you have locally updated the properties of a JRLanguagesElement, you can just call
 * JRLanguagesElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRLanguagesElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceLanguagesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRProfile#languagesSpoken array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfile#languagesSpoken property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfile#languagesSpoken property, and the name of the replaced array: \c "languagesSpoken".
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
 * When successful, the new array will be added to the JRProfile#languagesSpoken property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRLanguagesSpokenElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfile#languagesSpoken or JRLanguagesSpokenElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRLanguagesSpokenElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRLanguagesSpokenElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRLanguagesSpokenElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfile#languagesSpoken array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRLanguagesSpokenElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfile#languagesSpoken array, but
 * you have locally updated the properties of a JRLanguagesSpokenElement, you can just call
 * JRLanguagesSpokenElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRLanguagesSpokenElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceLanguagesSpokenArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRProfile#lookingFor array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfile#lookingFor property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfile#lookingFor property, and the name of the replaced array: \c "lookingFor".
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
 * When successful, the new array will be added to the JRProfile#lookingFor property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRLookingForElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfile#lookingFor or JRLookingForElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRLookingForElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRLookingForElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRLookingForElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfile#lookingFor array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRLookingForElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfile#lookingFor array, but
 * you have locally updated the properties of a JRLookingForElement, you can just call
 * JRLookingForElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRLookingForElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceLookingForArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRProfile#movies array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfile#movies property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfile#movies property, and the name of the replaced array: \c "movies".
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
 * When successful, the new array will be added to the JRProfile#movies property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRMoviesElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfile#movies or JRMoviesElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRMoviesElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRMoviesElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRMoviesElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfile#movies array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRMoviesElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfile#movies array, but
 * you have locally updated the properties of a JRMoviesElement, you can just call
 * JRMoviesElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRMoviesElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceMoviesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRProfile#music array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfile#music property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfile#music property, and the name of the replaced array: \c "music".
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
 * When successful, the new array will be added to the JRProfile#music property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRMusicElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfile#music or JRMusicElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRMusicElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRMusicElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRMusicElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfile#music array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRMusicElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfile#music array, but
 * you have locally updated the properties of a JRMusicElement, you can just call
 * JRMusicElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRMusicElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceMusicArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRProfile#organizations array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfile#organizations property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfile#organizations property, and the name of the replaced array: \c "organizations".
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
 * When successful, the new array will be added to the JRProfile#organizations property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JROrganizationsElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfile#organizations or JROrganizationsElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JROrganizationsElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JROrganizationsElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JROrganizationsElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfile#organizations array on Capture. Replacing the array will also
 * update any local changes to the properties of a JROrganizationsElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfile#organizations array, but
 * you have locally updated the properties of a JROrganizationsElement, you can just call
 * JROrganizationsElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JROrganizationsElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceOrganizationsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRProfile#pets array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfile#pets property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfile#pets property, and the name of the replaced array: \c "pets".
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
 * When successful, the new array will be added to the JRProfile#pets property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRPetsElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfile#pets or JRPetsElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRPetsElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRPetsElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRPetsElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfile#pets array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRPetsElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfile#pets array, but
 * you have locally updated the properties of a JRPetsElement, you can just call
 * JRPetsElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRPetsElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replacePetsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRProfile#phoneNumbers array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfile#phoneNumbers property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfile#phoneNumbers property, and the name of the replaced array: \c "phoneNumbers".
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
 * When successful, the new array will be added to the JRProfile#phoneNumbers property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRPhoneNumbersElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfile#phoneNumbers or JRPhoneNumbersElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRPhoneNumbersElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRPhoneNumbersElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRPhoneNumbersElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfile#phoneNumbers array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRPhoneNumbersElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfile#phoneNumbers array, but
 * you have locally updated the properties of a JRPhoneNumbersElement, you can just call
 * JRPhoneNumbersElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRPhoneNumbersElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replacePhoneNumbersArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRProfile#profilePhotos array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfile#profilePhotos property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfile#profilePhotos property, and the name of the replaced array: \c "profilePhotos".
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
 * When successful, the new array will be added to the JRProfile#profilePhotos property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRProfilePhotosElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfile#profilePhotos or JRProfilePhotosElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRProfilePhotosElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRProfilePhotosElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRProfilePhotosElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfile#profilePhotos array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRProfilePhotosElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfile#profilePhotos array, but
 * you have locally updated the properties of a JRProfilePhotosElement, you can just call
 * JRProfilePhotosElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRProfilePhotosElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceProfilePhotosArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRProfile#quotes array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfile#quotes property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfile#quotes property, and the name of the replaced array: \c "quotes".
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
 * When successful, the new array will be added to the JRProfile#quotes property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRQuotesElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfile#quotes or JRQuotesElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRQuotesElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRQuotesElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRQuotesElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfile#quotes array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRQuotesElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfile#quotes array, but
 * you have locally updated the properties of a JRQuotesElement, you can just call
 * JRQuotesElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRQuotesElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceQuotesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRProfile#relationships array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfile#relationships property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfile#relationships property, and the name of the replaced array: \c "relationships".
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
 * When successful, the new array will be added to the JRProfile#relationships property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRRelationshipsElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfile#relationships or JRRelationshipsElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRRelationshipsElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRRelationshipsElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRRelationshipsElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfile#relationships array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRRelationshipsElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfile#relationships array, but
 * you have locally updated the properties of a JRRelationshipsElement, you can just call
 * JRRelationshipsElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRRelationshipsElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceRelationshipsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRProfile#sports array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfile#sports property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfile#sports property, and the name of the replaced array: \c "sports".
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
 * When successful, the new array will be added to the JRProfile#sports property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRSportsElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfile#sports or JRSportsElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRSportsElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRSportsElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRSportsElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfile#sports array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRSportsElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfile#sports array, but
 * you have locally updated the properties of a JRSportsElement, you can just call
 * JRSportsElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRSportsElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceSportsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRProfile#tags array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfile#tags property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfile#tags property, and the name of the replaced array: \c "tags".
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
 * When successful, the new array will be added to the JRProfile#tags property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRTagsElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfile#tags or JRTagsElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRTagsElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRTagsElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRTagsElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfile#tags array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRTagsElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfile#tags array, but
 * you have locally updated the properties of a JRTagsElement, you can just call
 * JRTagsElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRTagsElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceTagsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRProfile#turnOffs array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfile#turnOffs property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfile#turnOffs property, and the name of the replaced array: \c "turnOffs".
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
 * When successful, the new array will be added to the JRProfile#turnOffs property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRTurnOffsElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfile#turnOffs or JRTurnOffsElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRTurnOffsElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRTurnOffsElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRTurnOffsElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfile#turnOffs array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRTurnOffsElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfile#turnOffs array, but
 * you have locally updated the properties of a JRTurnOffsElement, you can just call
 * JRTurnOffsElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRTurnOffsElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceTurnOffsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRProfile#turnOns array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfile#turnOns property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfile#turnOns property, and the name of the replaced array: \c "turnOns".
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
 * When successful, the new array will be added to the JRProfile#turnOns property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRTurnOnsElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfile#turnOns or JRTurnOnsElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRTurnOnsElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRTurnOnsElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRTurnOnsElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfile#turnOns array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRTurnOnsElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfile#turnOns array, but
 * you have locally updated the properties of a JRTurnOnsElement, you can just call
 * JRTurnOnsElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRTurnOnsElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceTurnOnsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRProfile#tvShows array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfile#tvShows property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfile#tvShows property, and the name of the replaced array: \c "tvShows".
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
 * When successful, the new array will be added to the JRProfile#tvShows property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRTvShowsElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfile#tvShows or JRTvShowsElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRTvShowsElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRTvShowsElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRTvShowsElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfile#tvShows array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRTvShowsElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfile#tvShows array, but
 * you have locally updated the properties of a JRTvShowsElement, you can just call
 * JRTvShowsElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRTvShowsElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceTvShowsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

/**
 * Use this method to replace the JRProfile#urls array on Capture after adding, removing,
 * or reordering elements. You should call this method immediately after you perform any of these actions.
 * This method will replace the entire array on Capture, including all of its elements and their sub-arrays and
 * sub-objects. When successful, the new array will be added to the JRProfile#urls property,
 * replacing the existing NSArray.
 *
 * If the array is replaced successfully, the method JRCaptureObjectDelegate#replaceArrayDidSucceedForObject:newArray:named:context:
 * will be called on your delegate. This method will return a pointer to the new array, which is also the same pointer
 * stored in the JRProfile#urls property, and the name of the replaced array: \c "urls".
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
 * When successful, the new array will be added to the JRProfile#urls property,
 * replacing the existing NSArray. The new array will contain new, but equivalent JRUrlsElement
 * objects. That is to say, the elements will be the same, but they will have new pointers. You should not hold onto
 * any references to the JRProfile#urls or JRUrlsElement objects
 * when you are replacing this array on Capture, as the pointers will become invalid.
 * 
 * @note
 * After the array has been replaced on Capture, you can now call JRUrlsElement#updateOnCaptureForDelegate:context:()
 * on the array's elements. You can check the JRUrlsElement#canBeUpdatedOnCapture property to determine
 * if an element can be updated or not. If the JRUrlsElement#canBeUpdatedOnCapture property is equal
 * to \c NO you should replace the JRProfile#urls array on Capture. Replacing the array will also
 * update any local changes to the properties of a JRUrlsElement, including sub-arrays and sub-objects.
 *
 * @par
 * If you haven't added, removed, or reordered any of the elements of the JRProfile#urls array, but
 * you have locally updated the properties of a JRUrlsElement, you can just call
 * JRUrlsElement#updateOnCaptureForDelegate:context:() to update the local changes on the Capture server.
 * The JRUrlsElement#canBeUpdatedOnCapture property will let you know if you can do this.
 **/
- (void)replaceUrlsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context;

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
 * This method recursively checks all of the sub-objects of JRProfile:
 *   - JRProfile#bodyType
 *   - JRProfile#currentLocation
 *   - JRProfile#name
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
 * This method recursively checks all of the sub-objects of JRProfile
 * but does not check any of the arrays of the JRProfile or the arrays' elements:
 *   - JRProfile#accounts, JRAccountsElement
 *   - JRProfile#activities, JRActivitiesElement
 *   - JRProfile#addresses, JRAddressesElement
 *   - JRProfile#books, JRBooksElement
 *   - JRProfile#cars, JRCarsElement
 *   - JRProfile#children, JRChildrenElement
 *   - JRProfile#emails, JREmailsElement
 *   - JRProfile#food, JRFoodElement
 *   - JRProfile#heroes, JRHeroesElement
 *   - JRProfile#ims, JRImsElement
 *   - JRProfile#interestedInMeeting, JRInterestedInMeetingElement
 *   - JRProfile#interests, JRInterestsElement
 *   - JRProfile#jobInterests, JRJobInterestsElement
 *   - JRProfile#languages, JRLanguagesElement
 *   - JRProfile#languagesSpoken, JRLanguagesSpokenElement
 *   - JRProfile#lookingFor, JRLookingForElement
 *   - JRProfile#movies, JRMoviesElement
 *   - JRProfile#music, JRMusicElement
 *   - JRProfile#organizations, JROrganizationsElement
 *   - JRProfile#pets, JRPetsElement
 *   - JRProfile#phoneNumbers, JRPhoneNumbersElement
 *   - JRProfile#profilePhotos, JRProfilePhotosElement
 *   - JRProfile#quotes, JRQuotesElement
 *   - JRProfile#relationships, JRRelationshipsElement
 *   - JRProfile#sports, JRSportsElement
 *   - JRProfile#tags, JRTagsElement
 *   - JRProfile#turnOffs, JRTurnOffsElement
 *   - JRProfile#turnOns, JRTurnOnsElement
 *   - JRProfile#tvShows, JRTvShowsElement
 *   - JRProfile#urls, JRUrlsElement
 * .
 * @par
 * If you have added or removed any elements from the arrays, you must call the following methods
 * to update the array on Capture: replaceAccountsArrayOnCaptureForDelegate:context:(),
 *   replaceActivitiesArrayOnCaptureForDelegate:context:(),
 *   replaceAddressesArrayOnCaptureForDelegate:context:(),
 *   replaceBooksArrayOnCaptureForDelegate:context:(),
 *   replaceCarsArrayOnCaptureForDelegate:context:(),
 *   replaceChildrenArrayOnCaptureForDelegate:context:(),
 *   replaceEmailsArrayOnCaptureForDelegate:context:(),
 *   replaceFoodArrayOnCaptureForDelegate:context:(),
 *   replaceHeroesArrayOnCaptureForDelegate:context:(),
 *   replaceImsArrayOnCaptureForDelegate:context:(),
 *   replaceInterestedInMeetingArrayOnCaptureForDelegate:context:(),
 *   replaceInterestsArrayOnCaptureForDelegate:context:(),
 *   replaceJobInterestsArrayOnCaptureForDelegate:context:(),
 *   replaceLanguagesArrayOnCaptureForDelegate:context:(),
 *   replaceLanguagesSpokenArrayOnCaptureForDelegate:context:(),
 *   replaceLookingForArrayOnCaptureForDelegate:context:(),
 *   replaceMoviesArrayOnCaptureForDelegate:context:(),
 *   replaceMusicArrayOnCaptureForDelegate:context:(),
 *   replaceOrganizationsArrayOnCaptureForDelegate:context:(),
 *   replacePetsArrayOnCaptureForDelegate:context:(),
 *   replacePhoneNumbersArrayOnCaptureForDelegate:context:(),
 *   replaceProfilePhotosArrayOnCaptureForDelegate:context:(),
 *   replaceQuotesArrayOnCaptureForDelegate:context:(),
 *   replaceRelationshipsArrayOnCaptureForDelegate:context:(),
 *   replaceSportsArrayOnCaptureForDelegate:context:(),
 *   replaceTagsArrayOnCaptureForDelegate:context:(),
 *   replaceTurnOffsArrayOnCaptureForDelegate:context:(),
 *   replaceTurnOnsArrayOnCaptureForDelegate:context:(),
 *   replaceTvShowsArrayOnCaptureForDelegate:context:(),
 *   replaceUrlsArrayOnCaptureForDelegate:context:()
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
