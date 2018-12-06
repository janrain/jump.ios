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
#import "JRCaptureUser.h"

@interface JRClientsElement (JRClientsElement_InternalMethods)
+ (id)clientsElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToClientsElement:(JRClientsElement *)otherClientsElement;
@end

@interface JRJanrain (JRJanrain_InternalMethods)
+ (id)janrainObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToJanrain:(JRJanrain *)otherJanrain;
@end

@interface JROptIn (JROptIn_InternalMethods)
+ (id)optInObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToOptIn:(JROptIn *)otherOptIn;
@end

@interface JRPhotosElement (JRPhotosElement_InternalMethods)
+ (id)photosElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToPhotosElement:(JRPhotosElement *)otherPhotosElement;
@end

@interface JRPrimaryAddress (JRPrimaryAddress_InternalMethods)
+ (id)primaryAddressObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToPrimaryAddress:(JRPrimaryAddress *)otherPrimaryAddress;
@end

@interface JRProfilesElement (JRProfilesElement_InternalMethods)
+ (id)profilesElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToProfilesElement:(JRProfilesElement *)otherProfilesElement;
@end

@interface JRStatusesElement (JRStatusesElement_InternalMethods)
+ (id)statusesElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToStatusesElement:(JRStatusesElement *)otherStatusesElement;
@end

@implementation NSArray (JRArray_Clients_ToFromDictionary)
- (NSArray*)arrayOfClientsElementsFromClientsDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredClientsArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredClientsArray addObject:[JRClientsElement clientsElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredClientsArray;
}

- (NSArray*)arrayOfClientsElementsFromClientsDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfClientsElementsFromClientsDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfClientsDictionariesFromClientsElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRClientsElement class]])
            [filteredDictionaryArray addObject:[(JRClientsElement*)object newDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfClientsDictionariesFromClientsElements
{
    return [self arrayOfClientsDictionariesFromClientsElementsForEncoder:NO];
}

- (NSArray*)arrayOfClientsReplaceDictionariesFromClientsElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRClientsElement class]])
            [filteredDictionaryArray addObject:[(JRClientsElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@implementation NSArray (JRArray_Photos_ToFromDictionary)
- (NSArray*)arrayOfPhotosElementsFromPhotosDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredPhotosArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredPhotosArray addObject:[JRPhotosElement photosElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredPhotosArray;
}

- (NSArray*)arrayOfPhotosElementsFromPhotosDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfPhotosElementsFromPhotosDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfPhotosDictionariesFromPhotosElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPhotosElement class]])
            [filteredDictionaryArray addObject:[(JRPhotosElement*)object newDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfPhotosDictionariesFromPhotosElements
{
    return [self arrayOfPhotosDictionariesFromPhotosElementsForEncoder:NO];
}

- (NSArray*)arrayOfPhotosReplaceDictionariesFromPhotosElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRPhotosElement class]])
            [filteredDictionaryArray addObject:[(JRPhotosElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@implementation NSArray (JRArray_Profiles_ToFromDictionary)
- (NSArray*)arrayOfProfilesElementsFromProfilesDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredProfilesArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredProfilesArray addObject:[JRProfilesElement profilesElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredProfilesArray;
}

- (NSArray*)arrayOfProfilesElementsFromProfilesDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfProfilesElementsFromProfilesDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfProfilesDictionariesFromProfilesElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRProfilesElement class]])
            [filteredDictionaryArray addObject:[(JRProfilesElement*)object newDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfProfilesDictionariesFromProfilesElements
{
    return [self arrayOfProfilesDictionariesFromProfilesElementsForEncoder:NO];
}

- (NSArray*)arrayOfProfilesReplaceDictionariesFromProfilesElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRProfilesElement class]])
            [filteredDictionaryArray addObject:[(JRProfilesElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@implementation NSArray (JRArray_Statuses_ToFromDictionary)
- (NSArray*)arrayOfStatusesElementsFromStatusesDictionariesWithPath:(NSString*)capturePath fromDecoder:(BOOL)fromDecoder
{
    NSMutableArray *filteredStatusesArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *dictionary in self)
        if ([dictionary isKindOfClass:[NSDictionary class]])
            [filteredStatusesArray addObject:[JRStatusesElement statusesElementFromDictionary:(NSDictionary*)dictionary withPath:capturePath fromDecoder:fromDecoder]];

    return filteredStatusesArray;
}

- (NSArray*)arrayOfStatusesElementsFromStatusesDictionariesWithPath:(NSString*)capturePath
{
    return [self arrayOfStatusesElementsFromStatusesDictionariesWithPath:capturePath fromDecoder:NO];
}

- (NSArray*)arrayOfStatusesDictionariesFromStatusesElementsForEncoder:(BOOL)forEncoder
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRStatusesElement class]])
            [filteredDictionaryArray addObject:[(JRStatusesElement*)object newDictionaryForEncoder:forEncoder]];

    return filteredDictionaryArray;
}

- (NSArray*)arrayOfStatusesDictionariesFromStatusesElements
{
    return [self arrayOfStatusesDictionariesFromStatusesElementsForEncoder:NO];
}

- (NSArray*)arrayOfStatusesReplaceDictionariesFromStatusesElements
{
    NSMutableArray *filteredDictionaryArray = [NSMutableArray arrayWithCapacity:[self count]];
    for (NSObject *object in self)
        if ([object isKindOfClass:[JRStatusesElement class]])
            [filteredDictionaryArray addObject:[(JRStatusesElement*)object toReplaceDictionary]];

    return filteredDictionaryArray;
}
@end

@interface NSArray (CaptureUser_ArrayComparison)
- (BOOL)isEqualToClientsArray:(NSArray *)otherArray;
- (BOOL)isEqualToPhotosArray:(NSArray *)otherArray;
- (BOOL)isEqualToProfilesArray:(NSArray *)otherArray;
- (BOOL)isEqualToStatusesArray:(NSArray *)otherArray;
@end

@implementation NSArray (CaptureUser_ArrayComparison)

- (BOOL)isEqualToClientsArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRClientsElement *)[self objectAtIndex:i]) isEqualToClientsElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToPhotosArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRPhotosElement *)[self objectAtIndex:i]) isEqualToPhotosElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToProfilesArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRProfilesElement *)[self objectAtIndex:i]) isEqualToProfilesElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}

- (BOOL)isEqualToStatusesArray:(NSArray *)otherArray
{
    if ([self count] != [otherArray count]) return NO;

    for (NSUInteger i = 0; i < [self count]; i++)
        if (![((JRStatusesElement *)[self objectAtIndex:i]) isEqualToStatusesElement:[otherArray objectAtIndex:i]])
            return NO;

    return YES;
}
@end

@interface JRCaptureUser ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JRCaptureUser
{
    NSString *_aboutMe;
    JRDate *_birthday;
    NSArray *_clients;
    NSString *_currentLocation;
    JRDateTime *_deactivateAccount;
    JRJsonObject *_display;
    NSString *_displayName;
    NSString *_email;
    JRDateTime *_emailVerified;
    NSString *_externalId;
    NSString *_familyName;
    NSString *_gender;
    NSString *_givenName;
    JRJanrain *_janrain;
    JRDateTime *_lastLogin;
    NSString *_middleName;
    JROptIn *_optIn;
    JRPassword *_password;
    NSArray *_photos;
    JRPrimaryAddress *_primaryAddress;
    NSArray *_profiles;
    NSArray *_statuses;
    JRObjectId *_captureUserId;
    JRDateTime *_created;
    JRDateTime *_lastUpdated;
    JRUuid *_uuid;
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

- (JRDate *)birthday
{
    return _birthday;
}

- (void)setBirthday:(JRDate *)newBirthday
{
    [self.dirtyPropertySet addObject:@"birthday"];

    _birthday = [newBirthday copy];
}

- (NSArray *)clients
{
    return _clients;
}

- (void)setClients:(NSArray *)newClients
{
    _clients = [newClients copy];
}

- (NSString *)currentLocation
{
    return _currentLocation;
}

- (void)setCurrentLocation:(NSString *)newCurrentLocation
{
    [self.dirtyPropertySet addObject:@"currentLocation"];

    _currentLocation = [newCurrentLocation copy];
}

- (JRDateTime *)deactivateAccount
{
    return _deactivateAccount;
}

- (void)setDeactivateAccount:(JRDateTime *)newDeactivateAccount
{
    [self.dirtyPropertySet addObject:@"deactivateAccount"];

    _deactivateAccount = [newDeactivateAccount copy];
}

- (JRJsonObject *)display
{
    return _display;
}

- (void)setDisplay:(JRJsonObject *)newDisplay
{
    [self.dirtyPropertySet addObject:@"display"];

    _display = [newDisplay copy];
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

- (NSString *)email
{
    return _email;
}

- (void)setEmail:(NSString *)newEmail
{
    [self.dirtyPropertySet addObject:@"email"];

    _email = [newEmail copy];
}

- (JRDateTime *)emailVerified
{
    return _emailVerified;
}

- (void)setEmailVerified:(JRDateTime *)newEmailVerified
{
    [self.dirtyPropertySet addObject:@"emailVerified"];

    _emailVerified = [newEmailVerified copy];
}

- (NSString *)externalId
{
    return _externalId;
}

- (void)setExternalId:(NSString *)newExternalId
{
    [self.dirtyPropertySet addObject:@"externalId"];

    _externalId = [newExternalId copy];
}

- (NSString *)familyName
{
    return _familyName;
}

- (void)setFamilyName:(NSString *)newFamilyName
{
    [self.dirtyPropertySet addObject:@"familyName"];

    _familyName = [newFamilyName copy];
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

- (NSString *)givenName
{
    return _givenName;
}

- (void)setGivenName:(NSString *)newGivenName
{
    [self.dirtyPropertySet addObject:@"givenName"];

    _givenName = [newGivenName copy];
}

- (JRJanrain *)janrain
{
    return _janrain;
}

- (void)setJanrain:(JRJanrain *)newJanrain
{
    [self.dirtyPropertySet addObject:@"janrain"];

    _janrain = newJanrain;

    [_janrain setAllPropertiesToDirty];
}

- (JRDateTime *)lastLogin
{
    return _lastLogin;
}

- (void)setLastLogin:(JRDateTime *)newLastLogin
{
    [self.dirtyPropertySet addObject:@"lastLogin"];

    _lastLogin = [newLastLogin copy];
}

- (NSString *)middleName
{
    return _middleName;
}

- (void)setMiddleName:(NSString *)newMiddleName
{
    [self.dirtyPropertySet addObject:@"middleName"];

    _middleName = [newMiddleName copy];
}

- (JROptIn *)optIn
{
    return _optIn;
}

- (void)setOptIn:(JROptIn *)newOptIn
{
    [self.dirtyPropertySet addObject:@"optIn"];

    _optIn = newOptIn;

    [_optIn setAllPropertiesToDirty];
}

- (JRPassword *)password
{
    return _password;
}

- (void)setPassword:(JRPassword *)newPassword
{
    [self.dirtyPropertySet addObject:@"password"];

    _password = [newPassword copy];
}

- (NSArray *)photos
{
    return _photos;
}

- (void)setPhotos:(NSArray *)newPhotos
{
    _photos = [newPhotos copy];
}

- (JRPrimaryAddress *)primaryAddress
{
    return _primaryAddress;
}

- (void)setPrimaryAddress:(JRPrimaryAddress *)newPrimaryAddress
{
    [self.dirtyPropertySet addObject:@"primaryAddress"];

    _primaryAddress = newPrimaryAddress;

    [_primaryAddress setAllPropertiesToDirty];
}

- (NSArray *)profiles
{
    return _profiles;
}

- (void)setProfiles:(NSArray *)newProfiles
{
    _profiles = [newProfiles copy];
}

- (NSArray *)statuses
{
    return _statuses;
}

- (void)setStatuses:(NSArray *)newStatuses
{
    _statuses = [newStatuses copy];
}

- (JRObjectId *)captureUserId
{
    return _captureUserId;
}

- (void)setCaptureUserId:(JRObjectId *)newCaptureUserId
{
    [self.dirtyPropertySet addObject:@"captureUserId"];

    _captureUserId = [newCaptureUserId copy];
}

- (JRDateTime *)created
{
    return _created;
}

- (void)setCreated:(JRDateTime *)newCreated
{
    [self.dirtyPropertySet addObject:@"created"];

    _created = [newCreated copy];
}

- (JRDateTime *)lastUpdated
{
    return _lastUpdated;
}

- (void)setLastUpdated:(JRDateTime *)newLastUpdated
{
    [self.dirtyPropertySet addObject:@"lastUpdated"];

    _lastUpdated = [newLastUpdated copy];
}

- (JRUuid *)uuid
{
    return _uuid;
}

- (void)setUuid:(JRUuid *)newUuid
{
    [self.dirtyPropertySet addObject:@"uuid"];

    _uuid = [newUuid copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"";
        self.canBeUpdatedOnCapture = YES;

        _janrain = [[JRJanrain alloc] init];
        _optIn = [[JROptIn alloc] init];
        _primaryAddress = [[JRPrimaryAddress alloc] init];

        [self.dirtyPropertySet setSet:[self updatablePropertySet]];
    }
    return self;
}

+ (id)captureUser
{
    return [[JRCaptureUser alloc] init];
}

- (NSDictionary*)newDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.aboutMe ? self.aboutMe : [NSNull null])
                   forKey:@"aboutMe"];
    [dictionary setObject:(self.birthday ? [self.birthday stringFromISO8601Date] : [NSNull null])
                   forKey:@"birthday"];
    [dictionary setObject:(self.clients ? [self.clients arrayOfClientsDictionariesFromClientsElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"clients"];
    [dictionary setObject:(self.currentLocation ? self.currentLocation : [NSNull null])
                   forKey:@"currentLocation"];
    [dictionary setObject:(self.deactivateAccount ? [self.deactivateAccount stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"deactivateAccount"];
    [dictionary setObject:(self.display ? self.display : [NSNull null])
                   forKey:@"display"];
    [dictionary setObject:(self.displayName ? self.displayName : [NSNull null])
                   forKey:@"displayName"];
    [dictionary setObject:(self.email ? self.email : [NSNull null])
                   forKey:@"email"];
    [dictionary setObject:(self.emailVerified ? [self.emailVerified stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"emailVerified"];
    [dictionary setObject:(self.externalId ? self.externalId : [NSNull null])
                   forKey:@"externalId"];
    [dictionary setObject:(self.familyName ? self.familyName : [NSNull null])
                   forKey:@"familyName"];
    [dictionary setObject:(self.gender ? self.gender : [NSNull null])
                   forKey:@"gender"];
    [dictionary setObject:(self.givenName ? self.givenName : [NSNull null])
                   forKey:@"givenName"];
    [dictionary setObject:(self.janrain ? [self.janrain newDictionaryForEncoder:forEncoder] : [NSNull null])
                   forKey:@"janrain"];
    [dictionary setObject:(self.lastLogin ? [self.lastLogin stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"lastLogin"];
    [dictionary setObject:(self.middleName ? self.middleName : [NSNull null])
                   forKey:@"middleName"];
    [dictionary setObject:(self.optIn ? [self.optIn newDictionaryForEncoder:forEncoder] : [NSNull null])
                   forKey:@"optIn"];
    [dictionary setObject:(self.password ? self.password : [NSNull null])
                   forKey:@"password"];
    [dictionary setObject:(self.photos ? [self.photos arrayOfPhotosDictionariesFromPhotosElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"photos"];
    [dictionary setObject:(self.primaryAddress ? [self.primaryAddress newDictionaryForEncoder:forEncoder] : [NSNull null])
                   forKey:@"primaryAddress"];
    [dictionary setObject:(self.profiles ? [self.profiles arrayOfProfilesDictionariesFromProfilesElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"profiles"];
    [dictionary setObject:(self.statuses ? [self.statuses arrayOfStatusesDictionariesFromStatusesElementsForEncoder:forEncoder] : [NSNull null])
                   forKey:@"statuses"];
    [dictionary setObject:(self.captureUserId ? [NSNumber numberWithInteger:[self.captureUserId integerValue]] : [NSNull null])
                   forKey:@"id"];
    [dictionary setObject:(self.created ? [self.created stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"created"];
    [dictionary setObject:(self.lastUpdated ? [self.lastUpdated stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"lastUpdated"];
    [dictionary setObject:(self.uuid ? self.uuid : [NSNull null])
                   forKey:@"uuid"];

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

+ (id)captureUserObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRCaptureUser *captureUser = [JRCaptureUser captureUser];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        captureUser.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
    }

    captureUser.aboutMe =
        [dictionary objectForKey:@"aboutMe"] != [NSNull null] ? 
        [dictionary objectForKey:@"aboutMe"] : nil;

    captureUser.birthday =
        [dictionary objectForKey:@"birthday"] != [NSNull null] ? 
        [JRDate dateFromISO8601DateString:[dictionary objectForKey:@"birthday"]] : nil;

    captureUser.clients =
        [dictionary objectForKey:@"clients"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"clients"] arrayOfClientsElementsFromClientsDictionariesWithPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.currentLocation =
        [dictionary objectForKey:@"currentLocation"] != [NSNull null] ? 
        [dictionary objectForKey:@"currentLocation"] : nil;

    captureUser.deactivateAccount =
        [dictionary objectForKey:@"deactivateAccount"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"deactivateAccount"]] : nil;

    captureUser.display =
        [dictionary objectForKey:@"display"] != [NSNull null] ? 
        [dictionary objectForKey:@"display"] : nil;

    captureUser.displayName =
        [dictionary objectForKey:@"displayName"] != [NSNull null] ? 
        [dictionary objectForKey:@"displayName"] : nil;

    captureUser.email =
        [dictionary objectForKey:@"email"] != [NSNull null] ? 
        [dictionary objectForKey:@"email"] : nil;

    captureUser.emailVerified =
        [dictionary objectForKey:@"emailVerified"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"emailVerified"]] : nil;

    captureUser.externalId =
        [dictionary objectForKey:@"externalId"] != [NSNull null] ? 
        [dictionary objectForKey:@"externalId"] : nil;

    captureUser.familyName =
        [dictionary objectForKey:@"familyName"] != [NSNull null] ? 
        [dictionary objectForKey:@"familyName"] : nil;

    captureUser.gender =
        [dictionary objectForKey:@"gender"] != [NSNull null] ? 
        [dictionary objectForKey:@"gender"] : nil;

    captureUser.givenName =
        [dictionary objectForKey:@"givenName"] != [NSNull null] ? 
        [dictionary objectForKey:@"givenName"] : nil;

    captureUser.janrain =
        [dictionary objectForKey:@"janrain"] != [NSNull null] ? 
        [JRJanrain janrainObjectFromDictionary:[dictionary objectForKey:@"janrain"] withPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.lastLogin =
        [dictionary objectForKey:@"lastLogin"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastLogin"]] : nil;

    captureUser.middleName =
        [dictionary objectForKey:@"middleName"] != [NSNull null] ? 
        [dictionary objectForKey:@"middleName"] : nil;

    captureUser.optIn =
        [dictionary objectForKey:@"optIn"] != [NSNull null] ? 
        [JROptIn optInObjectFromDictionary:[dictionary objectForKey:@"optIn"] withPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.password =
        [dictionary objectForKey:@"password"] != [NSNull null] ? 
        [dictionary objectForKey:@"password"] : nil;

    captureUser.photos =
        [dictionary objectForKey:@"photos"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"photos"] arrayOfPhotosElementsFromPhotosDictionariesWithPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.primaryAddress =
        [dictionary objectForKey:@"primaryAddress"] != [NSNull null] ? 
        [JRPrimaryAddress primaryAddressObjectFromDictionary:[dictionary objectForKey:@"primaryAddress"] withPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.profiles =
        [dictionary objectForKey:@"profiles"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"profiles"] arrayOfProfilesElementsFromProfilesDictionariesWithPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.statuses =
        [dictionary objectForKey:@"statuses"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"statuses"] arrayOfStatusesElementsFromStatusesDictionariesWithPath:captureUser.captureObjectPath fromDecoder:fromDecoder] : nil;

    captureUser.captureUserId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    captureUser.created =
        [dictionary objectForKey:@"created"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"created"]] : nil;

    captureUser.lastUpdated =
        [dictionary objectForKey:@"lastUpdated"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastUpdated"]] : nil;

    captureUser.uuid =
        [dictionary objectForKey:@"uuid"] != [NSNull null] ? 
        [dictionary objectForKey:@"uuid"] : nil;

    if (fromDecoder)
        [captureUser.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [captureUser.dirtyPropertySet removeAllObjects];

    return captureUser;
}

+ (id)captureUserObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRCaptureUser captureUserObjectFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)decodeFromDictionary:(NSDictionary*)dictionary
{
    NSSet *dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];

    self.captureObjectPath = @"";
    self.canBeUpdatedOnCapture = YES;

    self.aboutMe =
        [dictionary objectForKey:@"aboutMe"] != [NSNull null] ? 
        [dictionary objectForKey:@"aboutMe"] : nil;

    self.birthday =
        [dictionary objectForKey:@"birthday"] != [NSNull null] ? 
        [JRDate dateFromISO8601DateString:[dictionary objectForKey:@"birthday"]] : nil;

    self.clients =
        [dictionary objectForKey:@"clients"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"clients"] arrayOfClientsElementsFromClientsDictionariesWithPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.currentLocation =
        [dictionary objectForKey:@"currentLocation"] != [NSNull null] ? 
        [dictionary objectForKey:@"currentLocation"] : nil;

    self.deactivateAccount =
        [dictionary objectForKey:@"deactivateAccount"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"deactivateAccount"]] : nil;

    self.display =
        [dictionary objectForKey:@"display"] != [NSNull null] ? 
        [dictionary objectForKey:@"display"] : nil;

    self.displayName =
        [dictionary objectForKey:@"displayName"] != [NSNull null] ? 
        [dictionary objectForKey:@"displayName"] : nil;

    self.email =
        [dictionary objectForKey:@"email"] != [NSNull null] ? 
        [dictionary objectForKey:@"email"] : nil;

    self.emailVerified =
        [dictionary objectForKey:@"emailVerified"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"emailVerified"]] : nil;

    self.externalId =
        [dictionary objectForKey:@"externalId"] != [NSNull null] ? 
        [dictionary objectForKey:@"externalId"] : nil;

    self.familyName =
        [dictionary objectForKey:@"familyName"] != [NSNull null] ? 
        [dictionary objectForKey:@"familyName"] : nil;

    self.gender =
        [dictionary objectForKey:@"gender"] != [NSNull null] ? 
        [dictionary objectForKey:@"gender"] : nil;

    self.givenName =
        [dictionary objectForKey:@"givenName"] != [NSNull null] ? 
        [dictionary objectForKey:@"givenName"] : nil;

    self.janrain =
        [dictionary objectForKey:@"janrain"] != [NSNull null] ? 
        [JRJanrain janrainObjectFromDictionary:[dictionary objectForKey:@"janrain"] withPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.lastLogin =
        [dictionary objectForKey:@"lastLogin"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastLogin"]] : nil;

    self.middleName =
        [dictionary objectForKey:@"middleName"] != [NSNull null] ? 
        [dictionary objectForKey:@"middleName"] : nil;

    self.optIn =
        [dictionary objectForKey:@"optIn"] != [NSNull null] ? 
        [JROptIn optInObjectFromDictionary:[dictionary objectForKey:@"optIn"] withPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.password =
        [dictionary objectForKey:@"password"] != [NSNull null] ? 
        [dictionary objectForKey:@"password"] : nil;

    self.photos =
        [dictionary objectForKey:@"photos"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"photos"] arrayOfPhotosElementsFromPhotosDictionariesWithPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.primaryAddress =
        [dictionary objectForKey:@"primaryAddress"] != [NSNull null] ? 
        [JRPrimaryAddress primaryAddressObjectFromDictionary:[dictionary objectForKey:@"primaryAddress"] withPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.profiles =
        [dictionary objectForKey:@"profiles"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"profiles"] arrayOfProfilesElementsFromProfilesDictionariesWithPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.statuses =
        [dictionary objectForKey:@"statuses"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"statuses"] arrayOfStatusesElementsFromStatusesDictionariesWithPath:self.captureObjectPath fromDecoder:YES] : nil;

    self.captureUserId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    self.created =
        [dictionary objectForKey:@"created"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"created"]] : nil;

    self.lastUpdated =
        [dictionary objectForKey:@"lastUpdated"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastUpdated"]] : nil;

    self.uuid =
        [dictionary objectForKey:@"uuid"] != [NSNull null] ? 
        [dictionary objectForKey:@"uuid"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [self.dirtyPropertySet copy];

    self.canBeUpdatedOnCapture = YES;

    self.aboutMe =
        [dictionary objectForKey:@"aboutMe"] != [NSNull null] ? 
        [dictionary objectForKey:@"aboutMe"] : nil;

    self.birthday =
        [dictionary objectForKey:@"birthday"] != [NSNull null] ? 
        [JRDate dateFromISO8601DateString:[dictionary objectForKey:@"birthday"]] : nil;

    self.clients =
        [dictionary objectForKey:@"clients"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"clients"] arrayOfClientsElementsFromClientsDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    self.currentLocation =
        [dictionary objectForKey:@"currentLocation"] != [NSNull null] ? 
        [dictionary objectForKey:@"currentLocation"] : nil;

    self.deactivateAccount =
        [dictionary objectForKey:@"deactivateAccount"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"deactivateAccount"]] : nil;

    self.display =
        [dictionary objectForKey:@"display"] != [NSNull null] ? 
        [dictionary objectForKey:@"display"] : nil;

    self.displayName =
        [dictionary objectForKey:@"displayName"] != [NSNull null] ? 
        [dictionary objectForKey:@"displayName"] : nil;

    self.email =
        [dictionary objectForKey:@"email"] != [NSNull null] ? 
        [dictionary objectForKey:@"email"] : nil;

    self.emailVerified =
        [dictionary objectForKey:@"emailVerified"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"emailVerified"]] : nil;

    self.externalId =
        [dictionary objectForKey:@"externalId"] != [NSNull null] ? 
        [dictionary objectForKey:@"externalId"] : nil;

    self.familyName =
        [dictionary objectForKey:@"familyName"] != [NSNull null] ? 
        [dictionary objectForKey:@"familyName"] : nil;

    self.gender =
        [dictionary objectForKey:@"gender"] != [NSNull null] ? 
        [dictionary objectForKey:@"gender"] : nil;

    self.givenName =
        [dictionary objectForKey:@"givenName"] != [NSNull null] ? 
        [dictionary objectForKey:@"givenName"] : nil;

    if (![dictionary objectForKey:@"janrain"] || [dictionary objectForKey:@"janrain"] == [NSNull null])
        self.janrain = nil;
    else if (!self.janrain)
        self.janrain = [JRJanrain janrainObjectFromDictionary:[dictionary objectForKey:@"janrain"] withPath:self.captureObjectPath fromDecoder:NO];
    else
        [self.janrain replaceFromDictionary:[dictionary objectForKey:@"janrain"] withPath:self.captureObjectPath];

    self.lastLogin =
        [dictionary objectForKey:@"lastLogin"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastLogin"]] : nil;

    self.middleName =
        [dictionary objectForKey:@"middleName"] != [NSNull null] ? 
        [dictionary objectForKey:@"middleName"] : nil;

    if (![dictionary objectForKey:@"optIn"] || [dictionary objectForKey:@"optIn"] == [NSNull null])
        self.optIn = nil;
    else if (!self.optIn)
        self.optIn = [JROptIn optInObjectFromDictionary:[dictionary objectForKey:@"optIn"] withPath:self.captureObjectPath fromDecoder:NO];
    else
        [self.optIn replaceFromDictionary:[dictionary objectForKey:@"optIn"] withPath:self.captureObjectPath];

    self.password =
        [dictionary objectForKey:@"password"] != [NSNull null] ? 
        [dictionary objectForKey:@"password"] : nil;

    self.photos =
        [dictionary objectForKey:@"photos"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"photos"] arrayOfPhotosElementsFromPhotosDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    if (![dictionary objectForKey:@"primaryAddress"] || [dictionary objectForKey:@"primaryAddress"] == [NSNull null])
        self.primaryAddress = nil;
    else if (!self.primaryAddress)
        self.primaryAddress = [JRPrimaryAddress primaryAddressObjectFromDictionary:[dictionary objectForKey:@"primaryAddress"] withPath:self.captureObjectPath fromDecoder:NO];
    else
        [self.primaryAddress replaceFromDictionary:[dictionary objectForKey:@"primaryAddress"] withPath:self.captureObjectPath];

    self.profiles =
        [dictionary objectForKey:@"profiles"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"profiles"] arrayOfProfilesElementsFromProfilesDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    self.statuses =
        [dictionary objectForKey:@"statuses"] != [NSNull null] ? 
        [(NSArray*)[dictionary objectForKey:@"statuses"] arrayOfStatusesElementsFromStatusesDictionariesWithPath:self.captureObjectPath fromDecoder:NO] : nil;

    self.captureUserId =
        [dictionary objectForKey:@"id"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]] : nil;

    self.created =
        [dictionary objectForKey:@"created"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"created"]] : nil;

    self.lastUpdated =
        [dictionary objectForKey:@"lastUpdated"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastUpdated"]] : nil;

    self.uuid =
        [dictionary objectForKey:@"uuid"] != [NSNull null] ? 
        [dictionary objectForKey:@"uuid"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"aboutMe", @"birthday", @"currentLocation", @"deactivateAccount", @"display", @"displayName", @"email", @"emailVerified", @"externalId", @"familyName", @"gender", @"givenName", @"janrain", @"lastLogin", @"middleName", @"optIn", @"password", @"primaryAddress", @"captureUserId", @"created", @"lastUpdated", @"uuid", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet addObjectsFromArray:[[self updatablePropertySet] allObjects]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[self.dirtyPropertySet copy] forKey:@"captureUser"];

    if (self.janrain)
        [snapshotDictionary setObject:[self.janrain snapshotDictionaryFromDirtyPropertySet]
                               forKey:@"janrain"];

    if (self.optIn)
        [snapshotDictionary setObject:[self.optIn snapshotDictionaryFromDirtyPropertySet]
                               forKey:@"optIn"];

    if (self.primaryAddress)
        [snapshotDictionary setObject:[self.primaryAddress snapshotDictionaryFromDirtyPropertySet]
                               forKey:@"primaryAddress"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"captureUser"])
        [self.dirtyPropertySet addObjectsFromArray:[[snapshotDictionary objectForKey:@"captureUser"] allObjects]];

    if ([snapshotDictionary objectForKey:@"janrain"])
        [self.janrain restoreDirtyPropertiesFromSnapshotDictionary:
                    [snapshotDictionary objectForKey:@"janrain"]];

    if ([snapshotDictionary objectForKey:@"optIn"])
        [self.optIn restoreDirtyPropertiesFromSnapshotDictionary:
                    [snapshotDictionary objectForKey:@"optIn"]];

    if ([snapshotDictionary objectForKey:@"primaryAddress"])
        [self.primaryAddress restoreDirtyPropertiesFromSnapshotDictionary:
                    [snapshotDictionary objectForKey:@"primaryAddress"]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"aboutMe"])
        [dictionary setObject:(self.aboutMe ? self.aboutMe : [NSNull null]) forKey:@"aboutMe"];

    if ([self.dirtyPropertySet containsObject:@"birthday"])
        [dictionary setObject:(self.birthday ? [self.birthday stringFromISO8601Date] : [NSNull null]) forKey:@"birthday"];

    if ([self.dirtyPropertySet containsObject:@"currentLocation"])
        [dictionary setObject:(self.currentLocation ? self.currentLocation : [NSNull null]) forKey:@"currentLocation"];

    if ([self.dirtyPropertySet containsObject:@"deactivateAccount"])
        [dictionary setObject:(self.deactivateAccount ? [self.deactivateAccount stringFromISO8601DateTime] : [NSNull null]) forKey:@"deactivateAccount"];

    if ([self.dirtyPropertySet containsObject:@"display"])
        [dictionary setObject:(self.display ? self.display : [NSNull null]) forKey:@"display"];

    if ([self.dirtyPropertySet containsObject:@"displayName"])
        [dictionary setObject:(self.displayName ? self.displayName : [NSNull null]) forKey:@"displayName"];

    if ([self.dirtyPropertySet containsObject:@"email"])
        [dictionary setObject:(self.email ? self.email : [NSNull null]) forKey:@"email"];

    if ([self.dirtyPropertySet containsObject:@"emailVerified"])
        [dictionary setObject:(self.emailVerified ? [self.emailVerified stringFromISO8601DateTime] : [NSNull null]) forKey:@"emailVerified"];

    if ([self.dirtyPropertySet containsObject:@"externalId"])
        [dictionary setObject:(self.externalId ? self.externalId : [NSNull null]) forKey:@"externalId"];

    if ([self.dirtyPropertySet containsObject:@"familyName"])
        [dictionary setObject:(self.familyName ? self.familyName : [NSNull null]) forKey:@"familyName"];

    if ([self.dirtyPropertySet containsObject:@"gender"])
        [dictionary setObject:(self.gender ? self.gender : [NSNull null]) forKey:@"gender"];

    if ([self.dirtyPropertySet containsObject:@"givenName"])
        [dictionary setObject:(self.givenName ? self.givenName : [NSNull null]) forKey:@"givenName"];

    if ([self.dirtyPropertySet containsObject:@"janrain"])
        [dictionary setObject:(self.janrain ?
                              [self.janrain toUpdateDictionary] :
                              [[JRJanrain janrain] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                       forKey:@"janrain"];
    else if ([self.janrain needsUpdate])
        [dictionary setObject:[self.janrain toUpdateDictionary]
                       forKey:@"janrain"];

    if ([self.dirtyPropertySet containsObject:@"lastLogin"])
        [dictionary setObject:(self.lastLogin ? [self.lastLogin stringFromISO8601DateTime] : [NSNull null]) forKey:@"lastLogin"];

    if ([self.dirtyPropertySet containsObject:@"middleName"])
        [dictionary setObject:(self.middleName ? self.middleName : [NSNull null]) forKey:@"middleName"];

    if ([self.dirtyPropertySet containsObject:@"optIn"])
        [dictionary setObject:(self.optIn ?
                              [self.optIn toUpdateDictionary] :
                              [[JROptIn optIn] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                       forKey:@"optIn"];
    else if ([self.optIn needsUpdate])
        [dictionary setObject:[self.optIn toUpdateDictionary]
                       forKey:@"optIn"];

    if ([self.dirtyPropertySet containsObject:@"password"])
        [dictionary setObject:(self.password ? self.password : [NSNull null]) forKey:@"password"];

    if ([self.dirtyPropertySet containsObject:@"primaryAddress"])
        [dictionary setObject:(self.primaryAddress ?
                              [self.primaryAddress toUpdateDictionary] :
                              [[JRPrimaryAddress primaryAddress] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                       forKey:@"primaryAddress"];
    else if ([self.primaryAddress needsUpdate])
        [dictionary setObject:[self.primaryAddress toUpdateDictionary]
                       forKey:@"primaryAddress"];

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
    [dictionary setObject:(self.birthday ? [self.birthday stringFromISO8601Date] : [NSNull null]) forKey:@"birthday"];

    [dictionary setObject:(self.clients ?
                          [self.clients arrayOfClientsReplaceDictionariesFromClientsElements] :
                          [NSArray array])
                   forKey:@"clients"];
    [dictionary setObject:(self.currentLocation ? self.currentLocation : [NSNull null]) forKey:@"currentLocation"];
    [dictionary setObject:(self.deactivateAccount ? [self.deactivateAccount stringFromISO8601DateTime] : [NSNull null]) forKey:@"deactivateAccount"];
    [dictionary setObject:(self.display ? self.display : [NSNull null]) forKey:@"display"];
    [dictionary setObject:(self.displayName ? self.displayName : [NSNull null]) forKey:@"displayName"];
    [dictionary setObject:(self.email ? self.email : [NSNull null]) forKey:@"email"];
    [dictionary setObject:(self.emailVerified ? [self.emailVerified stringFromISO8601DateTime] : [NSNull null]) forKey:@"emailVerified"];
    [dictionary setObject:(self.externalId ? self.externalId : [NSNull null]) forKey:@"externalId"];
    [dictionary setObject:(self.familyName ? self.familyName : [NSNull null]) forKey:@"familyName"];
    [dictionary setObject:(self.gender ? self.gender : [NSNull null]) forKey:@"gender"];
    [dictionary setObject:(self.givenName ? self.givenName : [NSNull null]) forKey:@"givenName"];

    [dictionary setObject:(self.janrain ?
                          [self.janrain toReplaceDictionary] :
                          [[JRJanrain janrain] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                   forKey:@"janrain"];
    [dictionary setObject:(self.lastLogin ? [self.lastLogin stringFromISO8601DateTime] : [NSNull null]) forKey:@"lastLogin"];
    [dictionary setObject:(self.middleName ? self.middleName : [NSNull null]) forKey:@"middleName"];

    [dictionary setObject:(self.optIn ?
                          [self.optIn toReplaceDictionary] :
                          [[JROptIn optIn] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                   forKey:@"optIn"];
    [dictionary setObject:(self.password ? self.password : [NSNull null]) forKey:@"password"];

    [dictionary setObject:(self.photos ?
                          [self.photos arrayOfPhotosReplaceDictionariesFromPhotosElements] :
                          [NSArray array])
                   forKey:@"photos"];

    [dictionary setObject:(self.primaryAddress ?
                          [self.primaryAddress toReplaceDictionary] :
                          [[JRPrimaryAddress primaryAddress] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                   forKey:@"primaryAddress"];

    [dictionary setObject:(self.profiles ?
                          [self.profiles arrayOfProfilesReplaceDictionariesFromProfilesElements] :
                          [NSArray array])
                   forKey:@"profiles"];

    [dictionary setObject:(self.statuses ?
                          [self.statuses arrayOfStatusesReplaceDictionariesFromStatusesElements] :
                          [NSArray array])
                   forKey:@"statuses"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (void)replaceClientsArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.clients named:@"clients" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (void)replacePhotosArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.photos named:@"photos" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (void)replaceProfilesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.profiles named:@"profiles" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (void)replaceStatusesArrayOnCaptureForDelegate:(id<JRCaptureObjectDelegate>)delegate context:(NSObject *)context
{
    [self replaceArrayOnCapture:self.statuses named:@"statuses" isArrayOfStrings:NO
                       withType:@"" forDelegate:delegate withContext:context];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    if ([self.janrain needsUpdate])
        return YES;

    if ([self.optIn needsUpdate])
        return YES;

    if ([self.primaryAddress needsUpdate])
        return YES;

    return NO;
}

- (BOOL)isEqualToCaptureUser:(JRCaptureUser *)otherCaptureUser
{
    if (!self.aboutMe && !otherCaptureUser.aboutMe) /* Keep going... */;
    else if ((self.aboutMe == nil) ^ (otherCaptureUser.aboutMe == nil)) return NO; // xor
    else if (![self.aboutMe isEqualToString:otherCaptureUser.aboutMe]) return NO;

    if (!self.birthday && !otherCaptureUser.birthday) /* Keep going... */;
    else if ((self.birthday == nil) ^ (otherCaptureUser.birthday == nil)) return NO; // xor
    else if (![self.birthday isEqualToDate:otherCaptureUser.birthday]) return NO;

    if (!self.clients && !otherCaptureUser.clients) /* Keep going... */;
    else if (!self.clients && ![otherCaptureUser.clients count]) /* Keep going... */;
    else if (!otherCaptureUser.clients && ![self.clients count]) /* Keep going... */;
    else if (![self.clients isEqualToClientsArray:otherCaptureUser.clients]) return NO;

    if (!self.currentLocation && !otherCaptureUser.currentLocation) /* Keep going... */;
    else if ((self.currentLocation == nil) ^ (otherCaptureUser.currentLocation == nil)) return NO; // xor
    else if (![self.currentLocation isEqualToString:otherCaptureUser.currentLocation]) return NO;

    if (!self.deactivateAccount && !otherCaptureUser.deactivateAccount) /* Keep going... */;
    else if ((self.deactivateAccount == nil) ^ (otherCaptureUser.deactivateAccount == nil)) return NO; // xor
    else if (![self.deactivateAccount isEqualToDate:otherCaptureUser.deactivateAccount]) return NO;

    if (!self.display && !otherCaptureUser.display) /* Keep going... */;
    else if ((self.display == nil) ^ (otherCaptureUser.display == nil)) return NO; // xor
    else if (![self.display isEqual:otherCaptureUser.display]) return NO;

    if (!self.displayName && !otherCaptureUser.displayName) /* Keep going... */;
    else if ((self.displayName == nil) ^ (otherCaptureUser.displayName == nil)) return NO; // xor
    else if (![self.displayName isEqualToString:otherCaptureUser.displayName]) return NO;

    if (!self.email && !otherCaptureUser.email) /* Keep going... */;
    else if ((self.email == nil) ^ (otherCaptureUser.email == nil)) return NO; // xor
    else if (![self.email isEqualToString:otherCaptureUser.email]) return NO;

    if (!self.emailVerified && !otherCaptureUser.emailVerified) /* Keep going... */;
    else if ((self.emailVerified == nil) ^ (otherCaptureUser.emailVerified == nil)) return NO; // xor
    else if (![self.emailVerified isEqualToDate:otherCaptureUser.emailVerified]) return NO;

    if (!self.externalId && !otherCaptureUser.externalId) /* Keep going... */;
    else if ((self.externalId == nil) ^ (otherCaptureUser.externalId == nil)) return NO; // xor
    else if (![self.externalId isEqualToString:otherCaptureUser.externalId]) return NO;

    if (!self.familyName && !otherCaptureUser.familyName) /* Keep going... */;
    else if ((self.familyName == nil) ^ (otherCaptureUser.familyName == nil)) return NO; // xor
    else if (![self.familyName isEqualToString:otherCaptureUser.familyName]) return NO;

    if (!self.gender && !otherCaptureUser.gender) /* Keep going... */;
    else if ((self.gender == nil) ^ (otherCaptureUser.gender == nil)) return NO; // xor
    else if (![self.gender isEqualToString:otherCaptureUser.gender]) return NO;

    if (!self.givenName && !otherCaptureUser.givenName) /* Keep going... */;
    else if ((self.givenName == nil) ^ (otherCaptureUser.givenName == nil)) return NO; // xor
    else if (![self.givenName isEqualToString:otherCaptureUser.givenName]) return NO;

    if (!self.janrain && !otherCaptureUser.janrain) /* Keep going... */;
    else if (!self.janrain && [otherCaptureUser.janrain isEqualToJanrain:[JRJanrain janrain]]) /* Keep going... */;
    else if (!otherCaptureUser.janrain && [self.janrain isEqualToJanrain:[JRJanrain janrain]]) /* Keep going... */;
    else if (![self.janrain isEqualToJanrain:otherCaptureUser.janrain]) return NO;

    if (!self.lastLogin && !otherCaptureUser.lastLogin) /* Keep going... */;
    else if ((self.lastLogin == nil) ^ (otherCaptureUser.lastLogin == nil)) return NO; // xor
    else if (![self.lastLogin isEqualToDate:otherCaptureUser.lastLogin]) return NO;

    if (!self.middleName && !otherCaptureUser.middleName) /* Keep going... */;
    else if ((self.middleName == nil) ^ (otherCaptureUser.middleName == nil)) return NO; // xor
    else if (![self.middleName isEqualToString:otherCaptureUser.middleName]) return NO;

    if (!self.optIn && !otherCaptureUser.optIn) /* Keep going... */;
    else if (!self.optIn && [otherCaptureUser.optIn isEqualToOptIn:[JROptIn optIn]]) /* Keep going... */;
    else if (!otherCaptureUser.optIn && [self.optIn isEqualToOptIn:[JROptIn optIn]]) /* Keep going... */;
    else if (![self.optIn isEqualToOptIn:otherCaptureUser.optIn]) return NO;

    if (!self.password && !otherCaptureUser.password) /* Keep going... */;
    else if ((self.password == nil) ^ (otherCaptureUser.password == nil)) return NO; // xor
    else if (![self.password isEqual:otherCaptureUser.password]) return NO;

    if (!self.photos && !otherCaptureUser.photos) /* Keep going... */;
    else if (!self.photos && ![otherCaptureUser.photos count]) /* Keep going... */;
    else if (!otherCaptureUser.photos && ![self.photos count]) /* Keep going... */;
    else if (![self.photos isEqualToPhotosArray:otherCaptureUser.photos]) return NO;

    if (!self.primaryAddress && !otherCaptureUser.primaryAddress) /* Keep going... */;
    else if (!self.primaryAddress && [otherCaptureUser.primaryAddress isEqualToPrimaryAddress:[JRPrimaryAddress primaryAddress]]) /* Keep going... */;
    else if (!otherCaptureUser.primaryAddress && [self.primaryAddress isEqualToPrimaryAddress:[JRPrimaryAddress primaryAddress]]) /* Keep going... */;
    else if (![self.primaryAddress isEqualToPrimaryAddress:otherCaptureUser.primaryAddress]) return NO;

    if (!self.profiles && !otherCaptureUser.profiles) /* Keep going... */;
    else if (!self.profiles && ![otherCaptureUser.profiles count]) /* Keep going... */;
    else if (!otherCaptureUser.profiles && ![self.profiles count]) /* Keep going... */;
    else if (![self.profiles isEqualToProfilesArray:otherCaptureUser.profiles]) return NO;

    if (!self.statuses && !otherCaptureUser.statuses) /* Keep going... */;
    else if (!self.statuses && ![otherCaptureUser.statuses count]) /* Keep going... */;
    else if (!otherCaptureUser.statuses && ![self.statuses count]) /* Keep going... */;
    else if (![self.statuses isEqualToStatusesArray:otherCaptureUser.statuses]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"aboutMe"];
    [dictionary setObject:@"JRDate" forKey:@"birthday"];
    [dictionary setObject:@"NSArray" forKey:@"clients"];
    [dictionary setObject:@"NSString" forKey:@"currentLocation"];
    [dictionary setObject:@"JRDateTime" forKey:@"deactivateAccount"];
    [dictionary setObject:@"JRJsonObject" forKey:@"display"];
    [dictionary setObject:@"NSString" forKey:@"displayName"];
    [dictionary setObject:@"NSString" forKey:@"email"];
    [dictionary setObject:@"JRDateTime" forKey:@"emailVerified"];
    [dictionary setObject:@"NSString" forKey:@"externalId"];
    [dictionary setObject:@"NSString" forKey:@"familyName"];
    [dictionary setObject:@"NSString" forKey:@"gender"];
    [dictionary setObject:@"NSString" forKey:@"givenName"];
    [dictionary setObject:@"JRJanrain" forKey:@"janrain"];
    [dictionary setObject:@"JRDateTime" forKey:@"lastLogin"];
    [dictionary setObject:@"NSString" forKey:@"middleName"];
    [dictionary setObject:@"JROptIn" forKey:@"optIn"];
    [dictionary setObject:@"JRPassword" forKey:@"password"];
    [dictionary setObject:@"NSArray" forKey:@"photos"];
    [dictionary setObject:@"JRPrimaryAddress" forKey:@"primaryAddress"];
    [dictionary setObject:@"NSArray" forKey:@"profiles"];
    [dictionary setObject:@"NSArray" forKey:@"statuses"];
    [dictionary setObject:@"JRObjectId" forKey:@"captureUserId"];
    [dictionary setObject:@"JRDateTime" forKey:@"created"];
    [dictionary setObject:@"JRDateTime" forKey:@"lastUpdated"];
    [dictionary setObject:@"JRUuid" forKey:@"uuid"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
