//
//  IDLPersistentFieldStore.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 23/07/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLPersistentFieldStore.h"
#import "IDLNestedDictionary.h"

#import "IDLCategoryFoundationHeaders.h"

NSString * const kPropertyPersistentFieldStoreFields = @"IDLPersistentFieldStore.fields";

NS_INLINE NSArray* KeyArrayForOwnerSetter(NSString* owner, NSString *setterSelectorString)
{
    return @[KeyFromObject(owner),KeyFromObject(setterSelectorString)];
}

NS_INLINE NSArray* KeyArrayFromPersistentField(IDLPersistentField* field)
{
    if (field == nil) {
        return nil;
    } else {
        return KeyArrayForOwnerSetter(field.owner, field.setterSelectorString);
    }
}

@interface IDLPersistentFieldStore ()

@property (nonatomic, strong) IDLNestedDictionary *fields;

@end

@implementation IDLPersistentFieldStore

+ (NSSet *)dictionaryRepresentationKeys
{
    return [NSSet setWithObject:kPropertyPersistentFieldStoreFields];
}

#pragma mark NSCoding

- (id) initWithCoder: (NSCoder*) aDecoder
{
    self = [super init];
    if (self) {
        self.fields = [aDecoder decodeObjectOfClass:[IDLNestedDictionary class] forKey: kPropertyPersistentFieldStoreFields];
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder*) aCoder
{
    [aCoder encodeObject: self.fields forKey: kPropertyPersistentFieldStoreFields];
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

#pragma mark Dictionary representation

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        NSArray *fieldDictionaries = [dictionary arrayForKey:kPropertyPersistentFieldStoreFields];
        IDLPersistentField *field = nil;
        for (NSDictionary *fd in fieldDictionaries) {
            if ([fd isKindOfClass:[NSDictionary class]]) {
                field = [[IDLPersistentField alloc] initWithDictionaryRepresentation:fd];
                if (field) {
                    [self addField:field];
                }
            }
        }
    }
    
    return self;
}

- (NSDictionary *)dictionaryRepresentation:(BOOL)plistConformant
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (_fields != nil) {
        NSArray *allFields = self.fields.allValues;
        
        NSMutableArray *fieldDictionaries = [NSMutableArray arrayWithCapacity:allFields];
        
        for (IDLPersistentField *field in allFields) {
            [fieldDictionaries addObject:field.dictionaryRepresentation];
        }
        [dict setObjectIfNotNil:fieldDictionaries forKey:kPropertyPersistentFieldStoreFields];
    }
    return [NSDictionary dictionaryWithDictionary:dict];
}

- (NSDictionary *)dictionaryRepresentation
{
    return [self dictionaryRepresentation:NO];
}

- (NSDictionary *)plistRepresentation
{
    return [self dictionaryRepresentation:YES];
}

#pragma mark Convenience

- (IDLNestedDictionary *)fields
{
    if (_fields == nil) {
        _fields = [IDLNestedDictionary dictionary];
    }
    return _fields;
}

- (NSArray *)fieldsForOwner:(NSString *)owner
{
    if (_fields != nil) {
        return [self.fields allObjectsForKeys:@[KeyFromObject(owner)]];
    } else {
        return nil;
    }
}

- (IDLPersistentField *)fieldForOwner:(NSString *)owner setterSelector:(SEL)setterSelector
{
    if (_fields != nil) {
        return (IDLPersistentField *)[self.fields objectForKeys:KeyArrayForOwnerSetter(owner, [IDLPersistentField stringFromSelector:setterSelector])];
    } else {
        return nil;
    }
}

- (void)addField:(IDLPersistentField *)field
{
    if (CLASS_OR_NIL(field, IDLPersistentField)) {
        [self.fields setObject:field forKeys:KeyArrayFromPersistentField(field)];
    }
}

- (void)addFields:(NSSet *)fields
{
    for (IDLPersistentField *field in fields) {
        [self addField:field];
    }
}

- (void)removeField:(IDLPersistentField *)field
{
    if (CLASS_OR_NIL(field, IDLPersistentField) && _fields != nil) {
        [self.fields removeObjectForKeys:KeyArrayFromPersistentField(field)];
    }
}

- (void)removeFields:(NSSet *)fields
{
    for (IDLPersistentField *field in fields) {
        [self removeField:field];
    }
}

- (void)removeAllFields
{
    [self.fields removeAllObjects];
}

- (NSUInteger)count
{
    return self.fields.count;
}

@end
