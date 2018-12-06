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
#import "JRCloudsearch.h"

@interface JRCloudsearch ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JRCloudsearch
{
    JRInteger *_syncAttempts;
    JRDateTime *_syncUpdated;
}
@synthesize canBeUpdatedOnCapture;

- (JRInteger *)syncAttempts
{
    return _syncAttempts;
}

- (void)setSyncAttempts:(JRInteger *)newSyncAttempts
{
    [self.dirtyPropertySet addObject:@"syncAttempts"];

    _syncAttempts = [newSyncAttempts copy];
}

- (NSInteger)getSyncAttemptsIntegerValue
{
    return [_syncAttempts integerValue];
}

- (void)setSyncAttemptsWithInteger:(NSInteger)integerVal
{
    [self.dirtyPropertySet addObject:@"syncAttempts"];

    _syncAttempts = [NSNumber numberWithInteger:integerVal];
}

- (JRDateTime *)syncUpdated
{
    return _syncUpdated;
}

- (void)setSyncUpdated:(JRDateTime *)newSyncUpdated
{
    [self.dirtyPropertySet addObject:@"syncUpdated"];

    _syncUpdated = [newSyncUpdated copy];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/janrain/cloudsearch";
        self.canBeUpdatedOnCapture = YES;


        [self.dirtyPropertySet setSet:[self updatablePropertySet]];
    }
    return self;
}

+ (id)cloudsearch
{
    return [[JRCloudsearch alloc] init];
}

- (NSDictionary*)newDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.syncAttempts ? [NSNumber numberWithInteger:[self.syncAttempts integerValue]] : [NSNull null])
                   forKey:@"syncAttempts"];
    [dictionary setObject:(self.syncUpdated ? [self.syncUpdated stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"syncUpdated"];

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

+ (id)cloudsearchObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRCloudsearch *cloudsearch = [JRCloudsearch cloudsearch];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        cloudsearch.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
    }

    cloudsearch.syncAttempts =
        [dictionary objectForKey:@"syncAttempts"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"syncAttempts"] integerValue]] : nil;

    cloudsearch.syncUpdated =
        [dictionary objectForKey:@"syncUpdated"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"syncUpdated"]] : nil;

    if (fromDecoder)
        [cloudsearch.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [cloudsearch.dirtyPropertySet removeAllObjects];

    return cloudsearch;
}

+ (id)cloudsearchObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRCloudsearch cloudsearchObjectFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [self.dirtyPropertySet copy];

    self.canBeUpdatedOnCapture = YES;

    self.syncAttempts =
        [dictionary objectForKey:@"syncAttempts"] != [NSNull null] ? 
        [NSNumber numberWithInteger:[(NSNumber*)[dictionary objectForKey:@"syncAttempts"] integerValue]] : nil;

    self.syncUpdated =
        [dictionary objectForKey:@"syncUpdated"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"syncUpdated"]] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"syncAttempts", @"syncUpdated", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet addObjectsFromArray:[[self updatablePropertySet] allObjects]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[self.dirtyPropertySet copy] forKey:@"cloudsearch"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"cloudsearch"])
        [self.dirtyPropertySet addObjectsFromArray:[[snapshotDictionary objectForKey:@"cloudsearch"] allObjects]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"syncAttempts"])
        [dictionary setObject:(self.syncAttempts ? [NSNumber numberWithInteger:[self.syncAttempts integerValue]] : [NSNull null]) forKey:@"syncAttempts"];

    if ([self.dirtyPropertySet containsObject:@"syncUpdated"])
        [dictionary setObject:(self.syncUpdated ? [self.syncUpdated stringFromISO8601DateTime] : [NSNull null]) forKey:@"syncUpdated"];

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

    [dictionary setObject:(self.syncAttempts ? [NSNumber numberWithInteger:[self.syncAttempts integerValue]] : [NSNull null]) forKey:@"syncAttempts"];
    [dictionary setObject:(self.syncUpdated ? [self.syncUpdated stringFromISO8601DateTime] : [NSNull null]) forKey:@"syncUpdated"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToCloudsearch:(JRCloudsearch *)otherCloudsearch
{
    if (!self.syncAttempts && !otherCloudsearch.syncAttempts) /* Keep going... */;
    else if ((self.syncAttempts == nil) ^ (otherCloudsearch.syncAttempts == nil)) return NO; // xor
    else if (![self.syncAttempts isEqualToNumber:otherCloudsearch.syncAttempts]) return NO;

    if (!self.syncUpdated && !otherCloudsearch.syncUpdated) /* Keep going... */;
    else if ((self.syncUpdated == nil) ^ (otherCloudsearch.syncUpdated == nil)) return NO; // xor
    else if (![self.syncUpdated isEqualToDate:otherCloudsearch.syncUpdated]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"JRInteger" forKey:@"syncAttempts"];
    [dictionary setObject:@"JRDateTime" forKey:@"syncUpdated"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
