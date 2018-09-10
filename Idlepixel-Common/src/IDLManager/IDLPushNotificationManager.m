//
//  IDLPushNotificationManager.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 13/03/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLPushNotificationManager.h"
#import "NSUserDefaults+Idlepixel.h"
#import "NSString+Idlepixel.h"
#import "NSNotificationCenter+Idlepixel.h"
#import "IDLMacroHeaders.h"
#import "IDLNSInlineExtensions.h"

NSString * const NotificationManagerDeviceTokenChangedNotification                   = @"NotificationManagerDeviceTokenChangedNotification";

#define kPushNotificationDeviceToken            @"PushNotificationDeviceToken"

@interface IDLPushNotificationManager ()

@property (nonatomic, strong, readwrite) NSArray *sessionRemoteNotifications;
@property (nonatomic, strong, readwrite) NSDictionary *applicationLaunchRemoteNotification;
@property (nonatomic, strong, readwrite) NSDictionary *applicationLaunchLocalNotification;
@property (nonatomic, strong, readwrite) NSError *applicationFailedToRegisterForRemoteNotificationsError;

@end

@implementation IDLPushNotificationManager

+(instancetype)sharedManager
{
    return [self preferredSingleton];
}

+(NSString *)stringFromDeviceToken:(NSData *)deviceToken
{
    if (deviceToken != nil) {
        static NSCharacterSet *strippingCharacterSet = nil;
        if (strippingCharacterSet == nil) strippingCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"< >"];
        NSString *string = [deviceToken.description stringByStrippingCharactersInSet:strippingCharacterSet];
        return string;
    } else {
        return nil;
    }
}

-(void)setDeviceToken:(NSData *)deviceToken
{
    static BOOL notificationPosted = NO;
    
    NSData *existingToken = self.deviceToken;
    
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forDeviceSpecificKey:kPushNotificationDeviceToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    BOOL difference = !NSObjectEquals(existingToken.description, deviceToken.description);
    
    if (difference || (!notificationPosted && deviceToken != nil)) {
        if (!difference) notificationPosted = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationManagerDeviceTokenChangedNotification];
    }
}

-(NSData *)deviceToken
{
    NSData *token = [[NSUserDefaults standardUserDefaults] objectForDeviceSpecificKey:kPushNotificationDeviceToken];
    if (token.length == 0) token = nil;
    return token;
}

-(NSString *)deviceTokenString
{
    return [IDLPushNotificationManager stringFromDeviceToken:self.deviceToken];
}

-(UIRemoteNotificationType)enabledRemoteNotificationTypes
{
    return [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
}

-(void)registerForRemoteNotificationTypes:(UIRemoteNotificationType)notificationTypes
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
}

- (void)applicationDidFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    self.applicationFailedToRegisterForRemoteNotificationsError = error;
}

- (void)applicationDidReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (userInfo != nil) {
        if (self.sessionRemoteNotifications == nil) {
            self.sessionRemoteNotifications = [NSArray arrayWithObject:userInfo];
        } else {
            self.sessionRemoteNotifications = [self.sessionRemoteNotifications arrayByAddingObject:userInfo];
        }
    }
}

- (void)applicationDidLaunchWithRemoteNotification:(NSDictionary *)userInfo
{
    self.applicationLaunchRemoteNotification = userInfo;
}

- (void)applicationDidLaunchWithLocalNotification:(NSDictionary *)userInfo
{
    self.applicationLaunchLocalNotification = userInfo;
}

@end
