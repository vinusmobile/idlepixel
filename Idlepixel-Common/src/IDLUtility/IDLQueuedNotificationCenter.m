//
//  IDLQueuedNotificationCenter.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 2/10/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "IDLQueuedNotificationCenter.h"

@interface IDLQueuedNotificationCenter ()

-(void)postServiceFault;
-(void)postServiceFaultWithInfo:(NSDictionary *)userInfo;

-(void)addNotificationToQueue:(NSNotification *)notification;
-(void)addNotificationToQueueWithName:(NSString *)notificationName object:(id)notificationSender userInfo:(NSDictionary *)userInfo;

-(void)postNotificationsFromQueue;

-(BOOL)notificationQueued:(NSNotification *)notification;

@property (nonatomic, strong) NSMutableArray *notificationQueue;

@end

@implementation IDLQueuedNotificationCenter
@synthesize notificationQueue;

+ (instancetype) sharedCenter
{
    __strong static IDLQueuedNotificationCenter* center = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[self class] new];
    });
    return center;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

#pragma mark -
#pragma mark Observer convenience methods

+(void)removeObserver:(id)notificationObserver {
	[[self sharedCenter] removeObserver:notificationObserver];
}

+(void)removeObserver:(id)notificationObserver name:(NSString *)notificationName {
	[self removeObserver:notificationObserver name:notificationName object:nil];
}

+(void)removeObserver:(id)notificationObserver name:(NSString *)notificationName object:(id)notificationSender {
	[[self sharedCenter] removeObserver:notificationObserver name:notificationName object:notificationSender];
}

+(void)addObserver:(id)notificationObserver selector:(SEL)notificationSelector name:(NSString *)notificationName {
	[self addObserver:notificationObserver selector:notificationSelector name:notificationName object:nil];
}

+(void)addObserver:(id)notificationObserver selector:(SEL)notificationSelector name:(NSString *)notificationName object:(id)notificationSender {
	[[self sharedCenter] addObserver:notificationObserver selector:notificationSelector name:notificationName object:notificationSender];
}

+(void)addNotificationObserver:(id<IDLNotificationObserver>)notificationObserver name:(NSString *)notificationName
{
    [[self sharedCenter] addNotificationObserver:notificationObserver name:notificationName];
}

+(void)addNotificationObserver:(id<IDLNotificationObserver>)notificationObserver name:(NSString *)notificationName object:(id)notificationSender
{
    [[self sharedCenter] addNotificationObserver:notificationObserver name:notificationName object:notificationSender];
}

+(void)invalidateElement:(NSString *)notificationConstant
{
	[[self sharedCenter] invalidateElement:notificationConstant];
}

#pragma mark -
#pragma mark Invalidation convenience methods


+(void)postServiceFault {
	[[self sharedCenter] postServiceFault];
}

+(void)postServiceFaultWithInfo:(NSDictionary *)userInfo
{
	[[self sharedCenter] postServiceFaultWithInfo:userInfo];
}

-(void)postServiceFault {
	[self postServiceFaultWithInfo:nil];
}

-(void)postServiceFaultWithInfo:(NSDictionary *)userInfo
{
	[self postNotificationName:kNotificationCenterServiceFault object:self userInfo:userInfo];
}

-(void)invalidateElement:(NSString *)notificationConstant
{
    NSThread *currentThread = [NSThread currentThread];
    if (currentThread != [NSThread mainThread]) {
        [self performSelectorOnMainThread:@selector(invalidateElement:) withObject:notificationConstant waitUntilDone:NO];
    } else {
        [self postNotificationName:notificationConstant object:self];
    }
}

-(BOOL)notificationQueued:(NSNotification *)notification
{
    NSArray *queue = nil;
    @synchronized(self)
    {
        queue = [NSArray arrayWithArray:self.notificationQueue];
    }
    for (NSNotification *n in queue) {
        if ([notification isEqualToNotification:n]) {
            return YES;
        }
    }
    return NO;
}

-(void)addNotificationToQueue:(NSNotification *)notification
{
    if ([NSThread currentThread] != [NSThread mainThread]) {
        [self performSelectorOnMainThread:@selector(addNotificationToQueue:) withObject:notification waitUntilDone:NO];
    } else {
        @synchronized(self)
        {
            if (![self notificationQueued:notification]) {
                if (self.notificationQueue == nil) {
                    self.notificationQueue = [NSMutableArray array];
                }
                [self.notificationQueue addObject:notification];
                
                if ([self.notificationQueue count] > 0) {
                    double delayInSeconds = 0.01f;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        //[self performSelectorOnMainThread:@selector(postNotificationsFromQueue) withObject:nil waitUntilDone:NO];
                        [self performSelector:@selector(postNotificationsFromQueue) withObject:nil];
                    });
                }
            }
        }
    }
}

-(void)addNotificationToQueueWithName:(NSString *)notificationName object:(id)notificationSender userInfo:(NSDictionary *)userInfo
{
    if (notificationName == nil) return;
    
    [self addNotificationToQueue:[NSNotification notificationWithName:notificationName object:notificationSender userInfo:userInfo]];
}

-(void)postNotificationsFromQueue
{
    NSArray *queue = nil;
    @synchronized(self)
    {
        queue = [NSArray arrayWithArray:self.notificationQueue];
        self.notificationQueue = nil;
    }
    //IDLLogObject(queue);
    
    for (NSNotification *notification in queue) {
        //IDLLogObject(notification);
        [super postNotification:notification];
    }
}

-(void)postNotificationImmediately:(NSNotification *)notification
{
    [super postNotification:notification];
}

-(void)postNotificationImmediatelyName:(NSString *)notificationName
{
    [self postNotificationImmediatelyName:notificationName object:nil];
}

- (void)postNotificationImmediatelyName:(NSString *)notificationName object:(id)notificationSender
{
    [self postNotificationImmediatelyName:notificationName object:notificationSender userInfo:nil];
}

- (void)postNotificationImmediatelyName:(NSString *)notificationName object:(id)notificationSender userInfo:(NSDictionary *)userInfo
{
    NSNotification *notification = [NSNotification notificationWithName:notificationName object:notificationSender userInfo:userInfo];
    [self postNotificationImmediately:notification];
}

#pragma mark -
#pragma mark NSNotificationCenter Overrides

- (void)postNotification:(NSNotification *)notification
{
    [self addNotificationToQueue:notification];
}

- (void)postNotificationName:(NSString *)notificationName object:(id)notificationSender
{
    [self addNotificationToQueueWithName:notificationName object:notificationSender userInfo:nil];
}

- (void)postNotificationName:(NSString *)notificationName object:(id)notificationSender userInfo:(NSDictionary *)userInfo
{
    [self addNotificationToQueueWithName:notificationName object:notificationSender userInfo:userInfo];
}

-(void)addObserver:(id)notificationObserver selector:(SEL)notificationSelector name:(NSString *)notificationName object:(id)notificationSender {
	[self removeObserver:notificationObserver name:notificationName object:notificationSender];
	[super addObserver:notificationObserver selector:notificationSelector name:notificationName object:notificationSender];
}

@end
