//
//  IDLDiskCache.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 18/12/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "IDLResourceCache.h"

extern NSString * const kDiskCacheMetaDataFilename;

@interface IDLDiskCache : IDLResourceCache

@property (nonatomic, strong, readonly) NSString *cacheDirectoryPath;

- (id)initWithDirectoryPath:(NSString *)cacheDirectoryPath;
- (void)migrateCacheFilesFromApplicationBundle:(NSString *)internalCachePath;

@end
