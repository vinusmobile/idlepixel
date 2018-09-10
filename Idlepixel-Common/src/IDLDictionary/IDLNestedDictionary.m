//
//  IDLNestedDictionary.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 1/10/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "IDLNestedDictionary.h"
#import "NSDictionary+Idlepixel.h"
#import "NSMutableDictionary+Idlepixel.h"
#import "NSArray+Idlepixel.h"

@interface IDLNestedDictionaryObject () <IDLPersistentModelObject, NSSecureCoding>

@property (nonatomic, strong) NSMutableDictionary *dictionary;
@property (nonatomic, strong) NSObject *object;
@property (readonly) NSArray *allValues;

@property (readonly) BOOL simple;

-(IDLNestedDictionaryObject *)nestedObjectLevelForKeys:(NSArray *)keyArray currentLevel:(NSUInteger)aLevel createIfNotFound:(BOOL)create;
-(IDLNestedDictionaryObject *)nestedObjectLevelForKeys:(NSArray *)keyArray currentLevel:(NSUInteger)aLevel createIfNotFound:(BOOL)create returnParent:(BOOL)returnParent;

@end

@implementation IDLNestedDictionaryObject

-(IDLNestedDictionaryObject *)nestedObjectLevelForKeys:(NSArray *)keyArray currentLevel:(NSUInteger)aLevel createIfNotFound:(BOOL)create
{
    return [self nestedObjectLevelForKeys:keyArray currentLevel:aLevel createIfNotFound:create returnParent:NO];
}

-(IDLNestedDictionaryObject *)nestedObjectLevelForKeys:(NSArray *)keyArray currentLevel:(NSUInteger)currentLevel createIfNotFound:(BOOL)create returnParent:(BOOL)returnParent
{
    if (keyArray != nil && [keyArray count] > currentLevel) {
        if (create) {
            @synchronized(self) {
                if (_dictionary == nil) self.dictionary = [NSMutableDictionary dictionary];
            }
        }
        NSObject *key = [keyArray objectAtIndex:currentLevel];
        IDLNestedDictionaryObject *dictionaryObject = (IDLNestedDictionaryObject *)[_dictionary objectForKey:key];
        if (create && dictionaryObject == nil) {
            dictionaryObject = [[IDLNestedDictionaryObject alloc] init];
            [_dictionary setObject:dictionaryObject forKey: (id<NSCopying>)key];
        }
        if ([keyArray count] == currentLevel+1) {
            if (returnParent) {
                return self;
            } else {
                return dictionaryObject;
            }
        } else {
            return [dictionaryObject nestedObjectLevelForKeys:keyArray currentLevel:(currentLevel+1) createIfNotFound:create returnParent:returnParent];
        }
    }
    return nil;
}

-(NSArray *)allValues
{
    NSArray *set = nil;
    if (self.object != nil) {
        set = [NSArray arrayWithObject:self.object];
    }
    if (self.dictionary.count > 0) {
        for (IDLNestedDictionaryObject *dictionaryObject in self.dictionary.allValues) {
            NSArray *subSet = dictionaryObject.allValues;
            if (subSet.count > 0) {
                if (set.count > 0) {
                    set = [set arrayByAddingObjectsFromArray:subSet];
                } else {
                    set = subSet;
                }
            }
        }
    }
    return set;
}

-(NSUInteger)count
{
    return self.allValues.count;
}

-(BOOL)simple
{
    if (_dictionary.count > 0) {
        return NO;
    } else if (_object == nil || [_object isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    return YES;
}

-(NSString *)description
{
    if ([_dictionary count] == 0) {
        return [_object description];
    } else if (_object == nil) {
        return [_dictionary description];
    } else {
        return [NSString stringWithFormat:@"object=%@, dict:%@",self.object, self.dictionary];
    }
}

#pragma mark - IDLPersistentModelObject

#define kIDLNestedDictionaryKeyDictionary       @"__children"
#define kIDLNestedDictionaryKeyObject           @"__value"
#define kIDLNestedDictionaryKeyArray            @[kIDLNestedDictionaryKeyDictionary, kIDLNestedDictionaryKeyObject]


+ (NSSet *)dictionaryRepresentationKeys
{
    return [NSSet setWithArray:kIDLNestedDictionaryKeyArray];
}

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
    self = [super init];
    if (self && dictionary) {
        
        BOOL loadFromChildDict = ([dictionary containsAnyKeys:kIDLNestedDictionaryKeyArray]);
        
        _object = [dictionary objectForKey:kIDLNestedDictionaryKeyObject];
        NSDictionary *subdictionary = nil;
        
        if (loadFromChildDict) {
            subdictionary = [dictionary dictionaryForKey:kIDLNestedDictionaryKeyDictionary];
        } else {
            subdictionary = dictionary;
        }
        
        _dictionary = [NSMutableDictionary dictionary];
        
        if (subdictionary != nil) {
            for (NSObject<NSCopying> *key in subdictionary.allKeys) {
                
                NSObject *value = [subdictionary objectForKey:key];
                
                IDLNestedDictionaryObject *dictionaryObject = nil;
                
                if ([value isKindOfClass:[NSDictionary class]]) {
                    dictionaryObject = [[IDLNestedDictionaryObject alloc] initWithDictionaryRepresentation:(NSDictionary *)value];
                } else {
                    dictionaryObject = [[IDLNestedDictionaryObject alloc] init];
                    dictionaryObject.object = value;
                }
                
                if (dictionaryObject != nil) {
                    [_dictionary setObject:dictionaryObject forKey:key];
                }
            }
        }
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    return [self dictionaryRepresentation:NO];
}

- (NSDictionary *)dictionaryRepresentation:(BOOL)plistConformant
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    BOOL saveToChildDict = (_object != nil || [_dictionary containsAnyKeys:kIDLNestedDictionaryKeyArray]);
    
    if (_object != nil) [dictionary setObject:_object forKey:kIDLNestedDictionaryKeyObject];
    
    if (_dictionary.count > 0) {
        NSMutableDictionary *subdictionary = nil;
        
        if (saveToChildDict) {
            subdictionary = [NSMutableDictionary dictionary];
        } else {
            subdictionary = dictionary;
        }
        
        NSArray *keys = _dictionary.allKeys;
        
        for (NSObject<NSCopying> *key in keys) {
            IDLNestedDictionaryObject *mkobject = [_dictionary objectForKey:key];
            
            if (mkobject.simple) {
                [subdictionary setObject:mkobject.object forKey:key];
            } else {
                [subdictionary setObject:[mkobject dictionaryRepresentation:plistConformant] forKey:key];
            }
        }
        
        if (saveToChildDict) {
            [dictionary setObject:subdictionary forKey:kIDLNestedDictionaryKeyDictionary];
        }
        
    }
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (NSDictionary *)plistRepresentation
{
    return [self dictionaryRepresentation:YES];
}

#pragma mark - NSCoding

- (id) initWithCoder: (NSCoder*) aDecoder
{
    self = [super init];
    if (self) {
        self.object = [aDecoder decodeObjectOfClass:[NSObject class] forKey:kIDLNestedDictionaryKeyObject];
        self.dictionary = [aDecoder decodeObjectOfClass:[NSMutableDictionary class] forKey:kIDLNestedDictionaryKeyDictionary];
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder*) aCoder
{
    [aCoder encodeObject:self.object forKey:kIDLNestedDictionaryKeyObject];
    [aCoder encodeObject:self.dictionary forKey:kIDLNestedDictionaryKeyDictionary];
}

+ (BOOL) supportsSecureCoding
{
    return YES;
}

@end

@implementation IDLNestedDictionary

+(IDLNestedDictionary *)dictionary
{
    return [[IDLNestedDictionary alloc] init];
}

-(void)setObject:(NSObject *)anObject forKeys:(NSArray *)keyArray
{
    if (anObject != nil) {
        IDLNestedDictionaryObject *dictionaryObject = [self nestedObjectLevelForKeys:keyArray currentLevel:0 createIfNotFound:YES];
        if (dictionaryObject != nil) {
            dictionaryObject.object = anObject;
        }
    }
}

-(NSObject *)objectForKeys:(NSArray *)keyArray
{
    IDLNestedDictionaryObject *dictionaryObject = [self nestedObjectLevelForKeys:keyArray currentLevel:0 createIfNotFound:NO];
    return dictionaryObject.object;
}

-(NSObject *)anyObjectForKeys:(NSArray *)keyArray
{
    NSObject *object = [self objectForKeys:keyArray];
    if (object == nil) {
        object = [self allObjectsForKeys:keyArray].firstObject;
    }
    return object;
}

-(NSArray *)allObjectsForKeys:(NSArray *)keyArray
{
    IDLNestedDictionaryObject *dictionaryObject = [self nestedObjectLevelForKeys:keyArray currentLevel:0 createIfNotFound:NO];
    NSArray *objects = nil;
    if (dictionaryObject != nil) {
        objects = dictionaryObject.allValues;
    }
    return objects;
}

-(BOOL)removeObjectForKeys:(NSArray *)keyArray;
{
    IDLNestedDictionaryObject *dictionaryObject = [self nestedObjectLevelForKeys:keyArray currentLevel:0 createIfNotFound:NO returnParent:YES];
    
    if (dictionaryObject != nil) {
        [dictionaryObject.dictionary removeObjectForKey:[keyArray lastObject]];
        return YES;
    } else {
        return NO;
    }
}

-(void)removeAllObjects
{
    [self.dictionary removeAllObjects];
}

-(NSArray *)allKeys
{
    return self.dictionary.allKeys;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"dict:%@", self.dictionary];
}

+ (BOOL) supportsSecureCoding
{
    return YES;
}

@end
