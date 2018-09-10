//
//  IDLGlobal.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 27/03/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLGlobal.h"

@interface IDLGlobal ()

@end

@implementation IDLGlobal

+(instancetype)shared
{
    return [self preferredSingleton];
}

-(NSInteger)nextInteger
{
    static NSInteger counter = 0;
    return counter++;
}

@end
