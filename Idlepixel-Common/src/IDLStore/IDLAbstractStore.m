//
//  IDLAbstractStore.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 22/03/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLAbstractStore.h"
#import "NSObject+Idlepixel.h"
#import "IDLNestedDictionary.h"

NS_INLINE NSArray *KeyFromIdentifiers(NSString *primary, NSString *secondary, NSString *tertiary)
{
    if (primary == nil) {
        primary = (NSString *)[NSNull null];
    }
    
    if (secondary == nil && tertiary != nil) {
        secondary = (NSString *)[NSNull null];
    }
    
    if (secondary == nil && tertiary == nil) {
        return @[primary];
    } else if (tertiary == nil) {
        return @[primary, secondary];
    } else {
        return @[primary, secondary, tertiary];
    }
}

@interface IDLAbstractStore ()

@property (nonatomic, strong) IDLNestedDictionary *store;

@end

@implementation IDLAbstractStore

-(void)storeObject:(NSObject *)anObject withPrimaryIdentifier:(NSString *)primary
{
    [self storeObject:anObject withPrimaryIdentifier:primary secondary:nil];
}

-(void)storeObject:(NSObject *)anObject withPrimaryIdentifier:(NSString *)primary secondary:(NSString *)secondary
{
    [self storeObject:anObject withPrimaryIdentifier:primary secondary:secondary tertiary:nil];
}

-(void)storeObject:(NSObject *)anObject withPrimaryIdentifier:(NSString *)primary secondary:(NSString *)secondary tertiary:(NSString *)tertiary
{
    if (anObject != nil  && primary != nil) {
        if (self.store == nil) self.store = [IDLNestedDictionary dictionary];
        
        [self.store setObject:anObject forKeys:KeyFromIdentifiers(primary, secondary, tertiary)];
    }
}

-(id)storedObjectWithPrimaryIdentifier:(NSString *)primary
{
    return [self storedObjectWithPrimaryIdentifier:primary secondary:nil];
}

-(id)storedObjectWithPrimaryIdentifier:(NSString *)primary secondary:(NSString *)secondary
{
    return [self storedObjectWithPrimaryIdentifier:primary secondary:secondary tertiary:nil];
}

-(id)storedObjectWithPrimaryIdentifier:(NSString *)primary secondary:(NSString *)secondary tertiary:(NSString *)tertiary
{
    return [self.store anyObjectForKeys:KeyFromIdentifiers(primary, secondary, tertiary)];
}

-(void)clearStore
{
    [self.store removeAllObjects];
}

-(NSArray *)storedObjects
{
    if (self.store == nil) {
        return [NSArray array];
    } else {
        return [self.store allValues];
    }
}

@end
