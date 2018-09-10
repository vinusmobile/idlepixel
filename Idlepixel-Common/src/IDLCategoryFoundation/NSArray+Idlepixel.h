//
//  NSArray+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 30/08/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (IDLRemoveObjects)

- (NSArray *)arrayByRemovingObject:(id)anObject;
- (NSArray *)arrayByRemovingObjectsInArray:(NSArray *)anArray;
- (NSArray *)arrayByRemovingObjectsInSet:(NSSet *)aSet;

- (NSArray *)arrayByRemovingObjectsNotInSet:(NSSet *)aSet;
- (NSArray *)arrayByRemovingObjectsNotInArray:(NSArray *)anArray;

- (NSArray *)arrayByRemovingObjectsBelongingToClass:(Class)aClass;
- (NSArray *)arrayByRemovingObjectsNotBelongingToClass:(Class)aClass;

- (NSArray *)arrayByRemovingFirstObject;
- (NSArray *)arrayByRemovingLastObject;

@end

@interface NSArray (IDLUnique)

-(NSArray *)arrayByRemoveDuplicateObjects;
-(NSArray *)arrayByAddingUniqueObject:(id)anObject;
-(NSArray *)arrayByAddingUniqueObjects:(NSArray *)objects;

@end

@interface NSArray (IDLContains)

-(id)firstObjectWithKindOfClass:(Class)aClass;
-(id)firstObjectWithMemberOfClass:(Class)aClass;

-(NSInteger)indexOfObjectWithKindOfClass:(Class)aClass;
-(NSInteger)indexOfObjectWithMemberOfClass:(Class)aClass;
-(NSInteger)indexOfObjectWithClass:(Class)aClass allowSubclasses:(BOOL)allowSubclasses;

-(BOOL)containsKindOfClass:(Class)aClass;
-(BOOL)containsMemberOfClass:(Class)aClass;

@end

@interface NSArray (IDLNonNil)

+ (NSArray *)arrayWithNonNilObjects:(NSUInteger)count, ...;

#define NSArrayNonNil(count, ...) [NSArray arrayWithNonNilObjects:count, ##__VA_ARGS__]

+ (NSArray *)arrayWithObjectsFromNonNilArrays:(NSUInteger)count, ...;

#define NSArrayFromNonNilArrays(count, ...) [NSArray arrayWithObjectsFromNonNilArrays:count, ##__VA_ARGS__]

@end

@interface NSArray (IDLOrder)

- (NSArray *)reversedArray;
- (NSArray *)arrayByReversing;
- (NSArray *)arrayByShuffling;

- (NSArray *)arrayBySwappingSubarraysSplitAtIndex:(NSUInteger)index;

@end

@interface NSArray (IDLObject)

- (id)firstObject;
- (id)randomObject;
- (id)objectAtIndexOrNil:(NSUInteger)index;

@end

@interface NSArray (IDLBounds)

- (BOOL)indexWithinBounds:(NSInteger)anIndex;

@end

@interface NSArray (IDLIntegers)

- (NSArray *)integerValues;

@end

@interface NSArray (IDLSubarray)

- (NSArray *)subarrayFromIndex:(NSUInteger)index;
- (NSArray *)subarrayToIndex:(NSUInteger)index;

- (NSArray *)subarrayWithLastComponents:(NSUInteger)count;
- (NSArray *)subarrayWithFirstComponents:(NSUInteger)count;

@end

@interface NSArray (IDLSequences)

+ (NSArray *)sequencesDerivedFromArrayOfArrays:(NSArray *)arrayOfArrays;

@end