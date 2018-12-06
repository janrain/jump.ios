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
#import "JRBodyType.h"

@interface JRBodyType ()
@property BOOL canBeUpdatedOnCapture;
@end

@implementation JRBodyType
{
    NSString *_build;
    NSString *_color;
    NSString *_eyeColor;
    NSString *_hairColor;
    JRDecimal *_height;
}
@synthesize canBeUpdatedOnCapture;

- (NSString *)build
{
    return _build;
}

- (void)setBuild:(NSString *)newBuild
{
    [self.dirtyPropertySet addObject:@"build"];

    _build = [newBuild copy];
}

- (NSString *)color
{
    return _color;
}

- (void)setColor:(NSString *)newColor
{
    [self.dirtyPropertySet addObject:@"color"];

    _color = [newColor copy];
}

- (NSString *)eyeColor
{
    return _eyeColor;
}

- (void)setEyeColor:(NSString *)newEyeColor
{
    [self.dirtyPropertySet addObject:@"eyeColor"];

    _eyeColor = [newEyeColor copy];
}

- (NSString *)hairColor
{
    return _hairColor;
}

- (void)setHairColor:(NSString *)newHairColor
{
    [self.dirtyPropertySet addObject:@"hairColor"];

    _hairColor = [newHairColor copy];
}

- (JRDecimal *)height
{
    return _height;
}

- (void)setHeight:(JRDecimal *)newHeight
{
    [self.dirtyPropertySet addObject:@"height"];

    _height = [newHeight copy];
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

+ (id)bodyType
{
    return [[JRBodyType alloc] init];
}

- (NSDictionary*)newDictionaryForEncoder:(BOOL)forEncoder
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:(self.build ? self.build : [NSNull null])
                   forKey:@"build"];
    [dictionary setObject:(self.color ? self.color : [NSNull null])
                   forKey:@"color"];
    [dictionary setObject:(self.eyeColor ? self.eyeColor : [NSNull null])
                   forKey:@"eyeColor"];
    [dictionary setObject:(self.hairColor ? self.hairColor : [NSNull null])
                   forKey:@"hairColor"];
    [dictionary setObject:(self.height ? self.height : [NSNull null])
                   forKey:@"height"];

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

+ (id)bodyTypeObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath fromDecoder:(BOOL)fromDecoder
{
    if (!dictionary)
        return nil;

    JRBodyType *bodyType = [JRBodyType bodyType];

    NSSet *dirtyPropertySetCopy = nil;
    if (fromDecoder)
    {
        dirtyPropertySetCopy = [NSSet setWithArray:[dictionary objectForKey:@"dirtyPropertiesSet"]];
        bodyType.captureObjectPath = ([dictionary objectForKey:@"captureObjectPath"] == [NSNull null] ?
                                                              nil : [dictionary objectForKey:@"captureObjectPath"]);
        bodyType.canBeUpdatedOnCapture = [(NSNumber *)[dictionary objectForKey:@"canBeUpdatedOnCapture"] boolValue];
    }
    else
    {
        bodyType.captureObjectPath      = [NSString stringWithFormat:@"%@/%@", capturePath, @"bodyType"];
        bodyType.canBeUpdatedOnCapture = YES;
    }

    bodyType.build =
        [dictionary objectForKey:@"build"] != [NSNull null] ? 
        [dictionary objectForKey:@"build"] : nil;

    bodyType.color =
        [dictionary objectForKey:@"color"] != [NSNull null] ? 
        [dictionary objectForKey:@"color"] : nil;

    bodyType.eyeColor =
        [dictionary objectForKey:@"eyeColor"] != [NSNull null] ? 
        [dictionary objectForKey:@"eyeColor"] : nil;

    bodyType.hairColor =
        [dictionary objectForKey:@"hairColor"] != [NSNull null] ? 
        [dictionary objectForKey:@"hairColor"] : nil;

    bodyType.height =
        [dictionary objectForKey:@"height"] != [NSNull null] ? 
        [dictionary objectForKey:@"height"] : nil;

    if (fromDecoder)
        [bodyType.dirtyPropertySet setSet:dirtyPropertySetCopy];
    else
        [bodyType.dirtyPropertySet removeAllObjects];

    return bodyType;
}

+ (id)bodyTypeObjectFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    return [JRBodyType bodyTypeObjectFromDictionary:dictionary withPath:capturePath fromDecoder:NO];
}

- (void)replaceFromDictionary:(NSDictionary*)dictionary withPath:(NSString *)capturePath
{
    DLog(@"%@ %@", capturePath, [dictionary description]);

    NSSet *dirtyPropertySetCopy = [self.dirtyPropertySet copy];

    self.canBeUpdatedOnCapture = YES;
    self.captureObjectPath = [NSString stringWithFormat:@"%@/%@", capturePath, @"bodyType"];

    self.build =
        [dictionary objectForKey:@"build"] != [NSNull null] ? 
        [dictionary objectForKey:@"build"] : nil;

    self.color =
        [dictionary objectForKey:@"color"] != [NSNull null] ? 
        [dictionary objectForKey:@"color"] : nil;

    self.eyeColor =
        [dictionary objectForKey:@"eyeColor"] != [NSNull null] ? 
        [dictionary objectForKey:@"eyeColor"] : nil;

    self.hairColor =
        [dictionary objectForKey:@"hairColor"] != [NSNull null] ? 
        [dictionary objectForKey:@"hairColor"] : nil;

    self.height =
        [dictionary objectForKey:@"height"] != [NSNull null] ? 
        [dictionary objectForKey:@"height"] : nil;

    [self.dirtyPropertySet setSet:dirtyPropertySetCopy];
}

- (NSSet *)updatablePropertySet
{
    return [NSSet setWithObjects:@"build", @"color", @"eyeColor", @"hairColor", @"height", nil];
}

- (void)setAllPropertiesToDirty
{
    [self.dirtyPropertySet addObjectsFromArray:[[self updatablePropertySet] allObjects]];

}

- (NSDictionary *)snapshotDictionaryFromDirtyPropertySet
{
    NSMutableDictionary *snapshotDictionary =
             [NSMutableDictionary dictionaryWithCapacity:10];

    [snapshotDictionary setObject:[self.dirtyPropertySet copy] forKey:@"bodyType"];

    return [NSDictionary dictionaryWithDictionary:snapshotDictionary];
}

- (void)restoreDirtyPropertiesFromSnapshotDictionary:(NSDictionary *)snapshotDictionary
{
    if ([snapshotDictionary objectForKey:@"bodyType"])
        [self.dirtyPropertySet addObjectsFromArray:[[snapshotDictionary objectForKey:@"bodyType"] allObjects]];

}

- (NSDictionary *)toUpdateDictionary
{
    NSMutableDictionary *dictionary =
         [NSMutableDictionary dictionaryWithCapacity:10];

    if ([self.dirtyPropertySet containsObject:@"build"])
        [dictionary setObject:(self.build ? self.build : [NSNull null]) forKey:@"build"];

    if ([self.dirtyPropertySet containsObject:@"color"])
        [dictionary setObject:(self.color ? self.color : [NSNull null]) forKey:@"color"];

    if ([self.dirtyPropertySet containsObject:@"eyeColor"])
        [dictionary setObject:(self.eyeColor ? self.eyeColor : [NSNull null]) forKey:@"eyeColor"];

    if ([self.dirtyPropertySet containsObject:@"hairColor"])
        [dictionary setObject:(self.hairColor ? self.hairColor : [NSNull null]) forKey:@"hairColor"];

    if ([self.dirtyPropertySet containsObject:@"height"])
        [dictionary setObject:(self.height ? self.height : [NSNull null]) forKey:@"height"];

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

    [dictionary setObject:(self.build ? self.build : [NSNull null]) forKey:@"build"];
    [dictionary setObject:(self.color ? self.color : [NSNull null]) forKey:@"color"];
    [dictionary setObject:(self.eyeColor ? self.eyeColor : [NSNull null]) forKey:@"eyeColor"];
    [dictionary setObject:(self.hairColor ? self.hairColor : [NSNull null]) forKey:@"hairColor"];
    [dictionary setObject:(self.height ? self.height : [NSNull null]) forKey:@"height"];

    [self.dirtyPropertySet removeAllObjects];
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (BOOL)needsUpdate
{
    if ([self.dirtyPropertySet count])
         return YES;

    return NO;
}

- (BOOL)isEqualToBodyType:(JRBodyType *)otherBodyType
{
    if (!self.build && !otherBodyType.build) /* Keep going... */;
    else if ((self.build == nil) ^ (otherBodyType.build == nil)) return NO; // xor
    else if (![self.build isEqualToString:otherBodyType.build]) return NO;

    if (!self.color && !otherBodyType.color) /* Keep going... */;
    else if ((self.color == nil) ^ (otherBodyType.color == nil)) return NO; // xor
    else if (![self.color isEqualToString:otherBodyType.color]) return NO;

    if (!self.eyeColor && !otherBodyType.eyeColor) /* Keep going... */;
    else if ((self.eyeColor == nil) ^ (otherBodyType.eyeColor == nil)) return NO; // xor
    else if (![self.eyeColor isEqualToString:otherBodyType.eyeColor]) return NO;

    if (!self.hairColor && !otherBodyType.hairColor) /* Keep going... */;
    else if ((self.hairColor == nil) ^ (otherBodyType.hairColor == nil)) return NO; // xor
    else if (![self.hairColor isEqualToString:otherBodyType.hairColor]) return NO;

    if (!self.height && !otherBodyType.height) /* Keep going... */;
    else if ((self.height == nil) ^ (otherBodyType.height == nil)) return NO; // xor
    else if (![self.height isEqualToNumber:otherBodyType.height]) return NO;

    return YES;
}

- (NSDictionary*)objectProperties
{
    NSMutableDictionary *dictionary =
        [NSMutableDictionary dictionaryWithCapacity:10];

    [dictionary setObject:@"NSString" forKey:@"build"];
    [dictionary setObject:@"NSString" forKey:@"color"];
    [dictionary setObject:@"NSString" forKey:@"eyeColor"];
    [dictionary setObject:@"NSString" forKey:@"hairColor"];
    [dictionary setObject:@"JRDecimal" forKey:@"height"];

    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
