//
//  IDLInterfaceSection.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 5/04/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLInterfaceSection.h"
#import "NSArray+Idlepixel.h"
#import "NSMutableArray+Idlepixel.h"
#import "IDLNSInlineExtensions.h"
#import "IDLInterfaceDataSource.h"

@interface IDLInterfaceSection ()

@property (nonatomic, strong, readwrite) NSArray *items;

@end

@implementation IDLInterfaceSection

+(id)sectionWithTitle:(NSString *)title indexTitle:(NSString *)indexTitle
{
    return [self sectionWithTitle:title indexTitle:indexTitle headerReuseIdentifier:nil];
}

+(id)sectionWithTitle:(NSString *)title indexTitle:(NSString *)indexTitle headerReuseIdentifier:(NSString *)reuseIdentifier
{
    return [[self alloc] initWithTitle:title indexTitle:indexTitle headerReuseIdentifier:reuseIdentifier];
}

-(id)initWithTitle:(NSString *)title indexTitle:(NSString *)indexTitle headerReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super init];
    if (self) {
        self.title = title;
        self.indexTitle = indexTitle;
        self.headerReuseIdentifier = reuseIdentifier;
    }
    return self;
}

-(void)setItemClass:(Class)itemClass
{
    if ([itemClass isSubclassOfClass:[IDLInterfaceItem class]]) {
        _itemClass = itemClass;
    }
}

-(Class)preferredItemClass
{
    if (_itemClass != nil) {
        return _itemClass;
    } else {
        return [IDLInterfaceDataSource globalItemClass];
    }
}

-(IDLInterfaceItem *)itemAtIndex:(NSUInteger)index
{
    if (index < self.items.count) {
        return [self.items objectAtIndex:index];
    } else {
        return nil;
    }
}

-(void)addItem:(IDLInterfaceItem *)item
{
    [self insertItem:item atIndex:-1];
}

-(void)insertItem:(IDLInterfaceItem *)item atIndex:(NSInteger)index
{
    if (item != nil) {
        if (self.items == nil) {
            self.items = [NSArray arrayWithObject:item];
        } else {
            NSMutableArray *mutableItems = [self.items mutableCopy];
            
            [mutableItems removeObject:item];
            
            if ((mutableItems.count < index) || (index < 0)) {
                index = mutableItems.count;
            }
            [mutableItems insertObject:item atIndex:index];
            self.items = [NSArray arrayWithArray:mutableItems];
        }
    }
}

-(void)addItems:(NSArray *)items
{
    if (items.count > 0) {
        if (self.items == nil) {
            self.items = [NSArray arrayWithArray:items];
        } else {
            self.items = [self.items arrayByAddingObjectsFromArray:items];
        }
    }
}

-(void)removeItem:(IDLInterfaceItem *)item
{
    if (item != nil) {
        self.items = [self.items arrayByRemovingObject:item];
    }
}

-(void)removeAllItems
{
    self.items = nil;
}

-(NSInteger)indexOfItem:(IDLInterfaceItem *)item
{
    if (item != nil) {
        NSArray *items = self.items;
        if (items.count > 0) {
            return [items indexOfObject:item];
        }
    }
    return NSNotFound;
}

-(NSInteger)firstIndexOfItemWithReuseIdentifier:(NSString *)reuseIdentifier
{
    return [self nextIndexOfItemWithReuseIdentifier:reuseIdentifier afterIndex:-1];
}

-(NSInteger)nextIndexOfItemWithReuseIdentifier:(NSString *)reuseIdentifier afterIndex:(NSInteger)index
{
    NSArray *items = self.items;
    index += 1;
    if (items.count > index && items.count > 0) {
        for (NSInteger i = index; i < items.count; i++) {
            if (NSStringEquals(reuseIdentifier, [(IDLInterfaceItem *)[items objectAtIndex:i] reuseIdentifier])) {
                return i;
            }
        }
    }
    return NSNotFound;
}

-(IDLInterfaceItem *)newItem
{
    return [self newItemWithReuseIdentifier:nil];
}

-(IDLInterfaceItem *)newItemWithReuseIdentifier:(NSString *)reuseIdentifier
{
    return [self newItemWithReuseIdentifier:reuseIdentifier dimensions:nil];
}

-(IDLInterfaceItem *)newItemWithReuseIdentifier:(NSString *)reuseIdentifier ignoreSelection:(BOOL)ignoreSelection
{
    return [self newItemWithReuseIdentifier:reuseIdentifier dimensions:nil ignoreSelection:ignoreSelection];
}

-(IDLInterfaceItem *)newItemWithReuseIdentifier:(NSString *)reuseIdentifier ignoreSelection:(BOOL)ignoreSelection insertAtIndex:(NSInteger)index
{
    IDLInterfaceItem *item = [[self preferredItemClass] new];
    item.reuseIdentifier = reuseIdentifier;
    item.ignoreSelection = ignoreSelection;
    [self insertItem:item atIndex:index];
    return item;
}

-(IDLInterfaceItem *)newItemWithHeight:(CGFloat)height
{
    return [self newItemWithHeight:height ignoreSelection:NO];
}

-(IDLInterfaceItem *)newItemWithHeight:(CGFloat)height ignoreSelection:(BOOL)ignoreSelection
{
    return [self newItemWithReuseIdentifier:nil dimensions:[IDLInterfaceDimensions dimensionsWithHeight:height] ignoreSelection:ignoreSelection];
}

-(IDLInterfaceItem *)newItemWithSize:(CGSize)size
{
    return [self newItemWithSize:size ignoreSelection:NO];
}

-(IDLInterfaceItem *)newItemWithSize:(CGSize)size ignoreSelection:(BOOL)ignoreSelection
{
    return [self newItemWithReuseIdentifier:nil dimensions:[IDLInterfaceDimensions dimensionsWithSize:size] ignoreSelection:ignoreSelection];
}

-(IDLInterfaceItem *)newItemWithReuseIdentifier:(NSString *)reuseIdentifier dimensions:(IDLInterfaceDimensions *)dimensions
{
    return [self newItemWithReuseIdentifier:reuseIdentifier dimensions:dimensions ignoreSelection:NO];
}

-(IDLInterfaceItem *)newItemWithReuseIdentifier:(NSString *)reuseIdentifier dimensions:(IDLInterfaceDimensions *)dimensions ignoreSelection:(BOOL)ignoreSelection
{
    return [self newItemWithReuseIdentifier:reuseIdentifier dimensions:dimensions ignoreSelection:ignoreSelection alternatingFlag:IDLInterfaceAlternatingFlagUnspecified];
}

-(IDLInterfaceItem *)newItemWithReuseIdentifier:(NSString *)reuseIdentifier dimensions:(IDLInterfaceDimensions *)dimensions alternatingFlag:(IDLInterfaceAlternatingFlag)flag
{
    return [self newItemWithReuseIdentifier:reuseIdentifier dimensions:dimensions ignoreSelection:NO alternatingFlag:flag];
}

-(IDLInterfaceItem *)newItemWithReuseIdentifier:(NSString *)reuseIdentifier dimensions:(IDLInterfaceDimensions *)dimensions ignoreSelection:(BOOL)ignoreSelection alternatingFlag:(IDLInterfaceAlternatingFlag)flag
{
    IDLInterfaceItem *item = [[self preferredItemClass] new];
    item.reuseIdentifier = reuseIdentifier;
    item.dimensions = dimensions;
    item.ignoreSelection = ignoreSelection;
    item.alternatingFlag = flag;
    [self addItem:item];
    return item;
}

-(NSUInteger)count
{
    return self.items.count;
}

-(BOOL)isEqualToTitle:(NSString *)title indexTitle:(NSString *)indexTitle
{
    return NSStringEquals(self.title, title) && NSStringEquals(self.indexTitle, indexTitle);
}

-(IDLInterfaceItem *)firstItem
{
    return self.items.firstObject;
}

-(IDLInterfaceItem *)lastItem
{
    return self.items.lastObject;
}

-(NSArray *)itemIndexPathsRequiringReload:(NSUInteger)sectionIndex
{
    NSMutableArray *paths = [NSMutableArray array];
    NSArray *items = self.items;
    
    for (NSUInteger index = 0; index < items.count; index++) {
        
        if ([(IDLInterfaceItem *)[items objectAtIndex:index] requiresReload]) {
            [paths addObject:[NSIndexPath indexPathForItem:index inSection:sectionIndex]];
        }
    }
    return [NSArray arrayWithArray:paths];
}

-(void)updateInterfaceItemPositions
{
    NSArray *items = self.items;
    
    for (IDLInterfaceItem *item in items) {
        if (!item.manualPosition) {
            item.position = IDLInterfaceItemPositionMiddle;
        }
    }
    IDLInterfaceItem *item = self.firstItem;
    if (!item.manualPosition) item.position = (item.position | IDLInterfaceItemPositionFirst);
    item = self.lastItem;
    if (!item.manualPosition) item.position = (item.position | IDLInterfaceItemPositionLast);
}

-(void)setItemsRequireReload:(BOOL)requireReload
{
    NSArray *items = self.items;
    
    for (IDLInterfaceItem *item in items) {
        item.requiresReload = requireReload;
    }
}

-(NSSet *)itemReuseIdentifiers
{
    NSMutableSet *set = [NSMutableSet set];
    
    for (IDLInterfaceItem *item in self.items) {
        if (item.reuseIdentifier != nil) [set addObject:item.reuseIdentifier];
    }
    
    return [NSSet setWithSet:set];
}

-(NSIndexSet *)itemIndexesWithReuseIdentifier:(NSString *)reuseIdentifier
{
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    IDLInterfaceItem *item = nil;
    for (NSUInteger i = 0; i < self.items.count; i++) {
        item = [self.items objectAtIndex:i];
        if (NSStringEquals(item.reuseIdentifier, reuseIdentifier)) {
            [set addIndex:i];
        }
    }
    return [[NSIndexSet alloc] initWithIndexSet:set];
}

-(NSString *)reuseIdentifier
{
    return self.headerReuseIdentifier;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"Section[h:%@, f:%@] { data:%@, hd:%@, fd: %@ } [%@]",self.headerReuseIdentifier, self.footerReuseIdentifier,self.data,self.headerDimensions, self.footerDimensions, self.items];
}

@end
