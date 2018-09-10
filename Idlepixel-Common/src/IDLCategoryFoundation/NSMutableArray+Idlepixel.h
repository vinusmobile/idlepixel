//
//  NSMutableArray+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 30/08/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (IDLUnique)

-(BOOL)addUniqueObject:(id)anObject;
-(BOOL)addUniqueObjectsFromArray:(NSArray *)otherArray;

-(BOOL)insertUniqueObject:(id)anObject atIndex:(NSUInteger)index;

-(void)removeDuplicateObjects;

@end

@interface NSMutableArray (IDLNotNil)

-(void)addObjectIfNotNil:(id)anObject;

@end

@interface NSMutableArray (IDLRemoveObjects)

-(void)removeObjectsInSet:(NSSet *)aSet;
-(void)removeObjectsNotInSet:(NSSet *)aSet;
-(void)removeObjectsNotInArray:(NSArray *)anArray;

-(void)removeObjectsBelongingToClass:(Class)aClass;
-(void)removeObjectsNotBelongingToClass:(Class)aClass;

@end

@interface NSMutableArray (IDLOrder)

-(void)shuffle;

@end
