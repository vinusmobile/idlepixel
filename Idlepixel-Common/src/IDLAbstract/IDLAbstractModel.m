//
//  IDLAbstractModel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 7/10/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "IDLAbstractModel.h"
#import "UIApplication+Idlepixel.h"
#import "IDLDateKeeper.h"
#import "IDLLoggingMacros.h"
#import "NSDictionary+Idlepixel.h"
#import "NSData+Idlepixel.h"
#import "IDLMacroHeaders.h"
#import "IDLNSInlineExtensions.h"

#define kPersistentModelDataNeedsToSaveDelay    0.1f

NSString * const IDLModelNotificationPersisentModelDataLoaded   = @"IDLModelNotificationPersisentModelDataLoaded";

@interface IDLAbstractModel ()

@property (nonatomic, strong, readwrite) IDLPersistentFieldStore *persistentFieldStore;

@property (nonatomic, strong, readwrite) IDLDateKeeper *dateKeeper;

@property (nonatomic, assign, readwrite) BOOL persistentModelDataLoaded;
@property (nonatomic, assign, readwrite) BOOL persistentModelDataNeedsToSave;
@property (nonatomic, assign, readwrite) NSTimeInterval lastPersistentModelDataSaveTimeStamp;

@end

@implementation IDLAbstractModel

+ (instancetype)sharedModel
{
    return [self preferredSingleton];
}

+ (BOOL)isPreferredSingletonClass
{
    return NO;
}

- (void)configure
{
    [super configure];
    self.persistentModelDataNeedsToSaveDefaultDelay = kPersistentModelDataNeedsToSaveDelay;
}

#pragma mark - Persistence

-(IDLModelDataManager *)modelDataManager
{
    return [IDLModelDataManager sharedManager];
}

- (NSString *)persistentModelDataPathForFilename:(NSString *)filename includeBundleFallback:(BOOL)includeBundleFallback
{
    return [self.modelDataManager persistentModelDataPathForFilename:filename includeBundleFallback:includeBundleFallback];
}

- (NSString *)bundleModelDataFolderPath
{
    return [self.modelDataManager bundleModelDataFolderPath];
}

- (NSObject<IDLPersistentModelObject> *)loadModelDataWithFilename:(NSString *)filename includeBundleFallback:(BOOL)includeBundleFallback requiredClass:(__unsafe_unretained Class)requiredClass
{
    return [self.modelDataManager loadModelDataWithFilename:filename includeBundleFallback:includeBundleFallback requiredClass:requiredClass];
}

- (void)savePersistentModelData:(NSObject<IDLPersistentModelObject> *)modelObject toFilename:(NSString *)filename
{
    [self savePersistentModelData:modelObject toFilename:filename usePlistFormat:NO];
}

- (void)savePersistentModelData:(NSObject<IDLPersistentModelObject> *)modelObject toFilename:(NSString *)filename protectContents:(BOOL)protectContents
{
    [self savePersistentModelData:modelObject toFilename:filename usePlistFormat:NO protectContents:protectContents];
}

- (void)savePersistentModelData:(NSObject<IDLPersistentModelObject> *)modelObject toFilename:(NSString *)filename usePlistFormat:(BOOL)plistFormat;
{
    [self savePersistentModelData:modelObject toFilename:filename usePlistFormat:plistFormat protectContents:self.protectPersistentModelData];
}

- (void)savePersistentModelData:(NSObject<IDLPersistentModelObject> *)modelObject toFilename:(NSString *)filename usePlistFormat:(BOOL)plistFormat protectContents:(BOOL)protectContents
{
    [self.modelDataManager savePersistentModelData:modelObject toFilename:filename usePlistFormat:plistFormat protectContents:protectContents];
}

- (void)loadPersistentModelData
{
    IDLPersistentFieldStore *persistentFieldStore = (IDLPersistentFieldStore *)[self loadModelDataWithFilename:[self.modelDataManager persistentFieldStoreFilename] includeBundleFallback:YES requiredClass:[IDLPersistentFieldStore class]];
    if ([persistentFieldStore isKindOfClass:[IDLPersistentFieldStore class]]) {
        _persistentFieldStore = persistentFieldStore;
    }
}

- (void)setPersistentModelDataNeedsToSaveDefaultDelay:(NSTimeInterval)defaultDelay
{
    if (defaultDelay < 0.0f) {
        defaultDelay = kPersistentModelDataNeedsToSaveDelay;
    }
    _persistentModelDataNeedsToSaveDefaultDelay = defaultDelay;
}

- (void)setPersistentModelDataNeedsToSave
{
    [self setPersistentModelDataNeedsToSaveWithDelay:self.persistentModelDataNeedsToSaveDefaultDelay];
}

- (void)setPersistentModelDataNeedsToSaveWithDelay:(NSTimeInterval)delay
{
    self.persistentModelDataNeedsToSave = YES;
    [self performSelector:@selector(checkPersistentModelDataNeedsToSave:) withObject:@(SystemTimeSinceSystemStartup()) afterDelay:MAX(delay, 0.0f)];
}

- (void)checkPersistentModelDataNeedsToSave:(NSNumber *)checkRequestTimeStamp
{
    if (self.persistentModelDataNeedsToSave && (checkRequestTimeStamp == nil || checkRequestTimeStamp.floatValue > self.lastPersistentModelDataSaveTimeStamp)) {
        [self savePersistentModelData];
    } else {
        //IDLLog(@"*** IDLAbstractModel : Ignoring savePersistentModelData call made before the last save.");
    }
}

- (void)savePersistentModelData
{
    [self savePersistentModelData:NO];
}

- (void)savePersistentModelData:(BOOL)force
{
    self.persistentModelDataNeedsToSave = NO;
    self.lastPersistentModelDataSaveTimeStamp = SystemTimeSinceSystemStartup();
    if (_persistentFieldStore.count > 0) {
        [self savePersistentModelData:_persistentFieldStore toFilename:[self.modelDataManager persistentFieldStoreFilename]];
    }
}

#pragma mark - Launch

- (void)performLaunchOperations
{
    [self loadPersistentModelData];
    if (!self.persistentModelDataLoaded) {
        self.persistentModelDataLoaded = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:IDLModelNotificationPersisentModelDataLoaded object:nil];
    }
}

#pragma mark - Persistent Fields

- (IDLPersistentFieldStore *)persistentFieldStore
{
    if (_persistentFieldStore == nil) {
        _persistentFieldStore = [IDLPersistentFieldStore new];
    }
    return _persistentFieldStore;
}

#pragma mark - Date / Time

- (NSDate*)currentDate
{
    NSDate *date = [self.dateKeeper currentDate];
    if (date == nil) {
        date = [NSDate date];
    }
    return date;
}

#pragma mark Date

- (IDLDateKeeper *)dateKeeper
{
    if (_dateKeeper == nil) {
        _dateKeeper = [IDLDateKeeper new];
    }
    return _dateKeeper;
}

@end
