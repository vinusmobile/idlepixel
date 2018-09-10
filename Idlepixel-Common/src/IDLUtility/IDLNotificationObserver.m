//
//  IDLNotificationObserver.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 29/08/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import "IDLNotificationObserver.h"
#import "NSArray+Idlepixel.h"
#import "IDLNSInlineExtensions.h"

@interface IDLNotificationObserverRecord : NSObject

// keep the observer weak so we don't get a retain loop going
@property (nonatomic, weak) NSObject *observer;
@property (nonatomic, strong) NSString *selector;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSUInteger duplicateCount;

+(IDLNotificationObserverRecord *)recordWithObserver:(NSObject *)anObserver selector:(NSString *)selectorString name:(NSString *)notificationName;

-(id)initWithObserver:(NSObject *)anObserver selector:(NSString *)selectorString name:(NSString *)notificationName;

-(BOOL)isEqualToObserver:(NSObject *)anObserver name:(NSString *)notificationName selector:(NSString *)selectorString;
-(BOOL)isEqualToObserver:(NSObject *)anObserver name:(NSString *)notificationName selectorOrNil:(NSString *)selectorStringOrNil;

@end

@implementation IDLNotificationObserverRecord

+(IDLNotificationObserverRecord *)recordWithObserver:(NSObject *)anObserver selector:(NSString *)selectorString name:(NSString *)notificationName
{
	return [[self alloc] initWithObserver:anObserver selector:selectorString name:notificationName];
}

-(id)initWithObserver:(NSObject *)anObserver selector:(NSString *)selectorString name:(NSString *)notificationName
{
    if ((self = [super init])) {
        self.observer = anObserver;
        self.selector = selectorString;
        self.name = notificationName;
    }
    return self;
}

-(BOOL)isEqualToObserver:(NSObject *)anObserver name:(NSString *)notificationName selector:(NSString *)selectorString
{
    if (anObserver == self.observer && NSStringEquals(self.name, notificationName)
         && NSStringEquals(self.selector, selectorString)) {
        return YES;
    } else {
        return NO;
    }
}

-(BOOL)isEqualToObserver:(NSObject *)anObserver name:(NSString *)notificationName selectorOrNil:(NSString *)selectorStringOrNil
{
    if (anObserver == self.observer && NSStringEquals(self.name, notificationName)
        && (selectorStringOrNil == nil || NSStringEquals(self.selector, selectorStringOrNil))) {
        return YES;
    } else {
        return NO;
    }
}

@end

@interface IDLNotificationObserver ()

@property (nonatomic, strong, readwrite) NSNotificationCenter *notificationCenter;
@property (nonatomic, strong) NSArray *records;

- (IDLNotificationObserverRecord *)existingRecordForObserver:(NSObject *)anObserver selector:(NSString *)selectorString name:(NSString *)notificationName;

@end

@implementation IDLNotificationObserver

-(id)initWithCenter:(NSNotificationCenter *)aCenter
{
	if ((self = [super init])) {
		self.records = nil;
		self.notificationCenter = aCenter;
		self.allowDuplicates = NO;
	}
	return self;
}

- (IDLNotificationObserverRecord *)existingRecordForObserver:(NSObject *)anObserver selector:(NSString *)selectorString name:(NSString *)notificationName
{
	if (self.records.count == 0 || anObserver == nil || selectorString == nil) return nil;
	
    IDLNotificationObserverRecord *record = nil;
    
    NSArray *array = [NSArray arrayWithArray:self.records];
    for (record in array) {
        if ([record isEqualToObserver:anObserver name:notificationName selector:selectorString]) {
            return record;
        }
    }
    return nil;
	
}

- (void)notificationObserved:(NSNotification *)notification
{
	if (notification == nil || [self.records count] == 0) return;
	
    IDLNotificationObserverRecord *record = nil;
    
    NSArray *array = [NSArray arrayWithArray:self.records];
    
	SEL selector;
    
	NSInteger duplicateCounter;
    
    for (record in array) {
        if (NSStringEquals(record.name, notification.name)) {
            selector = NSSelectorFromString(record.selector);
            if ([record.observer respondsToSelector:selector]) {
                if (self.allowDuplicates) {
                    duplicateCounter = record.duplicateCount;
                } else {
                    duplicateCounter = 0;
                }
                NSObject *observer = record.observer;
                while (duplicateCounter >= 0) {
                    duplicateCounter--;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [observer performSelector:selector withObject:notification];
#pragma clang diagnostic pop
                }
            }
        }
    }
}

- (void)removeObserver:(id)anObserver selector:(SEL)aSelector name:(NSString *)notificationName
{
	if (self.records.count == 0 || anObserver == nil || notificationName == nil) return;
	
	NSString *selectorString = NSStringFromSelector(aSelector);
    
    IDLNotificationObserverRecord *record = nil;
    
    NSArray *array = [NSArray arrayWithArray:self.records];
    NSMutableArray *recordsToRemove = [NSMutableArray array];
    
    BOOL notificationNameFound = NO;
	
    for (record in array) {
        if ([record isEqualToObserver:anObserver name:notificationName selectorOrNil:selectorString]) {
            if (self.allowDuplicates && record.duplicateCount > 0) {
                record.duplicateCount--;
                notificationNameFound = YES;
            } else {
                [recordsToRemove addObject:record];
            }
		} else if (NSStringEquals(record.name, notificationName)) {
			notificationNameFound = YES;
		}
    }
    if (recordsToRemove.count > 0) {
        self.records = [self.records arrayByRemovingObject:recordsToRemove];
    }
	
	if (!notificationNameFound) {
		[self.center removeObserver:self name:notificationName object:nil];
	}
}

- (void)removeObserver:(NSObject *)anObserver name:(NSString *)notificationName
{
	[self removeObserver:anObserver selector:nil name:notificationName];
}

- (void)removeAllObservers
{
	@synchronized (self) {
		[self.center removeObserver:self];
		self.records = nil;
	}
}

- (void)addObserver:(NSObject *)anObserver selector:(SEL)aSelector name:(NSString *)notificationName
{
	if (self.center == nil || anObserver == nil || notificationName == nil) return;
	
    NSString *selectorString = NSStringFromSelector(aSelector);
	
	if (selectorString == nil || [selectorString length] == 0) return;
	
	IDLNotificationObserverRecord *record = [self existingRecordForObserver:anObserver selector:selectorString name:notificationName];
	
	if (record != nil) {
		if (self.allowDuplicates) {
			record.duplicateCount++;
		}
	} else {
        
        BOOL notificationNameFound = NO;
        
        NSArray *array = [NSArray arrayWithArray:self.records];
        for (record in array) {
            if (NSStringEquals(record.name, notificationName)) {
                notificationNameFound = YES;
                break;
            }
        }
        record = [IDLNotificationObserverRecord recordWithObserver:anObserver selector:selectorString name:notificationName];
        if (array.count > 0) {
            self.records = [self.records arrayByAddingObject:record];
        } else {
            self.records = [NSArray arrayWithObject:record];
        }
        
		if (!notificationNameFound) {
			[self.center addObserver:self selector:kNotificationObserverSelector name:notificationName object:nil];
		}
	}
}

@end
