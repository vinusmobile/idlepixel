//
//  IDLAbstractModelDataSet.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 4/04/2014.
//  Copyright (c) 2014 Trystan Pfluger. All rights reserved.
//

#import "IDLAbstractModelDataSet.h"
#import "IDLModelDataItem.h"

#import "IDLModelDataManager.h"
#import "NSDictionary+Idlepixel.h"

@interface IDLModelDataItem ()

@property (nonatomic, assign, readwrite) NSInteger sortOrder;
@property (nonatomic, assign, readwrite) NSInteger groupSortOrder;

@end

@interface IDLModelDataGroup ()

@property (nonatomic, assign, readwrite) NSInteger sortOrder;

@end

@interface IDLModelDataGroup (DataItems)

-(NSArray *)sortedItems:(BOOL)recursive;

@end

@interface IDLAbstractModelDataSet ()

@property (nonatomic, strong, readwrite) NSString *sourceFilename;
@property (nonatomic, strong, readwrite) NSString *sourcePath;

@property (nonatomic, strong) NSDictionary *itemLookupDictionary;
@property (nonatomic, strong) NSDictionary *groupLookupDictionary;

@property (nonatomic, strong, readwrite) NSArray *sortedUIDs;
@property (nonatomic, strong, readwrite) NSArray *sortedDataItems;
@property (nonatomic, strong, readwrite) NSArray *sortedDataItemsSkippingHidden;

@property (nonatomic, strong, readwrite) NSArray *groups;

@property (nonatomic, assign) BOOL dataLoaded;

-(void)checkModelDataLoaded;
-(BOOL)loadModelData;

@end

@implementation IDLModelDataGroup (DataItems)

-(NSArray *)sortedItems:(BOOL)recursive
{
    NSArray *items = [self.items sortedArrayUsingSelector:@selector(compare:)];
    if (recursive && self.children.count > 0) {
        NSMutableArray *childItems = [NSMutableArray array];
        for (IDLModelDataGroup *group in self.children) {
            NSArray *groupItems = [group sortedItems:YES];
            if (groupItems.count > 0) {
                [childItems addObjectsFromArray:groupItems];
            }
        }
        if (childItems.count > 0) {
            if (items.count > 0) {
                items = [items arrayByAddingObjectsFromArray:childItems];
            } else {
                items = [NSArray arrayWithArray:childItems];
            }
        }
    }
    return items;
}

@end

@implementation IDLAbstractModelDataSet

+(instancetype)modelDataSetWithFilename:(NSString *)filename
{
    IDLAbstractModelDataSet *set = [[[self class] alloc] initWithFilename:filename];
    return set;
}

+(instancetype)modelDataSetWithPath:(NSString *)path
{
    IDLAbstractModelDataSet *set = [[[self class] alloc] initWithPath:path];
    return set;
}

-(id)initWithFilename:(NSString *)filename
{
    self = [super init];
    if (self) {
        self.sourceFilename = filename;
    }
    return self;
}

-(id)initWithPath:(NSString *)path
{
    self = [super init];
    if (self) {
        self.sourcePath = path;
    }
    return self;
}

-(NSString *)modelDataItemsKey
{
    return @"items";
}

-(NSString *)modelDataGroupsKey
{
    return @"groups";
}

-(Class)modelDataItemClass
{
    return [IDLModelDataItem class];
}

NS_INLINE NSString *ModelDataGroupID(NSString *group)
{
    if (group) {
        return group;
    } else {
        return (NSString *)NSNULL;
    }
}

-(IDLModelDataItem *)itemForDictionary:(NSDictionary *)dictionary sortOrder:(NSInteger)sortOrder
{
    IDLModelDataItem *item = [[self modelDataItemClass] itemWithUID:[dictionary stringForKey:@"uid"] name:[dictionary stringForKey:@"name"] group:[dictionary stringForKey:@"group"] isHidden:[dictionary boolForKey:@"hidden"] isDefault:[dictionary boolForKey:@"default"]];
    [item setSortOrder:sortOrder++];
    return item;
}

-(void)checkModelDataLoaded
{
    if (!self.dataLoaded && (self.sourceFilename || self.sourcePath)) {
        self.dataLoaded = YES;
        self.dataLoaded = [self loadModelData];
    }
}

-(BOOL)loadModelData
{
    NSString *path = self.sourcePath;
    if (!path) {
        path = [[IDLModelDataManager sharedManager] modelDataPathForFilename:self.sourceFilename inBundle:YES];
    }
    if (path) {
        NSDictionary *rawDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
        [self parseModelData:rawDictionary];
    }
    return (path != nil);
}

-(NSArray *)parseModelDataGroupsArray:(NSArray *)rawGroupArray parentGroup:(IDLModelDataGroup *)parentGroup
{
    if (rawGroupArray.count > 0) {
        NSMutableArray *groups = [NSMutableArray array];
        IDLModelDataGroup *group = nil;
        for (NSObject *rawGroupObject in rawGroupArray) {
            group = nil;
            if ([rawGroupObject isKindOfClass:[NSString class]]) {
                group = [IDLModelDataGroup new];
                group.name = (NSString *)rawGroupObject;
            } else if ([rawGroupObject isKindOfClass:[NSDictionary class]]) {
                group = [IDLModelDataGroup new];
                group.name = [(NSDictionary *)rawGroupObject stringForKey:@"name"];
                group.open = [(NSDictionary *)rawGroupObject boolForKey:@"open"];
                group.children = [self parseModelDataGroupsArray:[(NSDictionary *)rawGroupObject arrayForKey:@"children"] parentGroup:group];
            }
            if (group) {
                group.parentName = parentGroup.name;
                [groups addObject:group];
            }
        }
        return [NSArray arrayWithArray:groups];
    } else {
        return nil;
    }
}

-(NSArray *)parseModelDataItemsArray:(NSArray *)rawItemArray
{
    NSMutableArray *items = [NSMutableArray array];
    IDLModelDataItem *item = nil;
    NSInteger sortOrder = 0;
    for (NSDictionary *itemDictionary in rawItemArray) {
        item = [self itemForDictionary:itemDictionary sortOrder:sortOrder++];
        if (item) {
            [items addObject:item];
        }
    }
    return [NSArray arrayWithArray:items];
}

-(NSDictionary *)generateGroupLookupDictionary:(NSArray *)groups recursive:(BOOL)recursive
{
    if (groups.count > 0) {
        NSMutableDictionary *lookup = [NSMutableDictionary dictionary];
        IDLModelDataGroup *group = nil;
        NSString *groupID = nil;
        for (group in groups) {
            groupID = ModelDataGroupID(group.uid);
            [lookup setObject:group forKey:groupID];
            if (group.children.count > 0) {
                if (recursive) {
                    NSDictionary *childrenLookup = [self generateGroupLookupDictionary:group.children recursive:recursive];
                    if (childrenLookup.count > 0) {
                        [lookup addEntriesFromDictionary:childrenLookup];
                    }
                }
            }
        }
        if (lookup.count > 0) {
            return [NSDictionary dictionaryWithDictionary:lookup];
        }
    }
    return nil;
}

-(NSInteger)refreshSortOrders:(NSArray *)groups groupSortOrder:(NSInteger)groupSortOrder
{
    if (groups.count > 0) {
        IDLModelDataGroup *group = nil;
        for (group in groups) {
            group.sortOrder = groupSortOrder++;
            if (group.children.count > 0) {
                groupSortOrder = [self refreshSortOrders:group.children groupSortOrder:groupSortOrder];
            }
            if (group.items.count > 0) {
                NSInteger itemSortOrder = 0;
                for (IDLModelDataItem *item in group.items) {
                    item.sortOrder = itemSortOrder++;
                    item.groupSortOrder = groupSortOrder;
                }
            }
        }
    }
    return groupSortOrder;
}

-(void)parseModelData:(NSDictionary *)rawDictionary;
{
    if (rawDictionary) {
        
        NSArray *rawItemArray = nil;
        if (self.modelDataItemsKey != nil) rawItemArray = [rawDictionary arrayForKey:self.modelDataItemsKey];
        if (rawItemArray == nil) rawItemArray = CLASS_OR_NIL([rawDictionary allValues].firstObject, NSArray);
        
        NSArray *items = [self parseModelDataItemsArray:rawItemArray];
        
        //IDLLogObject(items);
        
        IDLModelDataItem *item = nil;
        
        NSMutableOrderedSet *itemGroupNames = [NSMutableOrderedSet orderedSet];
        
        for (item in items) {
            [itemGroupNames addObject:ModelDataGroupID(item.group)];
        }
        
        NSArray *rawGroupArray = nil;
        if (self.modelDataGroupsKey != nil) rawGroupArray = [rawDictionary arrayForKey:self.modelDataGroupsKey];
        
        NSArray *groups = [self parseModelDataGroupsArray:rawGroupArray parentGroup:nil];
        
        IDLModelDataGroup *group = nil;
        
        NSString *groupID = nil;
        
        NSMutableDictionary *lookup = [NSMutableDictionary dictionaryWithCapacity:items.count];
        
        NSDictionary *groupLookup = [self generateGroupLookupDictionary:groups recursive:YES];
        
        NSArray *groupLookupKeys = [groupLookup allKeys];
        
        NSMutableArray *itemInferredGroups = [NSMutableArray array];
        
        for (NSString *itemGroupName in itemGroupNames) {
            if (![groupLookupKeys containsObject:itemGroupName]) {
                group = [IDLModelDataGroup new];
                group.name = itemGroupName;
                [itemInferredGroups addObject:group];
            }
        }
        
        if (itemInferredGroups.count > 0) {
            if (groups.count > 0) {
                groups = [groups arrayByAddingObjectsFromArray:itemInferredGroups];
            } else {
                groups = itemInferredGroups;
            }
            NSDictionary *inferredGroupLookup = [self generateGroupLookupDictionary:itemInferredGroups recursive:YES];
            
            if (groupLookup.count > 0) {
                NSMutableDictionary *combinedGroupLookup = [NSMutableDictionary dictionaryWithDictionary:groupLookup];
                [combinedGroupLookup addEntriesFromDictionary:inferredGroupLookup];
                groupLookup = [NSDictionary dictionaryWithDictionary:combinedGroupLookup];
            } else {
                groupLookup = inferredGroupLookup;
            }
        }
        
        for (item in items) {
            if (item.uid) [lookup setObject:item forKey:item.uid];
            
            groupID = ModelDataGroupID(item.group);
            group = [groupLookup objectForKey:item.group];
            if (group != nil) {
                if (group.items.count == 0) {
                    group.items = @[item];
                } else {
                    group.items = [group.items arrayByAddingObject:item];
                }
            } else {
                IDLLogContext(@"GROUP NOT FOUND: '%@' (THIS SHOULDN'T HAPPEN)",groupID);
            }
        }
        
        [self refreshSortOrders:groups groupSortOrder:0];
        
        _groups = groups;
        _groupLookupDictionary = groupLookup;
        _itemLookupDictionary = [NSDictionary dictionaryWithDictionary:lookup];
    }
}

-(NSDictionary *)itemLookupDictionary
{
    if (_itemLookupDictionary == nil) {
        [self checkModelDataLoaded];
    }
    return _itemLookupDictionary;
}

-(NSDictionary *)groupLookupDictionary
{
    if (_groupLookupDictionary == nil) {
        [self checkModelDataLoaded];
    }
    return _groupLookupDictionary;
}

-(NSArray *)groups
{
    if (_groups == nil) {
        [self checkModelDataLoaded];
    }
    return _groups;
}

-(IDLModelDataItem *)dataItemForUID:(NSString *)uid
{
    return [self dataItemForUID:uid skipHidden:NO];
}

-(IDLModelDataItem *)dataItemForUID:(NSString *)uid skipHidden:(BOOL)skipHidden
{
    IDLModelDataItem *item = [self.itemLookupDictionary objectForKey:uid];
    if (!skipHidden || !item.isHidden) {
        return item;
    } else {
        return nil;
    }
}

-(IDLModelDataGroup *)dataGroupForName:(NSString *)name
{
    return [self.groupLookupDictionary objectForKey:ModelDataGroupID(name)];
}

-(IDLModelDataGroup *)firstGroup
{
    return [self.groups firstObject];
}

-(NSArray *)dataGroupParents:(IDLModelDataGroup *)group
{
    if (group) {
        if (group.parentName) {
            NSMutableArray *groups = [NSMutableArray arrayWithObject:group];
            do {
                group = [self dataGroupForName:group.parentName];
                if (group) [groups insertObject:group atIndex:0];
            } while (group.parentName != nil);
            return [NSArray arrayWithArray:groups];
        } else {
            return @[group];
        }
    }
    return nil;
}

-(NSString *)nameForUID:(NSString *)uid
{
    return [self dataItemForUID:uid].name;
}

-(NSArray *)sortedDataItems
{
    if (_sortedDataItems == nil) {
        NSMutableArray *items = [NSMutableArray array];
        for (IDLModelDataGroup *group in self.groups) {
            NSArray *groupItems = [group sortedItems:YES];
            if (groupItems.count > 0) {
                [items addObjectsFromArray:groupItems];
            }
        }
        _sortedDataItems = [NSArray arrayWithArray:items];
    }
    return _sortedDataItems;
}

-(NSArray *)sortedDataItemsSkippingHidden
{
    if (_sortedDataItemsSkippingHidden == nil) {
        NSArray *sortedDataItems = self.sortedDataItems;
        NSMutableArray *array = [NSMutableArray array];
        for (IDLModelDataItem *dataItem in sortedDataItems) {
            if (!dataItem.isHidden) {
                [array addObject:dataItem];
            }
        }
        _sortedDataItemsSkippingHidden = [NSArray arrayWithArray:array];
    }
    return _sortedDataItemsSkippingHidden;
}

-(NSArray *)sortedUIDs
{
    if (_sortedUIDs == nil) {
        NSArray *sortedDataItems = self.sortedDataItems;
        NSMutableArray *array = [NSMutableArray array];
        for (IDLModelDataItem *dataItem in sortedDataItems) {
            [array addObject:dataItem.uid];
        }
        _sortedUIDs = [NSArray arrayWithArray:array];
    }
    return _sortedUIDs;
}

@end
