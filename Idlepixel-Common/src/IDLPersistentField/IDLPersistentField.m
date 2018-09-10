//
//  IDLPersistentField.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 23/07/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLPersistentField.h"
#import "IDLCategoryFoundationHeaders.h"

NSString * const kPropertyPersistentFieldFieldValue             = @"IDLPersistentField.fieldValue";
NSString * const kPropertyPersistentFieldSetterSelectorString   = @"IDLPersistentField.setterSelectorString";
NSString * const kPropertyPersistentFieldOwner                  = @"IDLPersistentField.owner";

@implementation IDLPersistentField

+ (NSSet *)dictionaryRepresentationKeys
{
    NSMutableSet *set = [NSMutableSet set];
    
    [set addObject:kPropertyPersistentFieldFieldValue];
    [set addObject:kPropertyPersistentFieldSetterSelectorString];
    [set addObject:kPropertyPersistentFieldOwner];
    
    return [NSSet setWithSet:set];
}

+(NSString *)stringFromSelector:(SEL)aSelector
{
    NSString *selector = nil;
    @try {
        selector = NSStringFromSelector(aSelector);
    } @catch (NSException *exception) {
        selector = nil;
    }
    return selector;
}

+(SEL)selectorFromString:(NSString *)aSelectorString
{
    SEL selector = nil;
    @try {
        selector = NSSelectorFromString(aSelectorString);
    } @catch (NSException *exception) {
        selector = nil;
    }
    return selector;
}

- (id)init
{
    if ((self = [super init]))
    {
        //
    }
    
    return self;
}

- (id) initWithCoder: (NSCoder*) aDecoder
{
    self = [super init];
    if (self) {
        self.fieldValue = [aDecoder decodeObjectOfClass:[NSString class] forKey: kPropertyPersistentFieldFieldValue];
        self.setterSelectorString = [aDecoder decodeObjectOfClass:[NSString class] forKey: kPropertyPersistentFieldSetterSelectorString];
        self.owner = [aDecoder decodeObjectOfClass:[NSString class] forKey: kPropertyPersistentFieldOwner];
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder*) aCoder
{
    [aCoder encodeObject: self.fieldValue forKey: kPropertyPersistentFieldFieldValue];
    [aCoder encodeObject: self.setterSelectorString forKey: kPropertyPersistentFieldSetterSelectorString];
    [aCoder encodeObject: self.owner forKey: kPropertyPersistentFieldOwner];
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
        self.fieldValue = [dictionary objectForKey:kPropertyPersistentFieldFieldValue];
        self.setterSelectorString = [dictionary objectForKey:kPropertyPersistentFieldSetterSelectorString];
        self.owner = [dictionary objectForKey:kPropertyPersistentFieldOwner];
    }
    
    return self;
}

- (NSDictionary *)dictionaryRepresentation:(BOOL)plistConformant
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObjectIfNotNil:self.fieldValue forKey:kPropertyPersistentFieldFieldValue];
    [dict setObjectIfNotNil:self.setterSelectorString forKey:kPropertyPersistentFieldSetterSelectorString];
    [dict setObjectIfNotNil:self.owner forKey:kPropertyPersistentFieldOwner];
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

-(SEL)setterSelector
{
    return [IDLPersistentField selectorFromString:self.setterSelectorString];
}

-(void)setSetterSelector:(SEL)setterSelector
{
    self.setterSelectorString = [IDLPersistentField stringFromSelector:setterSelector];
}

@end
