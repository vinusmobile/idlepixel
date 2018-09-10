//
//  IDLAbstractStore.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 22/03/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDLAbstractStore : NSObject

-(void)storeObject:(NSObject *)anObject withPrimaryIdentifier:(NSString *)primary;
-(void)storeObject:(NSObject *)anObject withPrimaryIdentifier:(NSString *)primary secondary:(NSString *)secondary;
-(void)storeObject:(NSObject *)anObject withPrimaryIdentifier:(NSString *)primary secondary:(NSString *)secondary tertiary:(NSString *)tertiary;

-(id)storedObjectWithPrimaryIdentifier:(NSString *)primary;
-(id)storedObjectWithPrimaryIdentifier:(NSString *)primary secondary:(NSString *)secondary;
-(id)storedObjectWithPrimaryIdentifier:(NSString *)primary secondary:(NSString *)secondary tertiary:(NSString *)tertiary;

-(void)clearStore;

-(NSArray *)storedObjects;

@end
