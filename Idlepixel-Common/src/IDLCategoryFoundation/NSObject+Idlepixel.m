//
//  NSObject+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 15/09/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "NSObject+Idlepixel.h"
#import "NSBundle+Idlepixel.h"
#import "NSString+Idlepixel.h"
#import "IDLLoggingMacros.h"
#import "IDLFlagSet.h"
#import "IDLNSInlineExtensions.h"
#import "IDLInterfaceProtocols.h"

#import <objc/runtime.h>

NSString * const kDevicePlatformSuffixPhone    = @"Phone";
NSString * const kDevicePlatformSuffixPad      = @"Pad";

static char * const kNSObjectSubclassesImmediateAssociatedArrayKey  = "NSObject_Subclasses_Immediate_AssociatedArray";
static char * const kNSObjectSubclassesAllAssociatedArrayKey        = "NSObject_Subclasses_All_AssociatedArray";

@implementation NSObject (IDLSubclasses)

+ (NSArray *) subclasses:(BOOL)immediateSubClassesOnly
{
    NSMutableArray *subclassList = [NSMutableArray array];
    NSInteger numberOfClasses = objc_getClassList(NULL, 0);
    Class *classes = nil;
    
    classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numberOfClasses);
    numberOfClasses = objc_getClassList(classes, (int)numberOfClasses);
    
    for (NSInteger i = 0; i < numberOfClasses; i++)
    {
        Class currentClass = classes[i];
        Class superClass = class_getSuperclass(currentClass);
        
        if (superClass == nil) continue;
        
        if ((immediateSubClassesOnly && currentClass.superclass != self) || ![currentClass isSubclassOfClass:self]) {
            continue;
        }
        [subclassList addObject:classes[i]];
    }
    
    free(classes);
    return [NSArray arrayWithArray: subclassList];
}

+ (NSArray *) immediateSubclasses
{
    NSArray *subclasses = objc_getAssociatedObject(self, kNSObjectSubclassesImmediateAssociatedArrayKey);
    if (subclasses == nil) {
        subclasses = [self subclasses:YES];
        objc_setAssociatedObject(self, kNSObjectSubclassesImmediateAssociatedArrayKey, subclasses, OBJC_ASSOCIATION_COPY);
    }
    return subclasses;
}

+ (NSArray *) allSubclasses
{
    NSArray *subclasses = objc_getAssociatedObject(self, kNSObjectSubclassesAllAssociatedArrayKey);
    if (subclasses == nil) {
        subclasses = [self subclasses:NO];
        objc_setAssociatedObject(self, kNSObjectSubclassesAllAssociatedArrayKey, subclasses, OBJC_ASSOCIATION_COPY);
    }
    return subclasses;
}

@end

@implementation NSObject (IDLPlatform)

+(NSString *)platformSuffixForName:(NSString *)name
{
    if ([name hasSuffix:kDevicePlatformSuffixPhone]) {
        return kDevicePlatformSuffixPhone;
    } else if ([name hasSuffix:kDevicePlatformSuffixPad]) {
        return kDevicePlatformSuffixPad;
    } else {
        return nil;
    }
}

+(NSString *)devicePlatformSuffix
{
    if ([self userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
		return kDevicePlatformSuffixPhone;
	} else if ([self userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		return kDevicePlatformSuffixPad;
	} else {
        return nil;
    }
}

+(NSString *)classPlatformSuffix
{
    return [self platformSuffixForName:[self className]];
}

+ (Class) platformSubclass
{
    NSArray *subclasses = [self immediateSubclasses];
    
    NSString *platformSuffix = [self devicePlatformSuffix];
    if (platformSuffix == nil) {
        return self;
    }
    
    for (Class subclass in subclasses) {
        NSString *className = NSStringFromClass(subclass);
        if ([className hasSuffix: platformSuffix]) {
            return subclass;
        }
    }
    
    return self;
}

-(NSString *)classPlatformSuffix
{
    return [[self class] classPlatformSuffix];
}

@end

@implementation NSObject (IDLClassName)

+(NSString *)className
{
    return NSStringFromClass([self class]);
}

-(NSString *)className
{
    return [[self class] className];
}

+(NSString *)baseClassNameForName:(NSString *)name
{
    NSString *baseClassName = name;
    if ([baseClassName hasSuffix:kDevicePlatformSuffixPhone]) {
        baseClassName = [baseClassName stringByRemovingSuffix:kDevicePlatformSuffixPhone];
    } else if ([baseClassName hasSuffix:kDevicePlatformSuffixPad]) {
        baseClassName = [baseClassName stringByRemovingSuffix:kDevicePlatformSuffixPad];
    }
    return baseClassName;
}

+(NSString *)baseClassName
{
    return [self baseClassNameForName:[self className]];
}

-(NSString *)baseClassName
{
    return [[self class] baseClassName];
}

@end

@implementation NSObject (IDLIntrospection)

+ (NSArray *)introspectedClassProperties
{
    unsigned int count;
    
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    
    for(int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *nameString = [NSString stringWithUTF8String:name];
        [array addObject:nameString];
    }
    
    free(properties);
    
    return [NSArray arrayWithArray:array];
}

+ (NSArray *)introspectedClassIVars
{
    unsigned int count;
    
    Ivar* ivars = class_copyIvarList([self class], &count);
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    
    for(int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSString *nameString = [NSString stringWithUTF8String:name];
        [array addObject:nameString];
    }
    
    free(ivars);
    
    return [NSArray arrayWithArray:array];
}

+ (NSArray *)introspectedClassMethods
{
    unsigned int count;
    
    Method* methods = class_copyMethodList([self class], &count);
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    
    for(int i = 0; i < count; i++) {
        Method method = methods[i];
        SEL selector = method_getName(method);
        NSString *nameString = NSStringFromSelector(selector);
        
        if (!NSStringEquals(nameString, @".cxx_destruct")) {
            [array addObject:nameString];
        }
    }
    
    free(methods);
    
    return [NSArray arrayWithArray:array];
}

-(NSDictionary *)introspectedProperties
{
    NSArray *keys = [[self class] introspectedClassProperties];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:keys.count];
    for (NSString *property in keys) {
        NSValue *value = [self valueForKey:property];
        if (value) {
            [dictionary setValue:value forKey:property];
        } else {
            [dictionary setObject:[NSNull null] forKey:property];
        }
    }
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

-(NSDictionary *)introspectedIVars
{
    NSArray *keys = [[self class] introspectedClassIVars];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:keys.count];
    for (NSString *property in keys) {
        NSValue *value = [self valueForKey:property];
        if (value) {
            [dictionary setValue:value forKey:property];
        } else {
            [dictionary setObject:[NSNull null] forKey:property];
        }
    }
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

-(NSDictionary *)introspectedObjects
{
    return [NSDictionary dictionaryWithObjectsAndKeys:self.introspectedIVars, @"ivars", self.introspectedProperties, @"properties", self.introspectedMethods, @"methods", nil];
}

-(NSArray *)introspectedMethods
{
    return [[self class] introspectedClassMethods];
}

@end

@implementation NSObject (IDLPlatformNib)

+ (NSString *)platformNibName:(NSString *)baseNibName fromBundle:(NSBundle *)bundle;
{
    if (bundle == nil) return nil;
    
    NSString *classPlatformSuffix = [NSObject platformSuffixForName:baseNibName];
    NSString *nibPath = nil;
    NSString *nibName = nil;
    //IDLLogContext(@"baseNibName: %@",baseNibName);
    //IDLLogContext(@"classPlatformSuffix: %@",classPlatformSuffix);
    if (classPlatformSuffix != nil) {
        nibName = baseNibName;
        nibPath = [bundle pathForNibResource:nibName];
    }
    //IDLLogContext(@"nibPath: %@",nibPath);
    //IDLLogContext(@"nibName: %@",nibName);
    if (nibPath == nil) {
        NSString *baseClassName = [self baseClassNameForName:baseNibName];
        nibName = baseClassName;
        nibPath = [bundle pathForNibResource:nibName];
        //IDLLogContext(@"nibPath: %@",nibPath);
        //IDLLogContext(@"nibName: %@",nibName);
        if (nibPath == nil) {
            nibName = [baseClassName stringByAppendingString:[NSObject devicePlatformSuffix]];
            nibPath = [bundle pathForNibResource:nibName];
            //IDLLogContext(@"nibPath: %@",nibPath);
            //IDLLogContext(@"nibName: %@",nibName);
        }
    }
    //IDLLogContext(@"nibPath: %@",nibPath);
    //IDLLogContext(@"nibName: %@",nibName);
    if (nibPath != nil) {
        return nibName;
    } else {
        return nil;
    }
}

+ (id) platformSubclassInstanceWithNib
{
    return [[[self platformSubclass] alloc] initWithPlatformNib];
}

+ (BOOL)loadableFromNib
{
    if ([self instancesRespondToSelector: @selector(initWithNibName:bundle:)] || [self isSubclassOfClass:[UIView class]]) {
        return YES;
    } else {
        return NO;
    }
}

- (id) initWithPlatformNib
{
	return [self initWithPlatformNibFromBundle: [NSBundle mainBundle]];
}

- (id) initWithPlatformNibFromBundle:(NSBundle *)bundle
{
    return [self initWithPlatformNibWithBaseName:self.className fromBundle:bundle includeSuperClasses:YES];
}

- (id) initWithPlatformNibWithBaseName:(NSString *)baseName
{
    return [self initWithPlatformNibWithBaseName:baseName fromBundle:[NSBundle mainBundle]];
}

- (id) initWithPlatformNibWithBaseName:(NSString *)baseName fromBundle:(NSBundle *)bundle
{
    return [self initWithPlatformNibWithBaseName:baseName fromBundle:bundle includeSuperClasses:NO];
}

- (id) initWithPlatformNibWithBaseName:(NSString *)baseName includeSuperClasses:(BOOL)includeSuperClasses
{
    return [self initWithPlatformNibWithBaseName:baseName fromBundle:[NSBundle mainBundle] includeSuperClasses:includeSuperClasses];
}

- (id) initWithPlatformNibWithBaseName:(NSString *)baseName fromBundle:(NSBundle *)bundle includeSuperClasses:(BOOL)includeSuperClasses
{
    //IDLLogContext(@"basename: %@",baseName);
    if ([self.class loadableFromNib]) {
        
        if (bundle != nil && baseName != nil) {
            
            NSString *nibName = nil;
            Class selfClass = self.class;
            Class currentClass = selfClass;
            
            do {
                nibName = [currentClass platformNibName:[currentClass className] fromBundle:bundle];
                
                if (nibName == nil) {
                    currentClass = [currentClass superclass];
                    //IDLLog(@"no luck, trying super class '%@'",[currentClass className]);
                } else {
                    //IDLLog(@"success with '%@'",[currentClass className]);
                }
            } while (includeSuperClasses && nibName == nil && [currentClass loadableFromNib]);
            
            if (nibName != nil) {
                if ([self respondsToSelector: @selector(initWithNibName:bundle:)]) {
                    return [(id<IDLNibLoadable>)self initWithNibName:nibName bundle:bundle];
                } else if ([self isKindOfClass:[UIView class]]) {
                    return [bundle loadNibObjectWithClass:self.class fromNibNamed:nibName];
                }
            }
        }
    }
    return nil;
}

@end

@implementation NSObject (IDLInterfaceIdiom)

+ (UIUserInterfaceIdiom)userInterfaceIdiom
{
    return [[UIDevice currentDevice] userInterfaceIdiom];
}

- (UIUserInterfaceIdiom)userInterfaceIdiom
{
    return [[UIDevice currentDevice] userInterfaceIdiom];
}

@end

@implementation NSObject (IDLStringTag)

#define kNSObjectAssociatedObjectStringTag      @"NSObjectAssociatedObjectStringTag"
#define kNSObjectAssociatedObjectFlags          @"NSObjectAssociatedObjectFlags"

- (void)setStringTag:(NSString *)stringTag
{
    if (![stringTag isKindOfClass:[NSString class]]) {
        stringTag = nil;
    }
    objc_setAssociatedObject(self, kNSObjectAssociatedObjectStringTag, stringTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)stringTag
{
    return objc_getAssociatedObject(self, kNSObjectAssociatedObjectStringTag);
}

@end

@implementation NSObject (IDLPointerKey)

- (NSString *)pointerKey
{
    return [NSString stringWithFormat:@"%@<%p>",self.className, self];
}

@end

@implementation NSObject (IDLFlags)

-(IDLFlagSet *)flags
{
    IDLFlagSet *flags = objc_getAssociatedObject(self, kNSObjectAssociatedObjectFlags);
    if (flags == nil) {
        flags = [IDLFlagSet new];
        objc_setAssociatedObject(self, kNSObjectAssociatedObjectFlags, flags, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return flags;
}

@end

@implementation NSObject (IDLSwizzle)

+ (void)swizzleMethods:(Method)originalMethod originalSelector:(SEL)originalSelector withNewMethod:(Method)newMethod newSelector:(SEL)newSelector
{
    BOOL methodAdded = class_addMethod([self class],
                                       originalSelector,
                                       method_getImplementation(newMethod),
                                       method_getTypeEncoding(newMethod));
    
    if (methodAdded) {
        class_replaceMethod([self class],
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}

+ (void)swizzleInstanceSelector:(SEL)originalSelector withNewSelector:(SEL)newSelector
{
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method newMethod = class_getInstanceMethod(self, newSelector);
    
    [self swizzleMethods:originalMethod originalSelector:originalSelector withNewMethod:newMethod newSelector:newSelector];
}

+ (void)swizzleClassSelector:(SEL)originalSelector withNewSelector:(SEL)newSelector
{
    Method originalMethod = class_getClassMethod(self, originalSelector);
    Method newMethod = class_getClassMethod(self, newSelector);
    
    [self swizzleMethods:originalMethod originalSelector:originalSelector withNewMethod:newMethod newSelector:newSelector];
}

@end
