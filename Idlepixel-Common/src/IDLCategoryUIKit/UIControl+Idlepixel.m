//
//  UIControl+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 27/03/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "UIControl+Idlepixel.h"
#import "NSSet+Idlepixel.h"
#import "NSArray+Idlepixel.h"

@implementation UIControl (IDLActions)

-(void)removeTargetsInArray:(NSArray *)targetArray
{
    if (targetArray.count > 0) {
        [self removeTargetsInSet:[NSSet setWithArray:targetArray]];
    }
}

-(void)removeTargetsInSet:(NSSet *)targetSet
{
    if (targetSet.count > 0) {
        
        targetSet = [targetSet copy];
        for (NSObject *target in targetSet) {
            [self removeTarget:target];
        }
    }
}

-(void)removeTarget:(NSObject *)target
{
    if (target) {
        [self removeTarget:target action:NULL forControlEvents:UIControlEventAllEvents];
    }
}

-(void)removeTargetsWithClass:(Class)aClass
{
    NSSet *set = [self.allTargets setByRemovingObjectsNotBelongingToClass:[aClass class]];
    [self removeTargetsInSet:set];
}

-(void)removeAllTargets
{
    NSSet *allTargets = self.allTargets;
    [self removeTargetsInSet:allTargets];
}

@end
