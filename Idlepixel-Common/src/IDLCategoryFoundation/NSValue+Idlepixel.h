//
//  NSValue+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 17/03/2014.
//  Copyright (c) 2014 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLCGInlineExtensions.h"
#import "IDLTypedefs.h"

@interface NSValue (IDLFloatRange)

+ (NSValue *)valueWithFloatRange:(IDLFloatRange)range;
- (IDLFloatRange)floatRangeValue;

@end
