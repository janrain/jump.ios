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
#import "JRAccountsElement.h"

@interface JRAccountsElement ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JRAccountsElement
{
    NSString *_domain;
    JRBoolean *_primary;
    NSString *_userid;
    NSString *_username;
}
@synthesize canBeUpdatedOnCapture;

- (NSString *)domain
{
    return _domain;
}

- (void)setDomain:(NSString *)newDomain
{
    [self.dirtyPropertySet addObject:@"domain"];

    _domain = [newDomain copy];
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

- (NSString *)userid
{
    return _userid;
}

- (void)setUserid:(NSString *)newUserid
{
    [self.dirtyPropertySet addObject:@"userid"];

    _userid = [newUserid copy];
}

- (NSString *)username
{
    return _username;
}

- (void)setUsername:(NSString *)newUsername
{
    [self.dirtyPropertySet addObject:@"username"];

    _username = [newUsername copy];
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

+ (id)accountsElement
{
    return [[JRAccountsElement alloc] init];
}

- (NSDictionary*)newDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.domain ? self.domain : [NSNull null])
                   forKey:@"domain"];
    [dictionary setObject:(self.primary ? [NSNumber numberWithBool:[self.primary boolValue]] : [NSNull null])
                   forKey:@"primary"];
    [dictionary setObject:(self.userid ? self.userid : [NSNull null])
                   forKey:@"userid"];
    [dictionary setObject:(self.username ? self.username : [NSNull null])
                   forKey:@"username"];

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

+ (id)accountsElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRAccountsElement *accountsElement = [JRAccountsElement accountsElement];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        accountsElement.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
        accountsElement.canBeUpdatedOnCapture = [(NSNumber *)[dictionary objectForKey:@"canBeUpdatedOnCapture"] boolValue];
    }
    else
    {
        accountsElement.captureObjectPath      = [NSString stringWithFormat:@"%@/%@#%ld", capturePath, @"accounts", (long)[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];
        accountsElement.canBeUpdatedOnCapture = YES;
    }

    accountsElement.domain =
        [dictionary objectForKey:@"domain"] != [NSNull null] ? 
        [dictionary objectForKey:@"domain"] : nil;

    accountsElement.primary =
        [dictionary objectForKey:@"primary"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"primary"] boolValue]] : nil;

    accountsElement.userid =
        [dictionary objectForKey:@"userid"] != [NSNull null] ? 
        [dictionary objectForKey:@"userid"] : nil;

    accountsElement.username =
        [dictionary objectForKey:@"username"] != [NSNull null] ? 
        [dictionary objectForKey:@"username"] : nil;

    if (fromDecoder)
        [accountsElement.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [accountsElement.dirtyPropertySet removeAllObjects];

    return accountsElement;
}

+ (id)accountsElementFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRAccountsElement accountsElementFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [self.dirtyPropertySet copy];

    self.canBeUpdatedOnCapture = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@#%ld", capturePath, @"accounts", (long)[(NSNumber*)[dictionary objectForKey:@"id"] integerValue]];

    self.domain =
        [dictionary objectForKey:@"domain"] != [NSNull null] ? 
        [dictionary objectForKey:@"domain"] : nil;

    self.primary =
        [dictionary objectForKey:@"primary"] != [NSNull null] ? 
        [NSNumber numberWithBool:[(NSNumber*)[dictionary objectForKey:@"primary"] boolValue]] : nil;

    self.userid =
        [dictionary objectForKey:@"userid"] != [NSNull null] ? 
        [dictionary objectForKey:@"userid"] : nil;

    self.username =
        [dictionary objectForKey:@"username"] != [NSNull null] ? 
        [dictionary objectForKey:@"username"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"domain", @"primary", @"userid", @"username", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet addObjectsFromArray:[[self updatablePropertySet] allObjects]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[self.dirtyPropertySet copy] forKey:@"accountsElement"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"accountsElement"])
        [self.dirtyPropertySet addObjectsFromArray:[[snapshotDictionary objectForKey:@"accountsElement"] allObjects]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"domain"])
        [dictionary setObject:(self.domain ? self.domain : [NSNull null]) forKey:@"domain"];

    if ([self.dirtyPropertySet containsObject:@"primary"])
        [dictionary setObject:(self.primary ? [NSNumber numberWithBool:[self.primary boolValue]] : [NSNull null]) forKey:@"primary"];

    if ([self.dirtyPropertySet containsObject:@"userid"])
        [dictionary setObject:(self.userid ? self.userid : [NSNull null]) forKey:@"userid"];

    if ([self.dirtyPropertySet containsObject:@"username"])
        [dictionary setObject:(self.username ? self.username : [NSNull null]) forKey:@"username"];

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

    [dictionary setObject:(self.domain ? self.domain : [NSNull null]) forKey:@"domain"];
    [dictionary setObject:(self.primary ? [NSNumber numberWithBool:[self.primary boolValue]] : [NSNull null]) forKey:@"primary"];
    [dictionary setObject:(self.userid ? self.userid : [NSNull null]) forKey:@"userid"];
    [dictionary setObject:(self.username ? self.username : [NSNull null]) forKey:@"username"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToAccountsElement:(JRAccountsElement *)otherAccountsElement
{
    if (!self.domain && !otherAccountsElement.domain) /* Keep going... */;
    else if ((self.domain == nil) ^ (otherAccountsElement.domain == nil)) return NO; // xor
    else if (![self.domain isEqualToString:otherAccountsElement.domain]) return NO;

    if (!self.primary && !otherAccountsElement.primary) /* Keep going... */;
    else if ((self.primary == nil) ^ (otherAccountsElement.primary == nil)) return NO; // xor
    else if (![self.primary isEqualToNumber:otherAccountsElement.primary]) return NO;

    if (!self.userid && !otherAccountsElement.userid) /* Keep going... */;
    else if ((self.userid == nil) ^ (otherAccountsElement.userid == nil)) return NO; // xor
    else if (![self.userid isEqualToString:otherAccountsElement.userid]) return NO;

    if (!self.username && !otherAccountsElement.username) /* Keep going... */;
    else if ((self.username == nil) ^ (otherAccountsElement.username == nil)) return NO; // xor
    else if (![self.username isEqualToString:otherAccountsElement.username]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"domain"];
    [dictionary setObject:@"JRBoolean" forKey:@"primary"];
    [dictionary setObject:@"NSString" forKey:@"userid"];
    [dictionary setObject:@"NSString" forKey:@"username"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
