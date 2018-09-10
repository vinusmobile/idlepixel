//
//  IDLPersistentFieldStore.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 23/07/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLAbstractStore.h"
#import "IDLPersistentField.h"

@interface IDLPersistentFieldStore : NSObject <IDLPersistentModelObject>

- (NSSet *)fieldsForOwner:(NSString *)owner;
- (IDLPersistentField *)fieldForOwner:(NSString *)owner setterSelector:(SEL)setterSelector;

- (void)addField:(IDLPersistentField *)field;
- (void)addFields:(NSSet *)fields;

- (void)removeField:(IDLPersistentField *)field;
- (void)removeFields:(NSSet *)fields;
- (void)removeAllFields;

- (NSUInteger)count;

@end
