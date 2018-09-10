//
//  NSIndexPath+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 14/01/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "NSIndexPath+Idlepixel.h"

@implementation NSIndexPath (OddEven)

-(BOOL)sectionEven
{
    return (self.section % 2) == 0;
}

-(BOOL)sectionOdd
{
    return !self.sectionEven;
}

-(BOOL)rowEven
{
    return (self.row % 2) == 0;
}

-(BOOL)rowOdd
{
    return !self.rowEven;
}

-(BOOL)itemEven
{
    return self.rowEven;
}

-(BOOL)itemOdd
{
    return !self.itemEven;
}

@end
