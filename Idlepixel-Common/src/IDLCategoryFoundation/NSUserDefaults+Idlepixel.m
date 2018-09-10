//
//  NSUserDefaults+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 4/12/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "NSUserDefaults+Idlepixel.h"
#import "NSBundle+Idlepixel.h"
#import "NSDictionary+Idlepixel.h"
#import "NSArray+Idlepixel.h"
#import "NSObject+Idlepixel.h"
#import "NSString+Idlepixel.h"
#import "NSBundle+Idlepixel.h"
#import "IDLDeviceInformation.h"

#define kCompoundKeyPrefixFormat    @"[[%@]]"
#define kCompoundKeyFormat          @"%@:%@"


NS_INLINE NSString *CompountKeyPrefixString(NSString *aPrefix)
{
    if (aPrefix == nil) aPrefix = @"";
    return [NSString stringWithFormat:kCompoundKeyPrefixFormat,aPrefix];
}

NS_INLINE NSString *CompountKeyString(NSString *aKey, NSString *aPrefix)
{
    if (aKey == nil) aKey = @"";
    aPrefix = CompountKeyPrefixString(aPrefix);
    return [NSString stringWithFormat:kCompoundKeyFormat,aPrefix, aKey];
}

NS_INLINE NSString *DevicePrefixString()
{
    static NSString *deviceHash = nil;
    if (!deviceHash) {
        deviceHash = [[NSBundle mainBundle] uniqueDeviceIdentifier];
    }
    return CompountKeyPrefixString(deviceHash);
}

NS_INLINE NSString *DeviceStringForKey(NSString *aKey)
{
    return CompountKeyString(aKey, DevicePrefixString());
}

NS_INLINE NSString *VersionPrefixString()
{
    static NSString *versionHash = nil;
    if (!versionHash) {
        NSBundle *bundle = [NSBundle mainBundle];
        versionHash = [[NSString stringWithFormat:@"%@-%@",[NSObject devicePlatformSuffix], bundle.bundleVersionFull] md5Hash];
    }
    return CompountKeyPrefixString(versionHash);
}

NS_INLINE NSString *VersionStringForKey(NSString *aKey)
{
    return CompountKeyString(aKey, VersionPrefixString());
}


@implementation NSUserDefaults (IDLKeyPrefix)

+ (NSString *)compoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix
{
    return CompountKeyString(aKey, keyPrefix);
}

- (NSString *)compoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix
{
    return CompountKeyString(aKey, keyPrefix);
}

- (void)removeAllCompoundKeysWithPrefix:(NSString *)keyPrefix
{
    keyPrefix = CompountKeyPrefixString(keyPrefix);
    [self removeValuesWithKeyPrefix:keyPrefix];
}

- (id)objectForCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix
{
    return [self objectForKey:CompountKeyString(aKey, keyPrefix)];
}
- (void)setObject:(id)value forCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix
{
    [self setObject:value forKey:CompountKeyString(aKey, keyPrefix)];
}

- (void)removeObjectForCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix
{
    [self removeObjectForKey:CompountKeyString(aKey, keyPrefix)];
}

- (NSString *)stringForCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix
{
    return [self stringForKey:CompountKeyString(aKey, keyPrefix)];
}

- (NSArray *)arrayForCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix
{
    return [self arrayForKey:CompountKeyString(aKey, keyPrefix)];
}

- (NSDictionary *)dictionaryForCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix
{
    return [self dictionaryForKey:CompountKeyString(aKey, keyPrefix)];
}

- (NSData *)dataForCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix
{
    return [self dataForKey:CompountKeyString(aKey, keyPrefix)];
}

- (NSArray *)stringArrayForCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix
{
    return [self stringArrayForKey:CompountKeyString(aKey, keyPrefix)];
}

- (NSInteger)integerForCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix
{
    return [self integerForKey:CompountKeyString(aKey, keyPrefix)];
}

- (float)floatForCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix
{
    return [self floatForKey:CompountKeyString(aKey, keyPrefix)];
}

- (double)doubleForCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix
{
    return [self doubleForKey:CompountKeyString(aKey, keyPrefix)];
}

- (BOOL)boolForCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix
{
    return [self boolForKey:CompountKeyString(aKey, keyPrefix)];
}

- (NSURL *)URLForCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix NS_AVAILABLE(10_6, 4_0)
{
    return [self URLForKey:CompountKeyString(aKey, keyPrefix)];
}

- (void)setInteger:(NSInteger)value forCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix
{
    [self setInteger:value forKey:CompountKeyString(aKey, keyPrefix)];
}

- (void)setFloat:(float)value forCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix
{
    [self setFloat:value forKey:CompountKeyString(aKey, keyPrefix)];
}

- (void)setDouble:(double)value forCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix
{
    [self setDouble:value forKey:CompountKeyString(aKey, keyPrefix)];
}

- (void)setBool:(BOOL)value forCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix
{
    [self setBool:value forKey:CompountKeyString(aKey, keyPrefix)];
}

- (void)setURL:(NSURL *)url forCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix NS_AVAILABLE(10_6, 4_0)
{
    [self setURL:url forKey:CompountKeyString(aKey, keyPrefix)];
}

@end

@implementation NSUserDefaults (IDLVersionSpecific)

#define kVersionSpecificKeyDictionary   @"VersionSpecificPrefixes"

-(void)saveVersionKeyInformation
{
    NSDictionary *versionKeys = [self dictionaryForKey:kVersionSpecificKeyDictionary];
    if (versionKeys == nil) {
        versionKeys = [NSDictionary dictionary];
    }
    
    NSString *currentPrefix = VersionPrefixString();
    NSString *currentVersion = [[NSBundle mainBundle] bundleVersionFull];
    
    if (![versionKeys.allValues containsObject:currentPrefix]) {
        versionKeys = [versionKeys dictionaryByAddingObject:currentPrefix forKey:currentVersion];
        [self setObject:versionKeys forKey:kVersionSpecificKeyDictionary];
    }
    //IDLLogObject(versionKeys);
}

+ (NSString *)versionSpecificKey:(NSString *)aKey
{
    return VersionStringForKey(aKey);
}

- (NSString *)versionSpecificKey:(NSString *)aKey
{
    return VersionStringForKey(aKey);
}

- (void)removeAllVersionSpecificKeys
{
    NSArray *prefixes = [self dictionaryForKey:kVersionSpecificKeyDictionary].allValues;
    [self removeValuesWithKeyPrefixes:prefixes];
}

- (void)removePriorVersionSpecificKeys
{
    NSArray *prefixes = [self dictionaryForKey:kVersionSpecificKeyDictionary].allValues;
    prefixes = [prefixes arrayByRemovingObject:VersionPrefixString()];
    [self removeValuesWithKeyPrefixes:prefixes];
}

- (id)objectForVersionSpecificKey:(NSString *)aKey
{
    return [self objectForKey:VersionStringForKey(aKey)];
}

- (void)setObject:(id)value forVersionSpecificKey:(NSString *)aKey
{
    [self saveVersionKeyInformation];
    [self setObject:value forKey:VersionStringForKey(aKey)];
}

- (void)removeObjectForVersionSpecificKey:(NSString *)aKey
{
    [self removeObjectForKey:VersionStringForKey(aKey)];
}

- (NSString *)stringForVersionSpecificKey:(NSString *)aKey
{
    return [self stringForKey:VersionStringForKey(aKey)];
}

- (NSArray *)arrayForVersionSpecificKey:(NSString *)aKey
{
    return [self arrayForKey:VersionStringForKey(aKey)];
}

- (NSDictionary *)dictionaryForVersionSpecificKey:(NSString *)aKey
{
    return [self dictionaryForKey:VersionStringForKey(aKey)];
}

- (NSData *)dataForVersionSpecificKey:(NSString *)aKey
{
    return [self dataForKey:VersionStringForKey(aKey)];
}

- (NSArray *)stringArrayForVersionSpecificKey:(NSString *)aKey
{
    return [self stringArrayForKey:VersionStringForKey(aKey)];
}

- (NSInteger)integerForVersionSpecificKey:(NSString *)aKey
{
    return [self integerForKey:VersionStringForKey(aKey)];
}

- (float)floatForVersionSpecificKey:(NSString *)aKey
{
    return [self floatForKey:VersionStringForKey(aKey)];
}

- (double)doubleForVersionSpecificKey:(NSString *)aKey
{
    return [self doubleForKey:VersionStringForKey(aKey)];
}

- (BOOL)boolForVersionSpecificKey:(NSString *)aKey
{
    return [self boolForKey:VersionStringForKey(aKey)];
}

- (NSURL *)URLForVersionSpecificKey:(NSString *)aKey
{
    return [self URLForKey:VersionStringForKey(aKey)];
}

- (void)setInteger:(NSInteger)value forVersionSpecificKey:(NSString *)aKey
{
    [self saveVersionKeyInformation];
    [self setInteger:value forKey:VersionStringForKey(aKey)];
}

- (void)setFloat:(float)value forVersionSpecificKey:(NSString *)aKey
{
    [self saveVersionKeyInformation];
    [self setFloat:value forKey:VersionStringForKey(aKey)];
}

- (void)setDouble:(double)value forVersionSpecificKey:(NSString *)aKey
{
    [self saveVersionKeyInformation];
    [self setDouble:value forKey:VersionStringForKey(aKey)];
}

- (void)setBool:(BOOL)value forVersionSpecificKey:(NSString *)aKey
{
    [self saveVersionKeyInformation];
    [self setBool:value forKey:VersionStringForKey(aKey)];
}

- (void)setURL:(NSURL *)url forVersionSpecificKey:(NSString *)aKey
{
    [self saveVersionKeyInformation];
    [self setURL:url forKey:VersionStringForKey(aKey)];
}

@end

@implementation NSUserDefaults (IDLDeviceSpecific)

#define kDeviceSpecificKeyDictionary   @"DeviceSpecificPrefixes"

-(void)saveDeviceKeyInformation
{
    NSDictionary *deviceKeys = [self dictionaryForKey:kDeviceSpecificKeyDictionary];
    if (deviceKeys == nil) {
        deviceKeys = [NSDictionary dictionary];
    }
    
    NSString *currentPrefix = DevicePrefixString();
    NSString *currentDevice = [NSString stringWithFormat:@"%@:%@",[IDLDeviceInformation devicePlatformSuffix], [IDLDeviceInformation deviceModelID]];
    
    if (![deviceKeys.allValues containsObject:currentPrefix]) {
        deviceKeys = [deviceKeys dictionaryByAddingObject:currentPrefix forKey:currentDevice];
        [self setObject:deviceKeys forKey:kDeviceSpecificKeyDictionary];
    }
    //IDLLogObject(deviceKeys);
}

+ (NSString *)deviceSpecificKey:(NSString *)aKey
{
    return DeviceStringForKey(aKey);
}

- (NSString *)deviceSpecificKey:(NSString *)aKey
{
    return DeviceStringForKey(aKey);
}

- (void)removeAllDeviceSpecificKeys
{
    NSArray *prefixes = [self dictionaryForKey:kDeviceSpecificKeyDictionary].allValues;
    [self removeValuesWithKeyPrefixes:prefixes];
}

- (void)removeOtherDeviceSpecificKeys
{
    NSArray *prefixes = [self dictionaryForKey:kDeviceSpecificKeyDictionary].allValues;
    prefixes = [prefixes arrayByRemovingObject:DevicePrefixString()];
    [self removeValuesWithKeyPrefixes:prefixes];
}

- (id)objectForDeviceSpecificKey:(NSString *)aKey
{
    return [self objectForKey:DeviceStringForKey(aKey)];
}

- (void)setObject:(id)value forDeviceSpecificKey:(NSString *)aKey
{
    [self saveDeviceKeyInformation];
    [self setObject:value forKey:DeviceStringForKey(aKey)];
}

- (void)removeObjectForDeviceSpecificKey:(NSString *)aKey
{
    [self removeObjectForKey:DeviceStringForKey(aKey)];
}

- (NSString *)stringForDeviceSpecificKey:(NSString *)aKey
{
    return [self stringForKey:DeviceStringForKey(aKey)];
}

- (NSArray *)arrayForDeviceSpecificKey:(NSString *)aKey
{
    return [self arrayForKey:DeviceStringForKey(aKey)];
}

- (NSDictionary *)dictionaryForDeviceSpecificKey:(NSString *)aKey
{
    return [self dictionaryForKey:DeviceStringForKey(aKey)];
}

- (NSData *)dataForDeviceSpecificKey:(NSString *)aKey
{
    return [self dataForKey:DeviceStringForKey(aKey)];
}

- (NSArray *)stringArrayForDeviceSpecificKey:(NSString *)aKey
{
    return [self stringArrayForKey:DeviceStringForKey(aKey)];
}

- (NSInteger)integerForDeviceSpecificKey:(NSString *)aKey
{
    return [self integerForKey:DeviceStringForKey(aKey)];
}

- (float)floatForDeviceSpecificKey:(NSString *)aKey
{
    return [self floatForKey:DeviceStringForKey(aKey)];
}

- (double)doubleForDeviceSpecificKey:(NSString *)aKey
{
    return [self doubleForKey:DeviceStringForKey(aKey)];
}

- (BOOL)boolForDeviceSpecificKey:(NSString *)aKey
{
    return [self boolForKey:DeviceStringForKey(aKey)];
}

- (NSURL *)URLForDeviceSpecificKey:(NSString *)aKey
{
    return [self URLForKey:DeviceStringForKey(aKey)];
}

- (void)setInteger:(NSInteger)value forDeviceSpecificKey:(NSString *)aKey
{
    [self saveDeviceKeyInformation];
    [self setInteger:value forKey:DeviceStringForKey(aKey)];
}

- (void)setFloat:(float)value forDeviceSpecificKey:(NSString *)aKey
{
    [self saveDeviceKeyInformation];
    [self setFloat:value forKey:DeviceStringForKey(aKey)];
}

- (void)setDouble:(double)value forDeviceSpecificKey:(NSString *)aKey
{
    [self saveDeviceKeyInformation];
    [self setDouble:value forKey:DeviceStringForKey(aKey)];
}

- (void)setBool:(BOOL)value forDeviceSpecificKey:(NSString *)aKey
{
    [self saveDeviceKeyInformation];
    [self setBool:value forKey:DeviceStringForKey(aKey)];
}

- (void)setURL:(NSURL *)url forDeviceSpecificKey:(NSString *)aKey
{
    [self saveDeviceKeyInformation];
    [self setURL:url forKey:DeviceStringForKey(aKey)];
}

@end

@implementation NSUserDefaults (IDLPrefix)

-(NSDictionary *)valuesWithKeyPrefix:(NSString *)prefix
{
    NSDictionary *dictionary = self.dictionaryRepresentation;
    return [dictionary dictionaryByRemovingKeysWithoutPrefix:prefix];
}

-(void)removeValuesWithKeyPrefix:(NSString *)prefix
{
    if (prefix != nil) {
        [self removeValuesWithKeyPrefixes:@[prefix]];
    }
}

-(void)removeValuesWithKeyPrefixes:(NSArray *)prefixes
{
    if (prefixes.count > 0) {
        NSArray *allKeys = self.dictionaryRepresentation.allKeys;
        for (NSString *key in allKeys) {
            for (NSString *prefix in prefixes) {
                if ([key hasPrefix:prefix]) {
                    [self removeObjectForKey:key];
                    break;
                }
            }
        }
    }
}

@end
