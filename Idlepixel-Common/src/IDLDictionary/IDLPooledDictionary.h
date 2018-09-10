//
//  IDLPooledDictionary.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 21/01/2014.
//  Copyright (c) 2014 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLObjectProtocols.h"

@interface IDLPooledDictionary : NSObject <IDLConfigurable>

-(void)addObject:(NSObject *)anObject forKey:(NSObject<NSCopying> *)key;

-(void)removeKey:(NSObject<NSCopying> *)key;
-(void)removeObject:(NSObject *)anObject;
-(void)removeObject:(NSObject *)anObject forKey:(NSObject<NSCopying> *)key;

-(NSArray *)objectsForKey:(NSObject<NSCopying> *)key;
-(NSObject<NSCopying> *)anyKeyWithObject:(NSObject *)object;
-(NSArray *)keysWithObject:(NSObject *)object;

@end
