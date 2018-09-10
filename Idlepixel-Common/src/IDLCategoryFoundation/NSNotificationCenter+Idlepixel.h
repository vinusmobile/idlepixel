//
//  NSNotificationCenter+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 2/10/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLNotificationObserverProtocol.h"

@interface NSNotificationCenter (IDLNotificationObserver)

-(void)postNotificationName:(NSString *)notificationName;

-(void)addNotificationObserver:(id<IDLNotificationObserver>)notificationObserver name:(NSString *)notificationName;
-(void)addNotificationObserver:(id<IDLNotificationObserver>)notificationObserver name:(NSString *)notificationName object:(id)notificationSender;

@end

@interface NSNotificationCenter (IDLRemoveObserver)

-(void)removeObserver:(id)observer name:(NSString *)aName;

@end
