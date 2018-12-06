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
#import "JROptIn.h"

@interface JROptIn ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JROptIn
{
    JRBoolean *_status;
    JRDateTime *_updated;
}
@synthesize canBeUpdatedOnCapture;

- (JRBoolean *)status
{
    return _status;
}

- (void)setStatus:(JRBoolean *)newStatus
{
    [self.dirtyPropertySet addObject:@"status"];

    _status = [newStatus copy];
}

- (BOOL)getStatusBoolValue
{
    return [_status boolValue];
}

- (void)setStatusWithBool:(BOOL)boolVal
{
    [self.dirtyPropertySet addObject:@"status"];

    _status = [NSNumber numberWithBool:boolVal];
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

- (id)init
{
    if ((self = [super init]))
    {
        self.captureObjectPath = @"/optIn";
        self.canBeUpdatedOnCapture = YES;


        [self.dirtyPropertySet setSet:[self updatablePropertySet]];
    }
    return self;
}

+ (id)optIn
{
    return [[JROptIn alloc] init];
}

- (NSDictionary*)newDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.status ? [NSNumber numberWithBool:[self.status boolValue]] : [NSNull null])
                   forKey:@"status"];
    [dictionary setObject:(self.updated ? [self.updated stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"updated"];

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

+ (id)optInObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JROptIn *optIn = [JROptIn optIn];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        optIn.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
    }

    optIn.status =
        [dictionary objectForKey:@"status"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"status"] boolValue]] : nil;

    optIn.updated =
        [dictionary objectForKey:@"updated"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"updated"]] : nil;

    if (fromDecoder)
        [optIn.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [optIn.dirtyPropertySet removeAllObjects];

    return optIn;
}

+ (id)optInObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JROptIn optInObjectFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [self.dirtyPropertySet copy];

    self.canBeUpdatedOnCapture = YES;

    self.status =
        [dictionary objectForKey:@"status"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"status"] boolValue]] : nil;

    self.updated =
        [dictionary objectForKey:@"updated"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"updated"]] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"status", @"updated", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet addObjectsFromArray:[[self updatablePropertySet] allObjects]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[self.dirtyPropertySet copy] forKey:@"optIn"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"optIn"])
        [self.dirtyPropertySet addObjectsFromArray:[[snapshotDictionary objectForKey:@"optIn"] allObjects]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"status"])
        [dictionary setObject:(self.status ? [NSNumber numberWithBool:[self.status boolValue]] : [NSNull null]) forKey:@"status"];

    if ([self.dirtyPropertySet containsObject:@"updated"])
        [dictionary setObject:(self.updated ? [self.updated stringFromISO8601DateTime] : [NSNull null]) forKey:@"updated"];

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

    [dictionary setObject:(self.status ? [NSNumber numberWithBool:[self.status boolValue]] : [NSNull null]) forKey:@"status"];
    [dictionary setObject:(self.updated ? [self.updated stringFromISO8601DateTime] : [NSNull null]) forKey:@"updated"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToOptIn:(JROptIn *)otherOptIn
{
    if (!self.status && !otherOptIn.status) /* Keep going... */;
    else if ((self.status == nil) ^ (otherOptIn.status == nil)) return NO; // xor
    else if (![self.status isEqualToNumber:otherOptIn.status]) return NO;

    if (!self.updated && !otherOptIn.updated) /* Keep going... */;
    else if ((self.updated == nil) ^ (otherOptIn.updated == nil)) return NO; // xor
    else if (![self.updated isEqualToDate:otherOptIn.updated]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"JRBoolean" forKey:@"status"];
    [dictionary setObject:@"JRDateTime" forKey:@"updated"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
