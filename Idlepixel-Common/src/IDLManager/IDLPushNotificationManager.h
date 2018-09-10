//
//  IDLPushNotificationManager.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 13/03/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLAbstractSharedSingleton.h"

extern NSString * const NotificationManagerDeviceTokenChangedNotification;

@interface IDLPushNotificationManager : IDLAbstractSharedSingleton

+ (instancetype)sharedManager;

+(NSString *)stringFromDeviceToken:(NSData *)deviceToken;

@property (weak) NSData *deviceToken;
@property (readonly) NSString *deviceTokenString;

@property (nonatomic, strong, readonly) NSArray *sessionRemoteNotifications;
@property (nonatomic, strong, readonly) NSDictionary *applicationLaunchRemoteNotification;
@property (nonatomic, strong, readonly) NSDictionary *applicationLaunchLocalNotification;
@property (nonatomic, strong, readonly) NSError *applicationFailedToRegisterForRemoteNotificationsError;

- (UIRemoteNotificationType)enabledRemoteNotificationTypes;
- (void)registerForRemoteNotificationTypes:(UIRemoteNotificationType)notificationTypes;

- (void)applicationDidFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

- (void)applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo;
- (void)applicationDidLaunchWithRemoteNotification:(NSDictionary *)userInfo;
- (void)applicationDidLaunchWithLocalNotification:(NSDictionary *)userInfo;

@end
