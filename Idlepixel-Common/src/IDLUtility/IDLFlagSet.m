//
//  IDLFlagSet.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 21/03/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLFlagSet.h"
#import "NSSet+Idlepixel.h"

NS_INLINE NSObject *KeyFromString(NSString *aKey)
{
    if ([aKey isKindOfClass:[NSString class]]) {
        return aKey;
    } else {
        return [NSNull null];
    }
}

@interface IDLFlagSet ()

@property (nonatomic, strong) NSSet *flags;

@end

@implementation IDLFlagSet

-(BOOL)flagForKey:(NSString *)aKey
{
    return [_flags containsObject:KeyFromString(aKey)];
}

-(void)setFlagForKey:(NSString *)aKey
{
    if (_flags != nil) {
        _flags = [_flags setByAddingObject:KeyFromString(aKey)];
    } else {
        _flags = [NSSet setWithObject:KeyFromString(aKey)];
    }
}

-(void)clearFlagForKey:(NSString *)aKey
{
    if (_flags != nil) {
        _flags = [_flags setByRemovingObject:KeyFromString(aKey)];
    }
}

@end
