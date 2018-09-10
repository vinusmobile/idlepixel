//
//  IDLIdentifierSet.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 27/02/2014.
//  Copyright (c) 2014 Trystan Pfluger. All rights reserved.
//

#import "IDLIdentifierSet.h"
#import "IDLNSInlineExtensions.h"

@interface IDLIdentifierSet ()

@property (nonatomic, strong) NSMutableSet *set;

@end

@implementation IDLIdentifierSet

+(instancetype)setWithIdentifiers:(NSSet *)identifiers
{
    IDLIdentifierSet *set = [[[self class] alloc] initWithIdentifiers:identifiers];
    return set;
}

-(id)initWithIdentifiers:(NSSet *)identifiers
{
    self = [super init];
    if (self) {
        self.identifiers = identifiers;
    }
    return self;
}

-(BOOL)containsIdentifier:(NSString *)identifier
{
    return [self containsIdentifier:identifier prefix:nil];
}

-(BOOL)containsIdentifier:(NSString *)identifier prefix:(NSString *)prefix
{
    identifier = IDLIdentifierWithPrefix(identifier, prefix);
    BOOL found = NO;
    if (identifier != nil) {
        NSSet *set = [self.set copy];
        for (NSString *existing in set) {
            if (NSStringEquals(existing, identifier)) {
                found = YES;
                break;
            }
        }
    }
    return found;
}

-(void)addIdentifier:(NSString *)identifier
{
    [self addIdentifier:identifier prefix:nil];
}

-(void)addIdentifier:(NSString *)identifier prefix:(NSString *)prefix
{
    identifier = IDLIdentifierWithPrefix(identifier, prefix);
    if (identifier != nil) {
        NSMutableSet *set = self.set;
        if (set) {
            @synchronized(set) {
                [set addObject:identifier];
            }
        } else {
            self.set = [NSMutableSet setWithObject:identifier];
        }
    }
}

-(void)addIdentifiers:(NSSet *)identifiers
{
    [self addIdentifiers:identifiers prefix:nil];
}

-(void)addIdentifiers:(NSSet *)identifiers prefix:(NSString *)prefix
{
    if (identifiers.count > 0) {
        identifiers = [identifiers copy];
        for (NSString *identifier in identifiers) {
            [self addIdentifier:CLASS_OR_NIL(identifier, NSString) prefix:prefix];
        }
    }
}

-(void)removeIdentifier:(NSString *)identifier
{
    [self removeIdentifier:identifier prefix:nil];
}

-(void)removeIdentifier:(NSString *)identifier prefix:(NSString *)prefix
{
    identifier = IDLIdentifierWithPrefix(identifier, prefix);
    if (identifier != nil) {
        NSMutableSet *set = self.set;
        if (set) {
            @synchronized(set) {
                NSSet *copy = [set copy];
                for (NSString *existing in copy) {
                    if (NSStringEquals(existing, identifier)) {
                        [set removeObject:existing];
                    }
                }
            }
        }
    }
}

-(void)removeIdentifiers:(NSSet *)identifiers
{
    [self removeIdentifiers:identifiers prefix:nil];
}

-(void)removeIdentifiers:(NSSet *)identifiers prefix:(NSString *)prefix
{
    if (identifiers.count > 0) {
        identifiers = [identifiers copy];
        for (NSString *identifier in identifiers) {
            [self removeIdentifier:CLASS_OR_NIL(identifier, NSString) prefix:prefix];
        }
    }
}

-(BOOL)removeIdentifiersNotInSet:(NSSet *)validIdentifiers
{
    BOOL found = NO;
    if (validIdentifiers.count > 0) {
        validIdentifiers = [validIdentifiers copy];
        NSSet *existingIdentifiers = self.identifiers;
        for (NSString *existingIdentifier in existingIdentifiers) {
            if (![validIdentifiers containsObject:existingIdentifier]) {
                [self removeIdentifier:existingIdentifier];
                found = YES;
            }
        }
    }
    return found;
}

-(BOOL)toggleIdentifier:(NSString *)identifier
{
    return [self toggleIdentifier:identifier prefix:nil];
}

-(BOOL)toggleIdentifier:(NSString *)identifier prefix:(NSString *)prefix
{
    BOOL found = NO;
    identifier = IDLIdentifierWithPrefix(identifier, prefix);
    if (identifier != nil) {
        found = [self containsIdentifier:identifier];
        if (found) {
            [self removeIdentifier:identifier];
        } else {
            [self addIdentifier:identifier];
        }
        found = !found;
    }
    return found;
}

-(void)toggleIdentifiers:(NSSet *)identifiers
{
    [self toggleIdentifiers:identifiers prefix:nil];
}

-(void)toggleIdentifiers:(NSSet *)identifiers prefix:(NSString *)prefix
{
    if (identifiers.count > 0) {
        identifiers = [identifiers copy];
        for (NSString *identifier in identifiers) {
            [self toggleIdentifier:CLASS_OR_NIL(identifier, NSString) prefix:prefix];
        }
    }
}

-(NSUInteger)count
{
    return self.set.count;
}

-(void)setIdentifiers:(NSSet *)identifiers
{
    identifiers = CLASS_OR_NIL(identifiers, NSSet);
    if (identifiers.count > 0) {
        self.set = [NSMutableSet setWithSet:identifiers];
    } else {
        self.set = nil;
    }
}

-(NSSet *)identifiers
{
    if (self.set) {
        return [NSSet setWithSet:self.set];
    } else {
        return [NSSet set];
    }
}

@end
