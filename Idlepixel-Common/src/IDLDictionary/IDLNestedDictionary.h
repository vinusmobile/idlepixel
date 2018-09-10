//
//  IDLNestedDictionary.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 1/10/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLModelObjectProtocols.h"

NS_INLINE NSObject* KeyFromObject(NSObject* object)
{
    if (object == nil) {
        return [NSNull null];
    } else {
        return object;
    }
}

NS_INLINE NSObject* KeyFromClass(Class aClass)
{
    return NSStringFromClass(aClass);
}

@interface IDLNestedDictionaryObject : NSObject

@property (readonly) NSUInteger count;

@end

@interface IDLNestedDictionary : IDLNestedDictionaryObject <IDLPersistentModelObject, NSSecureCoding>

+(IDLNestedDictionary *)dictionary;

-(void)setObject:(NSObject *)anObject forKeys:(NSArray *)keyArray;

-(NSObject *)objectForKeys:(NSArray *)keyArray;
-(NSObject *)anyObjectForKeys:(NSArray *)keyArray;

-(NSArray *)allObjectsForKeys:(NSArray *)keyArray;

-(BOOL)removeObjectForKeys:(NSArray *)keyArray;
-(void)removeAllObjects;

@property (nonatomic, readonly) NSArray *allValues;
@property (nonatomic, readonly) NSArray *allKeys;

@end
