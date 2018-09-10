//
//  IDLInterfaceDataSource.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 5/04/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLInterfaceDataSource.h"
#import "NSObject+Idlepixel.h"
#import "NSArray+Idlepixel.h"
#import "IDLNestedDictionary.h"

@interface IDLInterfaceDataSource ()

@property (nonatomic, strong, readwrite) NSArray *sections;
@property (nonatomic, strong, readwrite) NSMutableDictionary *properties;

@property (nonatomic, strong, readwrite) IDLNestedDictionary *registeredDimensions;

@end

@implementation IDLInterfaceDataSource

static Class static_globalSectionClass = nil;
static Class static_globalItemClass = nil;

+(void)setGlobalSectionClass:(Class)sectionClass
{
    if ([sectionClass isSubclassOfClass:[IDLInterfaceSection class]]) {
        static_globalSectionClass = sectionClass;
    }
}

+(Class)globalSectionClass
{
    if (static_globalSectionClass != nil) {
        return static_globalSectionClass;
    } else {
        return [IDLInterfaceSection class];
    }
}

+(void)setGlobalItemClass:(Class)itemClass
{
    if ([itemClass isSubclassOfClass:[IDLInterfaceItem class]]) {
        static_globalItemClass = itemClass;
    }
}

+(Class)globalItemClass
{
    if (static_globalItemClass != nil) {
        return static_globalItemClass;
    } else {
        return [IDLInterfaceItem class];
    }
}

-(id)init
{
    self = [super init];
    if (self) {
        self.sectionClass = [IDLInterfaceSection class];
    }
    return self;
}

-(void)addSection:(IDLInterfaceSection *)section
{
    [self insertSection:section atIndex:-1];
}

-(void)insertSection:(IDLInterfaceSection *)section atIndex:(NSInteger)index
{
    if (section != nil) {
        if (self.sections == nil) {
            self.sections = [NSArray arrayWithObject:section];
        } else {
            NSMutableArray *mutableSections = [self.sections mutableCopy];
            
            [mutableSections removeObject:section];
            
            if ((mutableSections.count < index) || (index < 0)) {
                index = mutableSections.count;
            }
            [mutableSections insertObject:section atIndex:index];
            self.sections = [NSArray arrayWithArray:mutableSections];
        }
    }
}

-(void)removeSection:(IDLInterfaceSection *)section
{
    if (section != nil) {
        self.sections = [self.sections arrayByRemovingObject:section];
    }
}

-(void)setSectionClass:(Class)aClass
{
    if ([aClass isSubclassOfClass:[IDLInterfaceSection class]]) {
        _sectionClass = aClass;
    }
}


-(Class)preferredSectionClass
{
    if (_sectionClass != nil) {
        return _sectionClass;
    } else {
        return [IDLInterfaceDataSource globalSectionClass];
    }
}

-(IDLInterfaceSection *)sectionAtIndex:(NSUInteger)index
{
    if (index < self.sections.count) {
        return [self.sections objectAtIndex:index];
    } else {
        return nil;
    }
}

-(IDLInterfaceSection *)sectionAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath != nil) {
        return [self sectionAtIndex:indexPath.section];
    } else {
        return nil;
    }
}

-(IDLInterfaceSection *)sectionForTitle:(NSString *)title indexTitle:(NSString *)indexTitle createIfNotFound:(BOOL)createIfNotFound
{
    if (self.sectionCount > 0) {
        for (IDLInterfaceSection *section in self.sections) {
            if ([section isEqualToTitle:title indexTitle:indexTitle]) return section;
        }
    }
    if (createIfNotFound) {
        return [self newSectionWithTitle:title indexTitle:indexTitle headerReuseIdentifier:nil];
    } else {
        return nil;
    }
}

-(IDLInterfaceSection *)newSection
{
    return [self newSectionWithTitle:nil indexTitle:nil headerReuseIdentifier:nil];
}

-(IDLInterfaceSection *)newSectionWithTitle:(NSString *)title indexTitle:(NSString *)indexTitle headerReuseIdentifier:(NSString *)reuseIdentifier
{
    return [self newSectionWithTitle:title indexTitle:indexTitle headerReuseIdentifier:reuseIdentifier insertAtIndex:-1];
}

-(IDLInterfaceSection *)newSectionWithTitle:(NSString *)title indexTitle:(NSString *)indexTitle headerReuseIdentifier:(NSString *)reuseIdentifier insertAtIndex:(NSInteger)index
{
    IDLInterfaceSection *section = [[self.sectionClass alloc] initWithTitle:title indexTitle:indexTitle headerReuseIdentifier:reuseIdentifier];
    [self insertSection:section atIndex:index];
    
    return section;
}

-(IDLInterfaceSection *)newSectionWithHeaderHeight:(CGFloat)height
{
    return [self newSectionWithHeaderReuseIdentifier:nil headerHeight:height];
}

-(IDLInterfaceSection *)newSectionWithHeaderSize:(CGSize)size
{
    return [self newSectionWithHeaderReuseIdentifier:nil headerSize:size];
}

-(IDLInterfaceSection *)newSectionWithHeaderReuseIdentifier:(NSString *)reuseIdentifier insertAtIndex:(NSInteger)index
{
    IDLInterfaceSection *section = [self newSection];
    section.headerReuseIdentifier = reuseIdentifier;
    [self insertSection:section atIndex:index];
    return section;
}

-(IDLInterfaceSection *)newSectionWithHeaderReuseIdentifier:(NSString *)reuseIdentifier headerHeight:(CGFloat)height
{
    return [self newSectionWithHeaderReuseIdentifier:reuseIdentifier headerDimensions:[IDLInterfaceDimensions dimensionsWithHeight:height]];
}

-(IDLInterfaceSection *)newSectionWithHeaderReuseIdentifier:(NSString *)reuseIdentifier headerSize:(CGSize)size
{
    return [self newSectionWithHeaderReuseIdentifier:reuseIdentifier headerDimensions:[IDLInterfaceDimensions dimensionsWithSize:size]];
}

-(IDLInterfaceSection *)newSectionWithHeaderReuseIdentifier:(NSString *)reuseIdentifier headerDimensions:(IDLInterfaceDimensions *)dimensions
{
    IDLInterfaceSection *section = [self newSection];
    section.headerReuseIdentifier = reuseIdentifier;
    section.headerDimensions = dimensions;
    return section;
}

-(IDLInterfaceItem *)itemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath != nil) {
        return [[self sectionAtIndex:indexPath.section] itemAtIndex:indexPath.row];
    } else {
        return nil;
    }
}

-(NSIndexPath *)indexPathOfItem:(IDLInterfaceItem *)item
{
    if (item != nil) {
        NSInteger itemIndex;
        NSArray *sections = self.sections;
        if (sections.count > 0) {
            for (NSInteger sectionIndex = 0; sectionIndex < sections.count; sectionIndex++) {
                itemIndex = [(IDLInterfaceSection *)[sections objectAtIndex:sectionIndex] indexOfItem:item];
                if (itemIndex != NSNotFound) {
                    return [NSIndexPath indexPathForItem:itemIndex inSection:sectionIndex];
                }
            }
        }
    }
    return nil;
}

-(NSIndexPath *)firstIndexPathOfItemWithReuseIdentifier:(NSString *)reuseIdentifier
{
    return [self nextIndexPathOfItemWithReuseIdentifier:reuseIdentifier afterIndexPath:nil];
}

-(NSIndexPath *)nextIndexPathOfItemWithReuseIdentifier:(NSString *)reuseIdentifier afterIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil) {
        indexPath = [NSIndexPath indexPathForItem:-1 inSection:-1];
    }
    NSArray *sections = self.sections;
    if (sections.count > indexPath.section && sections.count > 0) {
        NSInteger itemIndex;
        for (NSInteger sectionIndex = indexPath.section; sectionIndex < sections.count; sectionIndex++) {
            if (indexPath.section == sectionIndex) {
                itemIndex = indexPath.row;
            } else {
                itemIndex = -1;
            }
            itemIndex = [(IDLInterfaceSection *)[sections objectAtIndex:sectionIndex] nextIndexOfItemWithReuseIdentifier:reuseIdentifier afterIndex:itemIndex];
            if (itemIndex != NSNotFound) {
                return [NSIndexPath indexPathForItem:itemIndex inSection:sectionIndex];
            }
        }
    }
    return nil;
}

-(NSUInteger)indexOfSectionWithComparisonIdentifier:(IDLInterfaceComparisonIdentifier *)identifier
{
    if (identifier != nil) {
        NSArray *sections = self.sections;
        IDLInterfaceSection *section;
        for (NSUInteger i = 0; i < sections.count; i++) {
            section = [sections objectAtIndex:i];
            if ([identifier isEqualToIdentifier:section.comparisonIdentifier]) {
                return i;
            }
        }
    }
    return NSNotFound;
}

-(NSArray *)sectionComparisonIdentifiers
{
    NSArray *sections = self.sections;
    NSMutableArray *identifiers = [NSMutableArray arrayWithCapacity:sections.count];
    for (IDLInterfaceSection *section in sections) {
        [identifiers addObject:[section comparisonIdentifier]];
    }
    return identifiers;
}

-(NSArray *)sectionIndexTitles
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.sectionCount];
    
    for (IDLInterfaceSection *section in self.sections) {
        if (section.indexTitle != nil) {
            [array addObject:section.indexTitle];
        } else {
            [array addObject:@" "];
        }
    }
    return [NSArray arrayWithArray:array];
}

-(NSUInteger)numberOfItemsInSection:(NSInteger)section
{
    return [self sectionAtIndex:section].count;
}

-(NSUInteger)sectionCount
{
    return self.sections.count;
}

-(NSUInteger)itemCount
{
    NSUInteger count = 0;
    for (IDLInterfaceSection *section in self.sections) {
        count += section.count;
    }
    return count;
}

-(NSArray *)allItems
{
    NSMutableArray *items = [NSMutableArray array];
    for (IDLInterfaceSection *section in self.sections) {
        if (section.count > 0) {
            [items addObjectsFromArray:section.items];
        }
    }
    return [NSArray arrayWithArray:items];
}

-(NSArray *)allItemIndexPaths
{
    NSMutableArray *items = [NSMutableArray array];
    IDLInterfaceSection *section = nil;
    NSIndexPath *path = nil;
    for (NSInteger s = 0; s < self.sectionCount; s++) {
        section = [self sectionAtIndex:s];
        for (NSInteger i = 0; i < section.count; i++) {
            path = [NSIndexPath indexPathForItem:i inSection:s];
            [items addObject:path];
        }
    }
    return [NSArray arrayWithArray:items];
}

-(NSMutableDictionary *)properties
{
    if (_properties == nil) {
        _properties = [NSMutableDictionary new];
    }
    return _properties;
}

-(IDLInterfaceSection *)firstSection
{
    return self.sections.firstObject;
}

-(IDLInterfaceSection *)lastSection
{
    return self.sections.lastObject;
}

-(IDLInterfaceItem *)firstItem
{
    return self.firstSection.firstItem;
}

-(IDLInterfaceItem *)lastItem
{
    return self.lastSection.lastItem;
}

-(NSArray *)itemIndexPathsRequiringReload
{
    NSMutableArray *paths = [NSMutableArray array];
    NSArray *sections = self.sections;
    
    NSUInteger sectionIndex = 0;
    
    for (IDLInterfaceSection *section in sections) {
        NSArray *array = [section itemIndexPathsRequiringReload:sectionIndex++];
        if (array.count > 0) {
            [paths addObjectsFromArray:array];
        }
    }
    return [NSArray arrayWithArray:paths];
}

-(void)updateInterfaceItemPositions
{
    NSArray *sections = self.sections;
    
    for (IDLInterfaceSection *section in sections) {
        [section updateInterfaceItemPositions];
    }
}

-(void)setItemsRequireReload:(BOOL)requireReload
{
    NSArray *sections = self.sections;
    
    for (IDLInterfaceSection *section in sections) {
        [section setItemsRequireReload:requireReload];
    }
}

-(NSSet *)itemReuseIdentifiers
{
    NSMutableSet *set = [NSMutableSet set];
    NSArray *sections = self.sections;
    
    for (IDLInterfaceSection *section in sections) {
        [set unionSet:section.itemReuseIdentifiers];
    }
    
    return [NSSet setWithSet:set];
}

-(NSSet *)headerSectionReuseIdentifiers
{
    NSMutableSet *set = [NSMutableSet set];
    NSArray *sections = self.sections;
    
    for (IDLInterfaceSection *section in sections) {
        if (section.headerReuseIdentifier != nil) [set addObject:section.headerReuseIdentifier];
    }
    
    return [NSSet setWithSet:set];
}

-(NSSet *)footerSectionReuseIdentifiers
{
    NSMutableSet *set = [NSMutableSet set];
    NSArray *sections = self.sections;
    
    for (IDLInterfaceSection *section in sections) {
        if (section.footerReuseIdentifier != nil) [set addObject:section.footerReuseIdentifier];
    }
    
    return [NSSet setWithSet:set];
}

-(NSArray *)itemIndexPathsWithReuseIdentifier:(NSString *)reuseIdentifier
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSIndexPath *indexPath = nil;
    for (NSUInteger s = 0; s < self.sections.count; s++) {
        NSIndexSet *indexSet = [[self.sections objectAtIndex:s] itemIndexesWithReuseIdentifier:reuseIdentifier];
        if (indexSet.count > 0) {
            NSUInteger index = indexSet.firstIndex;
            while (index != NSNotFound) {
                indexPath = [NSIndexPath indexPathForItem:index inSection:s];
                [array addObject:indexPath];
                index = [indexSet indexGreaterThanIndex:index];
            }
        }
    }
    
    return [NSArray arrayWithArray:array];
}

-(void)splitSectionsAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath != nil) {
        IDLInterfaceSection *section = [self sectionAtIndex:indexPath.section];
        if (section != nil && section.count > indexPath.item) {
            NSArray *priorItems = [section.items subarrayToIndex:indexPath.item];
            NSArray *postItems = [section.items subarrayFromIndex:indexPath.item];
            IDLInterfaceSection *postSection = [[IDLInterfaceSection alloc] init];
            postSection.generatedBySplit = YES;
            [postSection addItems:postItems];
            
            [self insertSection:postSection atIndex:(indexPath.section + 1)];
            
            [section removeAllItems];
            [section addItems:priorItems];
        }
    }
}

-(void)splitSectionsAtIndexPaths:(NSArray *)indexPaths ignoreIndexPathsWithItemAtZero:(BOOL)ignoreAtZero
{
    if (indexPaths.count > 0) {
        // make sure the index paths are sorted from highest to lowest - otherwise the sections will get out of whack
        indexPaths = [indexPaths sortedArrayUsingSelector:@selector(compare:)];
        indexPaths = indexPaths.reversedArray;
        
        for (NSIndexPath *indexPath in indexPaths) {
            // only pay attention to items that aren't at the beginning of a section
            if (!ignoreAtZero || indexPath.item > 0) {
                [self splitSectionsAtIndexPath:indexPath];
            }
        }
    }
}

#pragma mark - registered dimensions

#define kRegisteredDimensionsTypeItem       @"item"
#define kRegisteredDimensionsTypeHeader     @"header"
#define kRegisteredDimensionsTypeFooter     @"footer"

-(void)registerDimensions:(IDLInterfaceDimensions *)dimensions forReuseIdentifier:(NSString *)reuseIdentifier ofType:(NSString *)type
{
    if (reuseIdentifier != nil && type != nil) {
        if (self.registeredDimensions == nil && dimensions != nil) {
            self.registeredDimensions = [IDLNestedDictionary new];
        }
        NSArray *keys = @[type, reuseIdentifier];
        if (dimensions != nil) {
            [self.registeredDimensions setObject:dimensions forKeys:keys];
        } else {
            [self.registeredDimensions removeObjectForKeys:keys];
        }
    }
}

-(void)registerDimensions:(IDLInterfaceDimensions *)dimensions forItemReuseIdentifier:(NSString *)reuseIdentifier
{
    [self registerDimensions:dimensions forReuseIdentifier:reuseIdentifier ofType:kRegisteredDimensionsTypeItem];
}

-(void)registerDimensions:(IDLInterfaceDimensions *)dimensions forSectionHeaderReuseIdentifier:(NSString *)reuseIdentifier
{
    [self registerDimensions:dimensions forReuseIdentifier:reuseIdentifier ofType:kRegisteredDimensionsTypeHeader];
}

-(void)registerDimensions:(IDLInterfaceDimensions *)dimensions forSectionFooterReuseIdentifier:(NSString *)reuseIdentifier
{
    [self registerDimensions:dimensions forReuseIdentifier:reuseIdentifier ofType:kRegisteredDimensionsTypeFooter];
}

-(IDLInterfaceDimensions *)registeredDimensionsForReuseIdentifier:(NSString *)reuseIdentifier ofType:(NSString *)type
{
    if (reuseIdentifier != nil && type != nil) {
        return (IDLInterfaceDimensions *)[self.registeredDimensions objectForKeys:@[type, reuseIdentifier]];
    } else {
        return nil;
    }
}

-(IDLInterfaceDimensions *)registeredDimensionsForItemReuseIdentifier:(NSString *)reuseIdentifier
{
    return [self registeredDimensionsForReuseIdentifier:reuseIdentifier ofType:kRegisteredDimensionsTypeItem];
}

-(IDLInterfaceDimensions *)registeredDimensionsForSectionHeaderReuseIdentifier:(NSString *)reuseIdentifier
{
    return [self registeredDimensionsForReuseIdentifier:reuseIdentifier ofType:kRegisteredDimensionsTypeHeader];
}

-(IDLInterfaceDimensions *)registeredDimensionsForSectionFooterReuseIdentifier:(NSString *)reuseIdentifier
{
    return [self registeredDimensionsForReuseIdentifier:reuseIdentifier ofType:kRegisteredDimensionsTypeFooter];
}

#pragma mark - debug

-(void)shuffleSections
{
    self.sections = [self.sections arrayByShuffling];
}

-(void)removeRandomSection
{
    NSUInteger i = rand()%self.sections.count;
    self.sections = [self.sections arrayByRemovingObject:[self.sections objectAtIndex:i]];
}

-(NSArray *)sectionCounts
{
    NSMutableArray *counts = [NSMutableArray array];
    for (IDLInterfaceSection *section in self.sections) {
        [counts addObject:@(section.count)];
    }
    return counts;
}

@end

