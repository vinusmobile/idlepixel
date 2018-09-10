//
//  IDLSkinDefinitionStore.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 23/07/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLAbstractSharedSingleton.h"
#import "IDLSkinDefinition.h"
#import "IDLModelObjectProtocols.h"

#define kIDLSharedSkinDefinitionStore       [IDLSkinDefinitionStore sharedStore]

@interface IDLSkinDefinitionStore : IDLAbstractSharedSingleton <IDLCacheableModelObject>

+(instancetype)sharedStore;

@property (readonly) IDLSkinDefinition *currentDefinition;

-(IDLSkinDefinition *)definitionWithIdentifier:(NSString *)identifier;

-(void)addDefinition:(IDLSkinDefinition *)definition;
-(void)addDefinition:(IDLSkinDefinition *)definition isDefault:(BOOL)isDefault isCurrent:(BOOL)isCurrent;

-(void)removeDefinitionWithIdentifier:(NSString *)identifier;
-(void)removeAllDefinitions;

@property (nonatomic, strong) NSString *currentDefinitionIdentifier;
@property (nonatomic, strong) NSString *defaultDefinitionIdentifier;

@property (readonly) NSArray *definitions;
@property (readonly) NSUInteger definitionCount;

@end
