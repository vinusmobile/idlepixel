//
//  IDLAbstractModel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 7/10/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLModelObjectProtocols.h"
#import "IDLDateKeeper.h"
#import "IDLPersistentFieldStore.h"
#import "IDLAbstractSharedSingleton.h"
#import "IDLModelDataManager.h"

extern NSString * const IDLModelNotificationPersisentModelDataLoaded;

@interface IDLAbstractModel : IDLAbstractSharedSingleton

+ (instancetype)sharedModel;

@property (readonly) IDLModelDataManager *modelDataManager;

- (NSString *)bundleModelDataFolderPath;
- (NSString *)persistentModelDataPathForFilename:(NSString *)filename includeBundleFallback:(BOOL)includeBundleFallback;

- (void)savePersistentModelData:(NSObject<IDLPersistentModelObject> *)modelObject toFilename:(NSString *)filename;
- (void)savePersistentModelData:(NSObject<IDLPersistentModelObject> *)modelObject toFilename:(NSString *)filename protectContents:(BOOL)protectContents;
- (void)savePersistentModelData:(NSObject<IDLPersistentModelObject> *)modelObject toFilename:(NSString *)filename usePlistFormat:(BOOL)plistFormat;
- (void)savePersistentModelData:(NSObject<IDLPersistentModelObject> *)modelObject toFilename:(NSString *)filename usePlistFormat:(BOOL)plistFormat protectContents:(BOOL)protectContents;

- (NSObject<IDLPersistentModelObject> *)loadModelDataWithFilename:(NSString *)filename includeBundleFallback:(BOOL)includeBundleFallback requiredClass:(Class)requiredClass;

@property (nonatomic, assign, readonly) BOOL persistentModelDataLoaded;
@property (nonatomic, assign, readonly) BOOL persistentModelDataNeedsToSave;
@property (nonatomic, assign, readwrite) NSTimeInterval persistentModelDataNeedsToSaveDefaultDelay;
@property (nonatomic, assign, readonly) NSTimeInterval lastPersistentModelDataSaveTimeStamp;

- (void)checkPersistentModelDataNeedsToSave:(NSNumber *)checkRequestTimeStamp;

- (void)performLaunchOperations;
- (void)loadPersistentModelData;
- (void)setPersistentModelDataNeedsToSave;
- (void)setPersistentModelDataNeedsToSaveWithDelay:(NSTimeInterval)delay;
- (void)savePersistentModelData;
- (void)savePersistentModelData:(BOOL)force;

@property (readonly) BOOL protectPersistentModelData;

@property (nonatomic, readonly) NSDate *currentDate;

@property (nonatomic, strong, readonly) IDLPersistentFieldStore *persistentFieldStore;

@property (nonatomic, strong, readonly) IDLDateKeeper *dateKeeper;

@end
