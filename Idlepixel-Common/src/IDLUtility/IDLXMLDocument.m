//
//  IDLXMLDocument.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 24/08/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "IDLXMLDocument.h"
#import "IDLLoggingMacros.h"
#import "NSDictionary+Idlepixel.h"
#import "NSArray+Idlepixel.h"
#import "NSString+Idlepixel.h"
#import "NSMutableDictionary+Idlepixel.h"
#import "IDLNSInlineExtensions.h"

NSString * const IDLXMLElementDictionaryKeyName              = @"name";
NSString * const IDLXMLElementDictionaryKeyQualifiedName     = @"qualifiedName";
NSString * const IDLXMLElementDictionaryKeyValue             = @"value";
NSString * const IDLXMLElementDictionaryKeyChildren          = @"children";
NSString * const IDLXMLElementDictionaryKeyAttributes        = @"attributes";
NSString * const IDLXMLElementDictionaryKeyComments          = @"comments";
NSString * const IDLXMLElementDictionaryKeyNamespaceURI      = @"namespaceURI";
NSString * const IDLXMLElementDictionaryKeyNamespacePrefix   = @"namespacePrefix";
//
NSString * const IDLXMLDocumentDictionaryKeyRoot             = @"root";
//
NSString * const IDLXMLDocumentErrorDomain                 = @"IDLXMLDocumentErrorDomain";
NSString * const IDLXMLDocumentErrorUserInfoLineNumber     = @"LineNumber";
NSString * const IDLXMLDocumentErrorUserInfoColumnNumber   = @"ColumnNumber";

#define kXMLDocumentErrorParseDescription           @"Malformed XML document. Parse error at line %@:%@."
#define kXMLDocumentValidationParseDescription      @"Malformed XML document. Validation error at line %@:%@."

static NSError *IDLXMLDocumentError(NSXMLParser *parser, NSError *parseError, BOOL validationError) {
	NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:parseError forKey:NSUnderlyingErrorKey];
	NSNumber *lineNumber = [NSNumber numberWithInteger:parser.lineNumber];
	NSNumber *columnNumber = [NSNumber numberWithInteger:parser.columnNumber];
    NSString *errorDescription = nil;
    if (validationError) {
        errorDescription = kXMLDocumentValidationParseDescription;
    } else {
        errorDescription = kXMLDocumentErrorParseDescription;
    }
	[userInfo setObject:[NSString stringWithFormat:NSLocalizedString(errorDescription, @""), lineNumber, columnNumber] forKey:NSLocalizedDescriptionKey];
	[userInfo setObject:lineNumber forKey:IDLXMLDocumentErrorUserInfoLineNumber];
	[userInfo setObject:columnNumber forKey:IDLXMLDocumentErrorUserInfoColumnNumber];
	return [NSError errorWithDomain:IDLXMLDocumentErrorDomain code:1 userInfo:userInfo];
}

@interface IDLXMLElement ()

@property (nonatomic, weak) IDLXMLElement *parent;
@property (nonatomic, assign) BOOL valueIsCDATA;

-(void)addChild:(IDLXMLElement *)childElement;
-(void)addComment:(NSString *)comment;

-(NSString *)stringRepresentation:(BOOL)applyFormatting tabDepth:(NSInteger)tabDepth;

@end

@implementation IDLXMLElement
@synthesize name, qualifiedName, value, children, attributes, comments, namespaceURI, namespacePrefix;
@synthesize parent, valueIsCDATA;

-(NSUInteger)count
{
    return self.children.count;
}

-(IDLXMLElement *)firstChild
{
    if (self.children.count > 0) {
        return [self.children objectAtIndex:0];
    } else {
        return nil;
    }
}

-(IDLXMLElement *)lastChild
{
    if (self.children.count > 0) {
        return [self.children lastObject];
    } else {
        return nil;
    }
}

-(IDLXMLElement *)firstChildWithName:(NSString *)aName
{
    if (self.count > 0) {
        for (IDLXMLElement *item in self.children) {
            if (NSStringEquals(item.name, aName)) {
                return item;
            }
        }
    }
    return nil;
}

-(NSString *)firstValueWithName:(NSString *)aName
{
    return [self firstChildWithName:aName].value;
}

-(NSArray *)childrenWithName:(NSString *)aName
{
    NSMutableArray *array = [NSMutableArray array];
    if (self.count > 0) {
        for (IDLXMLElement *item in self.children) {
            if (NSStringEquals(item.name, aName)) {
                [array addObject:item];
            }
        }
    }
    return [NSArray arrayWithArray:array];
}

-(NSString *)attributeWithName:(NSString *)aName
{
    return [self.attributes stringForKey:aName];
}

-(NSString *)qualifiedName
{
    if (qualifiedName == nil) {
        return self.name;
    } else {
        return qualifiedName;
    }
}

-(void)addChild:(IDLXMLElement *)childElement
{
    if (childElement != nil && childElement != self) {
        childElement.parent = self;
        @synchronized(self) {
            if (self.children == nil) {
                self.children = [NSArray arrayWithObject:childElement];
            } else {
                self.children = [self.children arrayByAddingObject:childElement];
            }
        }
    }
}

-(void)addComment:(NSString *)comment
{
    if (comment != nil) {
        @synchronized(self) {
            if (self.comments == nil) {
                self.comments = [NSArray arrayWithObject:comment];
            } else {
                self.comments = [self.comments arrayByAddingObject:comment];
            }
        }
    }
}

-(NSString *)description
{
    return self.formattedStringRepresentation;
}

-(NSString *)formattedStringRepresentation
{
    return [self stringRepresentation:YES tabDepth:0];
}

-(NSString *)stringRepresentation
{
    return [self stringRepresentation:NO tabDepth:0];
}

#define kPaddingNewline     @"\n"
#define kPaddingTab         @"    "
#define kPaddingEmpty       @""

-(NSString *)stringRepresentation:(BOOL)applyFormatting tabDepth:(NSInteger)tabDepth
{
    NSString *paddingNewline = nil;
    NSString *paddingTab = nil;
    if (applyFormatting && tabDepth > 0) {
        paddingNewline = kPaddingNewline;
        paddingTab = [NSString stringByLooping:kPaddingTab iterationCount:tabDepth];
    } else {
        paddingNewline = kPaddingEmpty;
        paddingTab = kPaddingEmpty;
    }
    NSMutableString *string = [NSMutableString string];
    [string appendFormat:@"%@%@<",paddingNewline,paddingTab];
    [string appendString:self.qualifiedName];
    if (self.namespaceURI.length > 0) {
        if (self.namespacePrefix.length > 0) {
            [string appendFormat:@" xmlns:%@=\"%@\"",self.namespacePrefix,self.namespaceURI];
        } else {
            [string appendFormat:@" xmlns=\"%@\"",self.namespaceURI];
        }
    }
    if (self.attributes.count > 0) {
        for (NSString *key in self.attributes.allKeys) {
            [string appendFormat:@" %@=\"%@\"",key,[self.attributes objectForKey:key]];
        }
    }
    if (self.value.length == 0 && self.children.count == 0) {
        [string appendFormat:@"/>"];
    } else {
        [string appendString:@">"];
        if (self.children.count > 0) {
            NSString *childRepresentation = nil;
            for (IDLXMLElement *element in self.children) {
                childRepresentation = [element stringRepresentation:applyFormatting tabDepth:(tabDepth+1)];
                [string appendString:childRepresentation];
            }
            if (applyFormatting) paddingNewline = kPaddingNewline;
        } else {
            paddingNewline = kPaddingEmpty;
            paddingTab = kPaddingEmpty;
            if (self.value.length > 0) {
                [string appendFormat:@"<![CDATA[%@]]>",self.value];
            }
        }
        [string appendFormat:@"%@%@</%@>",paddingNewline,paddingTab,self.qualifiedName];
    }
    
    return [NSString stringWithString:string];
}

#pragma mark IDLDictionaryRepresentation

+ (NSSet *)dictionaryRepresentationKeys
{
    NSMutableSet *set = [NSMutableSet new];
    [set addObject:IDLXMLElementDictionaryKeyName];
    [set addObject:IDLXMLElementDictionaryKeyQualifiedName];
    [set addObject:IDLXMLElementDictionaryKeyValue];
    [set addObject:IDLXMLElementDictionaryKeyChildren];
    [set addObject:IDLXMLElementDictionaryKeyAttributes];
    [set addObject:IDLXMLElementDictionaryKeyComments];
    [set addObject:IDLXMLElementDictionaryKeyNamespaceURI];
    [set addObject:IDLXMLElementDictionaryKeyNamespacePrefix];
    return [NSSet setWithSet:set];
}

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
    if ((self = [super init])) {
        self.name = [dictionary objectForKey:IDLXMLElementDictionaryKeyName];
        self.qualifiedName = [dictionary objectForKey:IDLXMLElementDictionaryKeyQualifiedName];
        self.value = [dictionary objectForKey:IDLXMLElementDictionaryKeyValue];
        self.namespaceURI = [dictionary objectForKey:IDLXMLElementDictionaryKeyNamespaceURI];
        self.namespacePrefix = [dictionary objectForKey:IDLXMLElementDictionaryKeyNamespacePrefix];
        self.attributes = [[dictionary dictionaryForKey:IDLXMLElementDictionaryKeyAttributes] dictionaryByRemovingObjectsAndKeysNotBelongingToClass:[NSString class]];
        self.comments = [[dictionary arrayForKey:IDLXMLElementDictionaryKeyComments] arrayByRemovingObjectsNotBelongingToClass:[NSString class]];
        NSArray *childArray = [[dictionary arrayForKey:IDLXMLElementDictionaryKeyChildren] arrayByRemovingObjectsNotBelongingToClass:[NSDictionary class]];
        IDLXMLElement *child = nil;
        for (NSDictionary *d in childArray) {
            child = [[IDLXMLElement alloc] initWithDictionaryRepresentation:d];
            if (child != nil) {
                [self addChild:child];
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
    NSMutableDictionary *d = [NSMutableDictionary new];
    
    [d setObjectIfNotNil:self.name forKey:IDLXMLElementDictionaryKeyName];
    [d setObjectIfNotNil:self.qualifiedName forKey:IDLXMLElementDictionaryKeyQualifiedName];
    [d setObjectIfNotNil:self.value forKey:IDLXMLElementDictionaryKeyValue];
    [d setObjectIfNotNil:self.attributes forKey:IDLXMLElementDictionaryKeyAttributes];
    [d setObjectIfNotNil:self.comments forKey:IDLXMLElementDictionaryKeyComments];
    [d setObjectIfNotNil:self.namespaceURI forKey:IDLXMLElementDictionaryKeyNamespaceURI];
    [d setObjectIfNotNil:self.namespacePrefix forKey:IDLXMLElementDictionaryKeyNamespacePrefix];
    //
    NSMutableArray *childArray = [NSMutableArray new];
    NSDictionary *childDictionary = nil;
    for (IDLXMLElement *element in self.children) {
        childDictionary = element.dictionaryRepresentation;
        if (childDictionary) {
            [childArray addObject:childDictionary];
        }
    }
    [d setObjectIfNotNil:[NSArray arrayWithArray:childArray] forKey:IDLXMLElementDictionaryKeyChildren];
    
    return [NSDictionary dictionaryWithDictionary:d];
}

- (NSDictionary *)plistRepresentation
{
    return [self dictionaryRepresentation:YES];
}

@end

@interface IDLXMLDocument (Parser) <NSXMLParserDelegate>

- (void)parseObject:(NSObject *)anObject completionBlock:(IDLXMLDocumentCompletionBlock)completionBlock asynchronous:(BOOL)asynchronous;

- (NSString *)elementNamespaceURI:(IDLXMLElement *)element;
- (NSString *)elementNamespacePrefix:(IDLXMLElement *)element;

@end

@interface IDLXMLDocument ()

@property (nonatomic, strong) IDLXMLElement *parsingElement;
@property (nonatomic, strong) NSString *parsingNamespaceURI;
@property (nonatomic, strong) NSString *parsingNamespacePrefix;

@property (nonatomic, strong, readwrite) IDLXMLElement *root;
@property (nonatomic, strong, readwrite) NSError *error;

-(BOOL)returnParseError:(NSError **)parseError;

@end

@implementation IDLXMLDocument
@synthesize root, error;
@synthesize parsingElement, parsingNamespacePrefix, parsingNamespaceURI;

-(BOOL)parseXMLFromContentsOfURL:(NSURL *)url error:(NSError *__autoreleasing *)parseError
{
    [self parseObject:url completionBlock:nil asynchronous:NO];
    return [self returnParseError:parseError];
}

-(BOOL)parseXMLFromData:(NSData *)data error:(NSError *__autoreleasing *)parseError
{
    [self parseObject:data completionBlock:nil asynchronous:NO];
    return [self returnParseError:parseError];
}

-(BOOL)parseXMLFromStream:(NSInputStream *)stream error:(NSError *__autoreleasing *)parseError
{
    [self parseObject:stream completionBlock:nil asynchronous:NO];
    return [self returnParseError:parseError];
}

-(void)parseXMLFromContentsOfURL:(NSURL *)url completionBlock:(IDLXMLDocumentCompletionBlock)completionBlock
{
    [self parseObject:url completionBlock:completionBlock asynchronous:YES];
}

-(void)parseXMLFromData:(NSData *)data completionBlock:(IDLXMLDocumentCompletionBlock)completionBlock
{
    [self parseObject:data completionBlock:completionBlock asynchronous:YES];
}

-(void)parseXMLFromStream:(NSInputStream *)stream completionBlock:(IDLXMLDocumentCompletionBlock)completionBlock
{
    [self parseObject:stream completionBlock:completionBlock asynchronous:YES];
}

-(BOOL)returnParseError:(NSError *__autoreleasing *)parseError
{
    if (parseError != nil) {
        *parseError = self.error;
    }
    return (self.error == nil);
}

-(NSString *)description
{
    if (self.error) {
        return [NSString stringWithFormat:@"%@ : %@",super.description,self.error.description];
    } else {
        return [NSString stringWithFormat:@"%@ : %@",super.description,self.root.description];
    }
}

#pragma mark IDLDictionaryRepresentation

+ (NSSet *)dictionaryRepresentationKeys
{
    NSMutableSet *set = [NSMutableSet new];
    [set addObject:IDLXMLDocumentDictionaryKeyRoot];
    return [NSSet setWithSet:set];
}

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary
{
    if ((self = [super init])) {
        NSDictionary *d = [dictionary dictionaryForKey:IDLXMLDocumentDictionaryKeyRoot];
        IDLXMLElement *element = [[IDLXMLElement alloc] initWithDictionaryRepresentation:d];
        self.root = element;
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation
{
    return [self dictionaryRepresentation:NO];
}

- (NSDictionary *)dictionaryRepresentation:(BOOL)plistConformant
{
    NSMutableDictionary *d = [NSMutableDictionary new];
    [d setObjectIfNotNil:[self.root dictionaryRepresentation] forKey:IDLXMLDocumentDictionaryKeyRoot];
    return [NSDictionary dictionaryWithDictionary:d];
}

- (NSDictionary *)plistRepresentation
{
    return [self dictionaryRepresentation:YES];
}

@end

@implementation IDLXMLDocument (Parser)

NS_INLINE BOOL ValidXMLParserObject(NSObject *anObject)
{
    if ([anObject isKindOfClass:[NSURL class]]) {
        return YES;
    } else if ([anObject isKindOfClass:[NSData class]]) {
        return YES;
    } else if ([anObject isKindOfClass:[NSInputStream class]]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)parseObject:(NSObject *)anObject completionBlock:(IDLXMLDocumentCompletionBlock)completionBlock asynchronous:(BOOL)asynchronous
{
    self.root = nil;
    self.error = nil;
    self.parsingElement = nil;
    if (ValidXMLParserObject(anObject)) {
        void(^parseBlock)(void) = ^{
            NSXMLParser *parser = nil;
            if ([anObject isKindOfClass:[NSURL class]]) {
                parser = [[NSXMLParser alloc] initWithContentsOfURL:(NSURL *)anObject];
            } else if ([anObject isKindOfClass:[NSData class]]) {
                parser = [[NSXMLParser alloc] initWithData:(NSData *)anObject];
            } else if ([anObject isKindOfClass:[NSInputStream class]]) {
                parser = [[NSXMLParser alloc] initWithStream:(NSInputStream *)anObject];
            }
            parser.delegate = self;
            parser.shouldProcessNamespaces = YES;
            parser.shouldReportNamespacePrefixes = YES;
            parser.shouldResolveExternalEntities = NO;
            [parser parse];
            //
            if (completionBlock != nil) {
                BOOL success = (self.error == nil);
                completionBlock(success, self.error, self.root);
            }
        };
        if (asynchronous) {
            dispatch_queue_t parserQueue = dispatch_queue_create("IDLXMLDocument.Parser.AsyncQueue", NULL);
            dispatch_async(parserQueue, parseBlock);
        } else {
            parseBlock();
        }
    }
}

- (NSString *)elementNamespaceURI:(IDLXMLElement *)element
{
    while (element != nil && element.namespaceURI == nil) {
        element = element.parent;
    }
    return element.namespaceURI;
}

- (NSString *)elementNamespacePrefix:(IDLXMLElement *)element
{
    while (element != nil && element.namespacePrefix == nil) {
        element = element.parent;
    }
    return element.namespacePrefix;
}

// sent when the parser begins parsing of the document.
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.parsingElement = nil;
    self.root = nil;
}

// sent when the parser has completed parsing. If this is encountered, the parse was successful.
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    self.parsingElement = nil;
}

// DTD handling methods for various declarations.
/*
- (void)parser:(NSXMLParser *)parser foundNotationDeclarationWithName:(NSString *)name publicID:(NSString *)publicID systemID:(NSString *)systemID
{
    IDLLogContext(@"name: %@", name);
}

- (void)parser:(NSXMLParser *)parser foundUnparsedEntityDeclarationWithName:(NSString *)name publicID:(NSString *)publicID systemID:(NSString *)systemID notationName:(NSString *)notationName
{
    IDLLogContext(@"name: %@", name);
}

- (void)parser:(NSXMLParser *)parser foundAttributeDeclarationWithName:(NSString *)attributeName forElement:(NSString *)elementName type:(NSString *)type defaultValue:(NSString *)defaultValue
{
    IDLLogContext(@"attributeName: %@", attributeName);
}

- (void)parser:(NSXMLParser *)parser foundElementDeclarationWithName:(NSString *)elementName model:(NSString *)model
{
    IDLLogContext(@"name: %@", elementName);
}

- (void)parser:(NSXMLParser *)parser foundInternalEntityDeclarationWithName:(NSString *)name value:(NSString *)value
{
    IDLLogContext(@"name: %@", name);
}

- (void)parser:(NSXMLParser *)parser foundExternalEntityDeclarationWithName:(NSString *)name publicID:(NSString *)publicID systemID:(NSString *)systemID
{
    IDLLogContext(@"name: %@", name);
}
 */

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
{
    //IDLLogContext(@"name: %@,\nqname: '%@',\nnamespace: '%@'\nattribs: %@", elementName, qName, namespaceURI, attributeDict);
    IDLXMLElement *newElement = [IDLXMLElement new];
    newElement.name = elementName;
    if (!NSStringEquals(qName, elementName)) {
        newElement.qualifiedName = qName;
    }
    //
    if (namespaceURI.length == 0) {
        namespaceURI = self.parsingNamespaceURI;
    }
    NSString *currentNamespace = [self elementNamespaceURI:self.parsingElement];
    if (!NSStringEquals(currentNamespace, namespaceURI)) {
        newElement.namespaceURI = namespaceURI;
    }
    currentNamespace = [self elementNamespacePrefix:self.parsingElement];
    if (!NSStringEquals(currentNamespace, self.parsingNamespacePrefix)) {
        newElement.namespacePrefix = self.parsingNamespacePrefix;
    }
    //
    newElement.attributes = attributeDict;
    //
    if (self.parsingElement != nil) {
        [self.parsingElement addChild:newElement];
    }
    self.parsingElement = newElement;
    if (self.root == nil) {
        self.root = newElement;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (!self.parsingElement.valueIsCDATA) {
        self.parsingElement.value = [self.parsingElement.value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    self.parsingElement = self.parsingElement.parent;
}

- (void)parser:(NSXMLParser *)parser didStartMappingPrefix:(NSString *)prefix toURI:(NSString *)namespaceURI
{
    //IDLLogContext(@"prefix: %@,\nnamespaceURI: %@",prefix, namespaceURI);
    self.parsingNamespacePrefix = prefix;
    self.parsingNamespaceURI = namespaceURI;
}

- (void)parser:(NSXMLParser *)parser didEndMappingPrefix:(NSString *)prefix
{
    self.parsingNamespacePrefix = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (!self.parsingElement.valueIsCDATA) {
        if (self.parsingElement.value == nil) {
            self.parsingElement.value = string;
        } else {
            self.parsingElement.value = [self.parsingElement.value stringByAppendingString:string];
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundComment:(NSString *)comment
{
    [self.parsingElement addComment:comment];
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    NSString *string = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    self.parsingElement.value = string;
    self.parsingElement.valueIsCDATA = YES;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError;
{
    self.error = IDLXMLDocumentError(parser, parseError, NO);
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError;
{
    self.error = IDLXMLDocumentError(parser, validationError, YES);
}

@end
