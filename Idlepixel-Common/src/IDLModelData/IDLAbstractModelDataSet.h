//
//  IDLAbstractModelDataSet.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 4/04/2014.
//  Copyright (c) 2014 Trystan Pfluger. All rights reserved.
//

#import "IDLAbstractManager.h"

@class IDLModelDataItem, IDLModelDataGroup;

@interface IDLAbstractModelDataSet : IDLAbstractManager

+(instancetype)modelDataSetWithFilename:(NSString *)filename;
+(instancetype)modelDataSetWithPath:(NSString *)path;

-(id)initWithFilename:(NSString *)filename;
-(id)initWithPath:(NSString *)path;

@property (nonatomic, strong, readonly) NSString *sourceFilename;
@property (nonatomic, strong, readonly) NSString *sourcePath;

-(NSString *)modelDataItemsKey;
-(NSString *)modelDataGroupsKey;
-(Class)modelDataItemClass;

-(NSArray *)parseModelDataItemsArray:(NSArray *)rawItemArray;
-(NSArray *)parseModelDataGroupsArray:(NSArray *)rawGroupArray parentGroup:(IDLModelDataGroup *)parentGroup;

-(void)parseModelData:(NSDictionary *)rawDictionary;

-(IDLModelDataItem *)itemForDictionary:(NSDictionary *)dictionary sortOrder:(NSInteger)sortOrder;

-(NSString *)nameForUID:(NSString *)uid;

-(IDLModelDataItem *)dataItemForUID:(NSString *)uid;
-(IDLModelDataItem *)dataItemForUID:(NSString *)uid skipHidden:(BOOL)skipHidden;

-(IDLModelDataGroup *)dataGroupForName:(NSString *)name;

-(NSArray *)dataGroupParents:(IDLModelDataGroup *)group;

@property (nonatomic, strong, readonly) NSArray *sortedUIDs;
@property (nonatomic, strong, readonly) NSArray *sortedDataItems;
@property (nonatomic, strong, readonly) NSArray *sortedDataItemsSkippingHidden;

@property (readonly) IDLModelDataGroup *firstGroup;

@end
