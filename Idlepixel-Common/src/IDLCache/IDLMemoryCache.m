//
//  IDLMemoryCache.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 17/12/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "IDLMemoryCache.h"
#import "IDLDateKeeper.h"
#import "NSNotificationCenter+Idlepixel.h"
#import "UIImage+Idlepixel.h"
#import "IDLNSInlineExtensions.h"

uint64_t const kMemoryCacheDefaultTotalUsageLimit = 67108864;
uint64_t const kMemoryCacheDefaultPerObjectUsageLimit = 2097152;

@interface IDLMemoryCacheObject : IDLResourceCacheObject

@property (nonatomic, strong) NSObject *object;

@end

@implementation IDLMemoryCacheObject

#define kMemoryCacheMetaDataObjectCoderObject         @"object"

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.key forKey:kMemoryCacheMetaDataObjectCoderObject];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.object = [aDecoder decodeObjectForKey:kMemoryCacheMetaDataObjectCoderObject];
    }
    return self;
}

@end

@interface IDLMemoryCache () <IDLNotificationObserver>

@property (nonatomic, strong) NSMutableDictionary *cache;

@end

@implementation IDLMemoryCache

#pragma mark

-(id)init
{
    self = [super init];
    if (self) {
        self.totalUsageLimit = kMemoryCacheDefaultTotalUsageLimit;
        self.perObjectUsageLimit = kMemoryCacheDefaultPerObjectUsageLimit;
        self.cache = [NSMutableDictionary new];
        [[NSNotificationCenter defaultCenter] addNotificationObserver:self name:UIApplicationDidReceiveMemoryWarningNotification];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)notificationObserved:(NSNotification *)notification
{
    if (NSStringEquals(notification.name, UIApplicationDidReceiveMemoryWarningNotification)) {
        [self purge];
    }
}

-(void)purge
{
    [self.cache removeAllObjects];
}

-(void)purgeObjectForKey:(NSString *)key
{
    [self.cache removeObjectForKey:key];
}

-(IDLMemoryCacheObject *)memoryCacheObjectForKey:(NSString *)key
{
    return [self.cache objectForKey:key];
}

-(NSObject *)objectForKey:(NSString *)key
{
    NSObject *result = nil;
    @synchronized(self) {
        IDLMemoryCacheObject *object = [self memoryCacheObjectForKey:key];
        if (object && [object.object isKindOfClass:[NSData class]]) {
            object.accessTimeStamp = self.currentSystemTimeInterval;
            result = object.object;
        }
    }
    return result;
}

- (void)cacheObject:(NSObject *)object forKey:(NSString *)key withSize:(uint64_t)objectSize;
{
    if (key == nil) return;
    
    IDLMemoryCacheObject *cacheObject = [self memoryCacheObjectForKey:key];
    
    if (cacheObject.object != object || cacheObject.objectSize != objectSize) {
        if (cacheObject != nil) {
            [self purgeObject:cacheObject];
            cacheObject = nil;
        }
        if (objectSize > 0 && objectSize <= self.perObjectUsageLimit) {
            uint64_t currentUsage = self.currentUsage;
            uint64_t freeMemory = self.totalUsageLimit - currentUsage;
            if (objectSize > freeMemory) {
                [self purgeBytes:(objectSize-freeMemory)];
            }
            cacheObject = [IDLMemoryCacheObject new];
            cacheObject.objectSize = objectSize;
            cacheObject.object = object;
            cacheObject.key = key;
            [self.cache setObject:cacheObject forKey:key];
        }
    }
    cacheObject.cacheTimeStamp = self.currentSystemTimeInterval;
    cacheObject.accessTimeStamp = cacheObject.cacheTimeStamp;
}

-(NSTimeInterval)currentSystemTimeInterval
{
    return SystemTimeSinceSystemStartup();
}

@end
