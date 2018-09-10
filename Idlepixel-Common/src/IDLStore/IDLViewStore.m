//
//  IDLViewStore.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 30/01/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLViewStore.h"
#import "IDLViewManager.h"

@implementation IDLViewStore

-(void)storeView:(UIView *)aView withReuseIdentifier:(NSString *)reuseIdentifier
{
    [self storeView:aView withReuseIdentifier:reuseIdentifier caller:nil];
}

-(void)storeView:(UIView *)aView withReuseIdentifier:(NSString *)reuseIdentifier caller:(NSString *)caller
{
    [self storeObject:aView withPrimaryIdentifier:reuseIdentifier secondary:caller];
}

-(id)storedViewWithReuseIdentifier:(NSString *)reuseIdentifier
{
    return [self storedViewWithReuseIdentifier:reuseIdentifier caller:nil];
}

-(id)storedViewWithReuseIdentifier:(NSString *)reuseIdentifier caller:(NSString *)caller
{
    return [self storedObjectWithPrimaryIdentifier:reuseIdentifier secondary:caller];
}

-(id)platformSubclassInstanceWithReuseIdentifier:(NSString *)reuseIdentifier
{
    return [self platformSubclassInstanceWithReuseIdentifier:reuseIdentifier caller:nil];
}

-(id)platformSubclassInstanceWithReuseIdentifier:(NSString *)reuseIdentifier caller:(NSString *)caller
{
    id instance = [self storedViewWithReuseIdentifier:reuseIdentifier caller:caller];
    if (instance == nil) {
        instance = [IDLViewManager platformSubclassInstanceWithReuseIdentifier:reuseIdentifier];
        if (instance != nil) {
            [self storeView:instance withReuseIdentifier:reuseIdentifier caller:caller];
        }
    }
    return instance;
}

@end
