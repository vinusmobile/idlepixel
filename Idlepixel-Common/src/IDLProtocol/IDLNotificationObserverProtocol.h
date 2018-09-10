//
//  IDLNotificationObserverProtocol.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 2/10/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNotificationObserverSelector @selector(notificationObserved:)

@protocol IDLNotificationObserver <NSObject>

@required
-(void)notificationObserved:(NSNotification *)notification;

@end

@protocol IDLNotificationObservant <IDLNotificationObserver>

@required
- (void)setupObservers;
- (void)removeObservers;

@end
