//
//  UINib+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 7/01/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "UINib+Idlepixel.h"
#import "NSObject+Idlepixel.h"

@implementation UINib (IDLPlatform)

+ (UINib *)platformNibWithNibName:(NSString *)name
{
    return [self platformNibWithNibName:name bundle:[NSBundle mainBundle]];
}

+ (UINib *)platformNibWithNibName:(NSString *)name bundle:(NSBundle *)bundleOrNil
{
    NSString *nibName = [self platformNibName:name fromBundle:bundleOrNil];
    if (nibName != nil) {
        return [self nibWithNibName:nibName bundle:bundleOrNil];
    } else {
        return nil;
    }
}

+ (UINib *)platformNibForClass:(Class)nibClass
{
    return [self platformNibForClass:nibClass bundle:[NSBundle mainBundle]];
}

+ (UINib *)platformNibForClass:(Class)nibClass bundle:(NSBundle *)bundleOrNil
{
    return [self platformNibWithNibName:[nibClass className] bundle:bundleOrNil];
}

@end
