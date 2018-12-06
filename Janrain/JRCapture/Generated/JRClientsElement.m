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
#import "JRClientsElement.h"

@interface JRClientsElement ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JRClientsElement
{
    NSString *_clientId;
    JRDateTime *_firstLogin;
    JRDateTime *_lastLogin;
    NSString *_name;
}
@synthesize canBeUpdatedOnCapture;

- (NSString *)clientId
{
    return _clientId;
}

- (void)setClientId:(NSString *)newClientId
{
    [self.dirtyPropertySet addObject:@"clientId"];

    _clientId = [newClientId copy];
}

- (JRDateTime *)firstLogin
{
    return _firstLogin;
}

- (void)setFirstLogin:(JRDateTime *)newFirstLogin
{
    [self.dirtyPropertySet addObject:@"firstLogin"];

    _firstLogin = [newFirstLogin copy];
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

- (NSString *)name
{
    return _name;
}

- (void)setName:(NSString *)newName
{
    [self.dirtyPropertySet addObject:@"name"];

    _name = [newName copy];
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

- (id)initWithClientId:(NSString *)newClientId
{
    if (!newClientId)
    {
        return nil;
     }

    if ((self = [super init]))
    {
        self.captureObjectPath      = @"";
        self.canBeUpdatedOnCapture  = NO;

        _clientId = [newClientId copy];

        [self.dirtyPropertySet setSet:[self updatablePropertySet]];
    }
    return self;
}

+ (id)clientsElement
{
    return [[JRClientsElement alloc] init];
}

+ (id)clientsElementWithClientId:(NSString *)clientId
{
    return [[JRClientsElement alloc] initWithClientId:clientId];
}

- (NSDictionary*)newDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.clientId ? self.clientId : [NSNull null])
                   forKey:@"clientId"];
    [dictionary setObject:(self.firstLogin ? [self.firstLogin stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"firstLogin"];
    [dictionary setObject:(self.lastLogin ? [self.lastLogin stringFromISO8601DateTime] : [NSNull null])
                   forKey:@"lastLogin"];
    [dictionary setObject:(self.name ? self.name : [NSNull null])
                   forKey:@"name"];

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

+ (id)clientsElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRClientsElement *clientsElement = [JRClientsElement clientsElement];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        clientsElement.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
        clientsElement.canBeUpdatedOnCapture = [(NSNumber *)[dictionary objectForKey:@"canBeUpdatedOnCapture"] boolValue];
    }
    else
    {
        clientsElement.captureObjectPath      = [NSString stringWithFormat:@"%@/%@#%ld", capturePath, @"clients", (long)[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
        clientsElement.canBeUpdatedOnCapture = YES;
    }

    clientsElement.clientId =
        [dictionary objectForKey:@"clientId"] != [NSNull null] ? 
        [dictionary objectForKey:@"clientId"] : nil;

    clientsElement.firstLogin =
        [dictionary objectForKey:@"firstLogin"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"firstLogin"]] : nil;

    clientsElement.lastLogin =
        [dictionary objectForKey:@"lastLogin"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastLogin"]] : nil;

    clientsElement.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    if (fromDecoder)
        [clientsElement.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [clientsElement.dirtyPropertySet removeAllObjects];

    return clientsElement;
}

+ (id)clientsElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRClientsElement clientsElementFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [self.dirtyPropertySet copy];

    self.canBeUpdatedOnCapture = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%ld", capturePath, @"clients", (long)[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.clientId =
        [dictionary objectForKey:@"clientId"] != [NSNull null] ? 
        [dictionary objectForKey:@"clientId"] : nil;

    self.firstLogin =
        [dictionary objectForKey:@"firstLogin"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"firstLogin"]] : nil;

    self.lastLogin =
        [dictionary objectForKey:@"lastLogin"] != [NSNull null] ? 
        [JRDateTime dateFromISO8601DateTimeString:[dictionary objectForKey:@"lastLogin"]] : nil;

    self.name =
        [dictionary objectForKey:@"name"] != [NSNull null] ? 
        [dictionary objectForKey:@"name"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"clientId", @"firstLogin", @"lastLogin", @"name", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet addObjectsFromArray:[[self updatablePropertySet] allObjects]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[self.dirtyPropertySet copy] forKey:@"clientsElement"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"clientsElement"])
        [self.dirtyPropertySet addObjectsFromArray:[[snapshotDictionary objectForKey:@"clientsElement"] allObjects]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"clientId"])
        [dictionary setObject:(self.clientId ? self.clientId : [NSNull null]) forKey:@"clientId"];

    if ([self.dirtyPropertySet containsObject:@"firstLogin"])
        [dictionary setObject:(self.firstLogin ? [self.firstLogin stringFromISO8601DateTime] : [NSNull null]) forKey:@"firstLogin"];

    if ([self.dirtyPropertySet containsObject:@"lastLogin"])
        [dictionary setObject:(self.lastLogin ? [self.lastLogin stringFromISO8601DateTime] : [NSNull null]) forKey:@"lastLogin"];

    if ([self.dirtyPropertySet containsObject:@"name"])
        [dictionary setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];

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

    [dictionary setObject:(self.clientId ? self.clientId : [NSNull null]) forKey:@"clientId"];
    [dictionary setObject:(self.firstLogin ? [self.firstLogin stringFromISO8601DateTime] : [NSNull null]) forKey:@"firstLogin"];
    [dictionary setObject:(self.lastLogin ? [self.lastLogin stringFromISO8601DateTime] : [NSNull null]) forKey:@"lastLogin"];
    [dictionary setObject:(self.name ? self.name : [NSNull null]) forKey:@"name"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToClientsElement:(JRClientsElement *)otherClientsElement
{
    if (!self.clientId && !otherClientsElement.clientId) /* Keep going... */;
    else if ((self.clientId == nil) ^ (otherClientsElement.clientId == nil)) return NO; // xor
    else if (![self.clientId isEqualToString:otherClientsElement.clientId]) return NO;

    if (!self.firstLogin && !otherClientsElement.firstLogin) /* Keep going... */;
    else if ((self.firstLogin == nil) ^ (otherClientsElement.firstLogin == nil)) return NO; // xor
    else if (![self.firstLogin isEqualToDate:otherClientsElement.firstLogin]) return NO;

    if (!self.lastLogin && !otherClientsElement.lastLogin) /* Keep going... */;
    else if ((self.lastLogin == nil) ^ (otherClientsElement.lastLogin == nil)) return NO; // xor
    else if (![self.lastLogin isEqualToDate:otherClientsElement.lastLogin]) return NO;

    if (!self.name && !otherClientsElement.name) /* Keep going... */;
    else if ((self.name == nil) ^ (otherClientsElement.name == nil)) return NO; // xor
    else if (![self.name isEqualToString:otherClientsElement.name]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"clientId"];
    [dictionary setObject:@"JRDateTime" forKey:@"firstLogin"];
    [dictionary setObject:@"JRDateTime" forKey:@"lastLogin"];
    [dictionary setObject:@"NSString" forKey:@"name"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
