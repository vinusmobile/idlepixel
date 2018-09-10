//
//  IDLAbstractApplicationDelegate.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 13/03/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLAbstractApplicationDelegate.h"
#import "IDLViewController.h"
#import "IDLDateKeeper.h"
#import "NSUserDefaults+Idlepixel.h"
#import "NSBundle+Idlepixel.h"
#import "IDLAbstractModel.h"
#import "IDLAbstractBootstrap.h"
#import "IDLPushNotificationManager.h"
#import "NSDictionary+Idlepixel.h"
#import "NSObject+Idlepixel.h"
#import "UIApplication+Idlepixel.h"

#import "IDLTimerWrapper.h"

@interface IDLAbstractApplicationDelegate ()

@property (nonatomic, assign) BOOL observersSetup;
@property (nonatomic, readwrite, assign) NSTimeInterval applicationResignedTimeStamp;
@property (nonatomic, strong) IDLTimerWrapper *savePersistentModelDataTimer;

-(void)updateObservers:(BOOL)enable;

-(void)startSavePersistentModelDataTimer;
-(void)stopSavePersistentModelDataTimer;
-(void)savePersistentModelDataTimerFired:(IDLTimerWrapper *)timer;

@end

@implementation IDLAbstractApplicationDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#if (TARGET_IPHONE_SIMULATOR)
    NSLog(@"BUNDLE: %@", [NSBundle applicationPath]);
    NSLog(@"LIBRARY: %@", application.libraryPath);
#endif
    [self executeLaunchBootstraps];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [IDLDateKeeper recordApplicationLaunch];
    
    NSDictionary *notificationsUserInfo = [launchOptions dictionaryForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (notificationsUserInfo != nil) {
        [[IDLPushNotificationManager sharedManager] applicationDidLaunchWithRemoteNotification:notificationsUserInfo];
    }
    notificationsUserInfo = [launchOptions dictionaryForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (notificationsUserInfo != nil) {
        [[IDLPushNotificationManager sharedManager] applicationDidLaunchWithRemoteNotification:notificationsUserInfo];
    }
    
    [IDLViewController registerStoryboardForIdentifierUse:self.window.rootViewController.storyboard];
    
    [self initializeRootViewController:application didFinishLaunchingWithOptions:launchOptions];
    
    [self performSelector:@selector(performLaunchOperations) withObject:nil afterDelay:0.01f];
    
    return YES;
}

- (void)initializeRootViewController:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // do nothing, meant for override
}

- (void)performLaunchOperations
{
    [self setupObservers];
    [[IDLAbstractModel sharedModel] performLaunchOperations];
}

- (void)executeLaunchBootstraps
{
    NSArray *bootstrapClasses = [IDLAbstractBootstrap allSubclasses];
    IDLAbstractBootstrap *bootstrap = nil;
    for (Class c in bootstrapClasses) {
        if (c != [IDLAbstractBootstrap class] && [c executeAtLaunch] && ![c instanceExecuted]) {
            bootstrap = [c new];
            [bootstrap execute];
        }
    }
}

- (void)saveData:(BOOL)willTerminate
{
    // do nothing, meant for override
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    self.applicationResignedTimeStamp = [IDLDateKeeper timeSinceApplicationStartup];
    [self updateObservers:NO];
    [self stopSavePersistentModelDataTimer];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self updateObservers:NO];
    [self stopSavePersistentModelDataTimer];
    [self saveData:NO];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [self updateObservers:YES];
    [self startSavePersistentModelDataTimer];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [self updateObservers:YES];
    [self startSavePersistentModelDataTimer];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self updateObservers:NO];
    [self stopSavePersistentModelDataTimer];
    [self saveData:YES];
}

-(void)updateObservers:(BOOL)enable
{
    @synchronized(self) {
        if (enable != self.observersSetup) {
            if (enable) {
                [self setupObservers];
            } else {
                [self removeObservers];
            }
            self.observersSetup = enable;
        }
    }
}

- (void)setupObservers
{
    // do nothing, meant for override
}

- (void)removeObservers
{
    // do nothing, meant for override
}

-(void)notificationObserved:(NSNotification *)notification
{
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[IDLPushNotificationManager sharedManager] setDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    IDLLogObject(error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[IDLPushNotificationManager sharedManager] applicationDidReceiveRemoteNotification:userInfo];
}

#pragma mark - save persistent model data timer

-(void)setSavePersistentModelDataInterval:(NSTimeInterval)savePersistentModelDataInterval
{
    _savePersistentModelDataInterval = savePersistentModelDataInterval;
    if (_savePersistentModelDataInterval > 0.0f) {
        [self startSavePersistentModelDataTimer];
    } else {
        [self stopSavePersistentModelDataTimer];
    }
}

-(void)startSavePersistentModelDataTimer
{
    if (self.savePersistentModelDataInterval > 0.0f) {
        if (self.savePersistentModelDataTimer == nil) {
            self.savePersistentModelDataTimer = [IDLTimerWrapper timerWithInterval:self.savePersistentModelDataInterval];
            [self.savePersistentModelDataTimer addTarget:self selector:@selector(savePersistentModelDataTimerFired:)];
            [self.savePersistentModelDataTimer start];
        } else if (self.savePersistentModelDataInterval != self.savePersistentModelDataTimer.interval) {
            self.savePersistentModelDataTimer.interval = self.savePersistentModelDataInterval;
            [self.savePersistentModelDataTimer start];
        }
    } else {
        [self stopSavePersistentModelDataTimer];
    }
}

-(void)stopSavePersistentModelDataTimer
{
    if (self.savePersistentModelDataTimer) {
        [self.savePersistentModelDataTimer stop];
        [self.savePersistentModelDataTimer removeTarget:self];
        self.savePersistentModelDataTimer = nil;
    }
}

-(void)savePersistentModelDataTimerFired:(IDLTimerWrapper *)timer
{
    [self saveData:NO];
}

@end

