//
//  NSSet+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 21/03/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "NSSet+Idlepixel.h"

@implementation NSSet (IDLRemoveObjects)

- (NSSet *)setByRemovingObject:(id)anObject
{
    NSSet *copy = [self copy];
    if (anObject != nil) {
        copy = [copy objectsPassingTest: ^BOOL(id obj,BOOL *stop){
            return (obj != anObject);
        }];
    }
    return copy;
}

- (NSSet *)setByRemovingObjectsFromArray:(NSArray *)anArray
{
    NSSet *copy = [self copy];
    if (anArray.count > 0) {
        copy = [copy objectsPassingTest: ^BOOL(id obj,BOOL *stop){
            return [anArray containsObject:obj];
        }];
    }
    return copy;
}

- (NSSet *)setByRemovingObjectsFromSet:(NSSet *)aSet
{
    NSSet *copy = [self copy];
    if (aSet.count > 0) {
        copy = [copy objectsPassingTest: ^BOOL(id obj,BOOL *stop){
            return [aSet containsObject:obj];
        }];
    }
    return copy;
}

- (NSSet *)setByRemovingObjectsNotInSet:(NSSet *)aSet
{
    NSSet *copy = [self copy];
    if (aSet.count > 0) {
        copy = [copy objectsPassingTest: ^BOOL(id obj,BOOL *stop){
            return ![aSet containsObject:obj];
        }];
    }
    return copy;
}

- (NSSet *)setByRemovingObjectsNotInArray:(NSArray *)anArray
{
    NSSet *copy = [self copy];
    if (anArray.count > 0) {
        copy = [copy objectsPassingTest: ^BOOL(id obj,BOOL *stop){
            return ![anArray containsObject:obj];
        }];
    }
    return copy;
}

- (NSSet *)setByRemovingObjectsBelongingToClass:(Class)aClass
{
    NSSet *copy = [self copy];
    if (aClass != nil) {
        copy = [copy objectsPassingTest: ^BOOL(id obj,BOOL *stop){
            return ![obj isKindOfClass:[aClass class]];
        }];
    }
    return copy;
}

- (NSSet *)setByRemovingObjectsNotBelongingToClass:(Class)aClass
{
    NSSet *copy = [self copy];
    if (aClass != nil) {
        copy = [copy objectsPassingTest: ^BOOL(id obj,BOOL *stop){
            return [obj isKindOfClass:[aClass class]];
        }];
    }
    return copy;
}

@end
