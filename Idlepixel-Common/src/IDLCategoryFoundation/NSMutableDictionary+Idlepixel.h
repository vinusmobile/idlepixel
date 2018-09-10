//
//  NSMutableDictionary+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 31/08/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+Idlepixel.h"

@interface NSMutableDictionary (IDLPrimitives)

-(void)setObject:(id)anObject forIntegerKey:(NSInteger)aKey;
-(void)setObject:(id)anObject forUnsignedIntegerKey:(NSUInteger)aKey;
-(void)setObject:(id)anObject forFloatKey:(CGFloat)aKey;
-(void)setObject:(id)anObject forBooleanKey:(BOOL)aKey;

-(void)setObjectIfNotNil:(id)anObject forKey:(id<NSCopying>)key;

-(void)setBool:(BOOL)value forKey:(id)key;
-(void)setFloat:(CGFloat)value forKey:(id)key;
-(void)setInteger:(NSInteger)value forKey:(id)key;
-(void)setUnsignedInteger:(NSUInteger)value forKey:(id)key;
-(void)setInt:(int)value forKey:(id)key;
-(void)setUint:(unsigned int)value forKey:(id)key;

-(void)setRect:(CGRect)value forKey:(id)key;
-(void)setSize:(CGSize)value forKey:(id)key;
-(void)setPoint:(CGPoint)value forKey:(id)key;

-(void)removeObjectForIntegerKey:(NSInteger)aKey;
-(void)removeObjectForUnsignedIntegerKey:(NSUInteger)aKey;
-(void)removeObjectForFloatKey:(CGFloat)aKey;
-(void)removeObjectForBooleanKey:(BOOL)aKey;

@end

@interface NSMutableDictionary (IDLRemoveObjects)

-(void)removeKeysBelongingToClass:(Class)aClass;
-(void)removeKeysNotBelongingToClass:(Class)aClass;
-(void)removeObjectsBelongingToClass:(Class)aClass;
-(void)removeObjectsNotBelongingToClass:(Class)aClass;

-(void)removeObjectsAndKeysBelongingToClass:(Class)aClass;
-(void)removeObjectsAndKeysNotBelongingToClass:(Class)aClass;

@end
