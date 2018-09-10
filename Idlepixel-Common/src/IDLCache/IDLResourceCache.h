//
//  IDLResourceCache.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 18/12/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kStringSuffixBytes;
extern NSString * const kStringSuffixKilobytes;
extern NSString * const kStringSuffixMegabytes;
extern NSString * const kStringSuffixGigabytes;
extern NSString * const kStringSuffixTerabytes;

NS_INLINE NSString* FormatBytes(uint64_t byteCount);
NS_INLINE uint64_t MegaBytesToBytes(uint64_t megaBytes);
NS_INLINE uint64_t BytesToMegaBytes(uint64_t bytes);

@class IDLResourceCacheObject;

@protocol IDLResourceCache <NSObject>

@required
@property (nonatomic, assign) BOOL enableLimits;
@property (nonatomic, assign) uint64_t totalUsageLimit;
@property (nonatomic, assign) uint64_t perObjectUsageLimit;
@property (nonatomic, readonly) uint64_t currentUsage;

- (void)cacheData:(NSData *)data forKey:(NSString *)key;
- (void)cacheImage:(UIImage *)image forKey:(NSString *)key;
- (void)cacheObject:(NSObject *)object forKey:(NSString *)key withSize:(uint64_t)objectSize;

- (NSArray *)allCacheObjects;

- (UIImage *)imageForKey:(NSString *)key;
- (NSData *)dataForKey:(NSString *)key;
- (NSObject *)objectForKey:(NSString *)key;
- (void)purge;
- (uint64_t)purgeBytes:(uint64_t)minimumPurgeBytes;
- (void)purgeObject:(IDLResourceCacheObject *)object;
- (void)purgeObjectForKey:(NSString *)key;

@end

typedef enum {
    IDLResourceCacheObjectTypeUnknown = 0,
    IDLResourceCacheObjectTypeImage,
    IDLResourceCacheObjectTypeData
} IDLResourceCacheObjectType;

@interface IDLResourceCacheObject : NSObject <NSCoding>

@property (nonatomic, strong) NSString *key;
@property (nonatomic, assign) NSTimeInterval cacheTimeStamp;
@property (nonatomic, assign) NSTimeInterval accessTimeStamp;
@property (nonatomic, assign) uint64_t objectSize;
@property (nonatomic, assign) CGFloat retentionFactor;
@property (nonatomic, assign) IDLResourceCacheObjectType type;

- (NSComparisonResult)compareRetentionFactors:(IDLResourceCacheObject*)otherObject;
- (CGFloat)calculateObjectRetentionFactorForInterval:(NSTimeInterval)interval;

@end

@interface IDLResourceCache : NSObject <IDLResourceCache>
@property (nonatomic, assign) BOOL enableLimits;
@property (nonatomic, assign) uint64_t totalUsageLimit;
@property (nonatomic, assign) uint64_t perObjectUsageLimit;

+ (uint64_t)devicePhysicalMemory;
+ (uint64_t)recommendedTotalUsageLimit;
+ (uint64_t)recommendedPerObjectUsageLimit;

+ (NSString *)uniqueKeyForURLString:(NSString *)URLString;

- (NSTimeInterval)currentSystemTimeInterval;
- (CGFloat)calculateObjectRetentionFactor:(IDLResourceCacheObject *)object forInterval:(NSTimeInterval)interval;

@end
