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
#import "JRPrimaryAddress.h"

@interface JRPrimaryAddress ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JRPrimaryAddress
{
    NSString *_address1;
    NSString *_address2;
    NSString *_city;
    NSString *_company;
    NSString *_country;
    NSString *_mobile;
    NSString *_phone;
    NSString *_stateAbbreviation;
    NSString *_zip;
    NSString *_zipPlus4;
}
@synthesize canBeUpdatedOnCapture;

- (NSString *)address1
{
    return _address1;
}

- (void)setAddress1:(NSString *)newAddress1
{
    [self.dirtyPropertySet addObject:@"address1"];

    _address1 = [newAddress1 copy];
}

- (NSString *)address2
{
    return _address2;
}

- (void)setAddress2:(NSString *)newAddress2
{
    [self.dirtyPropertySet addObject:@"address2"];

    _address2 = [newAddress2 copy];
}

- (NSString *)city
{
    return _city;
}

- (void)setCity:(NSString *)newCity
{
    [self.dirtyPropertySet addObject:@"city"];

    _city = [newCity copy];
}

- (NSString *)company
{
    return _company;
}

- (void)setCompany:(NSString *)newCompany
{
    [self.dirtyPropertySet addObject:@"company"];

    _company = [newCompany copy];
}

- (NSString *)country
{
    return _country;
}

- (void)setCountry:(NSString *)newCountry
{
    [self.dirtyPropertySet addObject:@"country"];

    _country = [newCountry copy];
}

- (NSString *)mobile
{
    return _mobile;
}

- (void)setMobile:(NSString *)newMobile
{
    [self.dirtyPropertySet addObject:@"mobile"];

    _mobile = [newMobile copy];
}

- (NSString *)phone
{
    return _phone;
}

- (void)setPhone:(NSString *)newPhone
{
    [self.dirtyPropertySet addObject:@"phone"];

    _phone = [newPhone copy];
}

- (NSString *)stateAbbreviation
{
    return _stateAbbreviation;
}

- (void)setStateAbbreviation:(NSString *)newStateAbbreviation
{
    [self.dirtyPropertySet addObject:@"stateAbbreviation"];

    _stateAbbreviation = [newStateAbbreviation copy];
}

- (NSString *)zip
{
    return _zip;
}

- (void)setZip:(NSString *)newZip
{
    [self.dirtyPropertySet addObject:@"zip"];

    _zip = [newZip copy];
}

- (NSString *)zipPlus4
{
    return _zipPlus4;
}

- (void)setZipPlus4:(NSString *)newZipPlus4
{
    [self.dirtyPropertySet addObject:@"zipPlus4"];

    _zipPlus4 = [newZipPlus4 copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/primaryAddress";
        self.canBeUpdatedOnCapture = YES;


        [self.dirtyPropertySet setSet:[self updatablePropertySet]];
    }
    return self;
}

+ (id)primaryAddress
{
    return [[JRPrimaryAddress alloc] init];
}

- (NSDictionary*)newDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.address1 ? self.address1 : [NSNull null])
                   forKey:@"address1"];
    [dictionary setObject:(self.address2 ? self.address2 : [NSNull null])
                   forKey:@"address2"];
    [dictionary setObject:(self.city ? self.city : [NSNull null])
                   forKey:@"city"];
    [dictionary setObject:(self.company ? self.company : [NSNull null])
                   forKey:@"company"];
    [dictionary setObject:(self.country ? self.country : [NSNull null])
                   forKey:@"country"];
    [dictionary setObject:(self.mobile ? self.mobile : [NSNull null])
                   forKey:@"mobile"];
    [dictionary setObject:(self.phone ? self.phone : [NSNull null])
                   forKey:@"phone"];
    [dictionary setObject:(self.stateAbbreviation ? self.stateAbbreviation : [NSNull null])
                   forKey:@"stateAbbreviation"];
    [dictionary setObject:(self.zip ? self.zip : [NSNull null])
                   forKey:@"zip"];
    [dictionary setObject:(self.zipPlus4 ? self.zipPlus4 : [NSNull null])
                   forKey:@"zipPlus4"];

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

+ (id)primaryAddressObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRPrimaryAddress *primaryAddress = [JRPrimaryAddress primaryAddress];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        primaryAddress.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
    }

    primaryAddress.address1 =
        [dictionary objectForKey:@"address1"] != [NSNull null] ? 
        [dictionary objectForKey:@"address1"] : nil;

    primaryAddress.address2 =
        [dictionary objectForKey:@"address2"] != [NSNull null] ? 
        [dictionary objectForKey:@"address2"] : nil;

    primaryAddress.city =
        [dictionary objectForKey:@"city"] != [NSNull null] ? 
        [dictionary objectForKey:@"city"] : nil;

    primaryAddress.company =
        [dictionary objectForKey:@"company"] != [NSNull null] ? 
        [dictionary objectForKey:@"company"] : nil;

    primaryAddress.country =
        [dictionary objectForKey:@"country"] != [NSNull null] ? 
        [dictionary objectForKey:@"country"] : nil;

    primaryAddress.mobile =
        [dictionary objectForKey:@"mobile"] != [NSNull null] ? 
        [dictionary objectForKey:@"mobile"] : nil;

    primaryAddress.phone =
        [dictionary objectForKey:@"phone"] != [NSNull null] ? 
        [dictionary objectForKey:@"phone"] : nil;

    primaryAddress.stateAbbreviation =
        [dictionary objectForKey:@"stateAbbreviation"] != [NSNull null] ? 
        [dictionary objectForKey:@"stateAbbreviation"] : nil;

    primaryAddress.zip =
        [dictionary objectForKey:@"zip"] != [NSNull null] ? 
        [dictionary objectForKey:@"zip"] : nil;

    primaryAddress.zipPlus4 =
        [dictionary objectForKey:@"zipPlus4"] != [NSNull null] ? 
        [dictionary objectForKey:@"zipPlus4"] : nil;

    if (fromDecoder)
        [primaryAddress.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [primaryAddress.dirtyPropertySet removeAllObjects];

    return primaryAddress;
}

+ (id)primaryAddressObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRPrimaryAddress primaryAddressObjectFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [self.dirtyPropertySet copy];

    self.canBeUpdatedOnCapture = YES;

    self.address1 =
        [dictionary objectForKey:@"address1"] != [NSNull null] ? 
        [dictionary objectForKey:@"address1"] : nil;

    self.address2 =
        [dictionary objectForKey:@"address2"] != [NSNull null] ? 
        [dictionary objectForKey:@"address2"] : nil;

    self.city =
        [dictionary objectForKey:@"city"] != [NSNull null] ? 
        [dictionary objectForKey:@"city"] : nil;

    self.company =
        [dictionary objectForKey:@"company"] != [NSNull null] ? 
        [dictionary objectForKey:@"company"] : nil;

    self.country =
        [dictionary objectForKey:@"country"] != [NSNull null] ? 
        [dictionary objectForKey:@"country"] : nil;

    self.mobile =
        [dictionary objectForKey:@"mobile"] != [NSNull null] ? 
        [dictionary objectForKey:@"mobile"] : nil;

    self.phone =
        [dictionary objectForKey:@"phone"] != [NSNull null] ? 
        [dictionary objectForKey:@"phone"] : nil;

    self.stateAbbreviation =
        [dictionary objectForKey:@"stateAbbreviation"] != [NSNull null] ? 
        [dictionary objectForKey:@"stateAbbreviation"] : nil;

    self.zip =
        [dictionary objectForKey:@"zip"] != [NSNull null] ? 
        [dictionary objectForKey:@"zip"] : nil;

    self.zipPlus4 =
        [dictionary objectForKey:@"zipPlus4"] != [NSNull null] ? 
        [dictionary objectForKey:@"zipPlus4"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"address1", @"address2", @"city", @"company", @"country", @"mobile", @"phone", @"stateAbbreviation", @"zip", @"zipPlus4", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet addObjectsFromArray:[[self updatablePropertySet] allObjects]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[self.dirtyPropertySet copy] forKey:@"primaryAddress"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"primaryAddress"])
        [self.dirtyPropertySet addObjectsFromArray:[[snapshotDictionary objectForKey:@"primaryAddress"] allObjects]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"address1"])
        [dictionary setObject:(self.address1 ? self.address1 : [NSNull null]) forKey:@"address1"];

    if ([self.dirtyPropertySet containsObject:@"address2"])
        [dictionary setObject:(self.address2 ? self.address2 : [NSNull null]) forKey:@"address2"];

    if ([self.dirtyPropertySet containsObject:@"city"])
        [dictionary setObject:(self.city ? self.city : [NSNull null]) forKey:@"city"];

    if ([self.dirtyPropertySet containsObject:@"company"])
        [dictionary setObject:(self.company ? self.company : [NSNull null]) forKey:@"company"];

    if ([self.dirtyPropertySet containsObject:@"country"])
        [dictionary setObject:(self.country ? self.country : [NSNull null]) forKey:@"country"];

    if ([self.dirtyPropertySet containsObject:@"mobile"])
        [dictionary setObject:(self.mobile ? self.mobile : [NSNull null]) forKey:@"mobile"];

    if ([self.dirtyPropertySet containsObject:@"phone"])
        [dictionary setObject:(self.phone ? self.phone : [NSNull null]) forKey:@"phone"];

    if ([self.dirtyPropertySet containsObject:@"stateAbbreviation"])
        [dictionary setObject:(self.stateAbbreviation ? self.stateAbbreviation : [NSNull null]) forKey:@"stateAbbreviation"];

    if ([self.dirtyPropertySet containsObject:@"zip"])
        [dictionary setObject:(self.zip ? self.zip : [NSNull null]) forKey:@"zip"];

    if ([self.dirtyPropertySet containsObject:@"zipPlus4"])
        [dictionary setObject:(self.zipPlus4 ? self.zipPlus4 : [NSNull null]) forKey:@"zipPlus4"];

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

    [dictionary setObject:(self.address1 ? self.address1 : [NSNull null]) forKey:@"address1"];
    [dictionary setObject:(self.address2 ? self.address2 : [NSNull null]) forKey:@"address2"];
    [dictionary setObject:(self.city ? self.city : [NSNull null]) forKey:@"city"];
    [dictionary setObject:(self.company ? self.company : [NSNull null]) forKey:@"company"];
    [dictionary setObject:(self.country ? self.country : [NSNull null]) forKey:@"country"];
    [dictionary setObject:(self.mobile ? self.mobile : [NSNull null]) forKey:@"mobile"];
    [dictionary setObject:(self.phone ? self.phone : [NSNull null]) forKey:@"phone"];
    [dictionary setObject:(self.stateAbbreviation ? self.stateAbbreviation : [NSNull null]) forKey:@"stateAbbreviation"];
    [dictionary setObject:(self.zip ? self.zip : [NSNull null]) forKey:@"zip"];
    [dictionary setObject:(self.zipPlus4 ? self.zipPlus4 : [NSNull null]) forKey:@"zipPlus4"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToPrimaryAddress:(JRPrimaryAddress *)otherPrimaryAddress
{
    if (!self.address1 && !otherPrimaryAddress.address1) /* Keep going... */;
    else if ((self.address1 == nil) ^ (otherPrimaryAddress.address1 == nil)) return NO; // xor
    else if (![self.address1 isEqualToString:otherPrimaryAddress.address1]) return NO;

    if (!self.address2 && !otherPrimaryAddress.address2) /* Keep going... */;
    else if ((self.address2 == nil) ^ (otherPrimaryAddress.address2 == nil)) return NO; // xor
    else if (![self.address2 isEqualToString:otherPrimaryAddress.address2]) return NO;

    if (!self.city && !otherPrimaryAddress.city) /* Keep going... */;
    else if ((self.city == nil) ^ (otherPrimaryAddress.city == nil)) return NO; // xor
    else if (![self.city isEqualToString:otherPrimaryAddress.city]) return NO;

    if (!self.company && !otherPrimaryAddress.company) /* Keep going... */;
    else if ((self.company == nil) ^ (otherPrimaryAddress.company == nil)) return NO; // xor
    else if (![self.company isEqualToString:otherPrimaryAddress.company]) return NO;

    if (!self.country && !otherPrimaryAddress.country) /* Keep going... */;
    else if ((self.country == nil) ^ (otherPrimaryAddress.country == nil)) return NO; // xor
    else if (![self.country isEqualToString:otherPrimaryAddress.country]) return NO;

    if (!self.mobile && !otherPrimaryAddress.mobile) /* Keep going... */;
    else if ((self.mobile == nil) ^ (otherPrimaryAddress.mobile == nil)) return NO; // xor
    else if (![self.mobile isEqualToString:otherPrimaryAddress.mobile]) return NO;

    if (!self.phone && !otherPrimaryAddress.phone) /* Keep going... */;
    else if ((self.phone == nil) ^ (otherPrimaryAddress.phone == nil)) return NO; // xor
    else if (![self.phone isEqualToString:otherPrimaryAddress.phone]) return NO;

    if (!self.stateAbbreviation && !otherPrimaryAddress.stateAbbreviation) /* Keep going... */;
    else if ((self.stateAbbreviation == nil) ^ (otherPrimaryAddress.stateAbbreviation == nil)) return NO; // xor
    else if (![self.stateAbbreviation isEqualToString:otherPrimaryAddress.stateAbbreviation]) return NO;

    if (!self.zip && !otherPrimaryAddress.zip) /* Keep going... */;
    else if ((self.zip == nil) ^ (otherPrimaryAddress.zip == nil)) return NO; // xor
    else if (![self.zip isEqualToString:otherPrimaryAddress.zip]) return NO;

    if (!self.zipPlus4 && !otherPrimaryAddress.zipPlus4) /* Keep going... */;
    else if ((self.zipPlus4 == nil) ^ (otherPrimaryAddress.zipPlus4 == nil)) return NO; // xor
    else if (![self.zipPlus4 isEqualToString:otherPrimaryAddress.zipPlus4]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"address1"];
    [dictionary setObject:@"NSString" forKey:@"address2"];
    [dictionary setObject:@"NSString" forKey:@"city"];
    [dictionary setObject:@"NSString" forKey:@"company"];
    [dictionary setObject:@"NSString" forKey:@"country"];
    [dictionary setObject:@"NSString" forKey:@"mobile"];
    [dictionary setObject:@"NSString" forKey:@"phone"];
    [dictionary setObject:@"NSString" forKey:@"stateAbbreviation"];
    [dictionary setObject:@"NSString" forKey:@"zip"];
    [dictionary setObject:@"NSString" forKey:@"zipPlus4"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
