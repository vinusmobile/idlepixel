//
//  IDLModelDataManager.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 4/04/2014.
//  Copyright (c) 2014 Trystan Pfluger. All rights reserved.
//

#import "IDLAbstractSharedSingleton.h"
#import "IDLModelObjectProtocols.h"

extern NSString * const IDLDefaultPersistentModelDataFolder;
extern NSString * const IDLDefaultBundleModelDataFolder;
extern NSString * const IDLDefaultModelDataArchiveFolder;

extern NSString * const IDLDefaultPersistentFieldStoreFilename;


@interface IDLModelDataManager : IDLAbstractSharedSingleton

+(instancetype)sharedManager;

@property (nonatomic, strong) NSString *persistentModelDataFolder;
@property (nonatomic, strong) NSString *bundleModelDataFolder;
@property (nonatomic, strong) NSString *modelDataArchiveFolder;

@property (nonatomic, strong) NSString *persistentFieldStoreFilename;

- (NSString *)bundleModelDataFolderPath;
- (NSString *)persistentModelDataPathForFilename:(NSString *)filename includeBundleFallback:(BOOL)includeBundleFallback;

- (void)savePersistentModelData:(NSObject<IDLPersistentModelObject> *)modelObject toFilename:(NSString *)filename usePlistFormat:(BOOL)plistFormat protectContents:(BOOL)protectContents;

- (NSObject<IDLPersistentModelObject> *)loadModelDataWithFilename:(NSString *)filename includeBundleFallback:(BOOL)includeBundleFallback requiredClass:(Class)requiredClass;
- (NSObject<IDLPersistentModelObject> *)loadPropertyListModelDataWithFilename:(NSString *)filename requiredClass:(Class)requiredClass;

- (NSString *)modelDataPathForFilename:(NSString *)filename inBundle:(BOOL)inBundle;

- (void)writeData:(NSData *)data toFilepath:(NSString *)filepath protectContents:(BOOL)protectContents;
- (NSData *)readDataFromFilepath:(NSString *)filepath;

- (NSString *)uniqueModelDataArchiveFilepath;

@end
