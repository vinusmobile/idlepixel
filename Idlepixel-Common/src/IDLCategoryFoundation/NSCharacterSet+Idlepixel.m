//
//  NSCharacterSet+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 11/12/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "NSCharacterSet+Idlepixel.h"

NSString * const kNSCharacterSetHexadecimalCharacters = @"0123456789abcdefABCDEF";
NSString * const kNSCharacterSetDigitCharacters = @"0123456789";

@implementation NSCharacterSet (IDLHexadecimal)

+(NSCharacterSet *)hexadecimalCharacterSet
{
    return [NSCharacterSet characterSetWithCharactersInString:kNSCharacterSetHexadecimalCharacters];
}

+(NSCharacterSet *)digitCharacterSet
{
    return [NSCharacterSet characterSetWithCharactersInString:kNSCharacterSetDigitCharacters];
}

@end
