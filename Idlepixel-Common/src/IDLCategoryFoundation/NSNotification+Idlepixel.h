//
//  NSNotification+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 2/10/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kNotificationCenterServiceFault;

@interface NSNotification (IDLEqualToNotification)

-(BOOL)isEqualToNotification:(NSNotification *)notification;

@end