//
//  IDLModelDataManager.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 4/04/2014.
//  Copyright (c) 2014 Trystan Pfluger. All rights reserved.
//

#import "IDLModelDataManager.h"
#import "IDLCategoryFoundationHeaders.h"
#import "IDLNSInlineExtensions.h"
#import "UIApplication+Idlepixel.h"

#define kSaveModelQueue                                         "savePersistenModelData"

NSString * const IDLDefaultPersistentModelDataFolder            = @"Model";
NSString * const IDLDefaultBundleModelDataFolder                = @"Model.bundle";
NSString * const IDLDefaultModelDataArchiveFolder               = @"Model/Archive";

NSString * const IDLDefaultPersistentFieldStoreFilename         = @"PersistentFields.plist";


@interface IDLModelDataManager ()

@property (nonatomic, strong) NSMutableDictionary *savedPersistentModelDataHashes;

- (void)internal_writeData:(NSData *)data toFilepath:(NSString *)filepath protectContents:(BOOL)protectContents;

@end

@implementation IDLModelDataManager

+(instancetype)sharedManager
{
    return [self preferredSingleton];
}

- (NSString *)persistentModelDataFolder
{
    if (_persistentModelDataFolder != nil) {
        return _persistentModelDataFolder;
    } else {
        return IDLDefaultPersistentModelDataFolder;
    }
}

- (NSString *)bundleModelDataFolder
{
    if (_bundleModelDataFolder != nil) {
        return _bundleModelDataFolder;
    } else {
        return IDLDefaultBundleModelDataFolder;
    }
}

- (NSString *)modelDataArchiveFolder
{
    if (_modelDataArchiveFolder != nil) {
        return _modelDataArchiveFolder;
    } else {
        return IDLDefaultModelDataArchiveFolder;
    }
}

- (NSString *)persistentFieldStoreFilename
{
    if (_persistentFieldStoreFilename != nil) {
        return _persistentFieldStoreFilename;
    } else {
        return IDLDefaultPersistentFieldStoreFilename;
    }
}

- (NSString *)modelDataPathForFilename:(NSString *)filename inBundle:(BOOL)inBundle
{
    if ([filename length] > 0) {
        
        if (!inBundle) {
            NSFileManager *fm = [NSFileManager defaultManager];
            NSString *supportPath = [[[UIApplication sharedApplication] applicationSupportPath] stringByAppendingPathComponent:[self persistentModelDataFolder]];
            if (![fm fileExistsAtPath:supportPath]) {
                [fm createDirectoryAtPath:supportPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            return [supportPath stringByAppendingPathComponent: filename];
        } else {
            return [[self bundleModelDataFolderPath] stringByAppendingPathComponent:filename];
        }
    } else {
        return nil;
    }
}

- (NSString *)bundleModelDataFolderPath
{
    return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[self bundleModelDataFolder]];
}

- (NSString *)persistentModelDataPathForFilename:(NSString *)filename includeBundleFallback:(BOOL)includeBundleFallback
{
    if ([filename length] > 0) {
        NSString *path = [self modelDataPathForFilename:filename inBundle:NO];
        
        if (includeBundleFallback) {
            NSFileManager *fm = [NSFileManager defaultManager];
            if (![fm fileExistsAtPath:path]) {
                path = [self modelDataPathForFilename:filename inBundle:YES];
            }
        }
        return path;
    } else {
        return nil;
    }
}

static dispatch_queue_t IDLModelDataManager_saveModelQueue = NULL;

- (void)savePersistentModelData:(NSObject<IDLPersistentModelObject> *)modelObject toFilename:(NSString *)filename usePlistFormat:(BOOL)plistFormat protectContents:(BOOL)protectContents
{
    if (filename.length != 0) {
        if (IDLModelDataManager_saveModelQueue == NULL) {
            IDLModelDataManager_saveModelQueue = dispatch_queue_create(kSaveModelQueue, DISPATCH_QUEUE_SERIAL);
        }
        
        NSString *filePath = [self persistentModelDataPathForFilename:filename includeBundleFallback:NO];
        
        NSMutableDictionary *savedPersistentModelDataHashes = self.savedPersistentModelDataHashes;
        if (savedPersistentModelDataHashes == nil) {
            savedPersistentModelDataHashes = [NSMutableDictionary new];
            self.savedPersistentModelDataHashes = savedPersistentModelDataHashes;
        }
        
        if (filePath.length > 0) {
            
            dispatch_async(IDLModelDataManager_saveModelQueue, ^{
                
                NSData *data = nil;
                NSDictionary *dictionary = nil;
                
                if (modelObject != nil) {
                    @synchronized(modelObject) {
                        if (!plistFormat) {
                            data = [NSKeyedArchiver archivedDataWithRootObject:modelObject];
                        } else {
                            dictionary = [modelObject plistRepresentation];
                        }
                    }
                }
                
                BOOL matchingHashes = NO;
                
                NSString *existingHash = [savedPersistentModelDataHashes stringForKey:filePath];
                NSString *newHash = nil;
                if (!plistFormat) {
                    newHash = data.md5Hash;
                    if (!NSStringEquals(existingHash, newHash) || newHash == nil) {
                        if (newHash != nil) {
                            [savedPersistentModelDataHashes setObject:newHash forKey:filePath];
                        } else {
                            [savedPersistentModelDataHashes removeObjectForKey:filePath];
                        }
                    } else {
                        matchingHashes = YES;
                    }
                }
                
                if (!matchingHashes) {
                    if (!plistFormat) {
                        [self internal_writeData:data toFilepath:filePath protectContents:protectContents];
                    } else {
                        @try {
                            if (dictionary == nil) dictionary = [NSDictionary dictionary];
                            [dictionary writeToFile:filePath atomically:YES];
                            if (protectContents) {
                                NSFileManager *fm = [NSFileManager defaultManager];
                                NSDictionary *fileAttributes = [NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey];
                                [fm setAttributes:fileAttributes ofItemAtPath:filePath error:nil];
                            }
                            //NSLog(@"##~~ DATA SAVED: %@",filename);
                        } @catch (NSException *exception) {
                            NSLog(@"UNABLE TO SAVE MODEL DATA TO '%@':\n%@", filename, exception);
                        }
                    }
                }
            });
        }
    }
}

- (void)writeData:(NSData *)data toFilepath:(NSString *)filepath protectContents:(BOOL)protectContents
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *filepathFolder = [filepath stringByDeletingLastPathComponent];
    if (![fm fileExistsAtPath:filepathFolder]) {
        [fm createDirectoryAtPath:filepathFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (IDLModelDataManager_saveModelQueue == NULL) {
        IDLModelDataManager_saveModelQueue = dispatch_queue_create(kSaveModelQueue, DISPATCH_QUEUE_SERIAL);
    }
    dispatch_async(IDLModelDataManager_saveModelQueue, ^{
        [self internal_writeData:data toFilepath:filepath protectContents:protectContents];
    });
}

- (void)internal_writeData:(NSData *)data toFilepath:(NSString *)filepath protectContents:(BOOL)protectContents
{
    @try {
        if (data == nil) data = [NSData data];
        NSDataWritingOptions options = NSDataWritingAtomic;
        if (protectContents) {
            options = options | NSDataWritingFileProtectionComplete;
        }
        [data writeToFile:filepath options:options error:nil];
        //NSLog(@"##~~ DATA SAVED: %@",filename);
    } @catch (NSException *exception) {
        NSLog(@"UNABLE TO SAVE DATA TO '%@':\n%@", filepath, exception);
    }
}

- (NSData *)readDataFromFilepath:(NSString *)filepath
{
    NSData *data = nil;
    @try {
        data = [NSData dataWithContentsOfFile:filepath options:NSDataReadingUncached error:nil];
        //NSLog(@"##~~ DATA SAVED: %@",filename);
    } @catch (NSException *exception) {
        NSLog(@"UNABLE TO READ DATA FROM '%@':\n%@", filepath, exception);
    }
    return data;
}

- (NSString *)uniqueModelDataArchiveFilepath
{
    NSString *uuid = NSStringUniversalUniqueID();
    
    NSString *path = [[[UIApplication sharedApplication] applicationSupportPath] stringByAppendingPathComponent:[self modelDataArchiveFolder]];
    path = [path stringByAppendingPathComponent:uuid];
    path = [path stringByAppendingPathExtension:@"archive"];
    
    IDLLogObject(path);
    
    return path;
}

- (NSObject<IDLPersistentModelObject> *)loadModelDataWithFilename:(NSString *)filename includeBundleFallback:(BOOL)includeBundleFallback requiredClass:(__unsafe_unretained Class)requiredClass
{
    NSObject<IDLPersistentModelObject> *data = nil;
    @try {
        NSString *path = [self persistentModelDataPathForFilename:filename includeBundleFallback:includeBundleFallback];
        //IDLLog(@"ARCHIVER PATH: %@", path);
        data = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (data != nil) {
            if (requiredClass == nil || [(NSObject *)data isKindOfClass:requiredClass]) {
                //IDLLog(@"SUCCESS!");
                return data;
            }
        }
    }
    @catch (NSException *exception) {
        data = nil;
        if (includeBundleFallback) {
            data = [self loadPropertyListModelDataWithFilename:filename requiredClass:requiredClass];
        }
        if (data != nil) {
            //IDLLog(@"SUCCESS!");
            return data;
        } else {
            IDLLog(@"EXCEPTION DURING LOAD: %@", exception);
        }
        
    }
    //IDLLog(@"UNABLE TO LOAD MODEL DATA FROM: %@", filename);
    return nil;
}

- (NSObject<IDLPersistentModelObject> *)loadPropertyListModelDataWithFilename:(NSString *)filename requiredClass:(Class)requiredClass
{
    NSObject<IDLPersistentModelObject> *data = nil;
    if ([requiredClass conformsToProtocol:@protocol(IDLPersistentModelObject)]) {
        @try {
            NSString *path = [self modelDataPathForFilename:filename inBundle:YES];
            //IDLLog(@"DICTIONARY PATH: %@", path);
            if (path != nil) {
                NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
                if (dictionary != nil) {
                    data = [(NSObject<IDLPersistentModelObject> *)[requiredClass alloc] initWithDictionaryRepresentation:dictionary];
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"EXCEPTION DURING PLIST LOAD: %@", exception);
        }
    }
    if (data != nil) {
        //IDLLog(@"SUCCESS!");
    }
    //NSLog(@"UNABLE TO LOAD MODEL DATA FROM: %@", filename);
    return data;
}

@end
