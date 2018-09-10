//
//  NSMutableArray+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 30/08/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "NSMutableArray+Idlepixel.h"

@implementation NSMutableArray (IDLUnique)

-(BOOL)addUniqueObject:(id)anObject
{
    if (anObject != nil) {
        NSArray *copy = [self copy];
        if (![copy containsObject:anObject]) {
            [self addObject:anObject];
            return YES;
        }
    }
    return NO;
}

-(BOOL)addUniqueObjectsFromArray:(NSArray *)otherArray
{
    BOOL added = NO;
    if (otherArray.count > 0) {
        otherArray = [NSArray arrayWithArray:otherArray];
        for (NSObject *anObject in otherArray) {
            added = added && [self addUniqueObject:anObject];
        }
    }
    return added;
}

-(BOOL)insertUniqueObject:(id)anObject atIndex:(NSUInteger)index
{
    if (anObject != nil && index <= self.count) {
        NSArray *copy = [self copy];
        if (![copy containsObject:anObject]) {
            [self insertObject:anObject atIndex:index];
            return YES;
        }
    }
    return NO;
}

-(void)removeDuplicateObjects
{
    if (self.count > 1) {
        @synchronized(self) {
            NSRange range;
            NSObject *object;
            for (NSInteger i = 0; i < self.count; i++) {
                object = [self objectAtIndex:i];
                range = NSMakeRange(i+1, (self.count - i));
                [self removeObjectIdenticalTo:object inRange:range];
            }
        }
    }
}

@end

@implementation NSMutableArray (IDLNotNil)

-(void)addObjectIfNotNil:(id)anObject
{
    if (anObject != nil) {
        [self addObject:anObject];
    }
}

@end

@implementation NSMutableArray (IDLRemoveObjects)

-(void)removeObjectsInSet:(NSSet *)aSet
{
    if (aSet.count > 0) {
        [self removeObjectsInArray:aSet.allObjects];
    }
}

-(void)removeObjectsNotInSet:(NSSet *)aSet
{
    if (aSet.count > 0) {
        [self removeObjectsNotInArray:aSet.allObjects];
    }
}

-(void)removeObjectsNotInArray:(NSArray *)anArray
{
    if (anArray.count > 0) {
        anArray = [NSArray arrayWithArray:anArray];
        for (NSObject *anObject in anArray) {
            if (![self containsObject:anObject]) {
                [self removeObject:anObject];
            }
        }
    }
}

-(void)removeObjectsBelongingToClass:(Class)aClass
{
    if (self.count > 0) {
        @synchronized(self) {
            NSArray *copy = [self copy];
            for (NSObject *object in copy) {
                if ([object isKindOfClass:aClass]) {
                    [self removeObjectAtIndex:object];
                }
            }
        }
    }
}

-(void)removeObjectsNotBelongingToClass:(Class)aClass
{
    if (self.count > 0) {
        @synchronized(self) {
            NSArray *copy = [self copy];
            for (NSObject *object in copy) {
                if (![object isKindOfClass:aClass]) {
                    [self removeObject:object];
                }
            }
        }
    }
}

@end

@implementation NSMutableArray (IDLOrder)

-(void)shuffle
{
    for (NSInteger x = 0; x < self.count; x++) {
        NSInteger randInt = (random() % (self.count - x)) + x;
        [self exchangeObjectAtIndex:x withObjectAtIndex:randInt];
    }
}

@end
