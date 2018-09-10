//
//  NSIndexPath+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 14/01/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIndexPath (OddEven)

@property (readonly) BOOL rowOdd;
@property (readonly) BOOL rowEven;

@property (readonly) BOOL itemOdd;
@property (readonly) BOOL itemEven;

@property (readonly) BOOL sectionOdd;
@property (readonly) BOOL sectionEven;

@end
