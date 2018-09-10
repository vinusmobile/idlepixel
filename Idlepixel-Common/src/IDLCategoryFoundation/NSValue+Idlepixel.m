//
//  NSValue+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 17/03/2014.
//  Copyright (c) 2014 Trystan Pfluger. All rights reserved.
//

#import "NSValue+Idlepixel.h"

@implementation NSValue (Idlepixel)

+ (NSValue *)valueWithFloatRange:(IDLFloatRange)range
{
    return [NSValue value:&range withObjCType:@encode(IDLFloatRange)];
}

- (IDLFloatRange)floatRangeValue
{
    IDLFloatRange range;
    [self getValue:&range];
    return range;
}

@end
