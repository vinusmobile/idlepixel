//
//  IDLResourceCache.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 18/12/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "IDLResourceCache.h"
#import "IDLNSInlineExtensions.h"
#import "UIImage+Idlepixel.h"
#import "NSURL+Idlepixel.h"
#import "NSString+Idlepixel.h"

NSString * const kStringSuffixBytes = @"b";
NSString * const kStringSuffixKilobytes = @"Kb";
NSString * const kStringSuffixMegabytes = @"Mb";
NSString * const kStringSuffixGigabytes = @"Gb";
NSString * const kStringSuffixTerabytes = @"Tb";

NS_INLINE NSString* FormatBytes(uint64_t byteCount)
{
    NSArray *levelSuffixes = [NSArray arrayWithObjects:
                              kStringSuffixBytes,
                              kStringSuffixKilobytes,
                              kStringSuffixMegabytes,
                              kStringSuffixGigabytes,
                              kStringSuffixTerabytes,
                              nil];
    Float32 displayBytes = byteCount;
    NSUInteger level = floor(log10(displayBytes) / log10(1000));
    level = MIN(level, (levelSuffixes.count - 1));
    displayBytes = displayBytes / (pow(1000, level));
    return [NSString stringWithFormat: @"%.3f%@", displayBytes, [levelSuffixes objectAtIndex: level]];
}

NS_INLINE uint64_t MegaBytesToBytes(uint64_t megaBytes)
{
    return (megaBytes * 1024 * 1024);
}
NS_INLINE uint64_t BytesToMegaBytes(uint64_t bytes)
{
    return bytes / (1024 * 1024);
}

@implementation IDLResourceCacheObject

- (NSComparisonResult)compareRetentionFactors:(IDLResourceCacheObject*)otherObject
{
    CGFloat selfRetention = self.retentionFactor;
    CGFloat otherRetention = otherObject.retentionFactor;
    if (selfRetention > otherRetention) {
        return NSOrderedAscending;
    } else if (selfRetention < otherRetention) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

#define kDiskCacheMetaDataObjectCoderKey                @"key"
#define kDiskCacheMetaDataObjectCoderCacheTimeStamp     @"cacheTimeStamp"
#define kDiskCacheMetaDataObjectCoderAccessTimeStamp    @"accessTimeStamp"
#define kDiskCacheMetaDataObjectCoderObjectSize         @"objectSize"
#define kDiskCacheMetaDataObjectCoderObjectType         @"type"

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.key forKey:kDiskCacheMetaDataObjectCoderKey];
    [aCoder encodeDouble:self.cacheTimeStamp forKey:kDiskCacheMetaDataObjectCoderCacheTimeStamp];
    [aCoder encodeDouble:self.accessTimeStamp forKey:kDiskCacheMetaDataObjectCoderAccessTimeStamp];
    [aCoder encodeInt64:self.objectSize forKey:kDiskCacheMetaDataObjectCoderObjectSize];
    [aCoder encodeInteger:self.type forKey:kDiskCacheMetaDataObjectCoderObjectType];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.key = [aDecoder decodeObjectForKey:kDiskCacheMetaDataObjectCoderKey];
        self.cacheTimeStamp = [aDecoder decodeDoubleForKey:kDiskCacheMetaDataObjectCoderCacheTimeStamp];
        self.accessTimeStamp = [aDecoder decodeDoubleForKey:kDiskCacheMetaDataObjectCoderAccessTimeStamp];
        self.objectSize = [aDecoder decodeInt64ForKey:kDiskCacheMetaDataObjectCoderObjectSize];
        self.type = (IDLResourceCacheObjectType)[aDecoder decodeIntegerForKey:kDiskCacheMetaDataObjectCoderObjectType];
    }
    return self;
}

- (CGFloat)calculateObjectRetentionFactorForInterval:(NSTimeInterval)interval
{
    NSTimeInterval accessAge = MAX((interval - self.accessTimeStamp), 1.0f);
    NSTimeInterval cacheAge = MAX((interval - self.cacheTimeStamp)/10.0f, 1.0f);
    CGFloat memoryUsage = MAX((CGFloat)self.objectSize/2.0f, 1.0f);
    return log(accessAge) + log(cacheAge) + log(memoryUsage);
}

@end

@implementation IDLResourceCache

#pragma mark Class Methods

+ (uint64_t)devicePhysicalMemory
{
    NSProcessInfo *info = [NSProcessInfo processInfo];
    return info.physicalMemory;
}

+ (uint64_t)recommendedTotalUsageLimit
{
    uint64_t physicalMemory = self.devicePhysicalMemory;
    uint64_t totalUsage = MAX(physicalMemory/12, MegaBytesToBytes(8));
    return totalUsage;
}

+ (uint64_t)recommendedPerObjectUsageLimit
{
    uint64_t physicalMemory = self.devicePhysicalMemory;
    uint64_t perObjectUsage = MAX(physicalMemory/100, MegaBytesToBytes(1));
    return perObjectUsage;
}

+ (NSString *)uniqueKeyForURLString:(NSString *)URLString
{
    NSURL *url = nil;
    @try {
        url = [NSURL URLWithString:URLString.URLEncodedString.lowercaseString];
    }
    @catch (NSException *exception) {
        //do nothing
    }
    NSString *key = nil;
    if (url != nil) {
        key = url.uniqueHashWithPathExtension;
    }
    return key;
}

- (void)cacheData:(NSData *)data forKey:(NSString *)key
{
    [self cacheObject:data forKey:key withSize:data.length];
}

- (void)cacheImage:(UIImage *)image forKey:(NSString *)key
{
    [self cacheObject:image forKey:key withSize:image.dataSize];
}

- (void)cacheObject:(NSObject *)object forKey:(NSString *)key withSize:(uint64_t)objectSize
{
    // do nothing, override in subclasses
}

- (NSArray *)allCacheObjects
{
    return nil;
}

- (UIImage *)imageForKey:(NSString *)key
{
    NSObject *object = [self objectForKey:key];
    if ([object isKindOfClass:[UIImage class]]) {
        return (UIImage *)object;
    } else {
        return nil;
    }
}

- (NSData *)dataForKey:(NSString *)key
{
    NSObject *object = [self objectForKey:key];
    if ([object isKindOfClass:[NSData class]]) {
        return (NSData *)object;
    } else {
        return nil;
    }
}

- (NSObject *)objectForKey:(NSString *)key
{
    return nil;
}

-(uint64_t)currentUsage
{
    uint64_t usageBytesCounter = 0;
    NSArray *cachedObjects = self.allCacheObjects;
    for (IDLResourceCacheObject *object in cachedObjects) {
        usageBytesCounter += object.objectSize;
    }
    return usageBytesCounter;
}

- (void)purge
{
    // do nothing, override in subclasses
}

- (void)purgeObject:(IDLResourceCacheObject *)object
{
    [self purgeObjectForKey:object.key];
}

- (void)purgeObjectForKey:(NSString *)key
{
    // do nothing, override in subclasses
}

-(uint64_t)purgeBytes:(uint64_t)minimumPurgeBytes
{
    uint64_t purgeBytesCounter = 0;
    NSInteger purgeCounter = 0;
    NSTimeInterval currentSystemTimeInterval = self.currentSystemTimeInterval;
    NSArray *sortedCacheObjects = [self.allCacheObjects sortedArrayUsingComparator:
                                   ^NSComparisonResult(IDLResourceCacheObject *obj1, IDLResourceCacheObject *obj2) {
                                       NSTimeInterval interval1 = [obj1 calculateObjectRetentionFactorForInterval:currentSystemTimeInterval];
                                       NSTimeInterval interval2 = [obj2 calculateObjectRetentionFactorForInterval:currentSystemTimeInterval];
                                       if (interval1 > interval2) {
                                           return NSOrderedAscending;
                                       } else if (interval1 < interval2) {
                                           return NSOrderedDescending;
                                       } else {
                                           return NSOrderedSame;
                                       }
                                   }];
    IDLResourceCacheObject *currentObject, *nextObject;
    //
    if (minimumPurgeBytes > 0) {
        for (NSInteger i = 0; i < sortedCacheObjects.count; i++) {
            currentObject = [sortedCacheObjects objectAtIndex:i];
            nextObject = (i < (sortedCacheObjects.count-1)) ? [sortedCacheObjects objectAtIndex:i] : nil;
            // jump the current object since the next object will purge enough of the buffer on its own
            if (minimumPurgeBytes > (currentObject.objectSize + purgeBytesCounter)
                && minimumPurgeBytes < (nextObject.objectSize + purgeBytesCounter)) {
                purgeBytesCounter += nextObject.objectSize;
                purgeCounter++;
                [self purgeObject:nextObject];
            } else {
                purgeBytesCounter += currentObject.objectSize;
                purgeCounter++;
                [self purgeObject:currentObject];
            }
            if (minimumPurgeBytes < purgeBytesCounter) break;
        }
    }
    return purgeBytesCounter;
}

-(NSTimeInterval)currentSystemTimeInterval
{
    return [NSDate timeIntervalSinceReferenceDate];
}

- (CGFloat)calculateObjectRetentionFactor:(IDLResourceCacheObject *)object forInterval:(NSTimeInterval)interval
{
    return [object calculateObjectRetentionFactorForInterval:interval];
}

@end
