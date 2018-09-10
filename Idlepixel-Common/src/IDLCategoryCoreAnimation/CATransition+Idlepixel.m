//
//  CATransition+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 19/07/2014.
//  Copyright (c) 2014 Trystan Pfluger. All rights reserved.
//

#import "CATransition+Idlepixel.h"

@implementation CATransition (Idlepixel)

+(CATransition *)transitionWithType:(NSString *)type subtype:(NSString *)subtype duration:(NSTimeInterval)duration
{
    return [self transitionWithType:type subtype:subtype duration:duration timingFunctionName:kCAMediaTimingFunctionEaseInEaseOut];
}

+(CATransition *)transitionWithType:(NSString *)type subtype:(NSString *)subtype duration:(NSTimeInterval)duration timingFunctionName:(NSString *)timingFunctionName
{
    CATransition* transition = [CATransition animation];
    transition.timingFunction = [CAMediaTimingFunction functionWithName:timingFunctionName];
    transition.duration = duration;
    transition.type =  type;
    transition.subtype = subtype;
    return transition;
}

@end
