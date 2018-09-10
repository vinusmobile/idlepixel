//
//  IDLAbstractSharedSingleton.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 13/03/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLAbstractSharedSingleton.h"
#import "NSObject+Idlepixel.h"

NS_INLINE NSString* IDLSingletonKeyFromClass(Class c)
{
    return NSStringFromClass([c class]);
}

@interface IDLAbstractSharedSingleton ()

+(instancetype)preferredSingletonForClass:(Class)singletonClass;

@end

@implementation IDLAbstractSharedSingleton

+(instancetype)preferredSingletonForClass:(Class)singletonClass
{
    if (singletonClass == nil || ![singletonClass isSubclassOfClass:[IDLAbstractSharedSingleton class]]) return nil;
    
    __strong static NSMutableDictionary *dictionary = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dictionary = [NSMutableDictionary dictionary];
    });
    
    IDLAbstractSharedSingleton *singleton = [dictionary objectForKey:IDLSingletonKeyFromClass(singletonClass)];
    
    if (singleton == nil) {
        
        Class preferredSingletonClass = nil;
        
        BOOL ignorePreferredSingletonClass = [singletonClass ignorePreferredSingletonClass];
        
        if (ignorePreferredSingletonClass) {
            preferredSingletonClass = singletonClass;
        } else {
            preferredSingletonClass = [self preferredSingletonClassForClass:singletonClass searchSuperClasses:YES];
        }
        
        if (preferredSingletonClass == nil) {
            preferredSingletonClass = singletonClass;
            Class rootSingletonClass = [singletonClass rootSingletonClass];
            if (rootSingletonClass != singletonClass) {
                IDLLog(@"WARNING: No preferred singleton class found for %@ (%@). Consider setting isPreferredSingleton to YES on preferred class.", NSStringFromClass(singletonClass),NSStringFromClass([singletonClass rootSingletonClass]));
            }
        }
        
        singleton = [dictionary objectForKey:IDLSingletonKeyFromClass(preferredSingletonClass)];
        
        if (singleton == nil) {
            
            Class rootSingletonClass = [singletonClass rootSingletonClass];
            singleton = [dictionary objectForKey:IDLSingletonKeyFromClass(rootSingletonClass)];
            
            if (singleton == nil) {
                singleton = [preferredSingletonClass new];
                [dictionary setObject:singleton forKey:IDLSingletonKeyFromClass(singletonClass)];
                if (!ignorePreferredSingletonClass) {
                    [dictionary setObject:singleton forKey:IDLSingletonKeyFromClass(preferredSingletonClass)];
                    if (![rootSingletonClass isPreferredSingletonClass]) {
                        [dictionary setObject:singleton forKey:IDLSingletonKeyFromClass(rootSingletonClass)];
                    }
                }
            }
        }
    }
    //IDLLogContext(@"%@ - preferred singleton: %@",NSStringFromClass(singletonClass),singleton);
    return singleton;
}

+(Class)preferredSingletonClassForClass:(Class)singletonClass searchSuperClasses:(BOOL)searchSuperClasses
{
    if ([singletonClass isPreferredSingletonClass]) {
        return singletonClass;
    } else {
        
        NSArray *subClasses = [singletonClass immediateSubclasses];
        
        for (Class subClass in subClasses) {
            if ([subClass isPreferredSingletonClass]) {
                return subClass;
            }
        }
        // not found, so loop through again more thoroughly checking sub-subclasses
        Class preferredSingletonClass = nil;
        
        for (Class subClass in subClasses) {
            preferredSingletonClass = [self preferredSingletonClassForClass:subClass searchSuperClasses:NO];
            if (preferredSingletonClass != nil) return preferredSingletonClass;
        }
        // not found - check superclasses if allowed
        if (searchSuperClasses) {
            Class superClass = singletonClass;
            while ([superClass superclass] != [IDLAbstractSharedSingleton class]) {
                superClass = [superClass superclass];
                if ([superClass isPreferredSingletonClass]) return superClass;
            }
        }
        
        return nil;
    }
}

+(instancetype)preferredSingleton
{
    if ([self class] != [IDLAbstractSharedSingleton class]) {
        return [self preferredSingletonForClass:[self class]];
    } else {
        return nil;
    }
}

+(BOOL)isPreferredSingletonClass
{
    return NO;
}

+(BOOL)ignorePreferredSingletonClass
{
    return NO;
}

+(Class)rootSingletonClass
{
    if ([self class] == [IDLAbstractSharedSingleton class]) return nil;
    
    Class superClass = [self class];
    while ([superClass superclass] != [IDLAbstractSharedSingleton class]) {
        superClass = [superClass superclass];
    }
    return superClass;
}

@end
