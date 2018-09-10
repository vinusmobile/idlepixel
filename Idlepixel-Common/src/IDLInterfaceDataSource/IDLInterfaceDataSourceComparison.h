//
//  IDLInterfaceDataSourceComparison.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 23/04/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLInterfaceTypedefs.h"

@interface IDLInterfaceComparisonIdentifier : NSObject

@property (nonatomic, strong, readonly) NSObject *identifier;
@property (nonatomic, assign, readonly) BOOL strong;
@property (nonatomic, assign, readonly) BOOL empty;
@property (nonatomic, assign, readonly) BOOL selected;
@property (nonatomic, assign, readonly) IDLInterfaceAlternatingFlag alternatingFlag;
@property (nonatomic, assign, readonly) BOOL willRequireReload;

+(IDLInterfaceComparisonIdentifier *)identifier:(NSObject *)identifier strong:(BOOL)strong selected:(BOOL)selected;
-(id)initWithIdentifier:(NSObject *)identifier strong:(BOOL)strong selected:(BOOL)selected;

-(BOOL)isEqualToIdentifier:(IDLInterfaceComparisonIdentifier *)anIdentifier;

@end

@interface IDLInterfaceComparisonSection : NSObject

@property (nonatomic, assign, readwrite) BOOL willRequireReload;
@property (nonatomic, strong, readwrite) NSArray *itemIdentifiers;
@property (nonatomic, strong, readwrite) IDLInterfaceComparisonIdentifier *sectionIdentifier;

@end

@class IDLInterfaceDataSource;

@interface IDLInterfaceDataSourceComparison : NSObject

@property (nonatomic, strong, readonly) NSArray *insertedItemIndexPaths;
@property (nonatomic, strong, readonly) NSArray *deletedItemIndexPaths;
@property (nonatomic, strong, readonly) NSArray *reloadItemIndexPaths;
@property (nonatomic, strong, readonly) NSIndexSet *insertedSections;
@property (nonatomic, strong, readonly) NSIndexSet *deletedSections;
@property (nonatomic, strong, readonly) NSIndexSet *reloadSections;

@property (readonly) BOOL layoutChanged;

+(IDLInterfaceDataSourceComparison *)compareExistingDataSource:(IDLInterfaceDataSource *)existingDataSource newDataSource:(IDLInterfaceDataSource *)newDataSource;
+(IDLInterfaceDataSourceComparison *)compareExistingDataSource:(IDLInterfaceDataSource *)existingDataSource newDataSource:(IDLInterfaceDataSource *)newDataSource reloadOnSelectedChanged:(BOOL)reloadOnSelectedChanged;

-(id)initWithExistingDataSource:(IDLInterfaceDataSource *)existingDataSource newDataSource:(IDLInterfaceDataSource *)newDataSource;
-(id)initWithExistingDataSource:(IDLInterfaceDataSource *)existingDataSource newDataSource:(IDLInterfaceDataSource *)newDataSource reloadOnSelectedChanged:(BOOL)reloadOnSelectedChanged;

@end
