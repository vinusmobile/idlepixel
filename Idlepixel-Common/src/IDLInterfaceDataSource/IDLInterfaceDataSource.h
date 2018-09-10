//
//  IDLInterfaceDataSource.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 5/04/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLInterfaceSection.h"

@interface IDLInterfaceDataSource : NSObject

+(void)setGlobalSectionClass:(Class)sectionClass;
+(Class)globalSectionClass;
+(void)setGlobalItemClass:(Class)itemClass;
+(Class)globalItemClass;

@property (readonly) NSUInteger sectionCount;
@property (readonly) NSUInteger itemCount;
@property (nonatomic, strong, readonly) NSArray *sections;
@property (nonatomic, strong, readonly) NSMutableDictionary *properties;
@property (nonatomic, strong) Class sectionClass;
@property (nonatomic, strong) Class itemClass;

@property (nonatomic, assign) BOOL requiresReload;
@property (nonatomic, assign) BOOL willRequireReload;

@property (readonly) NSArray *allItems;
@property (readonly) NSArray *allItemIndexPaths;

@property (readonly) IDLInterfaceItem *firstItem;
@property (readonly) IDLInterfaceItem *lastItem;
@property (readonly) IDLInterfaceSection *firstSection;
@property (readonly) IDLInterfaceSection *lastSection;

@property (readonly) NSArray *itemIndexPathsRequiringReload;

-(void)addSection:(IDLInterfaceSection *)section;
-(void)insertSection:(IDLInterfaceSection *)section atIndex:(NSInteger)index;
-(void)removeSection:(IDLInterfaceSection *)section;

-(IDLInterfaceSection *)sectionAtIndex:(NSUInteger)index;
-(IDLInterfaceSection *)sectionAtIndexPath:(NSIndexPath *)indexPath;
-(IDLInterfaceSection *)sectionForTitle:(NSString *)title indexTitle:(NSString *)indexTitle createIfNotFound:(BOOL)createIfNotFound;

-(IDLInterfaceSection *)newSection;
-(IDLInterfaceSection *)newSectionWithTitle:(NSString *)title indexTitle:(NSString *)indexTitle headerReuseIdentifier:(NSString *)reuseIdentifier;
-(IDLInterfaceSection *)newSectionWithTitle:(NSString *)title indexTitle:(NSString *)indexTitle headerReuseIdentifier:(NSString *)reuseIdentifier insertAtIndex:(NSInteger)index;

-(IDLInterfaceSection *)newSectionWithHeaderHeight:(CGFloat)height;
-(IDLInterfaceSection *)newSectionWithHeaderSize:(CGSize)size;
-(IDLInterfaceSection *)newSectionWithHeaderReuseIdentifier:(NSString *)reuseIdentifier insertAtIndex:(NSInteger)index;
-(IDLInterfaceSection *)newSectionWithHeaderReuseIdentifier:(NSString *)reuseIdentifier headerHeight:(CGFloat)height;
-(IDLInterfaceSection *)newSectionWithHeaderReuseIdentifier:(NSString *)reuseIdentifier headerSize:(CGSize)size;
-(IDLInterfaceSection *)newSectionWithHeaderReuseIdentifier:(NSString *)reuseIdentifier headerDimensions:(IDLInterfaceDimensions *)dimensions;

-(IDLInterfaceItem *)itemAtIndexPath:(NSIndexPath *)indexPath;
-(NSIndexPath *)indexPathOfItem:(IDLInterfaceItem *)item;
-(NSIndexPath *)firstIndexPathOfItemWithReuseIdentifier:(NSString *)reuseIdentifier;
-(NSIndexPath *)nextIndexPathOfItemWithReuseIdentifier:(NSString *)reuseIdentifier afterIndexPath:(NSIndexPath *)indexPath;

-(NSArray *)sectionComparisonIdentifiers;
-(NSUInteger)indexOfSectionWithComparisonIdentifier:(IDLInterfaceComparisonIdentifier *)identifier;

-(NSUInteger)numberOfItemsInSection:(NSInteger)section;

-(NSArray *)sectionIndexTitles;

-(void)updateInterfaceItemPositions;
-(void)setItemsRequireReload:(BOOL)requireReload;

-(NSSet *)itemReuseIdentifiers;
-(NSSet *)headerSectionReuseIdentifiers;
-(NSSet *)footerSectionReuseIdentifiers;

-(NSArray *)itemIndexPathsWithReuseIdentifier:(NSString *)reuseIdentifier;

-(void)splitSectionsAtIndexPath:(NSIndexPath *)indexPath;
-(void)splitSectionsAtIndexPaths:(NSArray *)indexPaths ignoreIndexPathsWithItemAtZero:(BOOL)ignoreAtZero;

-(void)registerDimensions:(IDLInterfaceDimensions *)dimensions forItemReuseIdentifier:(NSString *)reuseIdentifier;
-(void)registerDimensions:(IDLInterfaceDimensions *)dimensions forSectionHeaderReuseIdentifier:(NSString *)reuseIdentifier;
-(void)registerDimensions:(IDLInterfaceDimensions *)dimensions forSectionFooterReuseIdentifier:(NSString *)reuseIdentifier;

-(IDLInterfaceDimensions *)registeredDimensionsForItemReuseIdentifier:(NSString *)reuseIdentifier;
-(IDLInterfaceDimensions *)registeredDimensionsForSectionHeaderReuseIdentifier:(NSString *)reuseIdentifier;
-(IDLInterfaceDimensions *)registeredDimensionsForSectionFooterReuseIdentifier:(NSString *)reuseIdentifier;

// debug
-(void)shuffleSections;
-(void)removeRandomSection;
-(NSArray *)sectionCounts;

@end
