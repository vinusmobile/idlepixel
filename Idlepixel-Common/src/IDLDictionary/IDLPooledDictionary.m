//
//  IDLPooledDictionary.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 21/01/2014.
//  Copyright (c) 2014 Trystan Pfluger. All rights reserved.
//

#import "IDLPooledDictionary.h"
#import "NSArray+Idlepixel.h"
#import "NSMutableArray+Idlepixel.h"
#import "NSMutableDictionary+Idlepixel.h"

@interface IDLPooledDictionary ()

@property (nonatomic, strong) NSMutableDictionary *poolDictionary;

@end

@implementation IDLPooledDictionary

-(id)init
{
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}

-(void)configure
{
    self.poolDictionary = [NSMutableDictionary new];
}

-(void)addObject:(NSObject *)anObject forKey:(NSObject<NSCopying> *)key
{
    if (!key || !anObject) return;
    
    NSArray *existing = [self objectsForKey:key];
    if (existing && ![existing containsObject:anObject]) {
        [self.poolDictionary setObject:[existing arrayByAddingObject:anObject] forKey:key];
    } else if (!existing) {
        [self.poolDictionary setObject:@[anObject] forKey:key];
    }
}

-(void)removeKey:(NSObject<NSCopying> *)key
{
    if (key) {
        [self.poolDictionary removeObjectForKey:key];
    }
}

-(void)removeObject:(NSObject *)anObject
{
    if (!anObject) return;
    
    NSArray *keys = [self.poolDictionary allKeys];
    if (keys.count > 0) {
        for (NSObject<NSCopying> *key in keys) {
            [self removeObject:anObject forKey:key];
        }
    }
}

-(void)removeObject:(NSObject *)anObject forKey:(NSObject<NSCopying> *)key
{
    if (!key || !anObject) return;
    
    NSArray *existing = [self objectsForKey:key];
    if (existing && [existing containsObject:anObject]) {
        if (existing.count > 1) {
            [self.poolDictionary setObject:[existing arrayByRemovingObject:anObject] forKey:key];
        } else {
            [self.poolDictionary removeObjectForKey:key];
        }
    }
}

-(NSArray *)objectsForKey:(NSObject<NSCopying> *)key
{
    if (key) {
        return [[self.poolDictionary arrayForKey:key] copy];
    } else {
        return nil;
    }
}

-(NSObject<NSCopying> *)anyKeyWithObject:(NSObject *)object
{
    return [[self keysWithObject:object] firstObject];
}

-(NSArray *)keysWithObject:(NSObject *)object
{
    if (!object) return nil;
    
    NSArray *keys = [self.poolDictionary allKeys];
    if (keys.count > 0) {
        NSMutableArray *containingKeys = [NSMutableArray array];
        for (NSObject<NSCopying> *key in keys) {
            if ([[self.poolDictionary arrayForKey:key] containsObject:object]) {
                [containingKeys addObject:key];
            }
        }
        if (containingKeys.count > 0) {
            return [NSArray arrayWithArray:containingKeys];
        }
    }
    return nil;
}

@end
