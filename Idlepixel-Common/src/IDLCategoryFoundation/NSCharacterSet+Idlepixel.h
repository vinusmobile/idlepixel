//
//  NSCharacterSet+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 11/12/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kNSCharacterSetHexadecimalCharacters;
extern NSString * const kNSCharacterSetDigitCharacters;

@interface NSCharacterSet (IDLHexadecimal)

+(NSCharacterSet *)hexadecimalCharacterSet;
+(NSCharacterSet *)digitCharacterSet;

@end
