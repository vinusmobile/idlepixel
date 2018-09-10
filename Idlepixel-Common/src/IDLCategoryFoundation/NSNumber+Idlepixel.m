//
//  NSNumber+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 27/12/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "NSNumber+Idlepixel.h"
#import "NSObject+Idlepixel.h"
#import "NSString+Idlepixel.h"

@implementation NSNumber (IDLNumberType)

-(CFNumberType)numberType
{
    return CFNumberGetType((CFNumberRef)self);
}

-(BOOL)isNaN
{
    return [self isEqualToNumber:(NSNumber *)kCFNumberNaN];
}

-(BOOL)isPositiveInfinity
{
    return [self isEqualToNumber:(NSNumber *)kCFNumberPositiveInfinity];
}

-(BOOL)isNegativeInfinity
{
    return [self isEqualToNumber:(NSNumber *)kCFNumberNegativeInfinity];
}

-(BOOL)isBOOL
{
    return [self.className containsCaseInsensitiveString:@"Boolean"];
}

-(BOOL)isInteger
{
    CFNumberType type = self.numberType;
    
    switch (type) {
        case kCFNumberSInt8Type:
        case kCFNumberSInt16Type:
        case kCFNumberSInt32Type:
        case kCFNumberSInt64Type:
        case kCFNumberCharType:
        case kCFNumberShortType:
        case kCFNumberIntType:
        case kCFNumberLongType:
        case kCFNumberLongLongType:
        case kCFNumberNSIntegerType:
        {
            return !self.isBOOL;
            break;
        }
        default:
            return NO;
            break;
    }
}

-(BOOL)isFloat
{
    CFNumberType type = self.numberType;
    
    switch (type) {
        case kCFNumberFloat32Type:
        case kCFNumberFloat64Type:
        case kCFNumberFloatType:
        case kCFNumberDoubleType:
        case kCFNumberCGFloatType:
            return YES;
            break;
            
        default:
            return NO;
            break;
    }
}

@end
