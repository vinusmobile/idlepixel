//
//  IDLTimerWrapper.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 16/11/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "IDLTimerWrapper.h"
#import "IDLNSInlineExtensions.h"
#import "IDLActionTarget.h"

NSTimeInterval const kInterfaceRefreshTimeInterval = 1.0f / 60.0f;

@interface IDLTimerWrapper ()

@property (nonatomic, assign) NSTimeInterval startTimeStamp;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) IDLActionTargetSet *targets;
-(void) startTimer;
-(void) stopTimer;
-(void) timerFired:(NSTimer*)timer;

@end


@implementation IDLTimerWrapper

+(IDLTimerWrapper *)timerWithInterval:(NSTimeInterval)interval
{
    return [[IDLTimerWrapper alloc] initWithInterval:interval];
}

-(id)initWithInterval:(NSTimeInterval)anInterval
{
    self = [self init];
    if (self) {
        self.interval = anInterval;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        _firedCount = 0;
    }
    
    return self;
}

-(void)start
{
    [self startTimer];
}

-(void)startAfterInterval:(NSTimeInterval)timeInterval
{
    [self stopTimer];
    
    [self performSelector:@selector(startTimer) withObject:nil afterDelay:timeInterval];
}

-(void)stop
{
    [self stopTimer];
}

#define kTargetControlEvents        UIControlEventAllEvents

- (void) addTarget:(id)target selector:(SEL)selector
{
    if (!self.targets) {
        self.targets = [IDLActionTargetSet new];
    }
    [self.targets addTarget:target action:selector forControlEvents:kTargetControlEvents];
}

- (void) removeTarget:(id)target selector:(SEL)selector
{
    [self.targets removeTarget:target action:selector forControlEvents:kTargetControlEvents];
}

- (void) removeTarget: (id) target
{
    [self.targets removeTarget:target];
}

-(void)dealloc
{
    [self stopTimer];
    self.targets = nil;
}

-(void) startTimer
{
    [self stopTimer];
    _firedCount = 0;
    self.startTimeStamp = SystemTimeSinceSystemStartup();
    self.timer = [[NSTimer alloc] initWithFireDate:nil interval:self.interval target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    NSRunLoop *runLoop = nil;
    if (self.useMainRunLoop) {
        runLoop = [NSRunLoop mainRunLoop];
    } else {
        runLoop = [NSRunLoop currentRunLoop];
    }
    [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void) stopTimer
{
    if(self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(NSTimeInterval)age
{
    if (self.running) {
        return (SystemTimeSinceSystemStartup() - self.startTimeStamp);
    } else {
        return 0.0f;
    }
}

-(BOOL)running
{
    return (self.timer != nil);
}

-(void) timerFired:(NSTimer*)timer
{
    _firedCount++;
    if ([self.delegate respondsToSelector:@selector(timerWrapperFired:)]) {
        [self.delegate timerWrapperFired:self];
    }
    NSArray *actionTargets = [self.targets allActionTargets];
    for (IDLActionTarget *action in actionTargets) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [action.target performSelector: action.selector withObject: self];
#pragma clang diagnostic pop
    }
}

@end
