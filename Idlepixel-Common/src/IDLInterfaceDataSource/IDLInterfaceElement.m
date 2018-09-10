//
//  IDLInterfaceElement.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 17/04/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLInterfaceElement.h"
#import "IDLModelObjectProtocols.h"
#import "IDLNSInlineExtensions.h"

#import "NSString+Idlepixel.h"
#import "NSMutableArray+Idlepixel.h"
#import "NSArray+Idlepixel.h"

@interface IDLInterfaceComparisonIdentifier ()

@property (nonatomic, assign, readwrite) IDLInterfaceAlternatingFlag alternatingFlag;

@end

@implementation IDLInterfaceDimensions

+(IDLInterfaceDimensions *)dimensionsWithHeight:(CGFloat)height
{
    return [self dimensionsWithHeight:height size:CGSizeZero];
}

+(IDLInterfaceDimensions *)dimensionsWithSize:(CGSize)size
{
    return [self dimensionsWithHeight:0.0f size:size];
}

+(IDLInterfaceDimensions *)dimensionsWithHeight:(CGFloat)height size:(CGSize)size
{
    IDLInterfaceDimensions *dimensions = [IDLInterfaceDimensions new];
    dimensions.height = height;
    dimensions.size = size;
    return dimensions;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"[h:%f, s:%@]",self.height, NSStringFromCGSize(self.size)];
}

@end

@interface IDLInterfaceElement ()

@property (nonatomic, strong, readwrite) NSMutableDictionary *mutableProperties;

@property (nonatomic, strong) IDLInterfaceComparisonIdentifier *uniqueComparisonIdentifier;

-(NSString *)comparisonHref;

@end

@implementation IDLInterfaceElement

-(id)init
{
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}

-(void)configure
{
    [super configure];
    
    _alternatingFlag = IDLInterfaceAlternatingFlagUnspecified;
}

-(NSString *)reuseIdentifier
{
    return nil;
}

-(NSString *)uidOrTitle
{
    NSString *result = self.uid;
    if (!result) {
        result = self.title;
    }
    return result;
}

-(NSString *)populatableAssistantIdentifier
{
    return nil;
}

// comparison

-(NSString *)comparisonHref
{
    NSString *href = nil;
    if (self.href != nil) {
        href = self.href;
    } else if ([self.data respondsToSelector:@selector(href)]) {
        href = [(id)self.data href];
    } else if ([self.link respondsToSelector:@selector(href)]) {
        href = [(id)self.link href];
    }
    return href;
}


-(IDLInterfaceComparisonIdentifier *)comparisonIdentifier
{
    if (self.rejectComparison) {
        
        if (self.uniqueComparisonIdentifier == nil) {
            self.uniqueComparisonIdentifier = [IDLInterfaceComparisonIdentifier identifier:NSStringUniversalUniqueID() strong:YES selected:self.selected];
        }
        return self.uniqueComparisonIdentifier;
        
    } else {
        BOOL strong = NO;
        
        NSMutableArray *keys = [NSMutableArray array];
        if (self.uid != nil) {
            [keys addObject:self.uid];
            strong = YES;
            
        }
        if (self.reuseIdentifier != nil) {
            [keys addObject:self.reuseIdentifier];
            strong = YES;
        }
        
        if (keys.count < 2) {
            if (self.populatableAssistantIdentifier != nil) {
                [keys addObject:self.populatableAssistantIdentifier];
            }
            
            NSString *comparisonHref = self.comparisonHref;
            if (comparisonHref != nil) {
                [keys addObject:comparisonHref];
                strong = YES;
            }
            
            if (keys.count < 2) {
                
                BOOL found = NO;
                if (self.title != nil) {
                    [keys addObject:self.title];
                    found = YES;
                }
                if (self.details != nil) {
                    [keys addObject:self.details];
                    found = YES;
                }
                
                if (!found && !strong) {
                    if (self.titleArray.count > 0) {
                        [keys addObjectsFromArray:self.titleArray];
                    }
                    if (self.detailsArray.count > 0) {
                        [keys addObjectsFromArray:self.detailsArray];
                    }
                }
                
                if (keys.count == 0) {
                    
                    if ([self.link conformsToProtocol:@protocol(IDLUniqueKeyedObject)]) {
                        [keys addObjectIfNotNil:[(NSObject <IDLUniqueKeyedObject>*)self.link uniqueKey]];
                        
                    } else if ([self.data conformsToProtocol:@protocol(IDLUniqueKeyedObject)]) {
                        [keys addObjectIfNotNil:[(NSObject <IDLUniqueKeyedObject>*)self.data uniqueKey]];
                        
                    }
                }
            }
        }
        NSObject *identifier = nil;
        if (keys.count > 0) {
            identifier = [keys componentsJoinedByString:@"||"];
        } else {
            identifier = nil;
        }
        IDLInterfaceComparisonIdentifier *comparisonIdentifier = [IDLInterfaceComparisonIdentifier identifier:identifier strong:strong selected:self.selected];
        comparisonIdentifier.alternatingFlag = self.alternatingFlag;
        return comparisonIdentifier;
    }
}

- (id)titleAtIndex:(NSUInteger)index
{
    return [self.titleArray objectAtIndexOrNil:index];
}

- (id)detailsAtIndex:(NSUInteger)index
{
    return [self.detailsArray objectAtIndexOrNil:index];
}

- (id)colorAtIndex:(NSUInteger)index
{
    return [self.colorArray objectAtIndexOrNil:index];
}

- (id)dataAtIndex:(NSUInteger)index
{
    return [self.dataArray objectAtIndexOrNil:index];
}

- (id)imageNameAtIndex:(NSUInteger)index
{
    return [self.imageNameArray objectAtIndexOrNil:index];
}

- (id)imagePathAtIndex:(NSUInteger)index
{
    return [self.imagePathArray objectAtIndexOrNil:index];
}

- (id)imageDataAtIndex:(NSUInteger)index
{
    return [self.imageDataArray objectAtIndexOrNil:index];
}

- (id)propertiesAtIndex:(NSUInteger)index
{
    return [self.propertiesArray objectAtIndexOrNil:index];
}

// properties
-(void)setProperty:(NSObject *)property forKey:(NSString *)aKey
{
    if (aKey != nil) {
        
        if (self.mutableProperties == nil && property != nil) {
            self.mutableProperties = [NSMutableDictionary new];
        }
        
        if (property == nil) {
            [self.mutableProperties removeObjectForKey:aKey];
        } else {
            [self.mutableProperties setObject:property forKey:aKey];
        }
    }
}

-(id)propertyForKey:(NSString *)aKey
{
    if (aKey != nil) {
        return [self.mutableProperties objectForKey:aKey];
    } else {
        return nil;
    }
}

-(NSDictionary *)properties
{
    if (self.mutableProperties != nil) {
        return [NSDictionary dictionaryWithDictionary:self.mutableProperties];
    } else {
        return nil;
    }
}

@end

