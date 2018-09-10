//
//  NSMutableDictionary+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 31/08/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "NSMutableDictionary+Idlepixel.h"

@implementation NSMutableDictionary (IDLPrimitives)

- (void) setObjectIfNotNil:(id)anObject forKey:(id<NSCopying>)key
{
    if (anObject != nil && key != nil) {
        [self setObject:anObject forKey:key];
    } else if (key != nil) {
        [self removeObjectForKey:key];
    }
}

#pragma mark - Primitive Keys

- (void) setObject:(id)anObject forIntegerKey:(NSInteger)aKey
{
    [self setObject:anObject forKey:[NSNumber numberWithInteger:aKey]];
}

- (void) setObject:(id)anObject forUnsignedIntegerKey:(NSUInteger)aKey
{
    [self setObject:anObject forKey:[NSNumber numberWithUnsignedInteger:aKey]];
}

- (void) setObject:(id)anObject forFloatKey:(CGFloat)aKey
{
    [self setObject:anObject forKey:[NSNumber numberWithFloat:aKey]];
}

- (void) setObject:(id)anObject forBooleanKey:(BOOL)aKey
{
    [self setObject:anObject forKey:[NSNumber numberWithBool:aKey]];
}

- (void) removeObjectForIntegerKey: (NSInteger) aKey
{
    [self removeObjectForKey: [NSNumber numberWithInteger: aKey]];
}

- (void) removeObjectForUnsignedIntegerKey: (NSUInteger) aKey
{
    [self removeObjectForKey: [NSNumber numberWithUnsignedInteger: aKey]];
}

- (void) removeObjectForFloatKey: (CGFloat) aKey
{
    [self removeObjectForKey: [NSNumber numberWithFloat: aKey]];
}

- (void) removeObjectForBooleanKey: (BOOL) aKey
{
    [self removeObjectForKey: [NSNumber numberWithBool: aKey]];
}

#pragma mark - Primitive Values

- (void) setInteger: (NSInteger) value forKey: (id) key
{
    [self setObject:[NSNumber numberWithInteger:value] forKey:key];
}

- (void) setUnsignedInteger: (NSUInteger) value forKey: (id) key
{
    [self setObject:[NSNumber numberWithUnsignedInteger:value] forKey:key];
}

-(void)setInt:(int)value forKey:(id)key
{
    [self setObject:[NSNumber numberWithInt:value] forKey:key];
}

-(void)setUint:(unsigned int)value forKey:(id)key
{
    [self setObject:[NSNumber numberWithUnsignedInt:value] forKey:key];
}

- (void) setFloat: (CGFloat) value forKey: (id) key
{
    [self setObject:[NSNumber numberWithFloat:value] forKey:key];
}

- (void) setBool: (BOOL) value forKey: (id) key
{
    [self setObject:[NSNumber numberWithBool:value] forKey:key];
}

- (void) setRect: (CGRect) value forKey: (id) key
{
    [self setObject:NSStringFromCGRect(value) forKey:key];
}

- (void) setSize: (CGSize) value forKey: (id) key
{
    [self setObject:NSStringFromCGSize(value) forKey:key];
}

- (void) setPoint: (CGPoint) value forKey: (id) key
{
    [self setObject:NSStringFromCGPoint(value) forKey:key];
}

@end

@implementation NSMutableDictionary (IDLRemoveObjects)

- (void) removeKeysBelongingToClass:(Class)aClass
{
    if (self.count > 0) {
        @synchronized(self) {
            for (NSObject *key in self.allKeys) {
                if ([key isKindOfClass:aClass]) {
                    [self removeObjectForKey:key];
                }
            }
        }
    }
}

- (void) removeKeysNotBelongingToClass:(Class)aClass
{
    if (self.count > 0) {
        @synchronized(self) {
            for (NSObject *key in self.allKeys) {
                if (![key isKindOfClass:aClass]) {
                    [self removeObjectForKey:key];
                }
            }
        }
    }
}

- (void) removeObjectsBelongingToClass:(Class)aClass
{
    if (self.count > 0) {
        @synchronized(self) {
            for (NSObject *key in self.allKeys) {
                if ([[self objectForKey:key] isKindOfClass:aClass]) {
                    [self removeObjectForKey:key];
                }
            }
        }
    }
}

- (void) removeObjectsNotBelongingToClass:(Class)aClass
{
    if (self.count > 0) {
        @synchronized(self) {
            for (NSObject *key in self.allKeys) {
                if (![[self objectForKey:key] isKindOfClass:aClass]) {
                    [self removeObjectForKey:key];
                }
            }
        }
    }
}

- (void) removeObjectsAndKeysBelongingToClass:(Class)aClass
{
    if (self.count > 0) {
        @synchronized(self) {
            for (NSObject *key in self.allKeys) {
                if ([key isKindOfClass:aClass] || [[self objectForKey:key] isKindOfClass:aClass]) {
                    [self removeObjectForKey:key];
                }
            }
        }
    }
}

- (void) removeObjectsAndKeysNotBelongingToClass:(Class)aClass
{
    if (self.count > 0) {
        @synchronized(self) {
            for (NSObject *key in self.allKeys) {
                if (![key isKindOfClass:aClass] || ![[self objectForKey:key] isKindOfClass:aClass]) {
                    [self removeObjectForKey:key];
                }
            }
        }
    }
}

@end
