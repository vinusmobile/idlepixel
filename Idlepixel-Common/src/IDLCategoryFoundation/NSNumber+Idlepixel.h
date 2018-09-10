//
//  NSNumber+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 27/12/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (IDLNumberType)

@property (readonly) CFNumberType numberType;

@property (readonly) BOOL isNaN;
@property (readonly) BOOL isPositiveInfinity;
@property (readonly) BOOL isNegativeInfinity;
@property (readonly) BOOL isBOOL;
@property (readonly) BOOL isInteger;
@property (readonly) BOOL isFloat;

@end
