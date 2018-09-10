//
//  IDLSkinDefinitionStore.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 23/07/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLSkinDefinitionStore.h"

#import "IDLMacroHeaders.h"
#import "IDLCategoryFoundationHeaders.h"
#import "IDLNSInlineExtensions.h"

@interface IDLSkinDefinitionStore ()

@property (nonatomic, strong) NSMutableArray *definitionArray;
@property (nonatomic, strong) IDLSkinDefinition *cachedCurrentDefinition;

@end

@implementation IDLSkinDefinitionStore

+(instancetype)sharedStore
{
    return [self preferredSingleton];
}

-(void)configure
{
    [super configure];
    
    self.definitionArray = [NSMutableArray array];
}

-(void)setCurrentDefinitionIdentifier:(NSString *)currentDefinitionIdentifier
{
    if (!NSStringEquals(_currentDefinitionIdentifier, currentDefinitionIdentifier)) {
        _currentDefinitionIdentifier = currentDefinitionIdentifier;
        [self clearCache];
    }
}

-(void)setDefaultDefinitionIdentifier:(NSString *)defaultDefinitionIdentifier
{
    if (!NSStringEquals(_defaultDefinitionIdentifier, defaultDefinitionIdentifier)) {
        _defaultDefinitionIdentifier = defaultDefinitionIdentifier;
        [self clearCache];
    }
}

-(void)clearCache
{
    self.cachedCurrentDefinition = nil;
}

-(void)addDefinition:(IDLSkinDefinition *)definition
{
    [self addDefinition:definition isDefault:NO isCurrent:NO];
}

-(void)addDefinition:(IDLSkinDefinition *)definition isDefault:(BOOL)isDefault isCurrent:(BOOL)isCurrent
{
    if (definition != nil) {
        [self.definitionArray addUniqueObject:definition];
    }
    if (isDefault) {
        self.defaultDefinitionIdentifier = definition.uid;
    }
    if (isCurrent) {
        self.currentDefinitionIdentifier = definition.uid;
    }
}

-(void)removeDefinitionWithIdentifier:(NSString *)identifier
{
    NSArray *definitions = [self.definitionArray copy];
    for (IDLSkinDefinition *definition in definitions) {
        if (NSStringEquals(identifier, definition.uid)) {
            [self.definitionArray removeObject:definition];
        }
    }
    if (NSStringEquals(self.currentDefinitionIdentifier, identifier)) {
        self.currentDefinitionIdentifier = nil;
    }
}

-(void)removeAllDefinitions
{
    self.definitionArray = [NSMutableArray array];
    self.cachedCurrentDefinition = nil;
    self.currentDefinitionIdentifier = nil;
    self.defaultDefinitionIdentifier = nil;
}

-(NSArray *)definitions
{
    if (self.definitionArray.count > 0) {
        return [NSArray arrayWithArray:self.definitionArray];
    } else {
        return @[];
    }
}

-(IDLSkinDefinition *)definitionWithIdentifier:(NSString *)identifier
{
    IDLSkinDefinition *definition = self.cachedCurrentDefinition;
    if (definition != nil && NSStringEquals(identifier, definition.uid)) {
        return definition;
    } else {
        NSArray *definitions = [self.definitionArray copy];
        for (definition in definitions) {
            if (NSStringEquals(identifier, definition.uid)) {
                return definition;
            }
        }
    }
    return nil;
}

-(IDLSkinDefinition *)currentDefinition
{
    IDLSkinDefinition *definition = [self definitionWithIdentifier:self.currentDefinitionIdentifier];
    
    if (definition == nil) {
        definition = [self definitionWithIdentifier:self.defaultDefinitionIdentifier];
    }
    
    if (definition != self.cachedCurrentDefinition) {
        self.cachedCurrentDefinition = definition;
    }
    
    return self.cachedCurrentDefinition;
}

-(NSUInteger)definitionCount
{
    return self.definitionArray.count;
}

@end
