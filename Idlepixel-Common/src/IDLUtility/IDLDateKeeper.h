//
//  IDLDateKeeper.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 2/10/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLAbstractSharedSingleton.h"

@interface IDLDateKeeperEvent : NSObject

@property (nonatomic, strong, readonly) NSString *key;
@property (nonatomic, readonly) NSTimeInterval timeStamp;
@property (nonatomic, readonly) NSTimeInterval timeSinceEvent;

-(NSComparisonResult)compare:(IDLDateKeeperEvent *)otherObject;

@end

@interface IDLDateKeeper : IDLAbstractSharedSingleton

+(instancetype)sharedDateKeeper;

+(void)recordApplicationLaunch;
+(NSTimeInterval)timeSinceApplicationStartup;
+(NSTimeInterval)timeSinceSystemStartup;

@property (nonatomic, strong) NSDate *originDate;
@property (nonatomic, readonly) NSDate *currentDate;
@property (nonatomic, readonly) NSTimeInterval timeSinceDateSet;
@property (nonatomic, readonly) NSTimeInterval timeSinceReferenceDate;
@property (nonatomic, readonly) BOOL hasOriginDate;

@property (nonatomic, readonly) NSDate *systemStartupDate;
@property (nonatomic, readonly) NSDate *applicationStartupDate;

-(NSTimeInterval)timeSinceDate:(NSDate *)date;

-(NSDate *)dateForTimeAfterSystemStartup:(NSTimeInterval)timeInterval;

-(void)recordEventWithKey:(NSString *)eventKey;
-(IDLDateKeeperEvent *)eventWithKey:(NSString *)eventKey;
-(NSDate *)eventDateWithKey:(NSString *)eventKey;

-(NSArray *)allEvents;
-(void)clearEvents;

@end