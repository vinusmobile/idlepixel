//
//  NSNotification+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 2/10/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "NSNotification+Idlepixel.h"
#import "IDLNSInlineExtensions.h"

NSString * const kNotificationCenterServiceFault                           = @"NotificationCenterServiceFault";

@implementation NSNotification (IDLEqualToNotification)

-(BOOL)isEqualToNotification:(NSNotification *)notification
{
    if (self == notification) {
        return YES;
    } else if (![notification isKindOfClass:[NSNotification class]]) {
        return NO;
    } else {
        if (!NSStringEquals(self.name, notification.name)) {
            return NO;
        } else if (self.object != notification.object) {
            return NO;
        } else if ((self.userInfo != notification.userInfo) && ![self.userInfo isEqualToDictionary:notification.userInfo]) {
            return NO;
        } else {
            return YES;
        }
    }
}

@end
