//
//  IDLDateKeeper.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 2/10/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "IDLDateKeeper.h"
#import "IDLNSInlineExtensions.h"


@interface IDLDateKeeperEvent ()

@property (nonatomic, strong, readwrite) NSString *key;
@property (nonatomic, assign) NSTimeInterval timeStamp;

+(IDLDateKeeperEvent *)eventWithKey:(NSString *)key timeStamp:(NSTimeInterval)timeStamp;

@end

@implementation IDLDateKeeperEvent
@synthesize key, timeStamp;

+(IDLDateKeeperEvent *)eventWithKey:(NSString *)key timeStamp:(NSTimeInterval)timeStamp
{
    IDLDateKeeperEvent *event = [IDLDateKeeperEvent new];
    event.key = key;
    event.timeStamp = timeStamp;
    return event;
}

-(NSTimeInterval)timeSinceEvent
{
    NSTimeInterval interval = [IDLDateKeeper timeSinceSystemStartup] - timeStamp;
    return interval;
}

-(NSComparisonResult)compare:(IDLDateKeeperEvent *)otherObject
{
    if (self.timeStamp < otherObject.timeStamp) {
        return NSOrderedAscending;
    } else if (self.timeStamp > otherObject.timeStamp) {
        return NSOrderedDescending;
    } else {
        return [self.key compare:otherObject.key];
    }
}

@end

@interface IDLDateKeeper ()

@property (nonatomic, assign) uint64_t originDateStamp;
@property (nonatomic, strong) NSMutableDictionary *eventDictionary;
@property (nonatomic, assign) NSTimeInterval calculatedStartupTime;

@end

@implementation IDLDateKeeper
@synthesize originDate;
@synthesize originDateStamp;
@synthesize eventDictionary;
@synthesize calculatedStartupTime;

+(instancetype)sharedDateKeeper
{
    return [self preferredSingleton];
}

static uint64_t applicationLaunchTime;

+(void)recordApplicationLaunch
{
    applicationLaunchTime = mach_absolute_time();
}

+(NSTimeInterval)timeSinceSystemStartup
{
    return SystemTimeSinceSystemStartup();
}

+(NSTimeInterval)timeSinceApplicationStartup
{
    uint64_t difference = mach_absolute_time() - applicationLaunchTime;
    return TimeIntervalFromMachTime(difference);
}

-(void)setOriginDate:(NSDate *)newOriginDate
{
    // get the time as soon as possible
    uint64_t time = mach_absolute_time();
    
    if (newOriginDate == nil || originDate == newOriginDate) {
        return;
    }
    
    originDateStamp = time;
    originDate = newOriginDate;
    calculatedStartupTime = originDate.timeIntervalSinceReferenceDate - TimeIntervalFromMachTime(originDateStamp);
    
}

-(BOOL)hasOriginDate
{
    return (originDate != nil);
}

-(NSTimeInterval)timeSinceDateSet
{
    uint64_t difference = mach_absolute_time() - originDateStamp;
    return TimeIntervalFromMachTime(difference);
}

-(NSTimeInterval)timeSinceReferenceDate
{
    return (originDate.timeIntervalSinceReferenceDate + self.timeSinceDateSet);
}

-(NSTimeInterval)timeSinceDate:(NSDate *)date
{
    if (date) {
        return (self.timeSinceReferenceDate - date.timeIntervalSinceReferenceDate);
    } else {
        return self.timeSinceReferenceDate;
    }
}

-(NSDate *)dateForTimeAfterSystemStartup:(NSTimeInterval)timeInterval
{
    if (originDate != nil) {
        return [NSDate dateWithTimeIntervalSinceReferenceDate:(calculatedStartupTime + timeInterval)];
    } else {
        return nil;
    }
}

-(NSDate *)currentDate
{
    if (originDate != nil) {
        return [NSDate dateWithTimeIntervalSinceReferenceDate:self.timeSinceReferenceDate];
    } else {
        return nil;
    }
}

-(NSDate *)systemStartupDate
{
    return [self dateForTimeAfterSystemStartup:0.0f];
}

-(NSDate *)applicationStartupDate
{
    NSTimeInterval time = TimeIntervalFromMachTime(applicationLaunchTime);
    return [self dateForTimeAfterSystemStartup:time];
}

#pragma mark Events

-(void)recordEventWithKey:(NSString *)eventKey
{
    // get the time as soon as possible
    uint64_t time = mach_absolute_time();
    
    if (eventKey != nil) {
        @synchronized(self)
        {
            if (eventDictionary == nil) {
                self.eventDictionary = [NSMutableDictionary dictionary];
            }
        }
        IDLDateKeeperEvent *event = [IDLDateKeeperEvent eventWithKey:eventKey timeStamp:TimeIntervalFromMachTime(time)];
        [self.eventDictionary setObject:event forKey:eventKey];
    }
}

-(IDLDateKeeperEvent *)eventWithKey:(NSString *)eventKey
{
    if (eventKey != nil && self.eventDictionary != nil) {
        return (IDLDateKeeperEvent *)[self.eventDictionary objectForKey:eventKey];
    } else {
        return nil;
    }
}

-(NSDate *)eventDateWithKey:(NSString *)eventKey
{
    if (self.hasOriginDate) {
        IDLDateKeeperEvent *event = [self eventWithKey:eventKey];
        if (event != nil) {
            return [self dateForTimeAfterSystemStartup:event.timeStamp];
        }
    }
    return nil;
}

-(NSArray *)allEvents
{
    return [[self.eventDictionary allValues] sortedArrayUsingSelector:@selector(compare:)];
}

-(void)clearEvents
{
    self.eventDictionary = nil;
}

@end