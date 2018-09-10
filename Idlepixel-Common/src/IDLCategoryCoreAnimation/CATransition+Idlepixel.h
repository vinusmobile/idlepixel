//
//  CATransition+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 19/07/2014.
//  Copyright (c) 2014 Trystan Pfluger. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CATransition (Idlepixel)

+(CATransition *)transitionWithType:(NSString *)type subtype:(NSString *)subtype duration:(NSTimeInterval)duration;
+(CATransition *)transitionWithType:(NSString *)type subtype:(NSString *)subtype duration:(NSTimeInterval)duration timingFunctionName:(NSString *)timingFunctionName;

@end
