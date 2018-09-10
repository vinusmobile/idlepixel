//
//  IDLAbstractApplicationDelegate.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 13/03/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IDLNotificationObserver.h"

@interface IDLAbstractApplicationDelegate : UIResponder <UIApplicationDelegate, IDLNotificationObserver>

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (nonatomic, readonly, assign) NSTimeInterval applicationResignedTimeStamp;

@property (nonatomic, assign) NSTimeInterval savePersistentModelDataInterval;

- (void) saveData:(BOOL)willTerminate;

- (void) setupObservers;
- (void) removeObservers;

- (void) initializeRootViewController:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (void) performLaunchOperations;

- (void) executeLaunchBootstraps;

@end
