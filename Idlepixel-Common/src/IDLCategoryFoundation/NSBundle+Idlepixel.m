//
//  NSBundle+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 2/09/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "NSBundle+Idlepixel.h"
#import "NSString+Idlepixel.h"
#import "NSData+Idlepixel.h"
#import "NSDictionary+Idlepixel.h"
#import "IDLDeviceInformation.h"

NSString * const kUniqueIdentifierUndefined = @"undefined";

NSString * const kBinaryModificationDateStringUndefined = @"undefined";

@implementation NSBundle (IDLVersion)

- (NSString *)bundleVersion
{
	NSString *ver = [self objectForInfoDictionaryKey:@"CFBundleVersion"];
	if (ver == nil) {
		ver = @"0.0.0";
    }
	return ver;
}

- (NSString *)bundleVersionShort
{
    NSString *ver = [self objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
	if (ver == nil) {
		ver = @"0.0";
    }
	return ver;
}

- (NSString *)bundleVersionFull
{
	NSString *version = [self bundleVersion];
    NSString *modificationDate = NSBundle.binaryModificationDateString;
	if (modificationDate.length == 0) {
		return version;
    } else {
		return [NSString stringWithFormat:@"%@.%@", version, modificationDate];
    }
}

- (NSString *)bundleVersionFullHash
{
    return [[self bundleVersionFull] md5Hash];
}

@end

@implementation NSBundle (IDLBundleProperties)

-(NSString *)bundleDisplayName
{
    return [self.infoDictionary stringForKey:@"CFBundleDisplayName"];
}

@end

@implementation NSBundle (IDLBinaryProperties)

+ (NSString *)binaryName
{
    return [[self.applicationName componentsSeparatedByString:@"."] objectAtIndex:0];
}

+ (NSString *)binaryPath
{
    return [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:self.binaryName];
}

+ (NSString *)binaryHash
{
    return self.binaryData.md5Hash;
}

+ (NSData *)binaryData
{
    return [NSData dataWithContentsOfFile:self.binaryPath options:NSDataReadingUncached error:NULL];
}

+ (NSUInteger)binarySize
{
    return [self.binaryAttributes unsignedIntegerForKey:NSFileSize];
}

+ (NSDictionary *)binaryAttributes
{
    return [[NSFileManager defaultManager] attributesOfItemAtPath:self.binaryPath error:NULL];
}

+ (NSDictionary *)binaryFileSystemAttributes
{
    return [[NSFileManager defaultManager] attributesOfFileSystemForPath:self.binaryPath error:NULL];
}

+ (NSDate *)binaryModificationDate
{
    return [NSBundle.binaryAttributes dateForKey:NSFileModificationDate];
}

+ (NSString *)binaryModificationDateString
{
    static NSString *binaryModificationDateString = nil;
    if (binaryModificationDateString == nil) {
        NSDate *modDate = self.binaryModificationDate;
        if (modDate != nil) {
            UInt64 referenceTime = floor(modDate.timeIntervalSinceReferenceDate);
            binaryModificationDateString = [NSString stringWithFormat:@"%llu",referenceTime];
        } else {
            binaryModificationDateString = kBinaryModificationDateStringUndefined;
        }
    }
    return binaryModificationDateString;
}

+ (NSString *)applicationName
{
    return self.applicationPath.lastPathComponent;
}

+ (NSString *)applicationPath
{
    return [NSBundle mainBundle].bundlePath;
}

+ (NSArray *)applicationFolderContents
{
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.applicationPath error:NULL];
}

@end

@implementation NSBundle (IDLNibResource)

- (NSString *)pathForNibResource:(NSString *)name
{
    NSString *path = nil;
    if ([name length] > 0) {
        path = [self pathForResource:name ofType:@"nib"];
        if (path == nil) {
            path = [self pathForResource:name ofType:@"xib"];
        }
    }
    return path;
}

- (id)loadNibObjectWithClass:(Class)resourceClass fromNibNamed:(NSString *)name
{
    NSArray *nibContents = [self loadNibNamed:name owner:nil options:nil];
    for (NSObject *object in nibContents) {
        if ([object isKindOfClass:resourceClass]) {
            return object;
        }
    }
    return nil;
}

@end

@implementation NSBundle (IDLIdentifier)

+ (NSString *)uniqueBundleIdentifier
{
    return [NSBundle mainBundle].uniqueBundleIdentifier;
}

+ (NSString *)uniqueBundleVersionIdentifier
{
    return [NSBundle mainBundle].uniqueBundleVersionIdentifier;
}

+ (NSString *)uniqueDeviceIdentifier
{
    return [NSBundle mainBundle].uniqueDeviceIdentifier;
}

+ (NSString *)uniqueDeviceBundleIdentifier
{
    return [NSBundle mainBundle].uniqueDeviceBundleIdentifier;
}

+ (NSString *)uniqueVersionIdentifier
{
    return [NSBundle mainBundle].uniqueVersionIdentifier;
}

+ (NSString *)uniqueLaunchIdentifier
{
    return [NSBundle mainBundle].uniqueLaunchIdentifier;
}

- (NSString *)uniqueIdentifierWithPrecision:(IDLIdentifierPrecision)precision
{
    if (precision != IDLIdentifierPrecisionNone) {
        NSMutableArray *inputs = [NSMutableArray array];
        if (precision & IDLIdentifierPrecisionBundle) {
            [inputs addObject:[[NSBundle mainBundle] bundleIdentifier]];
        }
        if (precision & IDLIdentifierPrecisionDevice) {
            [inputs addObject:[[UIDevice currentDevice] identifierForVendor].UUIDString];
        }
        if (precision & IDLIdentifierPrecisionVersion) {
            [inputs addObject:[[NSBundle mainBundle] bundleVersion]];
        }
        if (precision & IDLIdentifierPrecisionLaunch) {
            [inputs addObject:[[NSProcessInfo processInfo] globallyUniqueString]];
        }
        if (inputs.count > 0) {
            NSString *identifierString = [inputs componentsJoinedByString:@"||"];
            return [identifierString md5Hash];
        }
    }
    return kUniqueIdentifierUndefined;
}

- (NSString *)uniqueBundleIdentifier
{
    static NSString *identifier = nil;
    if (!identifier) {
        identifier = [self uniqueIdentifierWithPrecision:(IDLIdentifierPrecisionBundle)];
    }
    return identifier;
}

- (NSString *)uniqueBundleVersionIdentifier
{
    static NSString *identifier = nil;
    if (!identifier) {
        identifier = [self uniqueIdentifierWithPrecision:(IDLIdentifierPrecisionBundle | IDLIdentifierPrecisionVersion)];
    }
    return identifier;
}

- (NSString *)uniqueDeviceIdentifier
{
    static NSString *identifier = nil;
    if (!identifier) {
        identifier = [self uniqueIdentifierWithPrecision:(IDLIdentifierPrecisionDevice)];
    }
    return identifier;
}

- (NSString *)uniqueDeviceBundleIdentifier
{
    static NSString *identifier = nil;
    if (!identifier) {
        identifier = [self uniqueIdentifierWithPrecision:(IDLIdentifierPrecisionDevice | IDLIdentifierPrecisionBundle)];
    }
    return identifier;
}

- (NSString *)uniqueVersionIdentifier
{
    static NSString *identifier = nil;
    if (!identifier) {
        identifier = [self uniqueIdentifierWithPrecision:(IDLIdentifierPrecisionDevice | IDLIdentifierPrecisionBundle | IDLIdentifierPrecisionVersion)];
    }
    return identifier;
}

- (NSString *)uniqueLaunchIdentifier
{
    static NSString *launchIdentifier = nil;
    
    @synchronized (self)
    {
        if (launchIdentifier == nil) {
            launchIdentifier = [self uniqueIdentifierWithPrecision:(IDLIdentifierPrecisionDevice | IDLIdentifierPrecisionLaunch)];
        }
    }
    return launchIdentifier;
}

@end

@implementation NSBundle (IDLFileMigration)

+ (NSInteger)migrateFilesFromBundlePath:(NSString *)bundlePath installPath:(NSString *)installPath
{
    if (bundlePath.length == 0 || installPath.length == 0) {
        IDLLog(@"COULD NOT MIGRATE FILES '%@' TO '%@'", bundlePath, installPath);
        return -1;
    }
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSError *error = nil;
    NSArray *bundleFiles = [fm contentsOfDirectoryAtPath:bundlePath error:&error];
    
    if (error) {
        IDLLog(@"MIGRATION ERROR (CRITICAL): %@",error);
        return -1;
    } else if (bundleFiles.count == 0) {
        IDLLog(@"NO FILES TO MIGRATE");
        return 0;
    }
    
    NSString *destinationPath;
    NSString *sourcePath;
    NSInteger transferCount = 0;
    for (NSString *bundleFile in bundleFiles) {
        destinationPath = [installPath stringByAppendingPathComponent: [[bundleFile pathComponents] lastObject]];
        sourcePath = [bundlePath stringByAppendingPathComponent: [[bundleFile pathComponents] lastObject]];
        BOOL isDir = NO;
        BOOL fileExists = [fm fileExistsAtPath: destinationPath isDirectory: &isDir];
        if (isDir || fileExists) {
            continue;
        } else {
            [fm copyItemAtPath: sourcePath toPath: destinationPath error: &error];
            if (error) {
                NSLog(@"MIGRATION ERROR: %@", error);
            } else {
                transferCount++;
            }
        }
    }
    return transferCount;
}

@end
