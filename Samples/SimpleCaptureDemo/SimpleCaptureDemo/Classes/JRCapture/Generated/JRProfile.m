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

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)


#import "JRCaptureObject+Internal.h"
#import "JRProfile.h"

@interface JRAccountsElement (JRAccountsElement_InternalMethods)
+ (id)accountsElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToAccountsElement:(JRAccountsElement *)otherAccountsElement;
@end

@interface JRAddressesElement (JRAddressesElement_InternalMethods)
+ (id)addressesElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToAddressesElement:(JRAddressesElement *)otherAddressesElement;
@end

@interface JRBodyType (JRBodyType_InternalMethods)
+ (id)bodyTypeObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToBodyType:(JRBodyType *)otherBodyType;
@end

@interface JRCurrentLocation (JRCurrentLocation_InternalMethods)
+ (id)currentLocationObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToCurrentLocation:(JRCurrentLocation *)otherCurrentLocation;
@end

@interface JREmailsElement (JREmailsElement_InternalMethods)
+ (id)emailsElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToEmailsElement:(JREmailsElement *)otherEmailsElement;
@end

@interface JRImsElement (JRImsElement_InternalMethods)
+ (id)imsElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToImsElement:(JRImsElement *)otherImsElement;
@end

@interface JRName (JRName_InternalMethods)
+ (id)nameObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToName:(JRName *)otherName;
@end

@interface JROrganizationsElement (JROrganizationsElement_InternalMethods)
+ (id)organizationsElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToOrganizationsElement:(JROrganizationsElement *)otherOrganizationsElement;
@end

@interface JRPhoneNumbersElement (JRPhoneNumbersElement_InternalMethods)
+ (id)phoneNumbersElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToPhoneNumbersElement:(JRPhoneNumbersElement *)otherPhoneNumbersElement;
@end

@interface JRProfilePhotosElement (JRProfilePhotosElement_InternalMethods)
+ (id)profilePhotosElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToProfilePhotosElement:(JRProfilePhotosElement *)otherProfilePhotosElement;
@end

@interface JRUrlsElement (JRUrlsElement_InternalMethods)
+ (id)urlsElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToUrlsElement:(JRUrlsElement *)otherUrlsElement;
@end

@implementation NSArray (JRArray_Accounts_ToFromDictionary)
- (NSArray*)arrayOfAccountsElementsFromAccountsDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredAccountsArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredAccountsArray addObject:[JRAccountsElement accountsElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredAccountsArray;
}

- (NSArray*)arrayOfAccountsElementsFromAccountsDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfAccountsElementsFromAccountsDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfAccountsDictionariesFromAccountsElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRAccountsElement class]])
            [filteredDictionaryArray addObject:[(JRAccountsElement*)object newDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfAccountsDictionariesFromAccountsElements
{
    return [self arrayOfAccountsDictionariesFromAccountsElementsForEncoder:NO];
}

- (NSArray*)arrayOfAccountsReplaceDictionariesFromAccountsElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRAccountsElement class]])
            [filteredDictionaryArray addObject:[(JRAccountsElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@implementation NSArray (JRArray_Addresses_ToFromDictionary)
- (NSArray*)arrayOfAddressesElementsFromAddressesDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredAddressesArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredAddressesArray addObject:[JRAddressesElement addressesElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredAddressesArray;
}

- (NSArray*)arrayOfAddressesElementsFromAddressesDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfAddressesElementsFromAddressesDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfAddressesDictionariesFromAddressesElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRAddressesElement class]])
            [filteredDictionaryArray addObject:[(JRAddressesElement*)object newDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfAddressesDictionariesFromAddressesElements
{
    return [self arrayOfAddressesDictionariesFromAddressesElementsForEncoder:NO];
}

- (NSArray*)arrayOfAddressesReplaceDictionariesFromAddressesElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRAddressesElement class]])
            [filteredDictionaryArray addObject:[(JRAddressesElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@implementation NSArray (JRArray_Emails_ToFromDictionary)
- (NSArray*)arrayOfEmailsElementsFromEmailsDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredEmailsArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredEmailsArray addObject:[JREmailsElement emailsElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredEmailsArray;
}

- (NSArray*)arrayOfEmailsElementsFromEmailsDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfEmailsElementsFromEmailsDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfEmailsDictionariesFromEmailsElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JREmailsElement class]])
            [filteredDictionaryArray addObject:[(JREmailsElement*)object newDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfEmailsDictionariesFromEmailsElements
{
    return [self arrayOfEmailsDictionariesFromEmailsElementsForEncoder:NO];
}

- (NSArray*)arrayOfEmailsReplaceDictionariesFromEmailsElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JREmailsElement class]])
            [filteredDictionaryArray addObject:[(JREmailsElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@implementation NSArray (JRArray_Ims_ToFromDictionary)
- (NSArray*)arrayOfImsElementsFromImsDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredImsArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredImsArray addObject:[JRImsElement imsElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredImsArray;
}

- (NSArray*)arrayOfImsElementsFromImsDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfImsElementsFromImsDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfImsDictionariesFromImsElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRImsElement class]])
            [filteredDictionaryArray addObject:[(JRImsElement*)object newDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfImsDictionariesFromImsElements
{
    return [self arrayOfImsDictionariesFromImsElementsForEncoder:NO];
}

- (NSArray*)arrayOfImsReplaceDictionariesFromImsElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRImsElement class]])
            [filteredDictionaryArray addObject:[(JRImsElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@implementation NSArray (JRArray_Organizations_ToFromDictionary)
- (NSArray*)arrayOfOrganizationsElementsFromOrganizationsDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredOrganizationsArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredOrganizationsArray addObject:[JROrganizationsElement organizationsElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredOrganizationsArray;
}

- (NSArray*)arrayOfOrganizationsElementsFromOrganizationsDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfOrganizationsElementsFromOrganizationsDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfOrganizationsDictionariesFromOrganizationsElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JROrganizationsElement class]])
            [filteredDictionaryArray addObject:[(JROrganizationsElement*)object newDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfOrganizationsDictionariesFromOrganizationsElements
{
    return [self arrayOfOrganizationsDictionariesFromOrganizationsElementsForEncoder:NO];
}

- (NSArray*)arrayOfOrganizationsReplaceDictionariesFromOrganizationsElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JROrganizationsElement class]])
            [filteredDictionaryArray addObject:[(JROrganizationsElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@implementation NSArray (JRArray_PhoneNumbers_ToFromDictionary)
- (NSArray*)arrayOfPhoneNumbersElementsFromPhoneNumbersDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredPhoneNumbersArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPhoneNumbersArray addObject:[JRPhoneNumbersElement phoneNumbersElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredPhoneNumbersArray;
}

- (NSArray*)arrayOfPhoneNumbersElementsFromPhoneNumbersDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfPhoneNumbersElementsFromPhoneNumbersDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfPhoneNumbersDictionariesFromPhoneNumbersElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPhoneNumbersElement class]])
            [filteredDictionaryArray addObject:[(JRPhoneNumbersElement*)object newDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPhoneNumbersDictionariesFromPhoneNumbersElements
{
    return [self arrayOfPhoneNumbersDictionariesFromPhoneNumbersElementsForEncoder:NO];
}

- (NSArray*)arrayOfPhoneNumbersReplaceDictionariesFromPhoneNumbersElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPhoneNumbersElement class]])
            [filteredDictionaryArray addObject:[(JRPhoneNumbersElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@implementation NSArray (JRArray_ProfilePhotos_ToFromDictionary)
- (NSArray*)arrayOfProfilePhotosElementsFromProfilePhotosDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredProfilePhotosArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredProfilePhotosArray addObject:[JRProfilePhotosElement profilePhotosElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredProfilePhotosArray;
}

- (NSArray*)arrayOfProfilePhotosElementsFromProfilePhotosDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfProfilePhotosElementsFromProfilePhotosDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfProfilePhotosDictionariesFromProfilePhotosElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRProfilePhotosElement class]])
            [filteredDictionaryArray addObject:[(JRProfilePhotosElement*)object newDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfProfilePhotosDictionariesFromProfilePhotosElements
{
    return [self arrayOfProfilePhotosDictionariesFromProfilePhotosElementsForEncoder:NO];
}

- (NSArray*)arrayOfProfilePhotosReplaceDictionariesFromProfilePhotosElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRProfilePhotosElement class]])
            [filteredDictionaryArray addObject:[(JRProfilePhotosElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@implementation NSArray (JRArray_Urls_ToFromDictionary)
- (NSArray*)arrayOfUrlsElementsFromUrlsDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredUrlsArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredUrlsArray addObject:[JRUrlsElement urlsElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredUrlsArray;
}

- (NSArray*)arrayOfUrlsElementsFromUrlsDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfUrlsElementsFromUrlsDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfUrlsDictionariesFromUrlsElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRUrlsElement class]])
            [filteredDictionaryArray addObject:[(JRUrlsElement*)object newDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfUrlsDictionariesFromUrlsElements
{
    return [self arrayOfUrlsDictionariesFromUrlsElementsForEncoder:NO];
}

- (NSArray*)arrayOfUrlsReplaceDictionariesFromUrlsElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRUrlsElement class]])
            [filteredDictionaryArray addObject:[(JRUrlsElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (Profile_ArrayComparison)
- (BOOL)isEqualToAccountsArray:(NSArray *)otherArray;
- (BOOL)isEqualToAddressesArray:(NSArray *)otherArray;
- (BOOL)isEqualToEmailsArray:(NSArray *)otherArray;
- (BOOL)isEqualToImsArray:(NSArray *)otherArray;
- (BOOL)isEqualToOrganizationsArray:(NSArray *)otherArray;
- (BOOL)isEqualToPhoneNumbersArray:(NSArray *)otherArray;
- (BOOL)isEqualToProfilePhotosArray:(NSArray *)otherArray;
- (BOOL)isEqualToUrlsArray:(NSArray *)otherArray;
@end

@implementation NSArray (Profile_ArrayComparison)

- (BOOL)isEqualToAccountsArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRAccountsElement *)[self objectAtIndex:i]) isEqualToAccountsElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToAddressesArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRAddressesElement *)[self objectAtIndex:i]) isEqualToAddressesElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToEmailsArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JREmailsElement *)[self objectAtIndex:i]) isEqualToEmailsElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToImsArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRImsElement *)[self objectAtIndex:i]) isEqualToImsElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToOrganizationsArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JROrganizationsElement *)[self objectAtIndex:i]) isEqualToOrganizationsElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToPhoneNumbersArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRPhoneNumbersElement *)[self objectAtIndex:i]) isEqualToPhoneNumbersElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToProfilePhotosArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRProfilePhotosElement *)[self objectAtIndex:i]) isEqualToProfilePhotosElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToUrlsArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRUrlsElement *)[self objectAtIndex:i]) isEqualToUrlsElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}
@end

@interface JRProfile ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JRProfile
{
    NSString *_aboutMe;
    NSArray *_accounts;
    JRStringArray *_activities;
    NSArray *_addresses;
    JRDate *_anniversary;
    NSString *_birthday;
    JRBodyType *_bodyType;
    JRStringArray *_books;
    JRStringArray *_cars;
    JRStringArray *_children;
    JRCurrentLocation *_currentLocation;
    NSString *_displayName;
    NSString *_drinker;
    NSArray *_emails;
    NSString *_ethnicity;
    NSString *_fashion;
    JRStringArray *_food;
    NSString *_gender;
    NSString *_happiestWhen;
    JRStringArray *_heroes;
    NSString *_humor;
    NSArray *_ims;
    JRStringArray *_interestedInMeeting;
    JRStringArray *_interests;
    JRStringArray *_jobInterests;
    JRStringArray *_languages;
    JRStringArray *_languagesSpoken;
    NSString *_livingArrangement;
    JRStringArray *_lookingFor;
    JRStringArray *_movies;
    JRStringArray *_music;
    JRName *_name;
    NSString *_nickname;
    NSString *_note;
    NSArray *_organizations;
    JRStringArray *_pets;
    NSArray *_phoneNumbers;
    NSArray *_profilePhotos;
    NSString *_politicalViews;
    NSString *_preferredUsername;
    NSString *_profileSong;
    NSString *_profileUrl;
    NSString *_profileVideo;
    JRDateTime *_published;
    JRStringArray *_quotes;
    NSString *_relationshipStatus;
    JRStringArray *_relationships;
    NSString *_religion;
    NSString *_romance;
    NSString *_scaredOf;
    NSString *_sexualOrientation;
    NSString *_smoker;
    JRStringArray *_sports;
    NSString *_status;
    JRStringArray *_tags;
    JRStringArray *_turnOffs;
    JRStringArray *_turnOns;
    JRStringArray *_tvShows;
    JRDateTime *_updated;
    NSArray *_urls;
    NSString *_utcOffset;
}
@synthesize canBeUpdatedOnCapture;

- (NSString *)aboutMe
{
    return _aboutMe;
}

- (void)setAboutMe:(NSString *)newAboutMe
{
    [self.dirtyPropertySet addObject:@"aboutMe"];

    _aboutMe = [newAboutMe copy];
}

- (NSArray *)accounts
{
    return _accounts;
}

- (void)setAccounts:(NSArray *)newAccounts
{
    _accounts = [newAccounts copy];
}

- (JRStringArray *)activities
{
    return _activities;
}

- (void)setActivities:(JRStringArray *)newActivities
{
    _activities = [newActivities copy];
}

- (NSArray *)addresses
{
    return _addresses;
}

- (void)setAddresses:(NSArray *)newAddresses
{
    _addresses = [newAddresses copy];
}

- (JRDate *)anniversary
{
    return _anniversary;
}

- (void)setAnniversary:(JRDate *)newAnniversary
{
    [self.dirtyPropertySet addObject:@"anniversary"];

    _anniversary = [newAnniversary copy];
}

- (NSString *)birthday
{
    return _birthday;
}

- (void)setBirthday:(NSString *)newBirthday
{
    [self.dirtyPropertySet addObject:@"birthday"];

    _birthday = [newBirthday copy];
}

- (JRBodyType *)bodyType
{
    return _bodyType;
}

- (void)setBodyType:(JRBodyType *)newBodyType
{
    [self.dirtyPropertySet addObject:@"bodyType"];

    _bodyType = newBodyType;

    [_bodyType setAllPropertiesToDirty];
}

- (JRStringArray *)books
{
    return _books;
}

- (void)setBooks:(JRStringArray *)newBooks
{
    _books = [newBooks copy];
}

- (JRStringArray *)cars
{
    return _cars;
}

- (void)setCars:(JRStringArray *)newCars
{
    _cars = [newCars copy];
}

- (JRStringArray *)children
{
    return _children;
}

- (void)setChildren:(JRStringArray *)newChildren
{
    _children = [newChildren copy];
}

- (JRCurrentLocation *)currentLocation
{
    return _currentLocation;
}

- (void)setCurrentLocation:(JRCurrentLocation *)newCurrentLocation
{
    [self.dirtyPropertySet addObject:@"currentLocation"];

    _currentLocation = newCurrentLocation;

    [_currentLocation setAllPropertiesToDirty];
}

- (NSString *)displayName
{
    return _displayName;
}

- (void)setDisplayName:(NSString *)newDisplayName
{
    [self.dirtyPropertySet addObject:@"displayName"];

    _displayName = [newDisplayName copy];
}

- (NSString *)drinker
{
    return _drinker;
}

- (void)setDrinker:(NSString *)newDrinker
{
    [self.dirtyPropertySet addObject:@"drinker"];

    _drinker = [newDrinker copy];
}

- (NSArray *)emails
{
    return _emails;
}

- (void)setEmails:(NSArray *)newEmails
{
    _emails = [newEmails copy];
}

- (NSString *)ethnicity
{
    return _ethnicity;
}

- (void)setEthnicity:(NSString *)newEthnicity
{
    [self.dirtyPropertySet addObject:@"ethnicity"];

    _ethnicity = [newEthnicity copy];
}

- (NSString *)fashion
{
    return _fashion;
}

- (void)setFashion:(NSString *)newFashion
{
    [self.dirtyPropertySet addObject:@"fashion"];

    _fashion = [newFashion copy];
}

- (JRStringArray *)food
{
    return _food;
}

- (void)setFood:(JRStringArray *)newFood
{
    _food = [newFood copy];
}

- (NSString *)gender
{
    return _gender;
}

- (void)setGender:(NSString *)newGender
{
    [self.dirtyPropertySet addObject:@"gender"];

    _gender = [newGender copy];
}

- (NSString *)happiestWhen
{
    return _happiestWhen;
}

- (void)setHappiestWhen:(NSString *)newHappiestWhen
{
    [self.dirtyPropertySet addObject:@"happiestWhen"];

    _happiestWhen = [newHappiestWhen copy];
}

- (JRStringArray *)heroes
{
    return _heroes;
}

- (void)setHeroes:(JRStringArray *)newHeroes
{
    _heroes = [newHeroes copy];
}

- (NSString *)humor
{
    return _humor;
}

- (void)setHumor:(NSString *)newHumor
{
    [self.dirtyPropertySet addObject:@"humor"];

    _humor = [newHumor copy];
}

- (NSArray *)ims
{
    return _ims;
}

- (void)setIms:(NSArray *)newIms
{
    _ims = [newIms copy];
}

- (JRStringArray *)interestedInMeeting
{
    return _interestedInMeeting;
}

- (void)setInterestedInMeeting:(JRStringArray *)newInterestedInMeeting
{
    _interestedInMeeting = [newInterestedInMeeting copy];
}

- (JRStringArray *)interests
{
    return _interests;
}

- (void)setInterests:(JRStringArray *)newInterests
{
    _interests = [newInterests copy];
}

- (JRStringArray *)jobInterests
{
    return _jobInterests;
}

- (void)setJobInterests:(JRStringArray *)newJobInterests
{
    _jobInterests = [newJobInterests copy];
}

- (JRStringArray *)languages
{
    return _languages;
}

- (void)setLanguages:(JRStringArray *)newLanguages
{
    _languages = [newLanguages copy];
}

- (JRStringArray *)languagesSpoken
{
    return _languagesSpoken;
}

- (void)setLanguagesSpoken:(JRStringArray *)newLanguagesSpoken
{
    _languagesSpoken = [newLanguagesSpoken copy];
}

- (NSString *)livingArrangement
{
    return _livingArrangement;
}

- (void)setLivingArrangement:(NSString *)newLivingArrangement
{
    [self.dirtyPropertySet addObject:@"livingArrangement"];

    _livingArrangement = [newLivingArrangement copy];
}

- (JRStringArray *)lookingFor
{
    return _lookingFor;
}

- (void)setLookingFor:(JRStringArray *)newLookingFor
{
    _lookingFor = [newLookingFor copy];
}

- (JRStringArray *)movies
{
    return _movies;
}

- (void)setMovies:(JRStringArray *)newMovies
{
    _movies = [newMovies copy];
}

- (JRStringArray *)music
{
    return _music;
}

- (void)setMusic:(JRStringArray *)newMusic
{
    _music = [newMusic copy];
}

- (JRName *)name
{
    return _name;
}

- (void)setName:(JRName *)newName
{
    [self.dirtyPropertySet addObject:@"name"];

    _name = newName;

    [_name setAllPropertiesToDirty];
}

- (NSString *)nickname
{
    return _nickname;
}

- (void)setNickname:(NSString *)newNickname
{
    [self.dirtyPropertySet addObject:@"nickname"];

    _nickname = [newNickname copy];
}

- (NSString *)note
{
    return _note;
}

- (void)setNote:(NSString *)newNote
{
    [self.dirtyPropertySet addObject:@"note"];

    _note = [newNote copy];
}

- (NSArray *)organizations
{
    return _organizations;
}

- (void)setOrganizations:(NSArray *)newOrganizations
{
    _organizations = [newOrganizations copy];
}

- (JRStringArray *)pets
{
    return _pets;
}

- (void)setPets:(JRStringArray *)newPets
{
    _pets = [newPets copy];
}

- (NSArray *)phoneNumbers
{
    return _phoneNumbers;
}

- (void)setPhoneNumbers:(NSArray *)newPhoneNumbers
{
    _phoneNumbers = [newPhoneNumbers copy];
}

- (NSArray *)profilePhotos
{
    return _profilePhotos;
}

- (void)setProfilePhotos:(NSArray *)newProfilePhotos
{
    _profilePhotos = [newProfilePhotos copy];
}

- (NSString *)politicalViews
{
    return _politicalViews;
}

- (void)setPoliticalViews:(NSString *)newPoliticalViews
{
    [self.dirtyPropertySet addObject:@"politicalViews"];

    _politicalViews = [newPoliticalViews copy];
}

- (NSString *)preferredUsername
{
    return _preferredUsername;
}

- (void)setPreferredUsername:(NSString *)newPreferredUsername
{
    [self.dirtyPropertySet addObject:@"preferredUsername"];

    _preferredUsername = [newPreferredUsername copy];
}

- (NSString *)profileSong
{
    return _profileSong;
}

- (void)setProfileSong:(NSString *)newProfileSong
{
    [self.dirtyPropertySet addObject:@"profileSong"];

    _profileSong = [newProfileSong copy];
}

- (NSString *)profileUrl
{
    return _profileUrl;
}

- (void)setProfileUrl:(NSString *)newProfileUrl
{
    [self.dirtyPropertySet addObject:@"profileUrl"];

    _profileUrl = [newProfileUrl copy];
}

- (NSString *)profileVideo
{
    return _profileVideo;
}

- (void)setProfileVideo:(NSString *)newProfileVideo
{
    [self.dirtyPropertySet addObject:@"profileVideo"];

    _profileVideo = [newProfileVideo copy];
}

- (JRDateTime *)published
{
    return _published;
}

- (void)setPublished:(JRDateTime *)newPublished
{
    [self.dirtyPropertySet addObject:@"published"];

    _published = [newPublished copy];
}

- (JRStringArray *)quotes
{
    return _quotes;
}

- (void)setQuotes:(JRStringArray *)newQuotes
{
    _quotes = [newQuotes copy];
}

- (NSString *)relationshipStatus
{
    return _relationshipStatus;
}

- (void)setRelationshipStatus:(NSString *)newRelationshipStatus
{
    [self.dirtyPropertySet addObject:@"relationshipStatus"];

    _relationshipStatus = [newRelationshipStatus copy];
}

- (JRStringArray *)relationships
{
    return _relationships;
}

- (void)setRelationships:(JRStringArray *)newRelationships
{
    _relationships = [newRelationships copy];
}

- (NSString *)religion
{
    return _religion;
}

- (void)setReligion:(NSString *)newReligion
{
    [self.dirtyPropertySet addObject:@"religion"];

    _religion = [newReligion copy];
}

- (NSString *)romance
{
    return _romance;
}

- (void)setRomance:(NSString *)newRomance
{
    [self.dirtyPropertySet addObject:@"romance"];

    _romance = [newRomance copy];
}

- (NSString *)scaredOf
{
    return _scaredOf;
}

- (void)setScaredOf:(NSString *)newScaredOf
{
    [self.dirtyPropertySet addObject:@"scaredOf"];

    _scaredOf = [newScaredOf copy];
}

- (NSString *)sexualOrientation
{
    return _sexualOrientation;
}

- (void)setSexualOrientation:(NSString *)newSexualOrientation
{
    [self.dirtyPropertySet addObject:@"sexualOrientation"];

    _sexualOrientation = [newSexualOrientation copy];
}

- (NSString *)smoker
{
    return _smoker;
}

- (void)setSmoker:(NSString *)newSmoker
{
    [self.dirtyPropertySet addObject:@"smoker"];

    _smoker = [newSmoker copy];
}

- (JRStringArray *)sports
{
    return _sports;
}

- (void)setSports:(JRStringArray *)newSports
{
    _sports = [newSports copy];
}

- (NSString *)status
{
    return _status;
}

- (void)setStatus:(NSString *)newStatus
{
    [self.dirtyPropertySet addObject:@"status"];

    _status = [newStatus copy];
}

- (JRStringArray *)tags
{
    return _tags;
}

- (void)setTags:(JRStringArray *)newTags
{
    _tags = [newTags copy];
}

- (JRStringArray *)turnOffs
{
    return _turnOffs;
}

- (void)setTurnOffs:(JRStringArray *)newTurnOffs
{
    _turnOffs = [newTurnOffs copy];
}

- (JRStringArray *)turnOns
{
    return _turnOns;
}

- (void)setTurnOns:(JRStringArray *)newTurnOns
{
    _turnOns = [newTurnOns copy];
}

- (JRStringArray *)tvShows
{
    return _tvShows;
}

- (void)setTvShows:(JRStringArray *)newTvShows
{
    _tvShows = [newTvShows copy];
}

- (JRDateTime *)updated
{
    return _updated;
}

- (void)setUpdated:(JRDateTime *)newUpdated
{
    [self.dirtyPropertySet addObject:@"updated"];

    _updated = [newUpdated copy];
}

- (NSArray *)urls
{
    return _urls;
}

- (void)setUrls:(NSArray *)newUrls
{
    _urls = [newUrls copy];
}

- (NSString *)utcOffset
{
    return _utcOffset;
}

- (void)setUtcOffset:(NSString *)newUtcOffset
{
    [self.dirtyPropertySet addObject:@"utcOffset"];

    _utcOffset = [newUtcOffset copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath      = @"";
        self.canBeUpdatedOnCapture  = NO;

        _bodyType = [[JRBodyType alloc] init];
        _currentLocation = [[JRCurrentLocation alloc] init];
        _name = [[JRName alloc] init];

        [self.dirtyPropertySet setSet:[self updatablePropertySet]];
    }
    return self;
}

+ (id)profile
{
    return [[JRProfile alloc] init];
}

- (NSDictionary*)newDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.aboutMe ? self.aboutMe : [NSNull null])
                   forKey:@"aboutMe"];
    [dictionary setObject:(self.accounts ? [self.accounts arrayOfAccountsDictionariesFromAccountsElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"accounts"];
    [dictionary setObject:(self.activities ? self.activities : [NSNull null])
                   forKey:@"activities"];
    [dictionary setObject:(self.addresses ? [self.addresses arrayOfAddressesDictionariesFromAddressesElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"addresses"];
    [dictionary setObject:(self.anniversary ? [self.anniversary stringFromISO8601Date] : [NSNull null])
                   forKey:@"anniversary"];
    [dictionary setObject:(self.birthday ? self.birthday : [NSNull null])
                   forKey:@"birthday"];
    [dictionary setObject:(self.bodyType ? [self.bodyType newDictionaryForEncoder:forEncoder] : [NSNull null])
                   forKey:@"bodyType"];
    [dictionary setObject:(self.books ? self.books : [NSNull null])
                   forKey:@"books"];
    [dictionary setObject:(self.cars ? self.cars : [NSNull null])
                   forKey:@"cars"];
    [dictionary setObject:(self.children ? self.children : [NSNull null])
                   forKey:@"children"];
    [dictionary setObject:(self.currentLocation ? [self.currentLocation newDictionaryForEncoder:forEncoder] : [NSNull null])
                   forKey:@"currentLocation"];
    [dictionary setObject:(self.displayName ? self.displayName : [NSNull null])
                   forKey:@"displayName"];
    [dictionary setObject:(self.drinker ? self.drinker : [NSNull null])
                   forKey:@"drinker"];
    [dictionary setObject:(self.emails ? [self.emails arrayOfEmailsDictionariesFromEmailsElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"emails"];
    [dictionary setObject:(self.ethnicity ? self.ethnicity : [NSNull null])
                   forKey:@"ethnicity"];
    [dictionary setObject:(self.fashion ? self.fashion : [NSNull null])
                   forKey:@"fashion"];
    [dictionary setObject:(self.food ? self.food : [NSNull null])
                   forKey:@"food"];
    [dictionary setObject:(self.gender ? self.gender : [NSNull null])
                   forKey:@"gender"];
    [dictionary setObject:(self.happiestWhen ? self.happiestWhen : [NSNull null])
                   forKey:@"happiestWhen"];
    [dictionary setObject:(self.heroes ? self.heroes : [NSNull null])
                   forKey:@"heroes"];
    [dictionary setObject:(self.humor ? self.humor : [NSNull null])
                   forKey:@"humor"];
    [dictionary setObject:(self.ims ? [self.ims arrayOfImsDictionariesFromImsElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"ims"];
    [dictionary setObject:(self.interestedInMeeting ? self.interestedInMeeting : [NSNull null])
                   forKey:@"interestedInMeeting"];
    [dictionary setObject:(self.interests ? self.interests : [NSNull null])
                   forKey:@"interests"];
    [dictionary setObject:(self.jobInterests ? self.jobInterests : [NSNull null])
                   forKey:@"jobInterests"];
    [dictionary setObject:(self.languages ? self.languages : [NSNull null])
                   forKey:@"languages"];
    [dictionary setObject:(self.languagesSpoken ? self.languagesSpoken : [NSNull null])
                   forKey:@"languagesSpoken"];
    [dictionary setObject:(self.livingArrangement ? self.livingArrangement : [NSNull null])
                   forKey:@"livingArrangement"];
    [dictionary setObject:(self.lookingFor ? self.lookingFor : [NSNull null])
                   forKey:@"lookingFor"];
    [dictionary setObject:(self.movies ? self.movies : [NSNull null])
                   forKey:@"movies"];
    [dictionary setObject:(self.music ? self.music : [NSNull null])
                   forKey:@"music"];
    [dictionary setObject:(self.name ? [self.name newDictionaryForEncoder:forEncoder] : [NSNull null])
                   forKey:@"name"];
    [dictionary setObject:(self.nickname ? self.nickname : [NSNull null])
                   forKey:@"nickname"];
    [dictionary setObject:(self.note ? self.note : [NSNull null])
                   forKey:@"note"];
    [dictionary setObject:(self.organizations ? [self.organizations arrayOfOrganizationsDictionariesFromOrganizationsElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"organizations"];
    [dictionary setObject:(self.pets ? self.pets : [NSNull null])
                   forKey:@"pets"];
    [dictionary setObject:(self.phoneNumbers ? [self.phoneNumbers arrayOfPhoneNumbersDictionariesFromPhoneNumbersElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"phoneNumbers"];
    [dictionary setObject:(self.profilePhotos ? [self.profilePhotos arrayOfProfilePhotosDictionariesFromProfilePhotosElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"photos"];
    [dictionary setObject:(self.politicalViews ? self.politicalViews : [NSNull null])
                   forKey:@"politicalViews"];
    [dictionary setObject:(self.preferredUsername ? self.preferredUsername : [NSNull null])
                   forKey:@"preferredUsername"];
    [dictionary setObject:(self.profileSong ? self.profileSong : [NSNull null])
                   forKey:@"profileSong"];
    [dictionary setObject:(self.profileUrl ? self.profileUrl : [NSNull null])
                   forKey:@"profileUrl"];
    [dictionary setObject:(self.profileVideo ? self.profileVideo : [NSNull null])
                   forKey:@"profileVideo"];
    [dictionary setObject:(self.published ? [self.published stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"published"];
    [dictionary setObject:(self.quotes ? self.quotes : [NSNull null])
                   forKey:@"quotes"];
    [dictionary setObject:(self.relationshipStatus ? self.relationshipStatus : [NSNull null])
                   forKey:@"relationshipStatus"];
    [dictionary setObject:(self.relationships ? self.relationships : [NSNull null])
                   forKey:@"relationships"];
    [dictionary setObject:(self.religion ? self.religion : [NSNull null])
                   forKey:@"religion"];
    [dictionary setObject:(self.romance ? self.romance : [NSNull null])
                   forKey:@"romance"];
    [dictionary setObject:(self.scaredOf ? self.scaredOf : [NSNull null])
                   forKey:@"scaredOf"];
    [dictionary setObject:(self.sexualOrientation ? self.sexualOrientation : [NSNull null])
                   forKey:@"sexualOrientation"];
    [dictionary setObject:(self.smoker ? self.smoker : [NSNull null])
                   forKey:@"smoker"];
    [dictionary setObject:(self.sports ? self.sports : [NSNull null])
                   forKey:@"sports"];
    [dictionary setObject:(self.status ? self.status : [NSNull null])
                   forKey:@"status"];
    [dictionary setObject:(self.tags ? self.tags : [NSNull null])
                   forKey:@"tags"];
    [dictionary setObject:(self.turnOffs ? self.turnOffs : [NSNull null])
                   forKey:@"turnOffs"];
    [dictionary setObject:(self.turnOns ? self.turnOns : [NSNull null])
                   forKey:@"turnOns"];
    [dictionary setObject:(self.tvShows ? self.tvShows : [NSNull null])
                   forKey:@"tvShows"];
    [dictionary setObject:(self.updated ? [self.updated stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"updated"];
    [dictionary setObject:(self.urls ? [self.urls arrayOfUrlsDictionariesFromUrlsElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"urls"];
    [dictionary setObject:(self.utcOffset ? self.utcOffset : [NSNull null])
                   forKey:@"utcOffset"];

    if (forEncoder)
    {
        [dictionary setObject:([self.dirtyPropertySet allObjects] ? [self.dirtyPropertySet allObjects] : [NSArray array])
                       forKey:@"dirtyPropertiesSet"];
        [dictionary setObject:(self.captureObjectPath ? self.captureObjectPath : [NSNull null])
                       forKey:@"captureObjectPath"];
        [dictionary setObject:[NSNumber numberWithBool:self.canBeUpdatedOnCapture]
                       forKey:@"canBeUpdatedOnCapture"];
    }

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

+ (id)profileObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRProfile *profile = [JRProfile profile];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        profile.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
        profile.canBeUpdatedOnCapture = [(NSNumber *)[dictionary objectForKey:@"canBeUpdatedOnCapture"] boolValue];
    }
    else
    {
        profile.captureObjectPath      = [NSString stringWithFormat:@"%@/%@", capturePath, @"profile"];
        profile.canBeUpdatedOnCapture = YES;
    }

    profile.aboutMe =
        [dictionary objectForKey:@"aboutMe"] != [NSNull null] ? 
        [dictionary objectForKey:@"aboutMe"] : nil;

    profile.accounts =
        [dictionary objectForKey:@"accounts"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"accounts"] arrayOfAccountsElementsFromAccountsDictionariesWithPath:profile.captureObjectPath fromDecoder:fromDecoder] : nil;

    profile.activities =
        [dictionary objectForKey:@"activities"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"activities"] arrayOfStringsFromStringPluralDictionariesWithType:@"activity"] : nil;

    profile.addresses =
        [dictionary objectForKey:@"addresses"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"addresses"] arrayOfAddressesElementsFromAddressesDictionariesWithPath:profile.captureObjectPath fromDecoder:fromDecoder] : nil;

    profile.anniversary =
        [dictionary objectForKey:@"anniversary"] != [NSNull null] ? 
        [JRDate dateFromISO8601DateString:[dictionary objectForKey:@"anniversary"]] : nil;

    profile.birthday =
        [dictionary objectForKey:@"birthday"] != [NSNull null] ? 
        [dictionary objectForKey:@"birthday"] : nil;

    profile.bodyType =
        [dictionary objectForKey:@"bodyType"] != [NSNull null] ? 
        [JRBodyType bodyTypeObjectFromDictionary:[dictionary objectForKey:@"bodyType"] withPath:profile.captureObjectPath fromDecoder:fromDecoder] : nil;

    profile.books =
        [dictionary objectForKey:@"books"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"books"] arrayOfStringsFromStringPluralDictionariesWithType:@"book"] : nil;

    profile.cars =
        [dictionary objectForKey:@"cars"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"cars"] arrayOfStringsFromStringPluralDictionariesWithType:@"car"] : nil;

    profile.children =
        [dictionary objectForKey:@"children"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"children"] arrayOfStringsFromStringPluralDictionariesWithType:@"value"] : nil;

    profile.currentLocation =
        [dictionary objectForKey:@"currentLocation"] != [NSNull null] ? 
        [JRCurrentLocation currentLocationObjectFromDictionary:[dictionary objectForKey:@"currentLocation"] withPath:profile.captureObjectPath fromDecoder:fromDecoder] : nil;

    profile.displayName =
        [dictionary objectForKey:@"displayName"] != [NSNull null] ? 
        [dictionary objectForKey:@"displayName"] : nil;

    profile.drinker =
        [dictionary objectForKey:@"drinker"] != [NSNull null] ? 
        [dictionary objectForKey:@"drinker"] : nil;

    profile.emails =
        [dictionary objectForKey:@"emails"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"emails"] arrayOfEmailsElementsFromEmailsDictionariesWithPath:profile.captureObjectPath fromDecoder:fromDecoder] : nil;

    profile.ethnicity =
        [dictionary objectForKey:@"ethnicity"] != [NSNull null] ? 
        [dictionary objectForKey:@"ethnicity"] : nil;

    profile.fashion =
        [dictionary objectForKey:@"fashion"] != [NSNull null] ? 
        [dictionary objectForKey:@"fashion"] : nil;

    profile.food =
        [dictionary objectForKey:@"food"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"food"] arrayOfStringsFromStringPluralDictionariesWithType:@"food"] : nil;

    profile.gender =
        [dictionary objectForKey:@"gender"] != [NSNull null] ? 
        [dictionary objectForKey:@"gender"] : nil;

    profile.happiestWhen =
        [dictionary objectForKey:@"happiestWhen"] != [NSNull null] ? 
        [dictionary objectForKey:@"happiestWhen"] : nil;

    profile.heroes =
        [dictionary objectForKey:@"heroes"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"heroes"] arrayOfStringsFromStringPluralDictionariesWithType:@"hero"] : nil;

    profile.humor =
        [dictionary objectForKey:@"humor"] != [NSNull null] ? 
        [dictionary objectForKey:@"humor"] : nil;

    profile.ims =
        [dictionary objectForKey:@"ims"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"ims"] arrayOfImsElementsFromImsDictionariesWithPath:profile.captureObjectPath fromDecoder:fromDecoder] : nil;

    profile.interestedInMeeting =
        [dictionary objectForKey:@"interestedInMeeting"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"interestedInMeeting"] arrayOfStringsFromStringPluralDictionariesWithType:@"interest"] : nil;

    profile.interests =
        [dictionary objectForKey:@"interests"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"interests"] arrayOfStringsFromStringPluralDictionariesWithType:@"interest"] : nil;

    profile.jobInterests =
        [dictionary objectForKey:@"jobInterests"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"jobInterests"] arrayOfStringsFromStringPluralDictionariesWithType:@"jobInterest"] : nil;

    profile.languages =
        [dictionary objectForKey:@"languages"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"languages"] arrayOfStringsFromStringPluralDictionariesWithType:@"language"] : nil;

    profile.languagesSpoken =
        [dictionary objectForKey:@"languagesSpoken"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"languagesSpoken"] arrayOfStringsFromStringPluralDictionariesWithType:@"languageSpoken"] : nil;

    profile.livingArrangement =
        [dictionary objectForKey:@"livingArrangement"] != [NSNull null] ? 
        [dictionary objectForKey:@"livingArrangement"] : nil;

    profile.lookingFor =
        [dictionary objectForKey:@"lookingFor"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"lookingFor"] arrayOfStringsFromStringPluralDictionariesWithType:@"value"] : nil;

    profile.movies =
        [dictionary objectForKey:@"movies"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"movies"] arrayOfStringsFromStringPluralDictionariesWithType:@"movie"] : nil;

    profile.music =
        [dictionary objectForKey:@"music"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"music"] arrayOfStringsFromStringPluralDictionariesWithType:@"music"] : nil;

    profile.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [JRName nameObjectFromDictionary:[dictionary objectForKey:@"name"] withPath:profile.captureObjectPath fromDecoder:fromDecoder] : nil;

    profile.nickname =
        [dictionary objectForKey:@"nickname"] != [NSNull null] ? 
        [dictionary objectForKey:@"nickname"] : nil;

    profile.note =
        [dictionary objectForKey:@"note"] != [NSNull null] ? 
        [dictionary objectForKey:@"note"] : nil;

    profile.organizations =
        [dictionary objectForKey:@"organizations"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"organizations"] arrayOfOrganizationsElementsFromOrganizationsDictionariesWithPath:profile.captureObjectPath fromDecoder:fromDecoder] : nil;

    profile.pets =
        [dictionary objectForKey:@"pets"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pets"] arrayOfStringsFromStringPluralDictionariesWithType:@"value"] : nil;

    profile.phoneNumbers =
        [dictionary objectForKey:@"phoneNumbers"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"phoneNumbers"] arrayOfPhoneNumbersElementsFromPhoneNumbersDictionariesWithPath:profile.captureObjectPath fromDecoder:fromDecoder] : nil;

    profile.profilePhotos =
        [dictionary objectForKey:@"photos"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"photos"] arrayOfProfilePhotosElementsFromProfilePhotosDictionariesWithPath:profile.captureObjectPath fromDecoder:fromDecoder] : nil;

    profile.politicalViews =
        [dictionary objectForKey:@"politicalViews"] != [NSNull null] ? 
        [dictionary objectForKey:@"politicalViews"] : nil;

    profile.preferredUsername =
        [dictionary objectForKey:@"preferredUsername"] != [NSNull null] ? 
        [dictionary objectForKey:@"preferredUsername"] : nil;

    profile.profileSong =
        [dictionary objectForKey:@"profileSong"] != [NSNull null] ? 
        [dictionary objectForKey:@"profileSong"] : nil;

    profile.profileUrl =
        [dictionary objectForKey:@"profileUrl"] != [NSNull null] ? 
        [dictionary objectForKey:@"profileUrl"] : nil;

    profile.profileVideo =
        [dictionary objectForKey:@"profileVideo"] != [NSNull null] ? 
        [dictionary objectForKey:@"profileVideo"] : nil;

    profile.published =
        [dictionary objectForKey:@"published"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"published"]] : nil;

    profile.quotes =
        [dictionary objectForKey:@"quotes"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"quotes"] arrayOfStringsFromStringPluralDictionariesWithType:@"quote"] : nil;

    profile.relationshipStatus =
        [dictionary objectForKey:@"relationshipStatus"] != [NSNull null] ? 
        [dictionary objectForKey:@"relationshipStatus"] : nil;

    profile.relationships =
        [dictionary objectForKey:@"relationships"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"relationships"] arrayOfStringsFromStringPluralDictionariesWithType:@"relationship"] : nil;

    profile.religion =
        [dictionary objectForKey:@"religion"] != [NSNull null] ? 
        [dictionary objectForKey:@"religion"] : nil;

    profile.romance =
        [dictionary objectForKey:@"romance"] != [NSNull null] ? 
        [dictionary objectForKey:@"romance"] : nil;

    profile.scaredOf =
        [dictionary objectForKey:@"scaredOf"] != [NSNull null] ? 
        [dictionary objectForKey:@"scaredOf"] : nil;

    profile.sexualOrientation =
        [dictionary objectForKey:@"sexualOrientation"] != [NSNull null] ? 
        [dictionary objectForKey:@"sexualOrientation"] : nil;

    profile.smoker =
        [dictionary objectForKey:@"smoker"] != [NSNull null] ? 
        [dictionary objectForKey:@"smoker"] : nil;

    profile.sports =
        [dictionary objectForKey:@"sports"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"sports"] arrayOfStringsFromStringPluralDictionariesWithType:@"sport"] : nil;

    profile.status =
        [dictionary objectForKey:@"status"] != [NSNull null] ? 
        [dictionary objectForKey:@"status"] : nil;

    profile.tags =
        [dictionary objectForKey:@"tags"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"tags"] arrayOfStringsFromStringPluralDictionariesWithType:@"tag"] : nil;

    profile.turnOffs =
        [dictionary objectForKey:@"turnOffs"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"turnOffs"] arrayOfStringsFromStringPluralDictionariesWithType:@"turnOff"] : nil;

    profile.turnOns =
        [dictionary objectForKey:@"turnOns"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"turnOns"] arrayOfStringsFromStringPluralDictionariesWithType:@"turnOn"] : nil;

    profile.tvShows =
        [dictionary objectForKey:@"tvShows"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"tvShows"] arrayOfStringsFromStringPluralDictionariesWithType:@"tvShow"] : nil;

    profile.updated =
        [dictionary objectForKey:@"updated"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"updated"]] : nil;

    profile.urls =
        [dictionary objectForKey:@"urls"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"urls"] arrayOfUrlsElementsFromUrlsDictionariesWithPath:profile.captureObjectPath fromDecoder:fromDecoder] : nil;

    profile.utcOffset =
        [dictionary objectForKey:@"utcOffset"] != [NSNull null] ? 
        [dictionary objectForKey:@"utcOffset"] : nil;

    if (fromDecoder)
        [profile.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [profile.dirtyPropertySet removeAllObjects];

    return profile;
}

+ (id)profileObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRProfile profileObjectFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [self.dirtyPropertySet copy];

    self.canBeUpdatedOnCapture = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@", capturePath, @"profile"];

    self.aboutMe =
        [dictionary objectForKey:@"aboutMe"] != [NSNull null] ? 
        [dictionary objectForKey:@"aboutMe"] : nil;

    self.accounts =
        [dictionary objectForKey:@"accounts"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"accounts"] arrayOfAccountsElementsFromAccountsDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    self.activities =
        [dictionary objectForKey:@"activities"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"activities"] arrayOfStringsFromStringPluralDictionariesWithType:@"activity"] : nil;

    self.addresses =
        [dictionary objectForKey:@"addresses"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"addresses"] arrayOfAddressesElementsFromAddressesDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    self.anniversary =
        [dictionary objectForKey:@"anniversary"] != [NSNull null] ? 
        [JRDate dateFromISO8601DateString:[dictionary objectForKey:@"anniversary"]] : nil;

    self.birthday =
        [dictionary objectForKey:@"birthday"] != [NSNull null] ? 
        [dictionary objectForKey:@"birthday"] : nil;

    if (![dictionary objectForKey:@"bodyType"] || [dictionary objectForKey:@"bodyType"] == [NSNull null])
        self.bodyType = nil;
    else if (!self.bodyType)
        self.bodyType = [JRBodyType bodyTypeObjectFromDictionary:[dictionary objectForKey:@"bodyType"] withPath:self.captureObjectPath fromDecoder:NO];
    else
        [self.bodyType replaceFromDictionary:[dictionary objectForKey:@"bodyType"] withPath:self.captureObjectPath];

    self.books =
        [dictionary objectForKey:@"books"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"books"] arrayOfStringsFromStringPluralDictionariesWithType:@"book"] : nil;

    self.cars =
        [dictionary objectForKey:@"cars"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"cars"] arrayOfStringsFromStringPluralDictionariesWithType:@"car"] : nil;

    self.children =
        [dictionary objectForKey:@"children"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"children"] arrayOfStringsFromStringPluralDictionariesWithType:@"value"] : nil;

    if (![dictionary objectForKey:@"currentLocation"] || [dictionary objectForKey:@"currentLocation"] == [NSNull null])
        self.currentLocation = nil;
    else if (!self.currentLocation)
        self.currentLocation = [JRCurrentLocation currentLocationObjectFromDictionary:[dictionary objectForKey:@"currentLocation"] withPath:self.captureObjectPath fromDecoder:NO];
    else
        [self.currentLocation replaceFromDictionary:[dictionary objectForKey:@"currentLocation"] withPath:self.captureObjectPath];

    self.displayName =
        [dictionary objectForKey:@"displayName"] != [NSNull null] ? 
        [dictionary objectForKey:@"displayName"] : nil;

    self.drinker =
        [dictionary objectForKey:@"drinker"] != [NSNull null] ? 
        [dictionary objectForKey:@"drinker"] : nil;

    self.emails =
        [dictionary objectForKey:@"emails"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"emails"] arrayOfEmailsElementsFromEmailsDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    self.ethnicity =
        [dictionary objectForKey:@"ethnicity"] != [NSNull null] ? 
        [dictionary objectForKey:@"ethnicity"] : nil;

    self.fashion =
        [dictionary objectForKey:@"fashion"] != [NSNull null] ? 
        [dictionary objectForKey:@"fashion"] : nil;

    self.food =
        [dictionary objectForKey:@"food"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"food"] arrayOfStringsFromStringPluralDictionariesWithType:@"food"] : nil;

    self.gender =
        [dictionary objectForKey:@"gender"] != [NSNull null] ? 
        [dictionary objectForKey:@"gender"] : nil;

    self.happiestWhen =
        [dictionary objectForKey:@"happiestWhen"] != [NSNull null] ? 
        [dictionary objectForKey:@"happiestWhen"] : nil;

    self.heroes =
        [dictionary objectForKey:@"heroes"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"heroes"] arrayOfStringsFromStringPluralDictionariesWithType:@"hero"] : nil;

    self.humor =
        [dictionary objectForKey:@"humor"] != [NSNull null] ? 
        [dictionary objectForKey:@"humor"] : nil;

    self.ims =
        [dictionary objectForKey:@"ims"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"ims"] arrayOfImsElementsFromImsDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    self.interestedInMeeting =
        [dictionary objectForKey:@"interestedInMeeting"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"interestedInMeeting"] arrayOfStringsFromStringPluralDictionariesWithType:@"interest"] : nil;

    self.interests =
        [dictionary objectForKey:@"interests"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"interests"] arrayOfStringsFromStringPluralDictionariesWithType:@"interest"] : nil;

    self.jobInterests =
        [dictionary objectForKey:@"jobInterests"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"jobInterests"] arrayOfStringsFromStringPluralDictionariesWithType:@"jobInterest"] : nil;

    self.languages =
        [dictionary objectForKey:@"languages"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"languages"] arrayOfStringsFromStringPluralDictionariesWithType:@"language"] : nil;

    self.languagesSpoken =
        [dictionary objectForKey:@"languagesSpoken"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"languagesSpoken"] arrayOfStringsFromStringPluralDictionariesWithType:@"languageSpoken"] : nil;

    self.livingArrangement =
        [dictionary objectForKey:@"livingArrangement"] != [NSNull null] ? 
        [dictionary objectForKey:@"livingArrangement"] : nil;

    self.lookingFor =
        [dictionary objectForKey:@"lookingFor"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"lookingFor"] arrayOfStringsFromStringPluralDictionariesWithType:@"value"] : nil;

    self.movies =
        [dictionary objectForKey:@"movies"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"movies"] arrayOfStringsFromStringPluralDictionariesWithType:@"movie"] : nil;

    self.music =
        [dictionary objectForKey:@"music"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"music"] arrayOfStringsFromStringPluralDictionariesWithType:@"music"] : nil;

    if (![dictionary objectForKey:@"name"] || [dictionary objectForKey:@"name"] == [NSNull null])
        self.name = nil;
    else if (!self.name)
        self.name = [JRName nameObjectFromDictionary:[dictionary objectForKey:@"name"] withPath:self.captureObjectPath fromDecoder:NO];
    else
        [self.name replaceFromDictionary:[dictionary objectForKey:@"name"] withPath:self.captureObjectPath];

    self.nickname =
        [dictionary objectForKey:@"nickname"] != [NSNull null] ? 
        [dictionary objectForKey:@"nickname"] : nil;

    self.note =
        [dictionary objectForKey:@"note"] != [NSNull null] ? 
        [dictionary objectForKey:@"note"] : nil;

    self.organizations =
        [dictionary objectForKey:@"organizations"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"organizations"] arrayOfOrganizationsElementsFromOrganizationsDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    self.pets =
        [dictionary objectForKey:@"pets"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"pets"] arrayOfStringsFromStringPluralDictionariesWithType:@"value"] : nil;

    self.phoneNumbers =
        [dictionary objectForKey:@"phoneNumbers"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"phoneNumbers"] arrayOfPhoneNumbersElementsFromPhoneNumbersDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    self.profilePhotos =
        [dictionary objectForKey:@"photos"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"photos"] arrayOfProfilePhotosElementsFromProfilePhotosDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    self.politicalViews =
        [dictionary objectForKey:@"politicalViews"] != [NSNull null] ? 
        [dictionary objectForKey:@"politicalViews"] : nil;

    self.preferredUsername =
        [dictionary objectForKey:@"preferredUsername"] != [NSNull null] ? 
        [dictionary objectForKey:@"preferredUsername"] : nil;

    self.profileSong =
        [dictionary objectForKey:@"profileSong"] != [NSNull null] ? 
        [dictionary objectForKey:@"profileSong"] : nil;

    self.profileUrl =
        [dictionary objectForKey:@"profileUrl"] != [NSNull null] ? 
        [dictionary objectForKey:@"profileUrl"] : nil;

    self.profileVideo =
        [dictionary objectForKey:@"profileVideo"] != [NSNull null] ? 
        [dictionary objectForKey:@"profileVideo"] : nil;

    self.published =
        [dictionary objectForKey:@"published"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"published"]] : nil;

    self.quotes =
        [dictionary objectForKey:@"quotes"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"quotes"] arrayOfStringsFromStringPluralDictionariesWithType:@"quote"] : nil;

    self.relationshipStatus =
        [dictionary objectForKey:@"relationshipStatus"] != [NSNull null] ? 
        [dictionary objectForKey:@"relationshipStatus"] : nil;

    self.relationships =
        [dictionary objectForKey:@"relationships"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"relationships"] arrayOfStringsFromStringPluralDictionariesWithType:@"relationship"] : nil;

    self.religion =
        [dictionary objectForKey:@"religion"] != [NSNull null] ? 
        [dictionary objectForKey:@"religion"] : nil;

    self.romance =
        [dictionary objectForKey:@"romance"] != [NSNull null] ? 
        [dictionary objectForKey:@"romance"] : nil;

    self.scaredOf =
        [dictionary objectForKey:@"scaredOf"] != [NSNull null] ? 
        [dictionary objectForKey:@"scaredOf"] : nil;

    self.sexualOrientation =
        [dictionary objectForKey:@"sexualOrientation"] != [NSNull null] ? 
        [dictionary objectForKey:@"sexualOrientation"] : nil;

    self.smoker =
        [dictionary objectForKey:@"smoker"] != [NSNull null] ? 
        [dictionary objectForKey:@"smoker"] : nil;

    self.sports =
        [dictionary objectForKey:@"sports"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"sports"] arrayOfStringsFromStringPluralDictionariesWithType:@"sport"] : nil;

    self.status =
        [dictionary objectForKey:@"status"] != [NSNull null] ? 
        [dictionary objectForKey:@"status"] : nil;

    self.tags =
        [dictionary objectForKey:@"tags"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"tags"] arrayOfStringsFromStringPluralDictionariesWithType:@"tag"] : nil;

    self.turnOffs =
        [dictionary objectForKey:@"turnOffs"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"turnOffs"] arrayOfStringsFromStringPluralDictionariesWithType:@"turnOff"] : nil;

    self.turnOns =
        [dictionary objectForKey:@"turnOns"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"turnOns"] arrayOfStringsFromStringPluralDictionariesWithType:@"turnOn"] : nil;

    self.tvShows =
        [dictionary objectForKey:@"tvShows"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"tvShows"] arrayOfStringsFromStringPluralDictionariesWithType:@"tvShow"] : nil;

    self.updated =
        [dictionary objectForKey:@"updated"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"updated"]] : nil;

    self.urls =
        [dictionary objectForKey:@"urls"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"urls"] arrayOfUrlsElementsFromUrlsDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    self.utcOffset =
        [dictionary objectForKey:@"utcOffset"] != [NSNull null] ? 
        [dictionary objectForKey:@"utcOffset"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"aboutMe", @"anniversary", @"birthday", @"bodyType", @"currentLocation", @"displayName", @"drinker", @"ethnicity", @"fashion", @"gender", @"happiestWhen", @"humor", @"livingArrangement", @"name", @"nickname", @"note", @"politicalViews", @"preferredUsername", @"profileSong", @"profileUrl", @"profileVideo", @"published", @"relationshipStatus", @"religion", @"romance", @"scaredOf", @"sexualOrientation", @"smoker", @"status", @"updated", @"utcOffset", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet addObjectsFromArray:[[self updatablePropertySet] allObjects]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[self.dirtyPropertySet copy] forKey:@"profile"];

    if (self.bodyType)
        [snapshotDictionary setObject:[self.bodyType snapshotDictionaryFromDirtyPropertySet]
                               forKey:@"bodyType"];

    if (self.currentLocation)
        [snapshotDictionary setObject:[self.currentLocation snapshotDictionaryFromDirtyPropertySet]
                               forKey:@"currentLocation"];

    if (self.name)
        [snapshotDictionary setObject:[self.name snapshotDictionaryFromDirtyPropertySet]
                               forKey:@"name"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"profile"])
        [self.dirtyPropertySet addObjectsFromArray:[[snapshotDictionary objectForKey:@"profile"] allObjects]];

    if ([snapshotDictionary objectForKey:@"bodyType"])
        [self.bodyType restoreDirtyPropertiesFromSnapshotDictionary:
                    [snapshotDictionary objectForKey:@"bodyType"]];

    if ([snapshotDictionary objectForKey:@"currentLocation"])
        [self.currentLocation restoreDirtyPropertiesFromSnapshotDictionary:
                    [snapshotDictionary objectForKey:@"currentLocation"]];

    if ([snapshotDictionary objectForKey:@"name"])
        [self.name restoreDirtyPropertiesFromSnapshotDictionary:
                    [snapshotDictionary objectForKey:@"name"]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"aboutMe"])
        [dictionary setObject:(self.aboutMe ? self.aboutMe : [NSNull null]) forKey:@"aboutMe"];

    if ([self.dirtyPropertySet containsObject:@"anniversary"])
        [dictionary setObject:(self.anniversary ? [self.anniversary stringFromISO8601Date] : [NSNull null]) forKey:@"anniversary"];

    if ([self.dirtyPropertySet containsObject:@"birthday"])
        [dictionary setObject:(self.birthday ? self.birthday : [NSNull null]) forKey:@"birthday"];

    if ([self.dirtyPropertySet containsObject:@"bodyType"])
        [dictionary setObject:(self.bodyType ?
                              [self.bodyType toUpdateDictionary] :
                              [[JRBodyType bodyType] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                       forKey:@"bodyType"];
    else if ([self.bodyType needsUpdate])
        [dictionary setObject:[self.bodyType toUpdateDictionary]
                       forKey:@"bodyType"];

    if ([self.dirtyPropertySet containsObject:@"currentLocation"])
        [dictionary setObject:(self.currentLocation ?
                              [self.currentLocation toUpdateDictionary] :
                              [[JRCurrentLocation currentLocation] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                       forKey:@"currentLocation"];
    else if ([self.currentLocation needsUpdate])
        [dictionary setObject:[self.currentLocation toUpdateDictionary]
                       forKey:@"currentLocation"];

    if ([self.dirtyPropertySet containsObject:@"displayName"])
        [dictionary setObject:(self.displayName ? self.displayName : [NSNull null]) forKey:@"displayName"];

    if ([self.dirtyPropertySet containsObject:@"drinker"])
        [dictionary setObject:(self.drinker ? self.drinker : [NSNull null]) forKey:@"drinker"];

    if ([self.dirtyPropertySet containsObject:@"ethnicity"])
        [dictionary setObject:(self.ethnicity ? self.ethnicity : [NSNull null]) forKey:@"ethnicity"];

    if ([self.dirtyPropertySet containsObject:@"fashion"])
        [dictionary setObject:(self.fashion ? self.fashion : [NSNull null]) forKey:@"fashion"];

    if ([self.dirtyPropertySet containsObject:@"gender"])
        [dictionary setObject:(self.gender ? self.gender : [NSNull null]) forKey:@"gender"];

    if ([self.dirtyPropertySet containsObject:@"happiestWhen"])
        [dictionary setObject:(self.happiestWhen ? self.happiestWhen : [NSNull null]) forKey:@"happiestWhen"];

    if ([self.dirtyPropertySet containsObject:@"humor"])
        [dictionary setObject:(self.humor ? self.humor : [NSNull null]) forKey:@"humor"];

    if ([self.dirtyPropertySet containsObject:@"livingArrangement"])
        [dictionary setObject:(self.livingArrangement ? self.livingArrangement : [NSNull null]) forKey:@"livingArrangement"];

    if ([self.dirtyPropertySet containsObject:@"name"])
        [dictionary setObject:(self.name ?
                              [self.name toUpdateDictionary] :
                              [[JRName name] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                       forKey:@"name"];
    else if ([self.name needsUpdate])
        [dictionary setObject:[self.name toUpdateDictionary]
                       forKey:@"name"];

    if ([self.dirtyPropertySet containsObject:@"nickname"])
        [dictionary setObject:(self.nickname ? self.nickname : [NSNull null]) forKey:@"nickname"];

    if ([self.dirtyPropertySet containsObject:@"note"])
        [dictionary setObject:(self.note ? self.note : [NSNull null]) forKey:@"note"];

    if ([self.dirtyPropertySet containsObject:@"politicalViews"])
        [dictionary setObject:(self.politicalViews ? self.politicalViews : [NSNull null]) forKey:@"politicalViews"];

    if ([self.dirtyPropertySet containsObject:@"preferredUsername"])
        [dictionary setObject:(self.preferredUsername ? self.preferredUsername : [NSNull null]) forKey:@"preferredUsername"];

    if ([self.dirtyPropertySet containsObject:@"profileSong"])
        [dictionary setObject:(self.profileSong ? self.profileSong : [NSNull null]) forKey:@"profileSong"];

    if ([self.dirtyPropertySet containsObject:@"profileUrl"])
        [dictionary setObject:(self.profileUrl ? self.profileUrl : [NSNull null]) forKey:@"profileUrl"];

    if ([self.dirtyPropertySet containsObject:@"profileVideo"])
        [dictionary setObject:(self.profileVideo ? self.profileVideo : [NSNull null]) forKey:@"profileVideo"];

    if ([self.dirtyPropertySet containsObject:@"published"])
        [dictionary setObject:(self.published ? [self.published stringFromISO8601DateTime] : [NSNull null]) forKey:@"published"];

    if ([self.dirtyPropertySet containsObject:@"relationshipStatus"])
        [dictionary setObject:(self.relationshipStatus ? self.relationshipStatus : [NSNull null]) forKey:@"relationshipStatus"];

    if ([self.dirtyPropertySet containsObject:@"religion"])
        [dictionary setObject:(self.religion ? self.religion : [NSNull null]) forKey:@"religion"];

    if ([self.dirtyPropertySet containsObject:@"romance"])
        [dictionary setObject:(self.romance ? self.romance : [NSNull null]) forKey:@"romance"];

    if ([self.dirtyPropertySet containsObject:@"scaredOf"])
        [dictionary setObject:(self.scaredOf ? self.scaredOf : [NSNull null]) forKey:@"scaredOf"];

    if ([self.dirtyPropertySet containsObject:@"sexualOrientation"])
        [dictionary setObject:(self.sexualOrientation ? self.sexualOrientation : [NSNull null]) forKey:@"sexualOrientation"];

    if ([self.dirtyPropertySet containsObject:@"smoker"])
        [dictionary setObject:(self.smoker ? self.smoker : [NSNull null]) forKey:@"smoker"];

    if ([self.dirtyPropertySet containsObject:@"status"])
        [dictionary setObject:(self.status ? self.status : [NSNull null]) forKey:@"status"];

    if ([self.dirtyPropertySet containsObject:@"updated"])
        [dictionary setObject:(self.updated ? [self.updated stringFromISO8601DateTime] : [NSNull null]) forKey:@"updated"];

    if ([self.dirtyPropertySet containsObject:@"utcOffset"])
        [dictionary setObject:(self.utcOffset ? self.utcOffset : [NSNull null]) forKey:@"utcOffset"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)updateOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [super updateOnCaptureForDelegate:delegate context:context];
}

- (NSDictionary *)toReplaceDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.aboutMe ? self.aboutMe : [NSNull null]) forKey:@"aboutMe"];

    [dictionary setObject:(self.accounts ?
                          [self.accounts arrayOfAccountsReplaceDictionariesFromAccountsElements] :
                          [NSArray array])
                   forKey:@"accounts"];

    [dictionary setObject:(self.activities ?
                          self.activities :
                          [NSArray array])
                   forKey:@"activities"];

    [dictionary setObject:(self.addresses ?
                          [self.addresses arrayOfAddressesReplaceDictionariesFromAddressesElements] :
                          [NSArray array])
                   forKey:@"addresses"];
    [dictionary setObject:(self.anniversary ? [self.anniversary stringFromISO8601Date] : [NSNull null]) forKey:@"anniversary"];
    [dictionary setObject:(self.birthday ? self.birthday : [NSNull null]) forKey:@"birthday"];

    [dictionary setObject:(self.bodyType ?
                          [self.bodyType toReplaceDictionary] :
                          [[JRBodyType bodyType] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                   forKey:@"bodyType"];

    [dictionary setObject:(self.books ?
                          self.books :
                          [NSArray array])
                   forKey:@"books"];

    [dictionary setObject:(self.cars ?
                          self.cars :
                          [NSArray array])
                   forKey:@"cars"];

    [dictionary setObject:(self.children ?
                          self.children :
                          [NSArray array])
                   forKey:@"children"];

    [dictionary setObject:(self.currentLocation ?
                          [self.currentLocation toReplaceDictionary] :
                          [[JRCurrentLocation currentLocation] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                   forKey:@"currentLocation"];
    [dictionary setObject:(self.displayName ? self.displayName : [NSNull null]) forKey:@"displayName"];
    [dictionary setObject:(self.drinker ? self.drinker : [NSNull null]) forKey:@"drinker"];

    [dictionary setObject:(self.emails ?
                          [self.emails arrayOfEmailsReplaceDictionariesFromEmailsElements] :
                          [NSArray array])
                   forKey:@"emails"];
    [dictionary setObject:(self.ethnicity ? self.ethnicity : [NSNull null]) forKey:@"ethnicity"];
    [dictionary setObject:(self.fashion ? self.fashion : [NSNull null]) forKey:@"fashion"];

    [dictionary setObject:(self.food ?
                          self.food :
                          [NSArray array])
                   forKey:@"food"];
    [dictionary setObject:(self.gender ? self.gender : [NSNull null]) forKey:@"gender"];
    [dictionary setObject:(self.happiestWhen ? self.happiestWhen : [NSNull null]) forKey:@"happiestWhen"];

    [dictionary setObject:(self.heroes ?
                          self.heroes :
                          [NSArray array])
                   forKey:@"heroes"];
    [dictionary setObject:(self.humor ? self.humor : [NSNull null]) forKey:@"humor"];

    [dictionary setObject:(self.ims ?
                          [self.ims arrayOfImsReplaceDictionariesFromImsElements] :
                          [NSArray array])
                   forKey:@"ims"];

    [dictionary setObject:(self.interestedInMeeting ?
                          self.interestedInMeeting :
                          [NSArray array])
                   forKey:@"interestedInMeeting"];

    [dictionary setObject:(self.interests ?
                          self.interests :
                          [NSArray array])
                   forKey:@"interests"];

    [dictionary setObject:(self.jobInterests ?
                          self.jobInterests :
                          [NSArray array])
                   forKey:@"jobInterests"];

    [dictionary setObject:(self.languages ?
                          self.languages :
                          [NSArray array])
                   forKey:@"languages"];

    [dictionary setObject:(self.languagesSpoken ?
                          self.languagesSpoken :
                          [NSArray array])
                   forKey:@"languagesSpoken"];
    [dictionary setObject:(self.livingArrangement ? self.livingArrangement : [NSNull null]) forKey:@"livingArrangement"];

    [dictionary setObject:(self.lookingFor ?
                          self.lookingFor :
                          [NSArray array])
                   forKey:@"lookingFor"];

    [dictionary setObject:(self.movies ?
                          self.movies :
                          [NSArray array])
                   forKey:@"movies"];

    [dictionary setObject:(self.music ?
                          self.music :
                          [NSArray array])
                   forKey:@"music"];

    [dictionary setObject:(self.name ?
                          [self.name toReplaceDictionary] :
                          [[JRName name] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                   forKey:@"name"];
    [dictionary setObject:(self.nickname ? self.nickname : [NSNull null]) forKey:@"nickname"];
    [dictionary setObject:(self.note ? self.note : [NSNull null]) forKey:@"note"];

    [dictionary setObject:(self.organizations ?
                          [self.organizations arrayOfOrganizationsReplaceDictionariesFromOrganizationsElements] :
                          [NSArray array])
                   forKey:@"organizations"];

    [dictionary setObject:(self.pets ?
                          self.pets :
                          [NSArray array])
                   forKey:@"pets"];

    [dictionary setObject:(self.phoneNumbers ?
                          [self.phoneNumbers arrayOfPhoneNumbersReplaceDictionariesFromPhoneNumbersElements] :
                          [NSArray array])
                   forKey:@"phoneNumbers"];

    [dictionary setObject:(self.profilePhotos ?
                          [self.profilePhotos arrayOfProfilePhotosReplaceDictionariesFromProfilePhotosElements] :
                          [NSArray array])
                   forKey:@"photos"];
    [dictionary setObject:(self.politicalViews ? self.politicalViews : [NSNull null]) forKey:@"politicalViews"];
    [dictionary setObject:(self.preferredUsername ? self.preferredUsername : [NSNull null]) forKey:@"preferredUsername"];
    [dictionary setObject:(self.profileSong ? self.profileSong : [NSNull null]) forKey:@"profileSong"];
    [dictionary setObject:(self.profileUrl ? self.profileUrl : [NSNull null]) forKey:@"profileUrl"];
    [dictionary setObject:(self.profileVideo ? self.profileVideo : [NSNull null]) forKey:@"profileVideo"];
    [dictionary setObject:(self.published ? [self.published stringFromISO8601DateTime] : [NSNull null]) forKey:@"published"];

    [dictionary setObject:(self.quotes ?
                          self.quotes :
                          [NSArray array])
                   forKey:@"quotes"];
    [dictionary setObject:(self.relationshipStatus ? self.relationshipStatus : [NSNull null]) forKey:@"relationshipStatus"];

    [dictionary setObject:(self.relationships ?
                          self.relationships :
                          [NSArray array])
                   forKey:@"relationships"];
    [dictionary setObject:(self.religion ? self.religion : [NSNull null]) forKey:@"religion"];
    [dictionary setObject:(self.romance ? self.romance : [NSNull null]) forKey:@"romance"];
    [dictionary setObject:(self.scaredOf ? self.scaredOf : [NSNull null]) forKey:@"scaredOf"];
    [dictionary setObject:(self.sexualOrientation ? self.sexualOrientation : [NSNull null]) forKey:@"sexualOrientation"];
    [dictionary setObject:(self.smoker ? self.smoker : [NSNull null]) forKey:@"smoker"];

    [dictionary setObject:(self.sports ?
                          self.sports :
                          [NSArray array])
                   forKey:@"sports"];
    [dictionary setObject:(self.status ? self.status : [NSNull null]) forKey:@"status"];

    [dictionary setObject:(self.tags ?
                          self.tags :
                          [NSArray array])
                   forKey:@"tags"];

    [dictionary setObject:(self.turnOffs ?
                          self.turnOffs :
                          [NSArray array])
                   forKey:@"turnOffs"];

    [dictionary setObject:(self.turnOns ?
                          self.turnOns :
                          [NSArray array])
                   forKey:@"turnOns"];

    [dictionary setObject:(self.tvShows ?
                          self.tvShows :
                          [NSArray array])
                   forKey:@"tvShows"];
    [dictionary setObject:(self.updated ? [self.updated stringFromISO8601DateTime] : [NSNull null]) forKey:@"updated"];

    [dictionary setObject:(self.urls ?
                          [self.urls arrayOfUrlsReplaceDictionariesFromUrlsElements] :
                          [NSArray array])
                   forKey:@"urls"];
    [dictionary setObject:(self.utcOffset ? self.utcOffset : [NSNull null]) forKey:@"utcOffset"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)replaceAccountsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.accounts named:@"accounts" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (void)replaceActivitiesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.activities named:@"activities" isArrayOfStrings:YES
                       withType:@"activity" forDelegate:delegate withContext:context];
}

- (void)replaceAddressesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.addresses named:@"addresses" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (void)replaceBooksArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.books named:@"books" isArrayOfStrings:YES
                       withType:@"book" forDelegate:delegate withContext:context];
}

- (void)replaceCarsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.cars named:@"cars" isArrayOfStrings:YES
                       withType:@"car" forDelegate:delegate withContext:context];
}

- (void)replaceChildrenArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.children named:@"children" isArrayOfStrings:YES
                       withType:@"value" forDelegate:delegate withContext:context];
}

- (void)replaceEmailsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.emails named:@"emails" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (void)replaceFoodArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.food named:@"food" isArrayOfStrings:YES
                       withType:@"food" forDelegate:delegate withContext:context];
}

- (void)replaceHeroesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.heroes named:@"heroes" isArrayOfStrings:YES
                       withType:@"hero" forDelegate:delegate withContext:context];
}

- (void)replaceImsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.ims named:@"ims" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (void)replaceInterestedInMeetingArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.interestedInMeeting named:@"interestedInMeeting" isArrayOfStrings:YES
                       withType:@"interest" forDelegate:delegate withContext:context];
}

- (void)replaceInterestsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.interests named:@"interests" isArrayOfStrings:YES
                       withType:@"interest" forDelegate:delegate withContext:context];
}

- (void)replaceJobInterestsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.jobInterests named:@"jobInterests" isArrayOfStrings:YES
                       withType:@"jobInterest" forDelegate:delegate withContext:context];
}

- (void)replaceLanguagesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.languages named:@"languages" isArrayOfStrings:YES
                       withType:@"language" forDelegate:delegate withContext:context];
}

- (void)replaceLanguagesSpokenArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.languagesSpoken named:@"languagesSpoken" isArrayOfStrings:YES
                       withType:@"languageSpoken" forDelegate:delegate withContext:context];
}

- (void)replaceLookingForArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.lookingFor named:@"lookingFor" isArrayOfStrings:YES
                       withType:@"value" forDelegate:delegate withContext:context];
}

- (void)replaceMoviesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.movies named:@"movies" isArrayOfStrings:YES
                       withType:@"movie" forDelegate:delegate withContext:context];
}

- (void)replaceMusicArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.music named:@"music" isArrayOfStrings:YES
                       withType:@"music" forDelegate:delegate withContext:context];
}

- (void)replaceOrganizationsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.organizations named:@"organizations" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (void)replacePetsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.pets named:@"pets" isArrayOfStrings:YES
                       withType:@"value" forDelegate:delegate withContext:context];
}

- (void)replacePhoneNumbersArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.phoneNumbers named:@"phoneNumbers" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (void)replaceProfilePhotosArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.profilePhotos named:@"profilePhotos" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (void)replaceQuotesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.quotes named:@"quotes" isArrayOfStrings:YES
                       withType:@"quote" forDelegate:delegate withContext:context];
}

- (void)replaceRelationshipsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.relationships named:@"relationships" isArrayOfStrings:YES
                       withType:@"relationship" forDelegate:delegate withContext:context];
}

- (void)replaceSportsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.sports named:@"sports" isArrayOfStrings:YES
                       withType:@"sport" forDelegate:delegate withContext:context];
}

- (void)replaceTagsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.tags named:@"tags" isArrayOfStrings:YES
                       withType:@"tag" forDelegate:delegate withContext:context];
}

- (void)replaceTurnOffsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.turnOffs named:@"turnOffs" isArrayOfStrings:YES
                       withType:@"turnOff" forDelegate:delegate withContext:context];
}

- (void)replaceTurnOnsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.turnOns named:@"turnOns" isArrayOfStrings:YES
                       withType:@"turnOn" forDelegate:delegate withContext:context];
}

- (void)replaceTvShowsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.tvShows named:@"tvShows" isArrayOfStrings:YES
                       withType:@"tvShow" forDelegate:delegate withContext:context];
}

- (void)replaceUrlsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.urls named:@"urls" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    if ([self.bodyType needsUpdate])
        return YES;

    if ([self.currentLocation needsUpdate])
        return YES;

    if ([self.name needsUpdate])
        return YES;

    return NO;
}

- (BOOL)isEqualToProfile:(JRProfile *)otherProfile
{
    if (!self.aboutMe && !otherProfile.aboutMe) /* Keep going... */;
    else if ((self.aboutMe == nil) ^ (otherProfile.aboutMe == nil)) return NO; // xor
    else if (![self.aboutMe isEqualToString:otherProfile.aboutMe]) return NO;

    if (!self.accounts && !otherProfile.accounts) /* Keep going... */;
    else if (!self.accounts && ![otherProfile.accounts count]) /* Keep going... */;
    else if (!otherProfile.accounts && ![self.accounts count]) /* Keep going... */;
    else if (![self.accounts isEqualToAccountsArray:otherProfile.accounts]) return NO;

    if (!self.activities && !otherProfile.activities) /* Keep going... */;
    else if (!self.activities && ![otherProfile.activities count]) /* Keep going... */;
    else if (!otherProfile.activities && ![self.activities count]) /* Keep going... */;
    else if (![self.activities isEqualToArray:otherProfile.activities]) return NO;

    if (!self.addresses && !otherProfile.addresses) /* Keep going... */;
    else if (!self.addresses && ![otherProfile.addresses count]) /* Keep going... */;
    else if (!otherProfile.addresses && ![self.addresses count]) /* Keep going... */;
    else if (![self.addresses isEqualToAddressesArray:otherProfile.addresses]) return NO;

    if (!self.anniversary && !otherProfile.anniversary) /* Keep going... */;
    else if ((self.anniversary == nil) ^ (otherProfile.anniversary == nil)) return NO; // xor
    else if (![self.anniversary isEqualToDate:otherProfile.anniversary]) return NO;

    if (!self.birthday && !otherProfile.birthday) /* Keep going... */;
    else if ((self.birthday == nil) ^ (otherProfile.birthday == nil)) return NO; // xor
    else if (![self.birthday isEqualToString:otherProfile.birthday]) return NO;

    if (!self.bodyType && !otherProfile.bodyType) /* Keep going... */;
    else if (!self.bodyType && [otherProfile.bodyType isEqualToBodyType:[JRBodyType bodyType]]) /* Keep going... */;
    else if (!otherProfile.bodyType && [self.bodyType isEqualToBodyType:[JRBodyType bodyType]]) /* Keep going... */;
    else if (![self.bodyType isEqualToBodyType:otherProfile.bodyType]) return NO;

    if (!self.books && !otherProfile.books) /* Keep going... */;
    else if (!self.books && ![otherProfile.books count]) /* Keep going... */;
    else if (!otherProfile.books && ![self.books count]) /* Keep going... */;
    else if (![self.books isEqualToArray:otherProfile.books]) return NO;

    if (!self.cars && !otherProfile.cars) /* Keep going... */;
    else if (!self.cars && ![otherProfile.cars count]) /* Keep going... */;
    else if (!otherProfile.cars && ![self.cars count]) /* Keep going... */;
    else if (![self.cars isEqualToArray:otherProfile.cars]) return NO;

    if (!self.children && !otherProfile.children) /* Keep going... */;
    else if (!self.children && ![otherProfile.children count]) /* Keep going... */;
    else if (!otherProfile.children && ![self.children count]) /* Keep going... */;
    else if (![self.children isEqualToArray:otherProfile.children]) return NO;

    if (!self.currentLocation && !otherProfile.currentLocation) /* Keep going... */;
    else if (!self.currentLocation && [otherProfile.currentLocation isEqualToCurrentLocation:[JRCurrentLocation currentLocation]]) /* Keep going... */;
    else if (!otherProfile.currentLocation && [self.currentLocation isEqualToCurrentLocation:[JRCurrentLocation currentLocation]]) /* Keep going... */;
    else if (![self.currentLocation isEqualToCurrentLocation:otherProfile.currentLocation]) return NO;

    if (!self.displayName && !otherProfile.displayName) /* Keep going... */;
    else if ((self.displayName == nil) ^ (otherProfile.displayName == nil)) return NO; // xor
    else if (![self.displayName isEqualToString:otherProfile.displayName]) return NO;

    if (!self.drinker && !otherProfile.drinker) /* Keep going... */;
    else if ((self.drinker == nil) ^ (otherProfile.drinker == nil)) return NO; // xor
    else if (![self.drinker isEqualToString:otherProfile.drinker]) return NO;

    if (!self.emails && !otherProfile.emails) /* Keep going... */;
    else if (!self.emails && ![otherProfile.emails count]) /* Keep going... */;
    else if (!otherProfile.emails && ![self.emails count]) /* Keep going... */;
    else if (![self.emails isEqualToEmailsArray:otherProfile.emails]) return NO;

    if (!self.ethnicity && !otherProfile.ethnicity) /* Keep going... */;
    else if ((self.ethnicity == nil) ^ (otherProfile.ethnicity == nil)) return NO; // xor
    else if (![self.ethnicity isEqualToString:otherProfile.ethnicity]) return NO;

    if (!self.fashion && !otherProfile.fashion) /* Keep going... */;
    else if ((self.fashion == nil) ^ (otherProfile.fashion == nil)) return NO; // xor
    else if (![self.fashion isEqualToString:otherProfile.fashion]) return NO;

    if (!self.food && !otherProfile.food) /* Keep going... */;
    else if (!self.food && ![otherProfile.food count]) /* Keep going... */;
    else if (!otherProfile.food && ![self.food count]) /* Keep going... */;
    else if (![self.food isEqualToArray:otherProfile.food]) return NO;

    if (!self.gender && !otherProfile.gender) /* Keep going... */;
    else if ((self.gender == nil) ^ (otherProfile.gender == nil)) return NO; // xor
    else if (![self.gender isEqualToString:otherProfile.gender]) return NO;

    if (!self.happiestWhen && !otherProfile.happiestWhen) /* Keep going... */;
    else if ((self.happiestWhen == nil) ^ (otherProfile.happiestWhen == nil)) return NO; // xor
    else if (![self.happiestWhen isEqualToString:otherProfile.happiestWhen]) return NO;

    if (!self.heroes && !otherProfile.heroes) /* Keep going... */;
    else if (!self.heroes && ![otherProfile.heroes count]) /* Keep going... */;
    else if (!otherProfile.heroes && ![self.heroes count]) /* Keep going... */;
    else if (![self.heroes isEqualToArray:otherProfile.heroes]) return NO;

    if (!self.humor && !otherProfile.humor) /* Keep going... */;
    else if ((self.humor == nil) ^ (otherProfile.humor == nil)) return NO; // xor
    else if (![self.humor isEqualToString:otherProfile.humor]) return NO;

    if (!self.ims && !otherProfile.ims) /* Keep going... */;
    else if (!self.ims && ![otherProfile.ims count]) /* Keep going... */;
    else if (!otherProfile.ims && ![self.ims count]) /* Keep going... */;
    else if (![self.ims isEqualToImsArray:otherProfile.ims]) return NO;

    if (!self.interestedInMeeting && !otherProfile.interestedInMeeting) /* Keep going... */;
    else if (!self.interestedInMeeting && ![otherProfile.interestedInMeeting count]) /* Keep going... */;
    else if (!otherProfile.interestedInMeeting && ![self.interestedInMeeting count]) /* Keep going... */;
    else if (![self.interestedInMeeting isEqualToArray:otherProfile.interestedInMeeting]) return NO;

    if (!self.interests && !otherProfile.interests) /* Keep going... */;
    else if (!self.interests && ![otherProfile.interests count]) /* Keep going... */;
    else if (!otherProfile.interests && ![self.interests count]) /* Keep going... */;
    else if (![self.interests isEqualToArray:otherProfile.interests]) return NO;

    if (!self.jobInterests && !otherProfile.jobInterests) /* Keep going... */;
    else if (!self.jobInterests && ![otherProfile.jobInterests count]) /* Keep going... */;
    else if (!otherProfile.jobInterests && ![self.jobInterests count]) /* Keep going... */;
    else if (![self.jobInterests isEqualToArray:otherProfile.jobInterests]) return NO;

    if (!self.languages && !otherProfile.languages) /* Keep going... */;
    else if (!self.languages && ![otherProfile.languages count]) /* Keep going... */;
    else if (!otherProfile.languages && ![self.languages count]) /* Keep going... */;
    else if (![self.languages isEqualToArray:otherProfile.languages]) return NO;

    if (!self.languagesSpoken && !otherProfile.languagesSpoken) /* Keep going... */;
    else if (!self.languagesSpoken && ![otherProfile.languagesSpoken count]) /* Keep going... */;
    else if (!otherProfile.languagesSpoken && ![self.languagesSpoken count]) /* Keep going... */;
    else if (![self.languagesSpoken isEqualToArray:otherProfile.languagesSpoken]) return NO;

    if (!self.livingArrangement && !otherProfile.livingArrangement) /* Keep going... */;
    else if ((self.livingArrangement == nil) ^ (otherProfile.livingArrangement == nil)) return NO; // xor
    else if (![self.livingArrangement isEqualToString:otherProfile.livingArrangement]) return NO;

    if (!self.lookingFor && !otherProfile.lookingFor) /* Keep going... */;
    else if (!self.lookingFor && ![otherProfile.lookingFor count]) /* Keep going... */;
    else if (!otherProfile.lookingFor && ![self.lookingFor count]) /* Keep going... */;
    else if (![self.lookingFor isEqualToArray:otherProfile.lookingFor]) return NO;

    if (!self.movies && !otherProfile.movies) /* Keep going... */;
    else if (!self.movies && ![otherProfile.movies count]) /* Keep going... */;
    else if (!otherProfile.movies && ![self.movies count]) /* Keep going... */;
    else if (![self.movies isEqualToArray:otherProfile.movies]) return NO;

    if (!self.music && !otherProfile.music) /* Keep going... */;
    else if (!self.music && ![otherProfile.music count]) /* Keep going... */;
    else if (!otherProfile.music && ![self.music count]) /* Keep going... */;
    else if (![self.music isEqualToArray:otherProfile.music]) return NO;

    if (!self.name && !otherProfile.name) /* Keep going... */;
    else if (!self.name && [otherProfile.name isEqualToName:[JRName name]]) /* Keep going... */;
    else if (!otherProfile.name && [self.name isEqualToName:[JRName name]]) /* Keep going... */;
    else if (![self.name isEqualToName:otherProfile.name]) return NO;

    if (!self.nickname && !otherProfile.nickname) /* Keep going... */;
    else if ((self.nickname == nil) ^ (otherProfile.nickname == nil)) return NO; // xor
    else if (![self.nickname isEqualToString:otherProfile.nickname]) return NO;

    if (!self.note && !otherProfile.note) /* Keep going... */;
    else if ((self.note == nil) ^ (otherProfile.note == nil)) return NO; // xor
    else if (![self.note isEqualToString:otherProfile.note]) return NO;

    if (!self.organizations && !otherProfile.organizations) /* Keep going... */;
    else if (!self.organizations && ![otherProfile.organizations count]) /* Keep going... */;
    else if (!otherProfile.organizations && ![self.organizations count]) /* Keep going... */;
    else if (![self.organizations isEqualToOrganizationsArray:otherProfile.organizations]) return NO;

    if (!self.pets && !otherProfile.pets) /* Keep going... */;
    else if (!self.pets && ![otherProfile.pets count]) /* Keep going... */;
    else if (!otherProfile.pets && ![self.pets count]) /* Keep going... */;
    else if (![self.pets isEqualToArray:otherProfile.pets]) return NO;

    if (!self.phoneNumbers && !otherProfile.phoneNumbers) /* Keep going... */;
    else if (!self.phoneNumbers && ![otherProfile.phoneNumbers count]) /* Keep going... */;
    else if (!otherProfile.phoneNumbers && ![self.phoneNumbers count]) /* Keep going... */;
    else if (![self.phoneNumbers isEqualToPhoneNumbersArray:otherProfile.phoneNumbers]) return NO;

    if (!self.profilePhotos && !otherProfile.profilePhotos) /* Keep going... */;
    else if (!self.profilePhotos && ![otherProfile.profilePhotos count]) /* Keep going... */;
    else if (!otherProfile.profilePhotos && ![self.profilePhotos count]) /* Keep going... */;
    else if (![self.profilePhotos isEqualToProfilePhotosArray:otherProfile.profilePhotos]) return NO;

    if (!self.politicalViews && !otherProfile.politicalViews) /* Keep going... */;
    else if ((self.politicalViews == nil) ^ (otherProfile.politicalViews == nil)) return NO; // xor
    else if (![self.politicalViews isEqualToString:otherProfile.politicalViews]) return NO;

    if (!self.preferredUsername && !otherProfile.preferredUsername) /* Keep going... */;
    else if ((self.preferredUsername == nil) ^ (otherProfile.preferredUsername == nil)) return NO; // xor
    else if (![self.preferredUsername isEqualToString:otherProfile.preferredUsername]) return NO;

    if (!self.profileSong && !otherProfile.profileSong) /* Keep going... */;
    else if ((self.profileSong == nil) ^ (otherProfile.profileSong == nil)) return NO; // xor
    else if (![self.profileSong isEqualToString:otherProfile.profileSong]) return NO;

    if (!self.profileUrl && !otherProfile.profileUrl) /* Keep going... */;
    else if ((self.profileUrl == nil) ^ (otherProfile.profileUrl == nil)) return NO; // xor
    else if (![self.profileUrl isEqualToString:otherProfile.profileUrl]) return NO;

    if (!self.profileVideo && !otherProfile.profileVideo) /* Keep going... */;
    else if ((self.profileVideo == nil) ^ (otherProfile.profileVideo == nil)) return NO; // xor
    else if (![self.profileVideo isEqualToString:otherProfile.profileVideo]) return NO;

    if (!self.published && !otherProfile.published) /* Keep going... */;
    else if ((self.published == nil) ^ (otherProfile.published == nil)) return NO; // xor
    else if (![self.published isEqualToDate:otherProfile.published]) return NO;

    if (!self.quotes && !otherProfile.quotes) /* Keep going... */;
    else if (!self.quotes && ![otherProfile.quotes count]) /* Keep going... */;
    else if (!otherProfile.quotes && ![self.quotes count]) /* Keep going... */;
    else if (![self.quotes isEqualToArray:otherProfile.quotes]) return NO;

    if (!self.relationshipStatus && !otherProfile.relationshipStatus) /* Keep going... */;
    else if ((self.relationshipStatus == nil) ^ (otherProfile.relationshipStatus == nil)) return NO; // xor
    else if (![self.relationshipStatus isEqualToString:otherProfile.relationshipStatus]) return NO;

    if (!self.relationships && !otherProfile.relationships) /* Keep going... */;
    else if (!self.relationships && ![otherProfile.relationships count]) /* Keep going... */;
    else if (!otherProfile.relationships && ![self.relationships count]) /* Keep going... */;
    else if (![self.relationships isEqualToArray:otherProfile.relationships]) return NO;

    if (!self.religion && !otherProfile.religion) /* Keep going... */;
    else if ((self.religion == nil) ^ (otherProfile.religion == nil)) return NO; // xor
    else if (![self.religion isEqualToString:otherProfile.religion]) return NO;

    if (!self.romance && !otherProfile.romance) /* Keep going... */;
    else if ((self.romance == nil) ^ (otherProfile.romance == nil)) return NO; // xor
    else if (![self.romance isEqualToString:otherProfile.romance]) return NO;

    if (!self.scaredOf && !otherProfile.scaredOf) /* Keep going... */;
    else if ((self.scaredOf == nil) ^ (otherProfile.scaredOf == nil)) return NO; // xor
    else if (![self.scaredOf isEqualToString:otherProfile.scaredOf]) return NO;

    if (!self.sexualOrientation && !otherProfile.sexualOrientation) /* Keep going... */;
    else if ((self.sexualOrientation == nil) ^ (otherProfile.sexualOrientation == nil)) return NO; // xor
    else if (![self.sexualOrientation isEqualToString:otherProfile.sexualOrientation]) return NO;

    if (!self.smoker && !otherProfile.smoker) /* Keep going... */;
    else if ((self.smoker == nil) ^ (otherProfile.smoker == nil)) return NO; // xor
    else if (![self.smoker isEqualToString:otherProfile.smoker]) return NO;

    if (!self.sports && !otherProfile.sports) /* Keep going... */;
    else if (!self.sports && ![otherProfile.sports count]) /* Keep going... */;
    else if (!otherProfile.sports && ![self.sports count]) /* Keep going... */;
    else if (![self.sports isEqualToArray:otherProfile.sports]) return NO;

    if (!self.status && !otherProfile.status) /* Keep going... */;
    else if ((self.status == nil) ^ (otherProfile.status == nil)) return NO; // xor
    else if (![self.status isEqualToString:otherProfile.status]) return NO;

    if (!self.tags && !otherProfile.tags) /* Keep going... */;
    else if (!self.tags && ![otherProfile.tags count]) /* Keep going... */;
    else if (!otherProfile.tags && ![self.tags count]) /* Keep going... */;
    else if (![self.tags isEqualToArray:otherProfile.tags]) return NO;

    if (!self.turnOffs && !otherProfile.turnOffs) /* Keep going... */;
    else if (!self.turnOffs && ![otherProfile.turnOffs count]) /* Keep going... */;
    else if (!otherProfile.turnOffs && ![self.turnOffs count]) /* Keep going... */;
    else if (![self.turnOffs isEqualToArray:otherProfile.turnOffs]) return NO;

    if (!self.turnOns && !otherProfile.turnOns) /* Keep going... */;
    else if (!self.turnOns && ![otherProfile.turnOns count]) /* Keep going... */;
    else if (!otherProfile.turnOns && ![self.turnOns count]) /* Keep going... */;
    else if (![self.turnOns isEqualToArray:otherProfile.turnOns]) return NO;

    if (!self.tvShows && !otherProfile.tvShows) /* Keep going... */;
    else if (!self.tvShows && ![otherProfile.tvShows count]) /* Keep going... */;
    else if (!otherProfile.tvShows && ![self.tvShows count]) /* Keep going... */;
    else if (![self.tvShows isEqualToArray:otherProfile.tvShows]) return NO;

    if (!self.updated && !otherProfile.updated) /* Keep going... */;
    else if ((self.updated == nil) ^ (otherProfile.updated == nil)) return NO; // xor
    else if (![self.updated isEqualToDate:otherProfile.updated]) return NO;

    if (!self.urls && !otherProfile.urls) /* Keep going... */;
    else if (!self.urls && ![otherProfile.urls count]) /* Keep going... */;
    else if (!otherProfile.urls && ![self.urls count]) /* Keep going... */;
    else if (![self.urls isEqualToUrlsArray:otherProfile.urls]) return NO;

    if (!self.utcOffset && !otherProfile.utcOffset) /* Keep going... */;
    else if ((self.utcOffset == nil) ^ (otherProfile.utcOffset == nil)) return NO; // xor
    else if (![self.utcOffset isEqualToString:otherProfile.utcOffset]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"aboutMe"];
    [dictionary setObject:@"NSArray" forKey:@"accounts"];
    [dictionary setObject:@"JRStringArray" forKey:@"activities"];
    [dictionary setObject:@"NSArray" forKey:@"addresses"];
    [dictionary setObject:@"JRDate" forKey:@"anniversary"];
    [dictionary setObject:@"NSString" forKey:@"birthday"];
    [dictionary setObject:@"JRBodyType" forKey:@"bodyType"];
    [dictionary setObject:@"JRStringArray" forKey:@"books"];
    [dictionary setObject:@"JRStringArray" forKey:@"cars"];
    [dictionary setObject:@"JRStringArray" forKey:@"children"];
    [dictionary setObject:@"JRCurrentLocation" forKey:@"currentLocation"];
    [dictionary setObject:@"NSString" forKey:@"displayName"];
    [dictionary setObject:@"NSString" forKey:@"drinker"];
    [dictionary setObject:@"NSArray" forKey:@"emails"];
    [dictionary setObject:@"NSString" forKey:@"ethnicity"];
    [dictionary setObject:@"NSString" forKey:@"fashion"];
    [dictionary setObject:@"JRStringArray" forKey:@"food"];
    [dictionary setObject:@"NSString" forKey:@"gender"];
    [dictionary setObject:@"NSString" forKey:@"happiestWhen"];
    [dictionary setObject:@"JRStringArray" forKey:@"heroes"];
    [dictionary setObject:@"NSString" forKey:@"humor"];
    [dictionary setObject:@"NSArray" forKey:@"ims"];
    [dictionary setObject:@"JRStringArray" forKey:@"interestedInMeeting"];
    [dictionary setObject:@"JRStringArray" forKey:@"interests"];
    [dictionary setObject:@"JRStringArray" forKey:@"jobInterests"];
    [dictionary setObject:@"JRStringArray" forKey:@"languages"];
    [dictionary setObject:@"JRStringArray" forKey:@"languagesSpoken"];
    [dictionary setObject:@"NSString" forKey:@"livingArrangement"];
    [dictionary setObject:@"JRStringArray" forKey:@"lookingFor"];
    [dictionary setObject:@"JRStringArray" forKey:@"movies"];
    [dictionary setObject:@"JRStringArray" forKey:@"music"];
    [dictionary setObject:@"JRName" forKey:@"name"];
    [dictionary setObject:@"NSString" forKey:@"nickname"];
    [dictionary setObject:@"NSString" forKey:@"note"];
    [dictionary setObject:@"NSArray" forKey:@"organizations"];
    [dictionary setObject:@"JRStringArray" forKey:@"pets"];
    [dictionary setObject:@"NSArray" forKey:@"phoneNumbers"];
    [dictionary setObject:@"NSArray" forKey:@"profilePhotos"];
    [dictionary setObject:@"NSString" forKey:@"politicalViews"];
    [dictionary setObject:@"NSString" forKey:@"preferredUsername"];
    [dictionary setObject:@"NSString" forKey:@"profileSong"];
    [dictionary setObject:@"NSString" forKey:@"profileUrl"];
    [dictionary setObject:@"NSString" forKey:@"profileVideo"];
    [dictionary setObject:@"JRDateTime" forKey:@"published"];
    [dictionary setObject:@"JRStringArray" forKey:@"quotes"];
    [dictionary setObject:@"NSString" forKey:@"relationshipStatus"];
    [dictionary setObject:@"JRStringArray" forKey:@"relationships"];
    [dictionary setObject:@"NSString" forKey:@"religion"];
    [dictionary setObject:@"NSString" forKey:@"romance"];
    [dictionary setObject:@"NSString" forKey:@"scaredOf"];
    [dictionary setObject:@"NSString" forKey:@"sexualOrientation"];
    [dictionary setObject:@"NSString" forKey:@"smoker"];
    [dictionary setObject:@"JRStringArray" forKey:@"sports"];
    [dictionary setObject:@"NSString" forKey:@"status"];
    [dictionary setObject:@"JRStringArray" forKey:@"tags"];
    [dictionary setObject:@"JRStringArray" forKey:@"turnOffs"];
    [dictionary setObject:@"JRStringArray" forKey:@"turnOns"];
    [dictionary setObject:@"JRStringArray" forKey:@"tvShows"];
    [dictionary setObject:@"JRDateTime" forKey:@"updated"];
    [dictionary setObject:@"NSArray" forKey:@"urls"];
    [dictionary setObject:@"NSString" forKey:@"utcOffset"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
