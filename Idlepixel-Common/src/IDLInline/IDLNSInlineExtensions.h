//
//  IDLNSInlineExtensions.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 11/12/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdint.h>
#include <mach/mach_time.h>
#include <objc/runtime.h>
#import "IDLTypedefs.h"

#ifndef Idlepixel_Common_IDLNSInlineExtensions_h
#define Idlepixel_Common_IDLNSInlineExtensions_h

NS_INLINE NSInteger NSRangeGetMax(NSRange range)
{
    return (range.location + range.length);
}

NS_INLINE NSInteger NSIntegerRangedModulus(NSInteger value, NSInteger A, NSInteger B, BOOL excludeA, BOOL excludeB)
{
    if (A > B) {
        NSInteger ti = B;
        B = A;
        A = ti;
        BOOL tb = excludeB;
        excludeB = excludeA;
        excludeA = tb;
    }
    if (excludeA) A++;
    if (excludeB) B--;
    NSInteger diff = B - A;
    if (diff < 0) {
        value = NSIntegerMin;
    } else if (diff == 0) {
        value = A;
    } else {
        value -= A;
        value = value % diff;
        value += A;
    }
    return value;
}

NS_INLINE NSComparisonResult NSIntegerCompare(NSInteger a, NSInteger b)
{
    if (a < b) {
        return NSOrderedAscending;
    } else if (b < a) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

NS_INLINE NSComparisonResult NSDateComparisonResultOptions(NSDate *a, NSDate *b, BOOL newestFirst)
{
    NSComparisonResult result;
    if (a == b) {
        result = NSOrderedSame;
    } else if (CLASS_OR_NIL(a, NSDate) == nil) {
        result = NSOrderedAscending;
    } else if (CLASS_OR_NIL(b, NSDate) == nil) {
        result = NSOrderedDescending;
    } else {
        result = [a compare:b];
    }
    if (newestFirst) {
        result *= -1;
    }
    return result;
}

NS_INLINE NSComparisonResult NSDateComparisonResult(NSDate *a, NSDate *b)
{
    return NSDateComparisonResultOptions(a, b, NO);
}

NS_INLINE NSComparisonResult NSStringComparisonResultOptions(NSString *a, NSString *b, NSStringCompareOptions options)
{
    if (a == b) {
        return NSOrderedSame;
    } else if (CLASS_OR_NIL(a, NSString) == nil) {
        return NSOrderedAscending;
    } else if (CLASS_OR_NIL(b, NSString) == nil) {
        return NSOrderedDescending;
    } else {
        return [a compare:b options:options];
    }
}

NS_INLINE NSComparisonResult NSStringComparisonResult(NSString *a, NSString *b)
{
    return NSStringComparisonResultOptions(a, b, 0);
}

NS_INLINE IDLComparisonResult NSObjectCompare(NSObject *a, NSObject *b)
{
    if (a == b) {
        return IDLComparisonResultEqual;
    } else if (a == nil || b == nil) {
        return IDLComparisonResultNotEqual;
    } else if (![a isKindOfClass:[b class]]) {
        return IDLComparisonResultNotEqual;
    } else {
        return IDLComparisonResultInconclusive;
    }
}

NS_INLINE BOOL NSObjectEquals(NSObject *a, NSObject *b)
{
    IDLComparisonResult result = NSObjectCompare(a, b);
    if (result != IDLComparisonResultInconclusive) {
        return (BOOL)result;
    } else {
        return [a isEqual:b];
    }
}

NS_INLINE BOOL NSStringEquals(const NSString *a, const NSString *b)
{
    if ([a isKindOfClass:[NSString class]] && [b isKindOfClass:[NSString class]]) {
        return [(NSString *)a isEqualToString:(NSString *)b];
    } else {
        return (a == b);
    }
}

NS_INLINE BOOL NSStringCaseInsensitiveEquals(const NSString *a, const NSString *b)
{
    if ([a isKindOfClass:[NSString class]] && [b isKindOfClass:[NSString class]]) {
        return ([(NSString *)a compare:(NSString *)b options:NSCaseInsensitiveSearch] == NSOrderedSame);
    } else {
        return (a == b);
    }
}

NS_INLINE BOOL NSArrayEquals(NSArray *a, NSArray *b)
{
    if ([a isKindOfClass:[NSArray class]] && [b isKindOfClass:[NSArray class]]) {
        return [a isEqualToArray:b];
    } else {
        return (a == b);
    }
}

NS_INLINE NSArray *NSArrayCombine(NSArray *a, NSArray *b)
{
    if ([a isKindOfClass:[NSArray class]] && [b isKindOfClass:[NSArray class]]) {
        return [a arrayByAddingObjectsFromArray:b];
    } else if ([a isKindOfClass:[NSArray class]]) {
        return [NSArray arrayWithArray:a];
    } else if ([b isKindOfClass:[NSArray class]]) {
        return [NSArray arrayWithArray:b];
    } else {
        return nil;
    }
}

NS_INLINE NSString *NSStringFromInteger(NSInteger integer)
{
    return [NSString stringWithFormat:@"%li",(long)integer];
}

NS_INLINE NSString *NSStringWithLengthOrNil(NSString *a)
{
    if ([a isKindOfClass:[NSString class]] && a.length > 0) {
        return a;
    } else {
        return nil;
    }
}

NS_INLINE NSTimeInterval TimeIntervalFromMachTime(uint64_t time)
{
    static double conversion = 0.0;
    
    if (conversion == 0.0) {
        mach_timebase_info_data_t info;
        kern_return_t err = mach_timebase_info( &info );
        
        if (err == 0) {
            conversion = 1e-9 * (double) info.numer / (double) info.denom;
        }
    }
    
    return conversion * (double) time;
}

NS_INLINE NSTimeInterval SystemTimeSinceSystemStartup()
{
    return TimeIntervalFromMachTime(mach_absolute_time());
}

NS_INLINE NSTimeInterval SystemTimeSinceInterval(NSTimeInterval interval)
{
    return SystemTimeSinceSystemStartup()-interval;
}

NS_INLINE BOOL ClassOrSuperclassConformsToProtocol(Class aClass, Protocol* protocol)
{
    Class superClass = aClass;
    while (superClass != nil) {
        if (class_conformsToProtocol(superClass, protocol)) {
            return YES;
        }
        superClass = class_getSuperclass(superClass);
    }
    return NO;
}

// Adapted from http://stackoverflow.com/questions/3139619/check-that-an-email-address-is-valid-on-ios
// Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
NS_INLINE BOOL NSStringIsValidEmail(NSString *string, BOOL strictFilter)
{
    if (string.length > 0) {
        NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
        NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
        NSString *emailRegex = strictFilter ? stricterFilterString : laxString;
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        return [emailTest evaluateWithObject:string];
    } else {
        return NO;
    }
}

NS_INLINE NSString* NSStringFromCATransform3D(CATransform3D t)
{
	return [NSString stringWithFormat: @"%0.2f,%0.2f,%0.2f,%0.2f\n%0.2f,%0.2f,%0.2f,%0.2f\n%0.2f,%0.2f,%0.2f,%0.2f\n%0.2f,%0.2f,%0.2f,%0.2f",
			t.m11, t.m12, t.m13, t.m14,
			t.m21, t.m22, t.m23, t.m24,
			t.m31, t.m32, t.m33, t.m34,
			t.m41, t.m42, t.m43, t.m44];
}


NS_INLINE BOOL AddUniqueClassToDictionaryWithKey(NSMutableDictionary *dictionary, Class aClass, NSString *aKey)
{
    Class existingClass = [dictionary objectForKey:aKey];
    if (existingClass == nil || existingClass == aClass) {
        if (existingClass == nil) [dictionary setObject:aClass forKey:aKey];
        return YES;
    } else {
        return NO;
    }
}

NS_INLINE IDLTimeIntervalRange IDLTimeIntervalRangeMake(NSTimeInterval start, NSTimeInterval duration)
{
    IDLTimeIntervalRange range;
    range.start = start;
    range.duration = duration;
    return range;
}

#pragma mark - IDLVersion

NS_INLINE IDLVersion IDLVersionFromString(NSString *string)
{
    NSArray *components = [string componentsSeparatedByString:@"."];
	
	IDLVersion version;
    
	NSUInteger componentCount = [components count];
	
    if (componentCount > 0) {
        version.major = [[components objectAtIndex:0] intValue];
    } else {
        version.major = 0;
    }
    if (componentCount > 1) {
        version.minor = [[components objectAtIndex:1] intValue];
    } else {
        version.minor = 0;
    }
    if (componentCount > 2) {
        version.point = [[components objectAtIndex:2] intValue];
    } else {
        version.point = 0;
    }
    if (componentCount > 3) {
        version.build = [[components objectAtIndex:3] intValue];
    } else {
        version.build = 0;
    }
	return version;
}

NS_INLINE NSString *NSStringFromIDLVersion(IDLVersion version, BOOL full)
{
    NSMutableArray *components = [NSMutableArray array];
    [components addObject:@(version.major)];
    [components addObject:@(version.minor)];
    if (full || version.point > 0) {
        [components addObject:@(version.point)];
        if (full || version.build > 0) {
            [components addObject:@(version.build)];
        }
    }
    return [components componentsJoinedByString:@"."];
}

NS_INLINE NSComparisonResult IDLVersionCompare(IDLVersion version, IDLVersion otherVersion)
{
    if (version.major < otherVersion.major) {
        return NSOrderedAscending;
    } else if (version.major == otherVersion.major) {
        if (version.minor < otherVersion.minor) {
            return NSOrderedAscending;
        } else if (version.minor == otherVersion.minor) {
            if (version.point < otherVersion.point) {
                return NSOrderedAscending;
            } else if (version.point == otherVersion.point) {
                if (version.build < otherVersion.build) {
                    return NSOrderedAscending;
                } else if (version.build == otherVersion.build) {
                    return NSOrderedSame;
                }
            }
        }
    }
    return NSOrderedDescending;
}

#endif
