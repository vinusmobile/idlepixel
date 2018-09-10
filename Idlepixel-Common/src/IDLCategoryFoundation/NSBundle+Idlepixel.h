//
//  NSBundle+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 2/09/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLTypedefs.h"

extern NSString * const kUniqueIdentifierUndefined;

extern NSString * const kBinaryModificationDateStringUndefined;

@interface NSBundle (IDLVersion)

@property (readonly) NSString *bundleVersion;
@property (readonly) NSString *bundleVersionShort;
@property (readonly) NSString *bundleVersionFull;
@property (readonly) NSString *bundleVersionFullHash;

@end

@interface NSBundle (IDLBundleProperties)

@property (readonly) NSString *bundleDisplayName;

@end

@interface NSBundle (IDLBinaryProperties)

+ (NSString *)binaryName;
+ (NSString *)binaryPath;
+ (NSString *)binaryHash;
+ (NSData *)binaryData;
+ (NSUInteger)binarySize;
+ (NSDictionary *)binaryAttributes;
+ (NSDictionary *)binaryFileSystemAttributes;
+ (NSDate *)binaryModificationDate;
+ (NSString *)binaryModificationDateString;

+ (NSString *)applicationName;
+ (NSString *)applicationPath;
+ (NSArray *)applicationFolderContents;

@end

@interface NSBundle (IDLNibResource)

- (NSString *)pathForNibResource:(NSString *)name;

- (id)loadNibObjectWithClass:(Class)resourceClass fromNibNamed:(NSString *)name;

@end

@interface NSBundle (IDLIdentifier)

+ (NSString *)uniqueBundleIdentifier;
+ (NSString *)uniqueBundleVersionIdentifier;
+ (NSString *)uniqueDeviceIdentifier;
+ (NSString *)uniqueDeviceBundleIdentifier;
+ (NSString *)uniqueVersionIdentifier;
+ (NSString *)uniqueLaunchIdentifier;

- (NSString *) uniqueIdentifierWithPrecision:(IDLIdentifierPrecision)precision;

@property (readonly) NSString *uniqueBundleIdentifier;
@property (readonly) NSString *uniqueBundleVersionIdentifier;
@property (readonly) NSString *uniqueDeviceIdentifier;
@property (readonly) NSString *uniqueDeviceBundleIdentifier;
@property (readonly) NSString *uniqueVersionIdentifier;
@property (readonly) NSString *uniqueLaunchIdentifier;

@end

@interface NSBundle (IDLFileMigration)

+ (NSInteger)migrateFilesFromBundlePath:(NSString *)bundlePath installPath:(NSString *)installPath;

@end
