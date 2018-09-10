//
//  IDLFontStore.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 22/03/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLFontStore.h"

@implementation IDLFontStore

-(void)storeFont:(UIFont *)aFont withIdentifier:(NSString *)identifier
{
    [self storeFont:aFont withIdentifier:identifier style:nil];
}

-(void)storeFont:(UIFont *)aFont withIdentifier:(NSString *)identifier style:(NSString *)style
{
    [self storeFont:aFont withIdentifier:identifier style:style viewClass:nil];
}

-(void)storeFont:(UIFont *)aFont withIdentifier:(NSString *)identifier style:(NSString *)style viewClass:(Class)viewClass
{
    [self storeObject:aFont withPrimaryIdentifier:identifier secondary:style tertiary:NSStringFromClass(viewClass)];
}

-(UIFont *)storedFontWithIdentifier:(NSString *)identifier
{
    return [self storedFontWithIdentifier:identifier style:nil];
}

-(UIFont *)storedFontWithIdentifier:(NSString *)identifier style:(NSString *)style
{
    return [self storedFontWithIdentifier:identifier style:style viewClass:nil];
}

-(UIFont *)storedFontWithIdentifier:(NSString *)identifier style:(NSString *)style viewClass:(Class)viewClass
{
    return [self storedObjectWithPrimaryIdentifier:identifier secondary:style tertiary:NSStringFromClass(viewClass)];
}

@end
