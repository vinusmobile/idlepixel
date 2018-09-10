//
//  NSObject+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 15/09/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class IDLFlagSet;

extern NSString * const kDevicePlatformSuffixPhone;
extern NSString * const kDevicePlatformSuffixPad;

@interface NSObject (IDLSubclasses)

+ (NSArray *)immediateSubclasses;
+ (NSArray *)allSubclasses;

@end

@interface NSObject (IDLClassName)

+ (NSString *)className;
+ (NSString *)baseClassName;

@property (readonly) NSString *className;
@property (readonly) NSString *baseClassName;

@end

@interface NSObject (IDLIntrospection)

+ (NSArray *)introspectedClassProperties;
+ (NSArray *)introspectedClassIVars;
+ (NSArray *)introspectedClassMethods;

@property (readonly) NSDictionary *introspectedProperties;
@property (readonly) NSDictionary *introspectedIVars;
@property (readonly) NSDictionary *introspectedObjects;
@property (readonly) NSArray *introspectedMethods;

@end

@interface NSObject (IDLPlatform)

+ (NSString *)platformSuffixForName:(NSString *)name;
+ (NSString *)devicePlatformSuffix;
+ (NSString *)classPlatformSuffix;
- (NSString *)classPlatformSuffix;

+ (Class)platformSubclass;

@end

@interface NSObject (IDLPlatformNib)

+ (NSString *)platformNibName:(NSString *)baseName fromBundle:(NSBundle *)bundle;

+ (id)platformSubclassInstanceWithNib;

- (id)initWithPlatformNib;
- (id)initWithPlatformNibFromBundle:(NSBundle *)bundle;
- (id)initWithPlatformNibWithBaseName:(NSString *)baseName;
- (id)initWithPlatformNibWithBaseName:(NSString *)baseName fromBundle:(NSBundle *)bundle;

- (id)initWithPlatformNibWithBaseName:(NSString *)baseName includeSuperClasses:(BOOL)includeSuperClasses;
- (id)initWithPlatformNibWithBaseName:(NSString *)baseName fromBundle:(NSBundle *)bundle includeSuperClasses:(BOOL)includeSuperClasses;

@end

@interface NSObject (IDLInterfaceIdiom)

+ (UIUserInterfaceIdiom)userInterfaceIdiom;
- (UIUserInterfaceIdiom)userInterfaceIdiom;

@end

@interface NSObject (IDLStringTag)

@property (nonatomic, strong) NSString *stringTag;

@end

@interface NSObject (IDLPointerKey)

@property (readonly) NSString *pointerKey;

@end

@interface NSObject (IDLFlags)

@property (readonly) IDLFlagSet *flags;

@end

@interface NSObject (IDLSwizzle)

+ (void)swizzleInstanceSelector:(SEL)originalSelector withNewSelector:(SEL)newSelector;
+ (void)swizzleClassSelector:(SEL)originalSelector withNewSelector:(SEL)newSelector;

@end
