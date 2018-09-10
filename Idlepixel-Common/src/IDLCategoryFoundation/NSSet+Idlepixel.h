//
//  NSSet+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 21/03/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSet (IDLRemoveObjects)

- (NSSet *)setByRemovingObject:(id)anObject;
- (NSSet *)setByRemovingObjectsFromArray:(NSArray *)anArray;
- (NSSet *)setByRemovingObjectsFromSet:(NSSet *)aSet;

- (NSSet *)setByRemovingObjectsNotInSet:(NSSet *)aSet;
- (NSSet *)setByRemovingObjectsNotInArray:(NSArray *)anArray;

- (NSSet *)setByRemovingObjectsBelongingToClass:(Class)aClass;
- (NSSet *)setByRemovingObjectsNotBelongingToClass:(Class)aClass;

@end
