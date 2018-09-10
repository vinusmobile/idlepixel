//
//  NSDictionary+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 30/08/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "NSDictionary+Idlepixel.h"
#import "NSMutableDictionary+Idlepixel.h"
#import "NSArray+Idlepixel.h"
#import "NSObject+Idlepixel.h"
#import "IDLCommonMacros.h"

@implementation NSDictionary (IDLPrimitives)

#pragma mark - Primitive Keys

- (id) objectForIntegerKey:(NSInteger)key
{
    return [self objectForKeyCollection:[NSNumber numberWithInteger:key]];
}

- (id) objectForUnsignedIntegerKey:(NSUInteger)key
{
    return [self objectForKeyCollection:[NSNumber numberWithUnsignedInteger:key]];
}

- (id) objectForFloatKey:(CGFloat)key
{
    return [self objectForKeyCollection:[NSNumber numberWithFloat:key]];
}

- (id) objectForBoolKey:(BOOL)key
{
    return [self objectForKeyCollection:[NSNumber numberWithBool:key]];
}

#pragma mark - Cases-Insensitive Keys

- (id) valueForCaseInsensitiveKey:(NSString *)key
{
    if (key == nil) return nil;
    
    NSArray *dictKeys = [self allKeys];
    for (id dictKey in dictKeys) {
        if ([dictKey isKindOfClass:[NSString class]]) {
            if ([key compare:(NSString *)dictKey options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                return [self objectForKey:dictKey];
            }
        }
    }
    return nil;
}

#pragma mark - Primitive Values

- (BOOL) boolForKey: (id) key
{
    NSNumber *number = [self numberForKey:key];
    if (number != nil) {
        return [number boolValue];
    } else {
        return NO;
    }
}

- (CGFloat) floatForKey: (id) key
{
    NSNumber *number = [self numberForKey:key];
    if (number != nil) {
        return [number floatValue];
    } else {
        return 0.0f;
    }
}

- (int) intForKey: (id) key
{
    NSNumber *number = [self numberForKey:key];
    if (number != nil) {
        return [number intValue];
    } else {
        return 0;
    }
}

- (unsigned int) uintForKey: (id) key
{
    NSNumber *number = [self numberForKey:key];
    if (number != nil) {
        return [number unsignedIntValue];
    } else {
        return 0;
    }
}

- (NSInteger) integerForKey: (id) key
{
    NSNumber *number = [self numberForKey:key];
    if (number != nil) {
        return [number integerValue];
    } else {
        return 0;
    }
}

- (NSUInteger) unsignedIntegerForKey: (id) key
{
    NSNumber *number = [self numberForKey:key];
    if (number != nil) {
        return [number unsignedIntegerValue];
    } else {
        return 0;
    }
}

- (CGRect) rectForKey: (id) key
{
    NSString *value = [self stringForKey:key];
    if (value) {
        return CGRectFromString(value);
    } else {
        return CGRectZero;
    }
}

- (CGSize) sizeForKey: (id) key
{
    NSString *value = [self stringForKey:key];
    if (value) {
        return CGSizeFromString(value);
    } else {
        return CGSizeZero;
    }
}

- (CGPoint) pointForKey: (id) key
{
    NSString *value = [self stringForKey:key];
    if (value) {
        return CGPointFromString(value);
    } else {
        return CGPointZero;
    }
}

#pragma mark - Typed Values

- (id) valueForKeyCollection:(id)keyCollection
{
    id result = nil;
    if ([keyCollection conformsToProtocol:@protocol(NSFastEnumeration)]) {
        @synchronized(keyCollection) {
            id<NSFastEnumeration> fe = keyCollection;
            for (id key in fe) {
                result = [self valueForKey:key];
                if (result != nil) {
                    break;
                }
            }
        }
    }
    if (result == nil) {
        result = [self objectForKey:keyCollection];
    }
    return result;
}

- (NSObject *) objectForKeyCollection:(id)keyCollection
{
    RETURN_IF_CLASS([self valueForKeyCollection:keyCollection], NSObject);
}

- (NSNumber *) numberForKey: (id) key
{
    RETURN_IF_CLASS([self valueForKeyCollection:key], NSNumber);
}

- (NSData *) dataForKey: (id) key
{
    RETURN_IF_CLASS([self valueForKeyCollection:key], NSData);
}

- (NSString *) stringForKey: (id) key
{
    RETURN_IF_CLASS([self valueForKeyCollection:key], NSString);
}

- (NSString *) stringValueForKey: (id) key
{
    NSObject *object = [self valueForKeyCollection:key];
    if ([object isKindOfClass:[NSString class]]) {
        return (NSString *)object;
    } else if ([object respondsToSelector:@selector(stringValue)]){
        return (NSString *)[(NSNumber *)object stringValue];
    } else {
        return nil;
    }
}

- (NSDate *) dateForKey: (id) key
{
    RETURN_IF_CLASS([self valueForKeyCollection:key], NSDate);
}

- (NSDictionary *) dictionaryForKey: (id) key
{
    RETURN_IF_CLASS([self valueForKeyCollection:key], NSDictionary);
}

- (NSArray *) arrayForKey: (id) key
{
    RETURN_IF_CLASS([self valueForKeyCollection:key], NSArray);
}

@end

@implementation NSDictionary (IDLAnyObject)

- (id) anyObject
{
    return self.allValues.firstObject;
}

- (id) anyKey
{
    return self.allKeys.firstObject;
}

@end

@implementation NSDictionary (IDLAddObject)

- (NSDictionary *) dictionaryByAddingObject:(id)anObject forKey:(id <NSCopying>)aKey
{
    if (anObject != nil && aKey != nil) {
        NSMutableDictionary *dictionary = [self mutableCopy];
        [dictionary setObject:anObject forKey:aKey];
        return [NSDictionary dictionaryWithDictionary:dictionary];
    } else {
        return [self copy];
    }
}

@end

@implementation NSDictionary (IDLRemoveObjects)

- (NSDictionary *) dictionaryByRemovingKey:(id <NSCopying>)aKey
{
    NSMutableDictionary *d = [self mutableCopy];
    [d removeObjectForKey:aKey];
    return [NSDictionary dictionaryWithDictionary:d];
}

- (NSDictionary *) dictionaryByRemovingKeysBelongingToClass:(Class)aClass
{
    NSMutableDictionary *d = [self mutableCopy];
    [d removeKeysBelongingToClass:aClass];
    return [NSDictionary dictionaryWithDictionary:d];
}

- (NSDictionary *) dictionaryByRemovingKeysNotBelongingToClass:(Class)aClass
{
    NSMutableDictionary *d = [self mutableCopy];
    [d removeKeysNotBelongingToClass:aClass];
    return [NSDictionary dictionaryWithDictionary:d];
}

- (NSDictionary *) dictionaryByRemovingObjectsBelongingToClass:(Class)aClass
{
    NSMutableDictionary *d = [self mutableCopy];
    [d removeObjectsBelongingToClass:aClass];
    return [NSDictionary dictionaryWithDictionary:d];
}

- (NSDictionary *) dictionaryByRemovingObjectsNotBelongingToClass:(Class)aClass
{
    NSMutableDictionary *d = [self mutableCopy];
    [d removeObjectsNotBelongingToClass:aClass];
    return [NSDictionary dictionaryWithDictionary:d];
}

- (NSDictionary *) dictionaryByRemovingObjectsAndKeysBelongingToClass:(Class)aClass
{
    NSMutableDictionary *d = [self mutableCopy];
    [d removeObjectsAndKeysBelongingToClass:aClass];
    return [NSDictionary dictionaryWithDictionary:d];
}

- (NSDictionary *) dictionaryByRemovingObjectsAndKeysNotBelongingToClass:(Class)aClass
{
    NSMutableDictionary *d = [self mutableCopy];
    [d removeObjectsAndKeysNotBelongingToClass:aClass];
    return [NSDictionary dictionaryWithDictionary:d];
}

- (NSDictionary *) dictionaryByRemovingKeysWithPrefix:(NSString *)prefix
{
    NSMutableArray *keys = [self.allKeys mutableCopy];
    for (int i = (int)keys.count-1; i>=0; i--) {
        NSString *key = [keys objectAtIndex:i];
        if ([key isKindOfClass:[NSString class]] && [key hasPrefix:prefix]) {
            [keys removeObjectAtIndex:i];
        }
    }
    return [self dictionaryWithValuesForKeys:keys];
}

- (NSDictionary *) dictionaryByRemovingKeysWithoutPrefix:(NSString *)prefix
{
    NSMutableArray *keys = [self.allKeys mutableCopy];
    for (int i = (int)keys.count-1; i>=0; i--) {
        NSString *key = [keys objectAtIndex:i];
        if (![key isKindOfClass:[NSString class]] || [key hasPrefix:prefix]) {
            [keys removeObjectAtIndex:i];
        }
    }
    return [self dictionaryWithValuesForKeys:keys];
}

@end

@implementation NSDictionary (IDLMatchingKeys)


-(BOOL)containsAnyKeys:(NSArray *)keys
{
    return [self containsKeys:keys any:YES exactMatch:NO];
}

-(BOOL)containsAllKeys:(NSArray *)keys
{
    return [self containsAllKeys:keys exactMatch:YES];
}

-(BOOL)containsAllKeys:(NSArray *)keys exactMatch:(BOOL)exactMatch
{
    return [self containsKeys:keys any:NO exactMatch:YES];
}

-(BOOL)containsKeys:(NSArray *)keys any:(BOOL)any exactMatch:(BOOL)exactMatch
{
    NSArray *selfKeys = self.allKeys;
    if (!any && ((exactMatch && keys.count != selfKeys.count) || keys.count > selfKeys.count)) {
        return NO;
    } else {
        BOOL contained = NO;
        for (NSObject *key in keys) {
            contained = [selfKeys containsObject:key];
            if (any && contained) {
                return YES;
            } else if (!any && !contained) {
                return NO;
            }
        }
        return !any;
    }
}

@end

@implementation NSDictionary (IDLPersistent)

+ (NSSet *)dictionaryRepresentationKeys
{
    return [NSSet set];
}

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
    if (dictionary != nil) {
        return [self initWithDictionary:dictionary];
    } else {
        return [self init];
    }
}

- (NSDictionary *)dictionaryRepresentation
{
    return [self dictionaryRepresentation:NO];
}

- (NSDictionary *)dictionaryRepresentation:(BOOL)plistConformant
{
    return [NSDictionary dictionaryWithDictionary:self];
}

- (NSDictionary *)plistRepresentation
{
    return [self dictionaryRepresentation:YES];
}

@end
