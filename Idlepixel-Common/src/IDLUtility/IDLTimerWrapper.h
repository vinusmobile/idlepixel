//
//  IDLTimerWrapper.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 16/11/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSTimeInterval const kInterfaceRefreshTimeInterval;

@class IDLTimerWrapper;

@protocol IDLTimerWrapperDelegate <NSObject>

@required
-(void)timerWrapperFired:(IDLTimerWrapper *)wrapper;

@end

@interface IDLTimerWrapper : NSObject

+(IDLTimerWrapper *)timerWithInterval:(NSTimeInterval)interval;
-(id)initWithInterval:(NSTimeInterval)anInterval;

-(void)start;
-(void)startAfterInterval:(NSTimeInterval)timeInterval;
-(void)stop;

- (void) addTarget: (id) target selector: (SEL) selector;
- (void) removeTarget: (id) target selector: (SEL) selector;
- (void) removeTarget: (id) target;

@property (nonatomic, assign) BOOL useMainRunLoop;
@property (nonatomic, assign) NSTimeInterval interval;
@property (readonly) NSTimeInterval age;
@property (nonatomic, readonly) NSUInteger firedCount;
@property (readonly) BOOL running;
@property (nonatomic, weak) id<IDLTimerWrapperDelegate> delegate;
@end