//
//  NSArray+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 30/08/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "NSArray+Idlepixel.h"
#import "NSMutableArray+Idlepixel.h"
#import "NSObject+Idlepixel.h"
#import "IDLNSInlineExtensions.h"

@implementation NSArray (IDLRemoveObjects)

- (NSArray *)arrayByRemovingObject:(id)anObject
{
    if (anObject != nil && [self containsObject:anObject]) {
        NSMutableArray *mutableSelf = [self mutableCopy];
        [mutableSelf removeObject:anObject];
        return [NSArray arrayWithArray:mutableSelf];
    } else {
        return [NSArray arrayWithArray:self];
    }
}

- (NSArray *)arrayByRemovingObjectsInArray:(NSArray *)anArray
{
    NSArray *returnArray = self;
    if (anArray.count > 0) {
        NSMutableArray *mutableSelf = [self mutableCopy];
        [mutableSelf removeObjectsInArray:anArray];
        returnArray = mutableSelf;
    }
    return [NSArray arrayWithArray:returnArray];
}

- (NSArray *)arrayByRemovingObjectsInSet:(NSSet *)aSet
{
    if (aSet.count > 0) {
        return [self arrayByRemovingObjectsInArray:aSet.allObjects];
    } else {
        return [NSArray arrayWithArray:self];
    }
}

- (NSArray *)arrayByRemovingObjectsNotInArray:(NSArray *)anArray
{
    NSArray *returnArray = self;
    if (anArray.count > 0) {
        NSMutableArray *mutableSelf = [self mutableCopy];
        [mutableSelf removeObjectsNotInArray:anArray];
        returnArray = mutableSelf;
    }
    return [NSArray arrayWithArray:returnArray];
}

- (NSArray *)arrayByRemovingObjectsNotInSet:(NSSet *)aSet
{
    if (aSet.count > 0) {
        return [self arrayByRemovingObjectsNotInArray:aSet.allObjects];
    } else {
        return [NSArray arrayWithArray:self];
    }
}

- (NSArray *)arrayByRemovingObjectsBelongingToClass:(Class)aClass
{
    NSArray *returnArray = self;
    if (self.count > 0) {
        NSMutableArray *mutableSelf = [self mutableCopy];
        [mutableSelf removeObjectsBelongingToClass:aClass];
        returnArray = mutableSelf;
    }
    return [NSArray arrayWithArray:returnArray];
}

- (NSArray *)arrayByRemovingObjectsNotBelongingToClass:(Class)aClass
{
    NSArray *returnArray = self;
    if (self.count > 0) {
        NSMutableArray *mutableSelf = [self mutableCopy];
        [mutableSelf removeObjectsNotBelongingToClass:aClass];
        returnArray = mutableSelf;
    }
    return [NSArray arrayWithArray:returnArray];
}

- (NSArray *)arrayByRemovingFirstObject
{
    if (self.count > 1) {
        return [self subarrayWithRange:NSMakeRange(1, [self count]-1)];
    } else {
        return [NSArray array];
    }
}

- (NSArray *)arrayByRemovingLastObject
{
    if (self.count > 1) {
        return [self subarrayWithRange:NSMakeRange(0, [self count]-1)];
    } else {
        return [NSArray array];
    }
}

@end

@implementation NSArray (IDLUnique)

-(NSArray *)arrayByRemoveDuplicateObjects
{
    NSArray *returnArray = self;
    if (self.count > 1) {
        NSMutableArray *mutableSelf = [self mutableCopy];
        [mutableSelf removeDuplicateObjects];
        returnArray = mutableSelf;
    }
    return [NSArray arrayWithArray:returnArray];
}

-(NSArray *)arrayByAddingUniqueObject:(id)anObject
{
    if ([self containsObject:anObject] || anObject == nil) {
        return self;
    } else {
        return [self arrayByAddingObject:anObject];
    }
}

-(NSArray *)arrayByAddingUniqueObjects:(NSArray *)objects
{
    if (objects.count > 0) {
        NSMutableArray *copy = [self mutableCopy];
        [copy addUniqueObjectsFromArray:objects];
        return [NSArray arrayWithArray:copy];
    } else {
        return self;
    }
}

@end

@implementation NSArray (IDLContains)

-(id)firstObjectWithKindOfClass:(Class)aClass
{
    NSInteger index = [self indexOfObjectWithKindOfClass:[aClass class]];
    return [self objectAtIndexOrNil:index];
}

-(id)firstObjectWithMemberOfClass:(Class)aClass
{
    NSInteger index = [self indexOfObjectWithMemberOfClass:[aClass class]];
    return [self objectAtIndexOrNil:index];
}

-(NSInteger)indexOfObjectWithKindOfClass:(Class)aClass
{
    return [self indexOfObjectWithClass:[aClass class] allowSubclasses:YES];
}

-(NSInteger)indexOfObjectWithMemberOfClass:(Class)aClass
{
    return [self indexOfObjectWithClass:[aClass class] allowSubclasses:NO];
}

-(NSInteger)indexOfObjectWithClass:(Class)aClass allowSubclasses:(BOOL)allowSubclasses
{
    if (aClass != nil) {
        NSArray *array = [self copy];
        for (NSInteger i = 0; i < array.count; i++) {
            NSObject *object = [array objectAtIndex:i];
            if ((allowSubclasses && [object respondsToSelector:@selector(isKindOfClass:)] && [object isKindOfClass:aClass]) ||
                (!allowSubclasses && [object respondsToSelector:@selector(isMemberOfClass:)] && [object isMemberOfClass:aClass])) {
                return i;
            }
        }
    }
    return NSNotFound;
}

-(BOOL)containsKindOfClass:(Class)aClass
{
    return ([self indexOfObjectWithKindOfClass:aClass] != NSNotFound);
}

-(BOOL)containsMemberOfClass:(Class)aClass
{
    return ([self indexOfObjectWithMemberOfClass:aClass] != NSNotFound);
}

@end

@implementation NSArray (IDLNonNil)

+ (NSArray *)arrayWithNonNilObjects:(NSUInteger)count, ...
{
    NSMutableArray *nonNils = [NSMutableArray array];
    va_list args;
    va_start(args, count);
    
    for (NSUInteger i = 0; i < count; i++) {
        NSObject *arg = va_arg(args, NSObject*);
        if (arg != nil) {
            //IDLLogContext(@"adding[%i]: %@",i,arg);
            [nonNils addObject:arg];
        }
    }
    va_end(args);
    //IDLLogObject(nonNils);
    return [NSArray arrayWithArray:nonNils];
}

+ (NSArray *)arrayWithObjectsFromNonNilArrays:(NSUInteger)count, ...
{
    NSMutableArray *nonNils = [NSMutableArray array];
    va_list args;
    va_start(args, count);
    
    for (NSUInteger i = 0; i < count; i++) {
        NSObject *arg = va_arg(args, NSObject*);
        if (arg != nil) {
            if ([arg isKindOfClass:[NSArray class]] && [(NSArray *)arg count] > 0) {
                //IDLLogContext(@"adding[%i]: %@",i,arg);
                [nonNils addObjectsFromArray:(NSArray *)arg];
            }
        }
    }
    va_end(args);
    //IDLLogObject(nonNils);
    return [NSArray arrayWithArray:nonNils];
}

@end

@implementation NSArray (IDLOrder)

- (NSArray*) arrayByReversing
{
    if (self.count > 1) {
        return [[self reverseObjectEnumerator] allObjects];
    } else {
        return [NSArray arrayWithArray:self];
    }
}

- (NSArray*) reversedArray
{
    return self.arrayByReversing;
}

- (NSArray*) arrayByShuffling
{
    if (self.count > 1) {
        NSMutableArray *a = [self mutableCopy];
        [a shuffle];
        return [NSArray arrayWithArray:a];
    } else {
        return [NSArray arrayWithArray:self];
    }
}

- (NSArray *)arrayBySwappingSubarraysSplitAtIndex:(NSUInteger)index
{
    if (index >= self.count || index == 0) {
        return [NSArray arrayWithArray:self];
    } else {
        NSArray *array = [[self subarrayFromIndex:index] arrayByAddingObjectsFromArray:[self subarrayToIndex:index]];
        return array;
    }
}

@end

@implementation NSArray (IDLObject)

- (id)firstObject
{
    if (self.count > 0) {
        return [self objectAtIndex:0];
    } else {
        return nil;
    }
}

- (id)randomObject
{
    if (self.count > 0) {
        return [self objectAtIndex:(rand() % self.count)];
    } else {
        return nil;
    }
}

- (id)objectAtIndexOrNil:(NSUInteger)index
{
    if (index < self.count) {
        return [self objectAtIndex:index];
    } else {
        return nil;
    }
}

@end

@implementation NSArray (IDLBounds)

- (BOOL)indexWithinBounds:(NSInteger)anIndex
{
    return (anIndex >= 0 && anIndex < self.count);
}

@end

@implementation NSArray (IDLIntegers)

- (NSArray *)integerValues
{
    if (self.count > 0) {
        NSMutableArray *integers = [NSMutableArray array];
        NSArray *objects = self.copy;
        for (NSObject *object in objects) {
            if ([object respondsToSelector:@selector(integerValue)]) {
                [integers addObject:@([(NSNumber *)object integerValue])];
            }
        }
        return [NSArray arrayWithArray:integers];
    }
    return @[];
}

@end

@implementation NSArray (IDLSubarray)

- (NSArray *)subarrayFromIndex:(NSUInteger)index
{
    if (index >= self.count) {
        return [NSArray array];
    } else {
        return [self subarrayWithRange:NSMakeRange(index, self.count-index)];
    }
}

- (NSArray *)subarrayToIndex:(NSUInteger)index
{
    if (index > self.count) {
        return [self copy];
    } else {
        return [self subarrayWithRange:NSMakeRange(0, index)];
    }
}

- (NSArray *)subarrayWithLastComponents:(NSUInteger)count
{
    if (self.count < count) count = self.count;
    return [self subarrayFromIndex:self.count-count];
}

- (NSArray *)subarrayWithFirstComponents:(NSUInteger)count
{
    if (self.count < count) count = self.count;
    return [self subarrayToIndex:count];
}

@end

@interface IDLInternalArray : NSArray

@end

@implementation IDLInternalArray

@end

@implementation NSArray (IDLSequences)

#define kNSArraySequenceStringTag  @"NSArraySequenceStringDerivedFromArrayOfArrays"

+ (NSArray *)sequencesDerivedFromArrayOfArrays:(NSArray *)arrayOfArrays
{
    if (arrayOfArrays.count > 2) {
        NSArray *endSequence = [arrayOfArrays subarrayFromIndex:1];
        endSequence = [self sequencesDerivedFromArrayOfArrays:endSequence];
        return [self sequencesDerivedFromArrayOfArrays:@[arrayOfArrays[0], endSequence]];
    } else if (arrayOfArrays.count == 1) {
        return [NSArray arrayWithArray:arrayOfArrays];
    } else if (arrayOfArrays.count == 2) {
        NSArray *firstArray = arrayOfArrays[0];
        NSArray *secondArray = arrayOfArrays[1];
        
        if (![firstArray isKindOfClass:[NSArray class]]) firstArray = @[firstArray];
        if (![secondArray isKindOfClass:[NSArray class]]) secondArray = @[secondArray];
        
        if (firstArray.count == 0) {
            return [NSArray arrayWithArray:secondArray];
        } else if (secondArray.count == 0) {
            return [NSArray arrayWithArray:firstArray];
        } else {
            NSMutableArray *sequences = [NSMutableArray array];
            NSArray *sequence = nil;
            for (int f = 0; f < firstArray.count; f++) {
                for (int s = 0; s < secondArray.count; s++) {
                    if ([secondArray[s] isKindOfClass:[NSArray class]] && NSStringEquals(kNSArraySequenceStringTag, [(NSArray *)secondArray[s] stringTag])) {
                        sequence = [@[firstArray[f]] arrayByAddingObjectsFromArray:secondArray[s]];
                    } else {
                        sequence = @[firstArray[f], secondArray[s]];
                    }
                    sequence.stringTag = kNSArraySequenceStringTag;
                    [sequences addObject:sequence];
                }
            }
            return [NSArray arrayWithArray:sequences];
        }
    } else {
        return [NSArray array];
    }
}

@end
