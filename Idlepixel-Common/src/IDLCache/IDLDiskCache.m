//
//  IDLDiskCache.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 18/12/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "IDLDiskCache.h"
#import "IDLImageData.h"
#import "NSData+Idlepixel.h"
#import "NSDictionary+Idlepixel.h"
#import "UIImage+Idlepixel.h"
#import "NSBundle+Idlepixel.h"

NSString * const kDiskCacheMetaDataFilename = @"DiskCache.meta";

@interface IDLDiskCacheMetaDataObject : IDLResourceCacheObject <NSCoding>

@property (nonatomic, strong) IDLImageData *imageData;
@property (nonatomic, assign) uint32_t CRC32;

@end

@implementation IDLDiskCacheMetaDataObject

#define kDiskCacheMetaDataObjectCoderObjectImageData        @"imageData"
#define kDiskCacheMetaDataObjectCoderObjectCRC32            @"CRC32"

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.imageData forKey:kDiskCacheMetaDataObjectCoderObjectImageData];
    [aCoder encodeInt64:self.CRC32 forKey:kDiskCacheMetaDataObjectCoderObjectCRC32];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.imageData = [aDecoder decodeObjectForKey:kDiskCacheMetaDataObjectCoderObjectImageData];
        self.CRC32 = (uint32_t)[aDecoder decodeInt32ForKey:kDiskCacheMetaDataObjectCoderObjectCRC32];
    }
    return self;
}

@end

@interface IDLDiskCacheMetaDataCollection : NSObject {
    @private
    NSMutableDictionary *dictionary;
}

@property (nonatomic, strong) NSData *previousArchiveMetaData;
@property (nonatomic, assign) NSTimeInterval previousSaveTime;

-(NSData *)archiveMetaData;
-(BOOL)unarchiveMetaData:(NSData *)data;

-(IDLDiskCacheMetaDataObject *)metaDataObjectForKey:(NSString *)key;
-(void)storeMetaDataObject:(IDLDiskCacheMetaDataObject *)object;
-(IDLDiskCacheMetaDataObject *)purgeMetaDataObjectWithKey:(NSString *)key;

@end

@interface IDLDiskCacheMetaDataCollection ()

@end

@implementation IDLDiskCacheMetaDataCollection

-(id)init
{
    self = [super init];
    if (self) {
        dictionary = [NSMutableDictionary new];
    }
    return self;
}

-(NSData *)archiveMetaData
{
    NSData *data = nil;
    @synchronized(self)
    {
        if ([dictionary count] > 0) {
            data = [NSKeyedArchiver archivedDataWithRootObject: dictionary];
        }
    }
    return data;
}

-(BOOL)unarchiveMetaData:(NSData *)data
{
    BOOL result = NO;
    @synchronized(self)
    {
        id unarchiveData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (unarchiveData != nil && [unarchiveData isKindOfClass:[NSDictionary class]]) {
            dictionary = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)unarchiveData];
            result = YES;
        } else {
            result = NO;
        }
    }
    return result;
}

-(IDLDiskCacheMetaDataObject *)metaDataObjectForKey:(NSString *)key
{
    return [dictionary objectForKey:key];
}

-(void)storeMetaDataObject:(IDLDiskCacheMetaDataObject *)object
{
    NSString *key = object.key;
    if (object != nil && key != nil) {
        [dictionary setObject:object forKey:key];
    }
}

-(IDLDiskCacheMetaDataObject *)purgeMetaDataObjectWithKey:(NSString *)key
{
    IDLDiskCacheMetaDataObject *object = nil;
    if (key != nil) {
        object = [dictionary objectForKey:key];
        if (object != nil) {
            [dictionary removeObjectForKey:key];
        }
    }
    return object;
}

@end

@interface IDLDiskCache ()

@property (nonatomic, strong) NSMutableDictionary *fileDataDictionary;
@property (nonatomic, strong) IDLDiskCacheMetaDataCollection *metaDataCollection;
@property (nonatomic, strong, readwrite) NSString *cacheDirectoryPath;
@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, assign) BOOL cacheMigrated;

- (NSError *)transferApplicationFile:(NSString *)sourcePath toCache:(NSString *)cachePath;
- (void)migrateCacheFilesFromApplicationBundle:(NSString *)internalCachePath;
- (BOOL)loadMetaData;

- (NSString *)cachePathForKey:(NSString*)key;

@end

@implementation IDLDiskCache

- (id)initWithDirectoryPath:(NSString *)cacheDirectoryPath
{
    self = [super init];
    if (self) {
        [self initialize];
        self.cacheDirectoryPath = cacheDirectoryPath;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.metaDataCollection = [IDLDiskCacheMetaDataCollection new];
    self.fileDataDictionary = [NSMutableDictionary dictionary];
}

- (void)setCacheDirectoryPath:(NSString *)cacheDirectoryPath
{
    if (_cacheDirectoryPath != cacheDirectoryPath) {
        _cacheDirectoryPath = cacheDirectoryPath;
        if (_cacheDirectoryPath.length > 0) {
            NSFileManager *fm = self.fileManager;
            if (![fm fileExistsAtPath:self.cacheDirectoryPath]) {
                [fm createDirectoryAtPath:self.cacheDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
        }
        [self loadMetaData];
    }
}

-(BOOL) loadMetaData
{
    NSData *metaData = [NSData dataWithContentsOfFile:[self.cacheDirectoryPath stringByAppendingPathComponent:kDiskCacheMetaDataFilename]];
    BOOL result = [self.metaDataCollection unarchiveMetaData:metaData];
    return result;
}

#define kSaveMetaDataQueue "saveMetaDataQueue"

-(void) saveMetaData
{
    //
    NSTimeInterval saveTime = self.currentSystemTimeInterval;
    NSData *previousMetaData = self.metaDataCollection.previousArchiveMetaData;
    NSString *metadataFilePath = [[self cacheDirectoryPath] stringByAppendingPathComponent:kDiskCacheMetaDataFilename];
    IDLDiskCacheMetaDataCollection *collection = self.metaDataCollection;
    
    
    dispatch_queue_t saveMetaDataQueue = dispatch_queue_create(kSaveMetaDataQueue, NULL);
    dispatch_async(saveMetaDataQueue, ^{
        NSData *metaData = collection.archiveMetaData;
        //
        if (metaData != previousMetaData && ![metaData isEqualToData:previousMetaData] && saveTime < collection.previousSaveTime) {
            
            BOOL result = [metaData writeToFile: metadataFilePath atomically: YES];
            if (result) {
                collection.previousArchiveMetaData = metaData;
                collection.previousSaveTime = saveTime;
            }
        }
    });
}

-(NSFileManager *)fileManager
{
    @synchronized(self)
    {
        if (_fileManager == nil) {
            _fileManager = [NSFileManager new];
        }
    }
    return _fileManager;
}

- (NSError *) transferApplicationFile:(NSString *)sourcePath toCache:(NSString *)cachePath
{
    
    NSError *error = nil;
    NSFileManager *fm = self.fileManager;
    
    [fm copyItemAtPath: sourcePath toPath: cachePath error: &error];
    return error;
}

- (void) migrateCacheFilesFromApplicationBundle:(NSString *)internalCachePath
{
    if (self.cacheMigrated) return;
    self.cacheMigrated = YES;
    
    [NSBundle migrateFilesFromBundlePath:internalCachePath installPath:[self cacheDirectoryPath]];
}

-(NSString *)cachePathForKey:(NSString *)key
{
    return [self.cacheDirectoryPath stringByAppendingPathComponent:key];
}

#define kSaveFileDataQueue "saveFileDataQueue"

- (void)storeFileData:(NSData *)fileData withKey:(NSString *)key
{
    if (fileData != nil && key != nil) {
        NSString *filePath = [self cachePathForKey:key];
        NSMutableDictionary *fileDictionary = self.fileDataDictionary;
        [fileDictionary setObject:fileData forKey:key];
        dispatch_queue_t saveFileDataQueue = dispatch_queue_create(kSaveFileDataQueue, NULL);
        dispatch_async(saveFileDataQueue, ^{
            //
            BOOL result = [fileData writeToFile: filePath atomically: YES];
            [fileDictionary removeObjectForKey:filePath];
            if (!result) {
                NSLog(@"COULD NOT SAVE DATA (size:%lu) TO %@",(unsigned long)fileData.length,filePath);
                [self purgeObjectForKey:key];
            }
        });
    }
}

- (NSData *)retrieveFileDataWithKey:(NSString *)key
{
    NSData *data = nil;
    if (key != nil) {
        data = [self.fileDataDictionary dataForKey:key];
        if (data == nil) {
            NSString *filePath = [self cachePathForKey:key];
            if (filePath != nil) {
                data = [NSData dataWithContentsOfFile:filePath];
            }
        }
    }
    return data;
}

- (void)purgeObjectForKey:(NSString *)key
{
    IDLDiskCacheMetaDataObject *object = [self.metaDataCollection purgeMetaDataObjectWithKey:key];
    if (object != nil) {
        NSString *path = [self cachePathForKey:key];
        [self.fileManager removeItemAtPath:path error:nil];
        [self saveMetaData];
    }
}

- (NSObject *)objectForKey:(NSString *)key
{
    IDLDiskCacheMetaDataObject *metaData = [self.metaDataCollection metaDataObjectForKey:key];
    NSObject *object = nil;
    if (metaData != nil) {
        NSData *fileData = [self retrieveFileDataWithKey:key];
        if (fileData != nil && metaData.type == IDLResourceCacheObjectTypeImage) {
            IDLImageData *imageData = [metaData.imageData copy];
            imageData.data = fileData;
            object = [UIImage imageWithImageData:imageData];
        } else {
            object = fileData;
        }
    }
    return object;
}

- (void)cacheObject:(NSObject *)object forKey:(NSString *)key withSize:(uint64_t)objectSize
{
    if (key == nil) return;
    
    IDLDiskCacheMetaDataObject *metaDataObject = [self.metaDataCollection metaDataObjectForKey:key];
    
    NSData *fileData = nil;
    IDLImageData *imageData = nil;
    
    IDLResourceCacheObjectType type = IDLResourceCacheObjectTypeUnknown;
    if ([object isKindOfClass:[UIImage class]]) {
        type = IDLResourceCacheObjectTypeImage;
        imageData = [IDLImageData dataWithImage:(UIImage *)object];
        fileData = imageData.data;
        imageData.data = nil;
        objectSize = fileData.length;
    } else if ([object isKindOfClass:[NSData class]]) {
        type = IDLResourceCacheObjectTypeData;
        fileData = (NSData *)object;
    }
    
    if (metaDataObject != nil) {
        uint32_t newCRC32 = fileData.CRC32;
        if (metaDataObject.type != type || metaDataObject.CRC32 != newCRC32 || metaDataObject.objectSize != objectSize) {
            [self purgeObject:metaDataObject];
            metaDataObject = nil;
        }
    }
    
    if (metaDataObject == nil) {
        metaDataObject = [IDLDiskCacheMetaDataObject new];
        metaDataObject.objectSize = objectSize;
        metaDataObject.key = key;
        metaDataObject.type = type;
        metaDataObject.imageData = imageData;
        [self.metaDataCollection storeMetaDataObject:metaDataObject];
        //
        [self storeFileData:fileData withKey:key];
    }
    metaDataObject.cacheTimeStamp = self.currentSystemTimeInterval;
    metaDataObject.accessTimeStamp = metaDataObject.cacheTimeStamp;
    //
    [self saveMetaData];
}

@end
