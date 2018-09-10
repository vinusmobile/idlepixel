//
//  IDLNotificationObserver.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 29/08/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLNotificationObserverProtocol.h"
#import "NSNotificationCenter+Idlepixel.h"

@interface IDLNotificationObserver : NSObject <IDLNotificationObserver>

-(id)initWithCenter:(NSNotificationCenter *)center;

- (void)removeObserver:(id)anObserver selector:(SEL)aSelector name:(NSString *)notificationName;
- (void)removeObserver:(id)anObserver name:(NSString *)notificationName;
- (void)removeAllObservers;

- (void)addObserver:(NSObject *)anObserver selector:(SEL)aSelector name:(NSString *)notificationName;

@property (nonatomic, assign) BOOL allowDuplicates;
@property (nonatomic, strong, readonly) NSNotificationCenter *center;

@end
