//
//  IDLXMLDocument.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 24/08/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLModelObjectProtocols.h"

extern NSString * const IDLXMLElementDictionaryKeyName;
extern NSString * const IDLXMLElementDictionaryKeyQualifiedName;
extern NSString * const IDLXMLElementDictionaryKeyValue;
extern NSString * const IDLXMLElementDictionaryKeyChildren;
extern NSString * const IDLXMLElementDictionaryKeyAttributes;
extern NSString * const IDLXMLElementDictionaryKeyComments;
extern NSString * const IDLXMLElementDictionaryKeyNamespaceURI;
extern NSString * const IDLXMLElementDictionaryKeyNamespacePrefix;
//
extern NSString * const IDLXMLDocumentDictionaryKeyRoot;
//
extern NSString *const IDLXMLDocumentErrorDomain;
extern NSString *const IDLXMLDocumentErrorUserInfoLineNumber;
extern NSString *const IDLXMLDocumentErrorUserInfoColumnNumber;

@interface IDLXMLElement : NSObject <IDLDictionaryRepresentation>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *qualifiedName;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSArray *children;
@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, strong) NSDictionary *attributes;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) NSString *namespaceURI;
@property (nonatomic, strong) NSString *namespacePrefix;
@property (nonatomic, readonly) IDLXMLElement *firstChild, *lastChild;

@property (nonatomic, readonly) NSString *formattedStringRepresentation;
@property (nonatomic, readonly) NSString *stringRepresentation;

-(IDLXMLElement *)firstChildWithName:(NSString *)aName;
-(NSString *)firstValueWithName:(NSString *)aName;
-(NSArray *)childrenWithName:(NSString *)aName;

-(NSString *)attributeWithName:(NSString *)aName;

@end

typedef void(^IDLXMLDocumentCompletionBlock)(BOOL success, NSError *error, IDLXMLElement *root);

@interface IDLXMLDocument : NSObject <IDLDictionaryRepresentation>

@property (nonatomic, strong, readonly) IDLXMLElement *root;
@property (nonatomic, strong, readonly) NSError *error;

-(BOOL)parseXMLFromContentsOfURL:(NSURL *)url error:(NSError **)parseError;
-(BOOL)parseXMLFromData:(NSData *)data error:(NSError **)parseError;
-(BOOL)parseXMLFromStream:(NSInputStream *)stream error:(NSError **)parseError;

-(void)parseXMLFromContentsOfURL:(NSURL *)url completionBlock:(IDLXMLDocumentCompletionBlock)completionBlock;
-(void)parseXMLFromData:(NSData *)data completionBlock:(IDLXMLDocumentCompletionBlock)completionBlock;
-(void)parseXMLFromStream:(NSInputStream *)stream completionBlock:(IDLXMLDocumentCompletionBlock)completionBlock;

@end
