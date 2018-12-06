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
#import "JROrganizationsElement.h"

@interface JRLocation (JRLocation_InternalMethods)
+ (id)locationObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder;
- (BOOL)isEqualToLocation:(JRLocation *)otherLocation;
@end

@interface JROrganizationsElement ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JROrganizationsElement
{
    NSString *_department;
    NSString *_description;
    NSString *_endDate;
    JRLocation *_location;
    NSString *_name;
    JRBoolean *_primary;
    NSString *_startDate;
    NSString *_title;
    NSString *_type;
}
@synthesize canBeUpdatedOnCapture;

- (NSString *)department
{
    return _department;
}

- (void)setDepartment:(NSString *)newDepartment
{
    [self.dirtyPropertySet addObject:@"department"];

    _department = [newDepartment copy];
}

- (NSString *)description
{
    return _description;
}

- (void)setDescription:(NSString *)newDescription
{
    [self.dirtyPropertySet addObject:@"description"];

    _description = [newDescription copy];
}

- (NSString *)endDate
{
    return _endDate;
}

- (void)setEndDate:(NSString *)newEndDate
{
    [self.dirtyPropertySet addObject:@"endDate"];

    _endDate = [newEndDate copy];
}

- (JRLocation *)location
{
    return _location;
}

- (void)setLocation:(JRLocation *)newLocation
{
    [self.dirtyPropertySet addObject:@"location"];

    _location = newLocation;

    [_location setAllPropertiesToDirty];
}

- (NSString *)name
{
    return _name;
}

- (void)setName:(NSString *)newName
{
    [self.dirtyPropertySet addObject:@"name"];

    _name = [newName copy];
}

- (JRBoolean *)primary
{
    return _primary;
}

- (void)setPrimary:(JRBoolean *)newPrimary
{
    [self.dirtyPropertySet addObject:@"primary"];

    _primary = [newPrimary copy];
}

- (BOOL)getPrimaryBoolValue
{
    return [_primary boolValue];
}

- (void)setPrimaryWithBool:(BOOL)boolVal
{
    [self.dirtyPropertySet addObject:@"primary"];

    _primary = [NSNumber numberWithBool:boolVal];
}

- (NSString *)startDate
{
    return _startDate;
}

- (void)setStartDate:(NSString *)newStartDate
{
    [self.dirtyPropertySet addObject:@"startDate"];

    _startDate = [newStartDate copy];
}

- (NSString *)title
{
    return _title;
}

- (void)setTitle:(NSString *)newTitle
{
    [self.dirtyPropertySet addObject:@"title"];

    _title = [newTitle copy];
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

        _location = [[JRLocation alloc] init];

        [self.dirtyPropertySet setSet:[self updatablePropertySet]];
    }
    return self;
}

+ (id)organizationsElement
{
    return [[JROrganizationsElement alloc] init];
}

- (NSDictionary*)newDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.department ? self.department : [NSNull null])
                   forKey:@"department"];
    [dictionary setObject:(self.description ? self.description : [NSNull null])
                   forKey:@"description"];
    [dictionary setObject:(self.endDate ? self.endDate : [NSNull null])
                   forKey:@"endDate"];
    [dictionary setObject:(self.location ? [self.location newDictionaryForEncoder:forEncoder] : [NSNull null])
                   forKey:@"location"];
    [dictionary setObject:(self.name ? self.name : [NSNull null])
                   forKey:@"name"];
    [dictionary setObject:(self.primary ? [NSNumber numberWithBool:[self.primary boolValue]] : [NSNull null])
                   forKey:@"primary"];
    [dictionary setObject:(self.startDate ? self.startDate : [NSNull null])
                   forKey:@"startDate"];
    [dictionary setObject:(self.title ? self.title : [NSNull null])
                   forKey:@"title"];
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

+ (id)organizationsElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JROrganizationsElement *organizationsElement = [JROrganizationsElement organizationsElement];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        organizationsElement.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
        organizationsElement.canBeUpdatedOnCapture = [(NSNumber *)[dictionary objectForKey:@"canBeUpdatedOnCapture"] boolValue];
    }
    else
    {
        organizationsElement.captureObjectPath      = [NSString stringWithFormat:@"%@/%@#%ld", capturePath, @"organizations", (long)[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
        organizationsElement.canBeUpdatedOnCapture = YES;
    }

    organizationsElement.department =
        [dictionary objectForKey:@"department"] != [NSNull null] ? 
        [dictionary objectForKey:@"department"] : nil;

    organizationsElement.description =
        [dictionary objectForKey:@"description"] != [NSNull null] ? 
        [dictionary objectForKey:@"description"] : nil;

    organizationsElement.endDate =
        [dictionary objectForKey:@"endDate"] != [NSNull null] ? 
        [dictionary objectForKey:@"endDate"] : nil;

    organizationsElement.location =
        [dictionary objectForKey:@"location"] != [NSNull null] ? 
        [JRLocation locationObjectFromDictionary:[dictionary objectForKey:@"location"] withPath:organizationsElement.captureObjectPath fromDecoder:fromDecoder] : nil;

    organizationsElement.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    organizationsElement.primary =
        [dictionary objectForKey:@"primary"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"primary"] boolValue]] : nil;

    organizationsElement.startDate =
        [dictionary objectForKey:@"startDate"] != [NSNull null] ? 
        [dictionary objectForKey:@"startDate"] : nil;

    organizationsElement.title =
        [dictionary objectForKey:@"title"] != [NSNull null] ? 
        [dictionary objectForKey:@"title"] : nil;

    organizationsElement.type =
        [dictionary objectForKey:@"type"] != [NSNull null] ? 
        [dictionary objectForKey:@"type"] : nil;

    if (fromDecoder)
        [organizationsElement.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [organizationsElement.dirtyPropertySet removeAllObjects];

    return organizationsElement;
}

+ (id)organizationsElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JROrganizationsElement organizationsElementFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [self.dirtyPropertySet copy];

    self.canBeUpdatedOnCapture = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%ld", capturePath, @"organizations", (long)[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.department =
        [dictionary objectForKey:@"department"] != [NSNull null] ? 
        [dictionary objectForKey:@"department"] : nil;

    self.description =
        [dictionary objectForKey:@"description"] != [NSNull null] ? 
        [dictionary objectForKey:@"description"] : nil;

    self.endDate =
        [dictionary objectForKey:@"endDate"] != [NSNull null] ? 
        [dictionary objectForKey:@"endDate"] : nil;

    if (![dictionary objectForKey:@"location"] || [dictionary objectForKey:@"location"] == [NSNull null])
        self.location = nil;
    else if (!self.location)
        self.location = [JRLocation locationObjectFromDictionary:[dictionary objectForKey:@"location"] withPath:self.captureObjectPath fromDecoder:NO];
    else
        [self.location replaceFromDictionary:[dictionary objectForKey:@"location"] withPath:self.captureObjectPath];

    self.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    self.primary =
        [dictionary objectForKey:@"primary"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"primary"] boolValue]] : nil;

    self.startDate =
        [dictionary objectForKey:@"startDate"] != [NSNull null] ? 
        [dictionary objectForKey:@"startDate"] : nil;

    self.title =
        [dictionary objectForKey:@"title"] != [NSNull null] ? 
        [dictionary objectForKey:@"title"] : nil;

    self.type =
        [dictionary objectForKey:@"type"] != [NSNull null] ? 
        [dictionary objectForKey:@"type"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"department", @"description", @"endDate", @"location", @"name", @"primary", @"startDate", @"title", @"type", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet addObjectsFromArray:[[self updatablePropertySet] allObjects]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[self.dirtyPropertySet copy] forKey:@"organizationsElement"];

    if (self.location)
        [snapshotDictionary setObject:[self.location snapshotDictionaryFromDirtyPropertySet]
                               forKey:@"location"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"organizationsElement"])
        [self.dirtyPropertySet addObjectsFromArray:[[snapshotDictionary objectForKey:@"organizationsElement"] allObjects]];

    if ([snapshotDictionary objectForKey:@"location"])
        [self.location restoreDirtyPropertiesFromSnapshotDictionary:
                    [snapshotDictionary objectForKey:@"location"]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"department"])
        [dictionary setObject:(self.department ? self.department : [NSNull null]) forKey:@"department"];

    if ([self.dirtyPropertySet containsObject:@"description"])
        [dictionary setObject:(self.description ? self.description : [NSNull null]) forKey:@"description"];

    if ([self.dirtyPropertySet containsObject:@"endDate"])
        [dictionary setObject:(self.endDate ? self.endDate : [NSNull null]) forKey:@"endDate"];

    if ([self.dirtyPropertySet containsObject:@"location"])
        [dictionary setObject:(self.location ?
                              [self.location toUpdateDictionary] :
                              [[JRLocation location] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                       forKey:@"location"];
    else if ([self.location needsUpdate])
        [dictionary setObject:[self.location toUpdateDictionary]
                       forKey:@"location"];

    if ([self.dirtyPropertySet containsObject:@"name"])
        [dictionary setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];

    if ([self.dirtyPropertySet containsObject:@"primary"])
        [dictionary setObject:(self.primary ? [NSNumber numberWithBool:[self.primary boolValue]] : [NSNull null]) forKey:@"primary"];

    if ([self.dirtyPropertySet containsObject:@"startDate"])
        [dictionary setObject:(self.startDate ? self.startDate : [NSNull null]) forKey:@"startDate"];

    if ([self.dirtyPropertySet containsObject:@"title"])
        [dictionary setObject:(self.title ? self.title : [NSNull null]) forKey:@"title"];

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

    [dictionary setObject:(self.department ? self.department : [NSNull null]) forKey:@"department"];
    [dictionary setObject:(self.description ? self.description : [NSNull null]) forKey:@"description"];
    [dictionary setObject:(self.endDate ? self.endDate : [NSNull null]) forKey:@"endDate"];

    [dictionary setObject:(self.location ?
                          [self.location toReplaceDictionary] :
                          [[JRLocation location] toUpdateDictionary]) /* Use the default constructor to create an empty object */
                   forKey:@"location"];
    [dictionary setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];
    [dictionary setObject:(self.primary ? [NSNumber numberWithBool:[self.primary boolValue]] : [NSNull null]) forKey:@"primary"];
    [dictionary setObject:(self.startDate ? self.startDate : [NSNull null]) forKey:@"startDate"];
    [dictionary setObject:(self.title ? self.title : [NSNull null]) forKey:@"title"];
    [dictionary setObject:(self.type ? self.type : [NSNull null]) forKey:@"type"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    if ([self.location needsUpdate])
        return YES;

    return NO;
}

- (BOOL)isEqualToOrganizationsElement:(JROrganizationsElement *)otherOrganizationsElement
{
    if (!self.department && !otherOrganizationsElement.department) /* Keep going... */;
    else if ((self.department == nil) ^ (otherOrganizationsElement.department == nil)) return NO; // xor
    else if (![self.department isEqualToString:otherOrganizationsElement.department]) return NO;

    if (!self.description && !otherOrganizationsElement.description) /* Keep going... */;
    else if ((self.description == nil) ^ (otherOrganizationsElement.description == nil)) return NO; // xor
    else if (![self.description isEqualToString:otherOrganizationsElement.description]) return NO;

    if (!self.endDate && !otherOrganizationsElement.endDate) /* Keep going... */;
    else if ((self.endDate == nil) ^ (otherOrganizationsElement.endDate == nil)) return NO; // xor
    else if (![self.endDate isEqualToString:otherOrganizationsElement.endDate]) return NO;

    if (!self.location && !otherOrganizationsElement.location) /* Keep going... */;
    else if (!self.location && [otherOrganizationsElement.location isEqualToLocation:[JRLocation location]]) /* Keep going... */;
    else if (!otherOrganizationsElement.location && [self.location isEqualToLocation:[JRLocation location]]) /* Keep going... */;
    else if (![self.location isEqualToLocation:otherOrganizationsElement.location]) return NO;

    if (!self.name && !otherOrganizationsElement.name) /* Keep going... */;
    else if ((self.name == nil) ^ (otherOrganizationsElement.name == nil)) return NO; // xor
    else if (![self.name isEqualToString:otherOrganizationsElement.name]) return NO;

    if (!self.primary && !otherOrganizationsElement.primary) /* Keep going... */;
    else if ((self.primary == nil) ^ (otherOrganizationsElement.primary == nil)) return NO; // xor
    else if (![self.primary isEqualToNumber:otherOrganizationsElement.primary]) return NO;

    if (!self.startDate && !otherOrganizationsElement.startDate) /* Keep going... */;
    else if ((self.startDate == nil) ^ (otherOrganizationsElement.startDate == nil)) return NO; // xor
    else if (![self.startDate isEqualToString:otherOrganizationsElement.startDate]) return NO;

    if (!self.title && !otherOrganizationsElement.title) /* Keep going... */;
    else if ((self.title == nil) ^ (otherOrganizationsElement.title == nil)) return NO; // xor
    else if (![self.title isEqualToString:otherOrganizationsElement.title]) return NO;

    if (!self.type && !otherOrganizationsElement.type) /* Keep going... */;
    else if ((self.type == nil) ^ (otherOrganizationsElement.type == nil)) return NO; // xor
    else if (![self.type isEqualToString:otherOrganizationsElement.type]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"department"];
    [dictionary setObject:@"NSString" forKey:@"description"];
    [dictionary setObject:@"NSString" forKey:@"endDate"];
    [dictionary setObject:@"JRLocation" forKey:@"location"];
    [dictionary setObject:@"NSString" forKey:@"name"];
    [dictionary setObject:@"JRBoolean" forKey:@"primary"];
    [dictionary setObject:@"NSString" forKey:@"startDate"];
    [dictionary setObject:@"NSString" forKey:@"title"];
    [dictionary setObject:@"NSString" forKey:@"type"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
