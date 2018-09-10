//
//  IDLQueuedNotificationCenter.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 2/10/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLNotificationObserverProtocol.h"
#import "NSNotification+Idlepixel.h"
#import "NSNotificationCenter+Idlepixel.h"

@interface IDLQueuedNotificationCenter : NSNotificationCenter

+(instancetype)sharedCenter;

+(void)removeObserver:(id)notificationObserver;
+(void)removeObserver:(id)notificationObserver name:(NSString *)notificationName;
+(void)removeObserver:(id)notificationObserver name:(NSString *)notificationName object:(id)notificationSender;
+(void)addObserver:(id)notificationObserver selector:(SEL)notificationSelector name:(NSString *)notificationName;
+(void)addObserver:(id)notificationObserver selector:(SEL)notificationSelector name:(NSString *)notificationName object:(id)notificationSender;

+(void)addNotificationObserver:(id<IDLNotificationObserver>)notificationObserver name:(NSString *)notificationName;
+(void)addNotificationObserver:(id<IDLNotificationObserver>)notificationObserver name:(NSString *)notificationName object:(id)notificationSender;

+(void)invalidateElement:(NSString *)notificationConstant;

+(void)postServiceFault;
+(void)postServiceFaultWithInfo:(NSDictionary *)userInfo;

-(void)invalidateElement:(NSString *)notificationConstant;

-(void)postNotificationImmediately:(NSNotification *)notification;
-(void)postNotificationImmediatelyName:(NSString *)notificationName;
-(void)postNotificationImmediatelyName:(NSString *)notificationName object:(id)notificationSender;
-(void)postNotificationImmediatelyName:(NSString *)notificationName object:(id)notificationSender userInfo:(NSDictionary *)userInfo;

@end
