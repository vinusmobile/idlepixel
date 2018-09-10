//
//  NSDictionary+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 30/08/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLModelObjectProtocols.h"

@interface NSDictionary (IDLPrimitives)

- (id) objectForIntegerKey:(NSInteger)key;
- (id) objectForUnsignedIntegerKey:(NSUInteger)key;
- (id) objectForFloatKey:(CGFloat)key;
- (id) objectForBoolKey:(BOOL)key;

- (id) valueForCaseInsensitiveKey:(NSString *)key;

- (id) valueForKeyCollection:(id)keyCollection;
- (NSObject *) objectForKeyCollection:(id)keyCollection;

- (BOOL) boolForKey: (id) key;
- (CGFloat) floatForKey: (id) key;
- (int) intForKey: (id) key;
- (unsigned int) uintForKey: (id) key;
- (NSInteger) integerForKey: (id) key;
- (NSUInteger) unsignedIntegerForKey: (id) key;

- (CGRect) rectForKey: (id) key;
- (CGSize) sizeForKey: (id) key;
- (CGPoint) pointForKey: (id) key;

- (NSNumber *) numberForKey: (id) key;
- (NSData *) dataForKey: (id) key;
- (NSString *) stringForKey: (id) key;
- (NSString *) stringValueForKey: (id) key;
- (NSDate *) dateForKey: (id) key;
- (NSDictionary *) dictionaryForKey: (id) key;
- (NSArray *) arrayForKey: (id) key;

@end

@interface NSDictionary (IDLAnyObject)

- (id) anyObject;
- (id) anyKey;

@end

@interface NSDictionary (IDLAddObject)

- (NSDictionary *) dictionaryByAddingObject:(id)anObject forKey:(id <NSCopying>)aKey;

@end

@interface NSDictionary (IDLRemoveObjects)

- (NSDictionary *) dictionaryByRemovingKey:(id <NSCopying>)aKey;

- (NSDictionary *) dictionaryByRemovingKeysBelongingToClass:(Class)aClass;
- (NSDictionary *) dictionaryByRemovingKeysNotBelongingToClass:(Class)aClass;
- (NSDictionary *) dictionaryByRemovingObjectsBelongingToClass:(Class)aClass;
- (NSDictionary *) dictionaryByRemovingObjectsNotBelongingToClass:(Class)aClass;

- (NSDictionary *) dictionaryByRemovingObjectsAndKeysBelongingToClass:(Class)aClass;
- (NSDictionary *) dictionaryByRemovingObjectsAndKeysNotBelongingToClass:(Class)aClass;

- (NSDictionary *) dictionaryByRemovingKeysWithPrefix:(NSString *)prefix;
- (NSDictionary *) dictionaryByRemovingKeysWithoutPrefix:(NSString *)prefix;

@end

@interface NSDictionary (IDLMatchingKeys)

-(BOOL)containsAnyKeys:(NSArray *)keys;
-(BOOL)containsAllKeys:(NSArray *)keys;
-(BOOL)containsAllKeys:(NSArray *)keys exactMatch:(BOOL)exactMatch;

@end

@interface NSDictionary (IDLPersistent) <IDLPersistentModelObject>

@end
