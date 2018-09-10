//
//  NSIndexSet+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 12/09/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "NSIndexSet+Idlepixel.h"

@implementation NSIndexSet (IDLRangeCount)

-(NSUInteger)countOfRanges
{
    NSUInteger count = 0;
    if (self.count > 0) {
        count++;
        NSUInteger index = self.firstIndex;
        NSUInteger lastIndex = index;
        do {
            if ((index - lastIndex) > 1) {
                count++;
            }
            index = [self indexGreaterThanIndex:index];
        } while (index != NSNotFound);
    }
    return count;
}

@end
