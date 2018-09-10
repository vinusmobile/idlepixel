//
//  IDLInterfaceDataSourceComparison.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 23/04/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLInterfaceDataSourceComparison.h"
#import "IDLInterfaceDataSourceHeaders.h"
#import "IDLNSInlineExtensions.h"
#import "NSArray+Idlepixel.h"
#import "NSObject+Idlepixel.h"
#import "NSString+Idlepixel.h"

@interface IDLInterfaceComparisonIdentifier ()

@property (nonatomic, strong, readwrite) NSObject *identifier;
@property (nonatomic, assign, readwrite) BOOL strong;
@property (nonatomic, assign, readwrite) BOOL empty;
@property (nonatomic, assign, readwrite) BOOL selected;
@property (nonatomic, assign, readwrite) BOOL willRequireReload;
@property (nonatomic, assign, readwrite) IDLInterfaceAlternatingFlag alternatingFlag;

@end

@implementation IDLInterfaceComparisonIdentifier

+(IDLInterfaceComparisonIdentifier *)identifier:(NSObject *)identifier strong:(BOOL)strong selected:(BOOL)selected
{
    return [[self alloc] initWithIdentifier:identifier strong:strong selected:selected];
}

-(id)initWithIdentifier:(NSObject *)identifier strong:(BOOL)strong selected:(BOOL)selected
{
    self = [super init];
    if (self) {
        self.identifier = identifier;
        self.empty = (identifier == nil);
        self.strong = strong && !self.empty;
        self.selected = selected;
        self.alternatingFlag = IDLInterfaceAlternatingFlagUnspecified;
    }
    return self;
}

-(BOOL)isEqualToIdentifier:(IDLInterfaceComparisonIdentifier *)anIdentifier
{
    IDLComparisonResult result = NSObjectCompare(self, anIdentifier);
    if (result == IDLComparisonResultInconclusive) {
        result = NSObjectEquals(anIdentifier.identifier, self.identifier);
    }
    return result;
}

-(NSString *)description
{
    NSString *prefix = nil;
    if (self.strong) {
        prefix = @"s";
    } else {
        prefix = @"w";
    }
    return [NSString stringWithFormat:@"%@:['%@']",prefix,self.identifier];
}

@end


@interface IDLInterfaceComparisonSection ()

@property (nonatomic, strong, readwrite) IDLInterfaceComparisonIdentifier *deferredIdentifier;

@end


@implementation IDLInterfaceComparisonSection

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@:%@",self.sectionIdentifier,self.itemIdentifiers];
}

-(IDLInterfaceComparisonIdentifier *)deferredIdentifier
{
    if (_deferredIdentifier == nil && _itemIdentifiers.count > 0) {
        NSArray *ids = _itemIdentifiers;
        for (IDLInterfaceComparisonIdentifier *identifier in ids) {
            if (identifier.strong) {
                _deferredIdentifier = identifier;
                break;
            }
        }
    }
    return _deferredIdentifier;
}

-(IDLInterfaceComparisonIdentifier *)sectionIdentifier
{
    if (_sectionIdentifier == nil || _sectionIdentifier.empty) {
        return self.deferredIdentifier;
    } else {
        return _sectionIdentifier;
    }
}

-(void)setItemIdentifiers:(NSArray *)itemIdentifiers
{
    if (itemIdentifiers != _itemIdentifiers) {
        _deferredIdentifier = nil;
        _itemIdentifiers = itemIdentifiers;
    }
}

@end



typedef NS_OPTIONS (NSUInteger, IDLInterfaceChangeSetType)
{
    IDLInterfaceChangeSetTypeUndefined          = 0,
    IDLInterfaceChangeSetTypeModify             = 1 << 0,
    IDLInterfaceChangeSetTypeInsertSection      = 1 << 1,
    IDLInterfaceChangeSetTypeDeleteSection      = 1 << 2,
    IDLInterfaceChangeSetTypeReloadSection      = 1 << 3
};

@interface IDLInterfaceChangeSet : NSObject

@property (nonatomic, strong) NSMutableIndexSet *inserted;
@property (nonatomic, strong) NSMutableIndexSet *deleted;
@property (nonatomic, strong) NSMutableIndexSet *reload;

@property (nonatomic, assign) NSInteger newSectionIndex;
@property (nonatomic, assign) NSInteger existingSectionIndex;

@property (readonly) BOOL empty;

@property (nonatomic, assign) IDLInterfaceChangeSetType type;

@end

@implementation IDLInterfaceChangeSet

-(id)init
{
    self = [super init];
    if (self) {
        _newSectionIndex = -1;
        _existingSectionIndex = -1;
    }
    return self;
}

-(NSMutableIndexSet *)inserted
{
    if (_inserted == nil) {
        _inserted = [NSMutableIndexSet new];
    }
    return _inserted;
}

-(NSMutableIndexSet *)deleted
{
    if (_deleted == nil) {
        _deleted = [NSMutableIndexSet new];
    }
    return _deleted;
}

-(NSMutableIndexSet *)reload
{
    if (_reload == nil) {
        _reload = [NSMutableIndexSet new];
    }
    return _reload;
}

-(BOOL)empty
{
    return !(_inserted.count > 0 || _deleted.count > 0 || _reload.count > 0);
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"section[new:%li, old:%i, type:%i]: inserted=%@, deleted=%@, reload=%@",(long)self.newSectionIndex, (int)self.existingSectionIndex, (int)self.type,_inserted,_deleted,_reload];
}

@end

@interface IDLInterfaceDataSourceComparison ()

@property (nonatomic, strong, readwrite) NSArray *insertedItemIndexPaths;
@property (nonatomic, strong, readwrite) NSArray *deletedItemIndexPaths;
@property (nonatomic, strong, readwrite) NSArray *reloadItemIndexPaths;
@property (nonatomic, strong, readwrite) NSIndexSet *insertedSections;
@property (nonatomic, strong, readwrite) NSIndexSet *deletedSections;
@property (nonatomic, strong, readwrite) NSIndexSet *reloadSections;

@property (nonatomic, assign) BOOL reloadOnSelectedChanged;

@end

@implementation IDLInterfaceDataSourceComparison

+(IDLInterfaceDataSourceComparison *)compareExistingDataSource:(IDLInterfaceDataSource *)existingDataSource newDataSource:(IDLInterfaceDataSource *)newDataSource
{
    return [[IDLInterfaceDataSourceComparison alloc] initWithExistingDataSource:existingDataSource newDataSource:newDataSource];
}

+(IDLInterfaceDataSourceComparison *)compareExistingDataSource:(IDLInterfaceDataSource *)existingDataSource newDataSource:(IDLInterfaceDataSource *)newDataSource reloadOnSelectedChanged:(BOOL)reloadOnSelectedChanged
{
    return [[IDLInterfaceDataSourceComparison alloc] initWithExistingDataSource:existingDataSource newDataSource:newDataSource reloadOnSelectedChanged:reloadOnSelectedChanged];
}

-(id)initWithExistingDataSource:(IDLInterfaceDataSource *)existingDataSource newDataSource:(IDLInterfaceDataSource *)newDataSource
{
    self = [self initWithExistingDataSource:existingDataSource newDataSource:newDataSource reloadOnSelectedChanged:NO];
    return self;
}

-(id)initWithExistingDataSource:(IDLInterfaceDataSource *)existingDataSource newDataSource:(IDLInterfaceDataSource *)newDataSource reloadOnSelectedChanged:(BOOL)reloadOnSelectedChanged
{
    self = [self init];
    if (self) {
        self.reloadOnSelectedChanged = reloadOnSelectedChanged;
        [self compareExistingDataSource:existingDataSource newDataSource:newDataSource];
    }
    return self;
}

-(void)compareExistingDataSource:(IDLInterfaceDataSource *)existingDataSource newDataSource:(IDLInterfaceDataSource *)newDataSource
{
    NSMutableArray *insertedIndexPaths = [NSMutableArray array];
    NSMutableArray *deletedIndexPaths = [NSMutableArray array];
    NSMutableArray *reloadIndexPaths = [NSMutableArray array];
    NSMutableIndexSet *insertedSections = [NSMutableIndexSet indexSet];
    NSMutableIndexSet *deletedSections = [NSMutableIndexSet indexSet];
    NSMutableIndexSet *reloadSections = [NSMutableIndexSet indexSet];
    
    BOOL forceReload = existingDataSource.willRequireReload || newDataSource.requiresReload;
    
    if (!NSObjectEquals(existingDataSource, newDataSource) || forceReload) {
        
        NSArray *newSectionIdentifiers = nil;
        NSArray *existingSectionIdentifiers = nil;
        
        if (existingDataSource != nil) {
            existingSectionIdentifiers = [self identifiersForDataSource:existingDataSource];
        }
        
        if (newDataSource != nil) {
            newSectionIdentifiers = [self identifiersForDataSource:newDataSource];
        }
        /*/
        int i;
        for (i = 0; i < existingSectionIdentifiers.count; i++) {
            IDLLog(@"existing %i: %@",i,[[existingSectionIdentifiers objectAtIndex:i] sectionIdentifier]);
            IDLLogObject([[existingSectionIdentifiers objectAtIndex:i] itemIdentifiers]);
        }
        for (i = 0; i < newSectionIdentifiers.count; i++) {
            IDLLog(@"new %i: %@",i,[[newSectionIdentifiers objectAtIndex:i] sectionIdentifier]);
            IDLLogObject([[newSectionIdentifiers objectAtIndex:i] itemIdentifiers]);
        }
        //*/
        
        /*/
        IDLLogObject(existingSectionIdentifiers);
        IDLLogObject(newSectionIdentifiers);
        
        IDLLogObject(existingDataSource.sectionCounts);
        IDLLogObject(newDataSource.sectionCounts);
        //*/
        
        NSMutableArray *changeSets = [NSMutableArray array];
        IDLInterfaceChangeSet *set = nil;
        
        if (newSectionIdentifiers.count > 0 && existingSectionIdentifiers.count > 0) {
            
            NSInteger existingOffset = 0;
            
            IDLInterfaceComparisonSection *existingSection = nil;
            IDLInterfaceComparisonSection *newSection = nil;
            
            NSInteger matchIndex = NSNotFound;
            NSUInteger newIndex;
            NSUInteger existingIndex;
            
            for (newIndex = 0; newIndex < newSectionIdentifiers.count; newIndex++) {
                
                newSection = [newSectionIdentifiers objectAtIndex:newIndex];
                matchIndex = NSNotFound;
                
                for (existingIndex = existingOffset; existingIndex < existingSectionIdentifiers.count; existingIndex++) {
                    existingSection = [existingSectionIdentifiers objectAtIndex:existingIndex];
                    if ([newSection.sectionIdentifier isEqualToIdentifier:existingSection.sectionIdentifier]) {
                        
                        matchIndex = existingIndex;
                        break;
                    }
                }
                
                if (matchIndex == NSNotFound) {
                    
                    //IDLLog(@"NEW[%i] WASN'T FOUND IN RANGE: %i->%i",newIndex,existingOffset,existingSectionIdentifiers.count);
                    //IDLLog(@"...INSERTED [%i] at ",newIndex);
                    
                    set = [IDLInterfaceChangeSet new];
                    set.newSectionIndex = newIndex;
                    set.type = IDLInterfaceChangeSetTypeInsertSection;
                    [changeSets addObject:set];
                    
                } else {
                    
                    //IDLLog(@"NEW[%i] FOUND AT: %i",newIndex,matchIndex);
                    
                    for (existingIndex = existingOffset; existingIndex < matchIndex; existingIndex++) {
                        
                        //IDLLog(@"...REMOVED: %i",existingIndex);
                        set = [IDLInterfaceChangeSet new];
                        set.existingSectionIndex = existingIndex;
                        set.type = IDLInterfaceChangeSetTypeDeleteSection;
                        [changeSets addObject:set];
                    }
                    
                    //IDLLog(@"CHECKING ITEM CHANGES IN SECTION %i",newIndex);
                    
                    IDLInterfaceSection *section = [newDataSource sectionAtIndex:newIndex];
                    
                    set = [self changeSetFromExistingComparisonSection:existingSection newComparisonSection:newSection newSection:section];
                    set.newSectionIndex = newIndex;
                    set.existingSectionIndex = matchIndex;
                    set.type = IDLInterfaceChangeSetTypeModify;
                    
                    if (section.requiresReload || existingSection.willRequireReload || forceReload) {
                        set.type = set.type | IDLInterfaceChangeSetTypeReloadSection;
                    }
                    
                    [changeSets addObject:set];
                    
                    existingOffset = matchIndex+1;
                }
            }
            
            if (existingOffset < existingSectionIdentifiers.count) {
                
                IDLInterfaceChangeSet *set = nil;
                
                for (existingIndex = existingOffset; existingIndex < existingSectionIdentifiers.count; existingIndex++) {
                    
                    //IDLLog(@"...REMOVED: %i",existingIndex);
                    set = [IDLInterfaceChangeSet new];
                    set.existingSectionIndex = existingIndex;
                    set.type = IDLInterfaceChangeSetTypeDeleteSection;
                    [changeSets addObject:set];
                }
            }
            
            
        } else if (newSectionIdentifiers.count > 0) {
            
            for (NSUInteger index = 0; index < newSectionIdentifiers.count; index++) {
                set = [IDLInterfaceChangeSet new];
                set.newSectionIndex = index;
                set.type = IDLInterfaceChangeSetTypeInsertSection;
                if (set) [changeSets addObject:set];
            }
            
        } else if (existingSectionIdentifiers.count > 0) {
            
            for (NSUInteger index = 0; index < existingSectionIdentifiers.count; index++) {
                set = [IDLInterfaceChangeSet new];
                set.existingSectionIndex = index;
                set.type = IDLInterfaceChangeSetTypeDeleteSection;
                if (set) [changeSets addObject:set];
            }
            
        }
        
        //IDLLogObject(changeSets);
        
        for (set in changeSets) {
            
            if (set.type & IDLInterfaceChangeSetTypeInsertSection) {
                [insertedSections addIndex:set.newSectionIndex];
            } else if (set.type & IDLInterfaceChangeSetTypeDeleteSection) {
                [deletedSections addIndex:set.existingSectionIndex];
            } else if (set.type & IDLInterfaceChangeSetTypeReloadSection) {
                [reloadSections addIndex:set.existingSectionIndex];
            }
            if (set.type & IDLInterfaceChangeSetTypeModify) {
                if (!set.empty) {
                    [set.inserted enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:set.newSectionIndex];
                        [insertedIndexPaths addObject:indexPath];
                    }];
                    [set.deleted enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:set.existingSectionIndex];
                        [deletedIndexPaths addObject:indexPath];
                    }];
                    [set.reload enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:set.existingSectionIndex];
                        [reloadIndexPaths addObject:indexPath];
                    }];
                }
            }
        }
        
        /*/
        IDLLogObject(existingDataSource.sections);
        IDLLogObject(newDataSource.sections);
        //*/
        
        //IDLLogObject(changeSets);
    }
    
    self.insertedItemIndexPaths = [NSArray arrayWithArray:insertedIndexPaths];
    self.deletedItemIndexPaths = [NSArray arrayWithArray:deletedIndexPaths];
    self.reloadItemIndexPaths = [NSArray arrayWithArray:reloadIndexPaths];
    self.insertedSections = [[NSIndexSet alloc] initWithIndexSet:insertedSections];
    self.deletedSections = [[NSIndexSet alloc] initWithIndexSet:deletedSections];
    self.reloadSections = [[NSIndexSet alloc] initWithIndexSet:reloadSections];
    
    /*/
    IDLLogObject(self.insertedItemIndexPaths);
    IDLLogObject(self.deletedItemIndexPaths);
    IDLLogObject(self.insertedSections);
    IDLLogObject(self.deletedSections);
    //*/
}

-(NSString *)description
{
    NSObject *ii = nil;
    if (self.insertedItemIndexPaths.count) ii = self.insertedItemIndexPaths;
    NSObject *di = nil;
    if (self.deletedItemIndexPaths.count) di = self.deletedItemIndexPaths;
    NSObject *ri = nil;
    if (self.reloadItemIndexPaths.count) ri = self.reloadItemIndexPaths;
    NSObject *is = nil;
    if (self.insertedSections.count) is = self.insertedSections;
    NSObject *ds = nil;
    if (self.deletedSections.count) ds = self.deletedSections;
    NSObject *rs = nil;
    if (self.reloadSections.count) rs = self.reloadSections;
    return [NSString stringWithFormat:@"%@\n Inserted Index Paths:\t%@\n Inserted Sections:\t%@\n Deleted Index Paths:\t%@\n Deleted Sections:\t%@\n Reload Index Paths:\t%@\n Reload Sections:\t%@",self.className,ii,is,di,ds,ri,rs];
}

-(IDLInterfaceChangeSet *)changeSetFromExistingComparisonSection:(IDLInterfaceComparisonSection *)existingSection newComparisonSection:(IDLInterfaceComparisonSection *)newSection newSection:(IDLInterfaceSection *)section
{
    IDLInterfaceChangeSet *set = [IDLInterfaceChangeSet new];
    
    NSUInteger existingOffset = 0;
    
    NSUInteger newIndex = 0;
    NSUInteger existingIndex = 0;
    NSInteger matchIndex = NSNotFound;
    
    NSArray *newArray = newSection.itemIdentifiers;
    NSArray *existingArray = existingSection.itemIdentifiers;
    
    NSUInteger newCount = newArray.count;
    NSUInteger existingCount = existingArray.count;
    
    IDLInterfaceComparisonIdentifier *newIdentifier, *existingIdentifier;
    
    for (newIndex = 0; newIndex < newCount; newIndex++) {
        
        newIdentifier = [newArray objectAtIndex:newIndex];
        
        matchIndex = NSNotFound;
        
        for (existingIndex = existingOffset; existingIndex < existingCount; existingIndex++) {
            
            existingIdentifier = [existingArray objectAtIndex:existingIndex];
            
            if ([existingIdentifier isEqualToIdentifier:newIdentifier]) {
                matchIndex = existingIndex;
                break;
            }
        }
        
        if (matchIndex == NSNotFound) {
            //IDLLog(@"NEW[%i] WASN'T FOUND IN RANGE: %i->%i",newIndex,existingOffset,existingCount);
            //IDLLog(@"...INSERTED [%i] at ",newIndex);
            [set.inserted addIndex:newIndex];
        } else {
            
            for (existingIndex = existingOffset; existingIndex < matchIndex; existingIndex++) {
                //IDLLog(@"...REMOVED: %i",existingIndex);
                [set.deleted addIndex:existingIndex];
            }
            
            if (self.reloadOnSelectedChanged && newIdentifier.selected != existingIdentifier.selected) {
                [set.reload addIndex:matchIndex];
            } else {
                // match found
                IDLInterfaceItem *item = [section itemAtIndex:newIndex];
                if (item.requiresReload
                    || existingIdentifier.willRequireReload
                    || (newIdentifier.alternatingFlag != existingIdentifier.alternatingFlag && (newIdentifier.alternatingFlag != IDLInterfaceAlternatingFlagUnspecified || existingIdentifier.alternatingFlag != IDLInterfaceAlternatingFlagUnspecified))) {
                    [set.reload addIndex:matchIndex];
                }
            }
            existingOffset = matchIndex+1;
        }
    }
    
    if (existingOffset < existingCount) {
        
        for (existingIndex = existingOffset; existingIndex < existingCount; existingIndex++) {
            //IDLLog(@"...REMOVED: %i",existingIndex);
            [set.deleted addIndex:existingIndex];
        }
    }
    
    return set;
}

-(IDLInterfaceChangeSet *)changeSetFromSection:(IDLInterfaceComparisonSection *)section inserted:(BOOL)inserted
{
    IDLInterfaceChangeSet *changeSet = [IDLInterfaceChangeSet new];
    if (section.itemIdentifiers.count > 0) {
        NSMutableIndexSet *set = nil;
        if (inserted) {
            set = changeSet.inserted;
        } else {
            set = changeSet.deleted;
        }
        for (NSUInteger i = 0; i < section.itemIdentifiers.count; i++) {
            [set addIndex:i];
        }
    }
    return changeSet;
}

-(NSArray *)identifiersForDataSource:(IDLInterfaceDataSource *)dataSource
{
    NSArray *sections = dataSource.sections;
    NSMutableArray *sectionIdentifiers = [NSMutableArray arrayWithCapacity:sections.count];
    
    for (IDLInterfaceSection *section in sections) {
        [sectionIdentifiers addObject:[self identifiersForSection:section]];
    }
    return [NSArray arrayWithArray:sectionIdentifiers];
}

-(IDLInterfaceComparisonSection *)identifiersForSection:(IDLInterfaceSection *)section
{
    IDLInterfaceComparisonSection *identifiers = [IDLInterfaceComparisonSection new];
    if (section != nil) {
        identifiers.sectionIdentifier = section.comparisonIdentifier;
        identifiers.willRequireReload = section.willRequireReload;
        if (section.count > 0) {
            NSMutableArray *itemIdentifiers = [NSMutableArray arrayWithCapacity:section.count];
            NSArray *items = section.items;
            for (IDLInterfaceItem *item in items) {
                IDLInterfaceComparisonIdentifier *itemIdentifier = item.comparisonIdentifier;
                itemIdentifier.willRequireReload = item.willRequireReload;
                [itemIdentifiers addObject:itemIdentifier];
                
            }
            identifiers.itemIdentifiers = [NSArray arrayWithArray:itemIdentifiers];
        }
    }
    return identifiers;
}

-(BOOL)layoutChanged
{
    return (self.insertedItemIndexPaths.count > 0
            || self.deletedItemIndexPaths.count > 0
            || self.insertedSections.count > 0
            || self.deletedSections.count > 0);
}

@end

