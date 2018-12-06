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
#import "JRCurrentLocation.h"

@interface JRCurrentLocation ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JRCurrentLocation
{
    NSString *_country;
    NSString *_extendedAddress;
    NSString *_formatted;
    JRDecimal *_latitude;
    NSString *_locality;
    JRDecimal *_longitude;
    NSString *_poBox;
    NSString *_postalCode;
    NSString *_region;
    NSString *_streetAddress;
    NSString *_type;
}
@synthesize canBeUpdatedOnCapture;

- (NSString *)country
{
    return _country;
}

- (void)setCountry:(NSString *)newCountry
{
    [self.dirtyPropertySet addObject:@"country"];

    _country = [newCountry copy];
}

- (NSString *)extendedAddress
{
    return _extendedAddress;
}

- (void)setExtendedAddress:(NSString *)newExtendedAddress
{
    [self.dirtyPropertySet addObject:@"extendedAddress"];

    _extendedAddress = [newExtendedAddress copy];
}

- (NSString *)formatted
{
    return _formatted;
}

- (void)setFormatted:(NSString *)newFormatted
{
    [self.dirtyPropertySet addObject:@"formatted"];

    _formatted = [newFormatted copy];
}

- (JRDecimal *)latitude
{
    return _latitude;
}

- (void)setLatitude:(JRDecimal *)newLatitude
{
    [self.dirtyPropertySet addObject:@"latitude"];

    _latitude = [newLatitude copy];
}

- (NSString *)locality
{
    return _locality;
}

- (void)setLocality:(NSString *)newLocality
{
    [self.dirtyPropertySet addObject:@"locality"];

    _locality = [newLocality copy];
}

- (JRDecimal *)longitude
{
    return _longitude;
}

- (void)setLongitude:(JRDecimal *)newLongitude
{
    [self.dirtyPropertySet addObject:@"longitude"];

    _longitude = [newLongitude copy];
}

- (NSString *)poBox
{
    return _poBox;
}

- (void)setPoBox:(NSString *)newPoBox
{
    [self.dirtyPropertySet addObject:@"poBox"];

    _poBox = [newPoBox copy];
}

- (NSString *)postalCode
{
    return _postalCode;
}

- (void)setPostalCode:(NSString *)newPostalCode
{
    [self.dirtyPropertySet addObject:@"postalCode"];

    _postalCode = [newPostalCode copy];
}

- (NSString *)region
{
    return _region;
}

- (void)setRegion:(NSString *)newRegion
{
    [self.dirtyPropertySet addObject:@"region"];

    _region = [newRegion copy];
}

- (NSString *)streetAddress
{
    return _streetAddress;
}

- (void)setStreetAddress:(NSString *)newStreetAddress
{
    [self.dirtyPropertySet addObject:@"streetAddress"];

    _streetAddress = [newStreetAddress copy];
}

- (NSString *)type
{
    return _type;
}

- (void)setType:(NSString *)newType
{
    [self.dirtyPropertySet addObject:@"type"];

    _type = [newType copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath      = @"";
        self.canBeUpdatedOnCapture  = NO;


        [self.dirtyPropertySet setSet:[self updatablePropertySet]];
    }
    return self;
}

+ (id)currentLocation
{
    return [[JRCurrentLocation alloc] init];
}

- (NSDictionary*)newDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.country ? self.country : [NSNull null])
                   forKey:@"country"];
    [dictionary setObject:(self.extendedAddress ? self.extendedAddress : [NSNull null])
                   forKey:@"extendedAddress"];
    [dictionary setObject:(self.formatted ? self.formatted : [NSNull null])
                   forKey:@"formatted"];
    [dictionary setObject:(self.latitude ? self.latitude : [NSNull null])
                   forKey:@"latitude"];
    [dictionary setObject:(self.locality ? self.locality : [NSNull null])
                   forKey:@"locality"];
    [dictionary setObject:(self.longitude ? self.longitude : [NSNull null])
                   forKey:@"longitude"];
    [dictionary setObject:(self.poBox ? self.poBox : [NSNull null])
                   forKey:@"poBox"];
    [dictionary setObject:(self.postalCode ? self.postalCode : [NSNull null])
                   forKey:@"postalCode"];
    [dictionary setObject:(self.region ? self.region : [NSNull null])
                   forKey:@"region"];
    [dictionary setObject:(self.streetAddress ? self.streetAddress : [NSNull null])
                   forKey:@"streetAddress"];
    [dictionary setObject:(self.type ? self.type : [NSNull null])
                   forKey:@"type"];

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

+ (id)currentLocationObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRCurrentLocation *currentLocation = [JRCurrentLocation currentLocation];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        currentLocation.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
        currentLocation.canBeUpdatedOnCapture = [(NSNumber *)[dictionary objectForKey:@"canBeUpdatedOnCapture"] boolValue];
    }
    else
    {
        currentLocation.captureObjectPath      = [NSString stringWithFormat:@"%@/%@", capturePath, @"currentLocation"];
        currentLocation.canBeUpdatedOnCapture = YES;
    }

    currentLocation.country =
        [dictionary objectForKey:@"country"] != [NSNull null] ? 
        [dictionary objectForKey:@"country"] : nil;

    currentLocation.extendedAddress =
        [dictionary objectForKey:@"extendedAddress"] != [NSNull null] ? 
        [dictionary objectForKey:@"extendedAddress"] : nil;

    currentLocation.formatted =
        [dictionary objectForKey:@"formatted"] != [NSNull null] ? 
        [dictionary objectForKey:@"formatted"] : nil;

    currentLocation.latitude =
        [dictionary objectForKey:@"latitude"] != [NSNull null] ? 
        [dictionary objectForKey:@"latitude"] : nil;

    currentLocation.locality =
        [dictionary objectForKey:@"locality"] != [NSNull null] ? 
        [dictionary objectForKey:@"locality"] : nil;

    currentLocation.longitude =
        [dictionary objectForKey:@"longitude"] != [NSNull null] ? 
        [dictionary objectForKey:@"longitude"] : nil;

    currentLocation.poBox =
        [dictionary objectForKey:@"poBox"] != [NSNull null] ? 
        [dictionary objectForKey:@"poBox"] : nil;

    currentLocation.postalCode =
        [dictionary objectForKey:@"postalCode"] != [NSNull null] ? 
        [dictionary objectForKey:@"postalCode"] : nil;

    currentLocation.region =
        [dictionary objectForKey:@"region"] != [NSNull null] ? 
        [dictionary objectForKey:@"region"] : nil;

    currentLocation.streetAddress =
        [dictionary objectForKey:@"streetAddress"] != [NSNull null] ? 
        [dictionary objectForKey:@"streetAddress"] : nil;

    currentLocation.type =
        [dictionary objectForKey:@"type"] != [NSNull null] ? 
        [dictionary objectForKey:@"type"] : nil;

    if (fromDecoder)
        [currentLocation.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [currentLocation.dirtyPropertySet removeAllObjects];

    return currentLocation;
}

+ (id)currentLocationObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRCurrentLocation currentLocationObjectFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [self.dirtyPropertySet copy];

    self.canBeUpdatedOnCapture = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@", capturePath, @"currentLocation"];

    self.country =
        [dictionary objectForKey:@"country"] != [NSNull null] ? 
        [dictionary objectForKey:@"country"] : nil;

    self.extendedAddress =
        [dictionary objectForKey:@"extendedAddress"] != [NSNull null] ? 
        [dictionary objectForKey:@"extendedAddress"] : nil;

    self.formatted =
        [dictionary objectForKey:@"formatted"] != [NSNull null] ? 
        [dictionary objectForKey:@"formatted"] : nil;

    self.latitude =
        [dictionary objectForKey:@"latitude"] != [NSNull null] ? 
        [dictionary objectForKey:@"latitude"] : nil;

    self.locality =
        [dictionary objectForKey:@"locality"] != [NSNull null] ? 
        [dictionary objectForKey:@"locality"] : nil;

    self.longitude =
        [dictionary objectForKey:@"longitude"] != [NSNull null] ? 
        [dictionary objectForKey:@"longitude"] : nil;

    self.poBox =
        [dictionary objectForKey:@"poBox"] != [NSNull null] ? 
        [dictionary objectForKey:@"poBox"] : nil;

    self.postalCode =
        [dictionary objectForKey:@"postalCode"] != [NSNull null] ? 
        [dictionary objectForKey:@"postalCode"] : nil;

    self.region =
        [dictionary objectForKey:@"region"] != [NSNull null] ? 
        [dictionary objectForKey:@"region"] : nil;

    self.streetAddress =
        [dictionary objectForKey:@"streetAddress"] != [NSNull null] ? 
        [dictionary objectForKey:@"streetAddress"] : nil;

    self.type =
        [dictionary objectForKey:@"type"] != [NSNull null] ? 
        [dictionary objectForKey:@"type"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"country", @"extendedAddress", @"formatted", @"latitude", @"locality", @"longitude", @"poBox", @"postalCode", @"region", @"streetAddress", @"type", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet addObjectsFromArray:[[self updatablePropertySet] allObjects]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[self.dirtyPropertySet copy] forKey:@"currentLocation"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"currentLocation"])
        [self.dirtyPropertySet addObjectsFromArray:[[snapshotDictionary objectForKey:@"currentLocation"] allObjects]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"country"])
        [dictionary setObject:(self.country ? self.country : [NSNull null]) forKey:@"country"];

    if ([self.dirtyPropertySet containsObject:@"extendedAddress"])
        [dictionary setObject:(self.extendedAddress ? self.extendedAddress : [NSNull null]) forKey:@"extendedAddress"];

    if ([self.dirtyPropertySet containsObject:@"formatted"])
        [dictionary setObject:(self.formatted ? self.formatted : [NSNull null]) forKey:@"formatted"];

    if ([self.dirtyPropertySet containsObject:@"latitude"])
        [dictionary setObject:(self.latitude ? self.latitude : [NSNull null]) forKey:@"latitude"];

    if ([self.dirtyPropertySet containsObject:@"locality"])
        [dictionary setObject:(self.locality ? self.locality : [NSNull null]) forKey:@"locality"];

    if ([self.dirtyPropertySet containsObject:@"longitude"])
        [dictionary setObject:(self.longitude ? self.longitude : [NSNull null]) forKey:@"longitude"];

    if ([self.dirtyPropertySet containsObject:@"poBox"])
        [dictionary setObject:(self.poBox ? self.poBox : [NSNull null]) forKey:@"poBox"];

    if ([self.dirtyPropertySet containsObject:@"postalCode"])
        [dictionary setObject:(self.postalCode ? self.postalCode : [NSNull null]) forKey:@"postalCode"];

    if ([self.dirtyPropertySet containsObject:@"region"])
        [dictionary setObject:(self.region ? self.region : [NSNull null]) forKey:@"region"];

    if ([self.dirtyPropertySet containsObject:@"streetAddress"])
        [dictionary setObject:(self.streetAddress ? self.streetAddress : [NSNull null]) forKey:@"streetAddress"];

    if ([self.dirtyPropertySet containsObject:@"type"])
        [dictionary setObject:(self.type ? self.type : [NSNull null]) forKey:@"type"];

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

    [dictionary setObject:(self.country ? self.country : [NSNull null]) forKey:@"country"];
    [dictionary setObject:(self.extendedAddress ? self.extendedAddress : [NSNull null]) forKey:@"extendedAddress"];
    [dictionary setObject:(self.formatted ? self.formatted : [NSNull null]) forKey:@"formatted"];
    [dictionary setObject:(self.latitude ? self.latitude : [NSNull null]) forKey:@"latitude"];
    [dictionary setObject:(self.locality ? self.locality : [NSNull null]) forKey:@"locality"];
    [dictionary setObject:(self.longitude ? self.longitude : [NSNull null]) forKey:@"longitude"];
    [dictionary setObject:(self.poBox ? self.poBox : [NSNull null]) forKey:@"poBox"];
    [dictionary setObject:(self.postalCode ? self.postalCode : [NSNull null]) forKey:@"postalCode"];
    [dictionary setObject:(self.region ? self.region : [NSNull null]) forKey:@"region"];
    [dictionary setObject:(self.streetAddress ? self.streetAddress : [NSNull null]) forKey:@"streetAddress"];
    [dictionary setObject:(self.type ? self.type : [NSNull null]) forKey:@"type"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToCurrentLocation:(JRCurrentLocation *)otherCurrentLocation
{
    if (!self.country && !otherCurrentLocation.country) /* Keep going... */;
    else if ((self.country == nil) ^ (otherCurrentLocation.country == nil)) return NO; // xor
    else if (![self.country isEqualToString:otherCurrentLocation.country]) return NO;

    if (!self.extendedAddress && !otherCurrentLocation.extendedAddress) /* Keep going... */;
    else if ((self.extendedAddress == nil) ^ (otherCurrentLocation.extendedAddress == nil)) return NO; // xor
    else if (![self.extendedAddress isEqualToString:otherCurrentLocation.extendedAddress]) return NO;

    if (!self.formatted && !otherCurrentLocation.formatted) /* Keep going... */;
    else if ((self.formatted == nil) ^ (otherCurrentLocation.formatted == nil)) return NO; // xor
    else if (![self.formatted isEqualToString:otherCurrentLocation.formatted]) return NO;

    if (!self.latitude && !otherCurrentLocation.latitude) /* Keep going... */;
    else if ((self.latitude == nil) ^ (otherCurrentLocation.latitude == nil)) return NO; // xor
    else if (![self.latitude isEqualToNumber:otherCurrentLocation.latitude]) return NO;

    if (!self.locality && !otherCurrentLocation.locality) /* Keep going... */;
    else if ((self.locality == nil) ^ (otherCurrentLocation.locality == nil)) return NO; // xor
    else if (![self.locality isEqualToString:otherCurrentLocation.locality]) return NO;

    if (!self.longitude && !otherCurrentLocation.longitude) /* Keep going... */;
    else if ((self.longitude == nil) ^ (otherCurrentLocation.longitude == nil)) return NO; // xor
    else if (![self.longitude isEqualToNumber:otherCurrentLocation.longitude]) return NO;

    if (!self.poBox && !otherCurrentLocation.poBox) /* Keep going... */;
    else if ((self.poBox == nil) ^ (otherCurrentLocation.poBox == nil)) return NO; // xor
    else if (![self.poBox isEqualToString:otherCurrentLocation.poBox]) return NO;

    if (!self.postalCode && !otherCurrentLocation.postalCode) /* Keep going... */;
    else if ((self.postalCode == nil) ^ (otherCurrentLocation.postalCode == nil)) return NO; // xor
    else if (![self.postalCode isEqualToString:otherCurrentLocation.postalCode]) return NO;

    if (!self.region && !otherCurrentLocation.region) /* Keep going... */;
    else if ((self.region == nil) ^ (otherCurrentLocation.region == nil)) return NO; // xor
    else if (![self.region isEqualToString:otherCurrentLocation.region]) return NO;

    if (!self.streetAddress && !otherCurrentLocation.streetAddress) /* Keep going... */;
    else if ((self.streetAddress == nil) ^ (otherCurrentLocation.streetAddress == nil)) return NO; // xor
    else if (![self.streetAddress isEqualToString:otherCurrentLocation.streetAddress]) return NO;

    if (!self.type && !otherCurrentLocation.type) /* Keep going... */;
    else if ((self.type == nil) ^ (otherCurrentLocation.type == nil)) return NO; // xor
    else if (![self.type isEqualToString:otherCurrentLocation.type]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"country"];
    [dictionary setObject:@"NSString" forKey:@"extendedAddress"];
    [dictionary setObject:@"NSString" forKey:@"formatted"];
    [dictionary setObject:@"JRDecimal" forKey:@"latitude"];
    [dictionary setObject:@"NSString" forKey:@"locality"];
    [dictionary setObject:@"JRDecimal" forKey:@"longitude"];
    [dictionary setObject:@"NSString" forKey:@"poBox"];
    [dictionary setObject:@"NSString" forKey:@"postalCode"];
    [dictionary setObject:@"NSString" forKey:@"region"];
    [dictionary setObject:@"NSString" forKey:@"streetAddress"];
    [dictionary setObject:@"NSString" forKey:@"type"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
