//
//  NSUserDefaults+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 4/12/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (IDLKeyPrefix)

+ (NSString *)compoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix;
- (NSString *)compoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix;

- (void)removeAllCompoundKeysWithPrefix:(NSString *)keyPrefix;

- (id)objectForCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix;
- (void)setObject:(id)value forCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix;
- (void)removeObjectForCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix;

- (NSString *)stringForCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix;
- (NSArray *)arrayForCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix;
- (NSDictionary *)dictionaryForCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix;
- (NSData *)dataForCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix;
- (NSArray *)stringArrayForCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix;
- (NSInteger)integerForCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix;
- (float)floatForCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix;
- (double)doubleForCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix;
- (BOOL)boolForCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix;
- (NSURL *)URLForCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix NS_AVAILABLE(10_6, 4_0);

- (void)setInteger:(NSInteger)value forCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix;
- (void)setFloat:(float)value forCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix;
- (void)setDouble:(double)value forCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix;
- (void)setBool:(BOOL)value forCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix;
- (void)setURL:(NSURL *)url forCompoundKey:(NSString *)aKey withPrefix:(NSString *)keyPrefix NS_AVAILABLE(10_6, 4_0);

@end

@interface NSUserDefaults (IDLVersionSpecific)

+ (NSString *)versionSpecificKey:(NSString *)aKey;
- (NSString *)versionSpecificKey:(NSString *)aKey;

- (void)removeAllVersionSpecificKeys;
- (void)removePriorVersionSpecificKeys;

- (id)objectForVersionSpecificKey:(NSString *)aKey;
- (void)setObject:(id)value forVersionSpecificKey:(NSString *)aKey;
- (void)removeObjectForVersionSpecificKey:(NSString *)aKey;

- (NSString *)stringForVersionSpecificKey:(NSString *)aKey;
- (NSArray *)arrayForVersionSpecificKey:(NSString *)aKey;
- (NSDictionary *)dictionaryForVersionSpecificKey:(NSString *)aKey;
- (NSData *)dataForVersionSpecificKey:(NSString *)aKey;
- (NSArray *)stringArrayForVersionSpecificKey:(NSString *)aKey;
- (NSInteger)integerForVersionSpecificKey:(NSString *)aKey;
- (float)floatForVersionSpecificKey:(NSString *)aKey;
- (double)doubleForVersionSpecificKey:(NSString *)aKey;
- (BOOL)boolForVersionSpecificKey:(NSString *)aKey;
- (NSURL *)URLForVersionSpecificKey:(NSString *)aKey NS_AVAILABLE(10_6, 4_0);

- (void)setInteger:(NSInteger)value forVersionSpecificKey:(NSString *)aKey;
- (void)setFloat:(float)value forVersionSpecificKey:(NSString *)aKey;
- (void)setDouble:(double)value forVersionSpecificKey:(NSString *)aKey;
- (void)setBool:(BOOL)value forVersionSpecificKey:(NSString *)aKey;
- (void)setURL:(NSURL *)url forVersionSpecificKey:(NSString *)aKey NS_AVAILABLE(10_6, 4_0);

@end

@interface NSUserDefaults (IDLDeviceSpecific)

+ (NSString *)deviceSpecificKey:(NSString *)aKey;
- (NSString *)deviceSpecificKey:(NSString *)aKey;

- (void)removeAllDeviceSpecificKeys;
- (void)removeOtherDeviceSpecificKeys;

- (id)objectForDeviceSpecificKey:(NSString *)aKey;
- (void)setObject:(id)value forDeviceSpecificKey:(NSString *)aKey;
- (void)removeObjectForDeviceSpecificKey:(NSString *)aKey;

- (NSString *)stringForDeviceSpecificKey:(NSString *)aKey;
- (NSArray *)arrayForDeviceSpecificKey:(NSString *)aKey;
- (NSDictionary *)dictionaryForDeviceSpecificKey:(NSString *)aKey;
- (NSData *)dataForDeviceSpecificKey:(NSString *)aKey;
- (NSArray *)stringArrayForDeviceSpecificKey:(NSString *)aKey;
- (NSInteger)integerForDeviceSpecificKey:(NSString *)aKey;
- (float)floatForDeviceSpecificKey:(NSString *)aKey;
- (double)doubleForDeviceSpecificKey:(NSString *)aKey;
- (BOOL)boolForDeviceSpecificKey:(NSString *)aKey;
- (NSURL *)URLForDeviceSpecificKey:(NSString *)aKey NS_AVAILABLE(10_6, 4_0);

- (void)setInteger:(NSInteger)value forDeviceSpecificKey:(NSString *)aKey;
- (void)setFloat:(float)value forDeviceSpecificKey:(NSString *)aKey;
- (void)setDouble:(double)value forDeviceSpecificKey:(NSString *)aKey;
- (void)setBool:(BOOL)value forDeviceSpecificKey:(NSString *)aKey;
- (void)setURL:(NSURL *)url forDeviceSpecificKey:(NSString *)aKey NS_AVAILABLE(10_6, 4_0);

@end

@interface NSUserDefaults (IDLPrefix)

-(NSDictionary *)valuesWithKeyPrefix:(NSString *)prefix;
-(void)removeValuesWithKeyPrefix:(NSString *)prefix;
-(void)removeValuesWithKeyPrefixes:(NSArray *)prefixes;

@end
