//
//  IDLInterfaceElement.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 17/04/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLInterfaceDataSourceComparison.h"
#import "IDLInterfaceProperties.h"

@interface IDLInterfaceDimensions : NSObject

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;

+(IDLInterfaceDimensions *)dimensionsWithHeight:(CGFloat)height;
+(IDLInterfaceDimensions *)dimensionsWithSize:(CGSize)size;
+(IDLInterfaceDimensions *)dimensionsWithHeight:(CGFloat)height size:(CGSize)size;

@end

@interface IDLInterfaceElement : IDLInterfaceProperties <IDLConfigurable>

@property (nonatomic, strong) NSObject *link;
@property (nonatomic, weak)   NSObject *assistant;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *secondaryDataArray;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *detailsArray;
@property (nonatomic, strong) NSArray *colorArray;

@property (nonatomic, strong) NSArray *imageNameArray;
@property (nonatomic, strong) NSArray *imagePathArray;
@property (nonatomic, strong) NSArray *imageDataArray;

@property (nonatomic, strong) NSArray *propertiesArray;

@property (nonatomic, strong) NSString *uid;
@property (readonly) NSString *uidOrTitle;

@property (nonatomic, strong) NSString *hint;
@property (nonatomic, assign) NSUInteger hintFlag;

@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@property (nonatomic, assign) BOOL allowsResize;
@property (nonatomic, assign) BOOL rejectComparison;

@property (nonatomic, assign) BOOL requiresReload;
@property (nonatomic, assign) BOOL willRequireReload;

@property (nonatomic, assign) IDLInterfaceAlternatingFlag alternatingFlag;

-(NSString *)reuseIdentifier;
-(NSString *)populatableAssistantIdentifier;

- (id)titleAtIndex:(NSUInteger)index;
- (id)detailsAtIndex:(NSUInteger)index;
- (id)colorAtIndex:(NSUInteger)index;
- (id)dataAtIndex:(NSUInteger)index;
- (id)imageNameAtIndex:(NSUInteger)index;
- (id)imagePathAtIndex:(NSUInteger)index;
- (id)imageDataAtIndex:(NSUInteger)index;
- (id)propertiesAtIndex:(NSUInteger)index;

// comparison
@property (readonly) IDLInterfaceComparisonIdentifier *comparisonIdentifier;

// properties
@property (readonly) NSDictionary *properties;
-(void)setProperty:(NSObject *)property forKey:(NSString *)aKey;
-(NSObject *)propertyForKey:(NSString *)aKey;

@end
