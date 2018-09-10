//
//  NSNotificationCenter+NotificationObserver.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 2/10/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "NSNotificationCenter+Idlepixel.h"

@implementation NSNotificationCenter (IDLNotificationObserver)

-(void)postNotificationName:(NSString *)notificationName
{
    [self postNotificationName:notificationName object:nil];
}

-(void)addNotificationObserver:(id<IDLNotificationObserver>)notificationObserver name:(NSString *)notificationName
{
    [self addObserver:notificationObserver selector:kNotificationObserverSelector name:notificationName object:nil];
}

-(void)addNotificationObserver:(id<IDLNotificationObserver>)notificationObserver name:(NSString *)notificationName object:(id)notificationSender
{
    [self addObserver:notificationObserver selector:kNotificationObserverSelector name:notificationName object:notificationSender];
}

@end

@implementation NSNotificationCenter (IDLRemoveObserver)

-(void)removeObserver:(id)observer name:(NSString *)aName
{
    [self removeObserver:observer name:aName object:nil];
}

@end
