//
//  IDLAlertManager.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 17/06/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLAlertManager.h"
#import "NSNotification+Idlepixel.h"
#import "NSNotificationCenter+Idlepixel.h"
#import "NSMutableArray+Idlepixel.h"
#import "NSArray+Idlepixel.h"

#import "IDLNSInlineExtensions.h"
#import "IDLCommonMacros.h"

NSString * const kIDLAlertManagerCurrentAlertsDismissedNotification                 = @"IDLAlertManagerCurrentAlertsDismissedNotification";

@interface UIAlertView (AlertManager)

@property (readwrite) IDLAlertManagerItem *alertManagerItem;

@end

@interface IDLAlertManagerItem ()

@property (nonatomic, assign, readwrite) NSTimeInterval displayTimeInterval;
@property (nonatomic, assign, readwrite) NSTimeInterval dismissTimeInterval;

@end

@implementation UIAlertView (AlertManager)

#define kUIAlertViewAssociatedObjectIDLAlertManagerItem        @"UIAlertViewAssociatedObjectIDLAlertManagerItem"

- (void)setAlertManagerItem:(IDLAlertManagerItem *)alertManagerItem
{
    objc_setAssociatedObject(self, kUIAlertViewAssociatedObjectIDLAlertManagerItem, alertManagerItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (IDLAlertManagerItem *)alertManagerItem
{
    return objc_getAssociatedObject(self, kUIAlertViewAssociatedObjectIDLAlertManagerItem);
}

@end

@interface IDLAlertManager ()

@property (nonatomic, strong) NSMutableArray *alertQueue;
@property (nonatomic, strong) UIAlertView *currentAlertView;
@property (nonatomic, strong) IDLAlertManagerItem *currentAlertItem;

@property (nonatomic, strong) IDLAlertManagerItem *lastDismissedAlertItem;

@end

@implementation IDLAlertManager

// class methods

+ (instancetype)sharedManager
{
    return [self preferredSingleton];
}

+ (BOOL)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    return [[self sharedManager] showAlertWithTitle:title message:message];
}

+ (BOOL)showAlertWithTitle:(NSString *)title message:(NSString *)message alertDismissBlock:(IDLAlertDismissBlock)block
{
    return [[self sharedManager] showAlertWithTitle:title message:message alertDismissBlock:block];
}

+ (BOOL)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles
{
    return [[self sharedManager] showAlertWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles];
}

+ (BOOL)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles alertDismissBlock:(IDLAlertDismissBlock)block
{
    return [[self sharedManager] showAlertWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles alertDismissBlock:block];
}

+ (BOOL)showAlertManagerItem:(IDLAlertManagerItem *)item
{
    return [[self sharedManager] showAlertManagerItem:item];
}

+ (void)showAlertManagerItems:(NSArray *)items sequenceDismissBlock:(IDLAlertDismissBlock)sequenceDismissBlock
{
    [[self sharedManager] showAlertManagerItems:items sequenceDismissBlock:sequenceDismissBlock];
}

+ (BOOL)alertsActive
{
    return [[self sharedManager] alertsActive];
}

// instance methods

- (id)init
{
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure
{
    self.defaultCancelButtonTitle = @"Okay";
    self.alertQueue = [NSMutableArray array];
    self.skipDuplicateDismissedAlert = NO;
    self.skipDuplicateQueuedAlerts = NO;
    self.skipDuplicateDismissedAlertMaximumTime = NSTimeIntervalQuarterSecond;
}

- (BOOL)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    return [self showAlertWithTitle:title message:message alertDismissBlock:nil];
}

- (BOOL)showAlertWithTitle:(NSString *)title message:(NSString *)message alertDismissBlock:(IDLAlertDismissBlock)block
{
    return [self showAlertWithTitle:title message:message cancelButtonTitle:nil otherButtonTitles:nil alertDismissBlock:block];
}

- (BOOL)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles
{
    return [self showAlertWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles alertDismissBlock:nil];
}

- (BOOL)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles alertDismissBlock:(IDLAlertDismissBlock)block
{
    if (title != nil) {
        IDLAlertManagerItem *item = [IDLAlertManagerItem itemWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles dismissBlock:block];
        return [self showAlertManagerItem:item];
    }
    return NO;
}

- (BOOL)showAlertManagerItem:(IDLAlertManagerItem *)item
{
    if (item != nil) {
        if (item.cancelButtonTitle == nil) {
            item.cancelButtonTitle = self.defaultCancelButtonTitle;
        }
        if (self.skipDuplicateQueuedAlerts) {
            IDLAlertManagerItem *lastItem = [self.alertQueue lastObject];
            if ([item isEqualToItem:lastItem]) {
                item = nil;
            }
        }
        if (self.skipDuplicateDismissedAlert && item) {
            IDLAlertManagerItem *lastItem = self.lastDismissedAlertItem;
            if ([item isEqualToItem:lastItem]) {
                NSTimeInterval interval = SystemTimeSinceInterval(lastItem.dismissTimeInterval);
                if (interval < self.skipDuplicateDismissedAlertMaximumTime) {
                    item = nil;
                }
            }
        }
        if (item != nil) {
            [self.alertQueue addObject:item];
            [self showNextAlert];
            return YES;
        }
    }
    return NO;
}

- (void)showAlertManagerItems:(NSArray *)items sequenceDismissBlock:(IDLAlertDismissBlock)sequenceDismissBlock
{
    IDLAlertManagerItem *lastItem = nil;
    for (IDLAlertManagerItem *item in items) {
        if ([item isKindOfClass:[IDLAlertManagerItem class]]) {
            BOOL added = [self showAlertManagerItem:item];
            if (added) {
                lastItem = item;
            }
        }
    }
    if (lastItem != nil) {
        lastItem.sequenceDismissBlock = sequenceDismissBlock;
    }
}

-(void)showNextAlert
{
    if (self.currentAlertItem == nil && self.alertQueue.count > 0) {
        self.currentAlertItem = [self.alertQueue firstObject];
        self.currentAlertItem.displayTimeInterval = SystemTimeSinceSystemStartup();
        [self.alertQueue removeObjectAtIndex:0];
        IDLAlertManagerItem *item = self.currentAlertItem;
        UIAlertView *alertView = [self createAlertViewWithAlertManagerItem:item];
        if (alertView.delegate == nil) alertView.delegate = self;
        self.currentAlertView = alertView;
        self.currentAlertView.alertManagerItem = item;
        [self.currentAlertView show];
    }
}

-(BOOL)alertsActive
{
    return (self.currentAlertItem != nil || self.alertQueue.count > 0);
}

-(UIAlertView *)createAlertViewWithAlertManagerItem:(IDLAlertManagerItem *)item
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:item.title message:item.message delegate:self cancelButtonTitle:item.cancelButtonTitle otherButtonTitles:nil];
    if (item.otherButtonTitles.count > 0) {
        for (NSString *buttonTitle in item.otherButtonTitles) {
            [alertView addButtonWithTitle:buttonTitle];
        }
    }
    return alertView;
}

+ (IDLAlertLevel)maximumAlertLevelfromAlertManagerItemsArray:(NSArray *)array
{
    IDLAlertLevel maximumAlertLevel = IDLAlertLevelUndefined;
    [self extractAlertManagerItemsFromArray:array maximumAlertLevel:&maximumAlertLevel];
    return maximumAlertLevel;
}

- (IDLAlertLevel)maximumAlertLevelfromAlertManagerItemsArray:(NSArray *)array
{
    return [[self class] maximumAlertLevelfromAlertManagerItemsArray:array];
}

+ (NSArray *)extractAlertManagerItemsFromArray:(NSArray *)array maximumAlertLevel:(IDLAlertLevel *)maximumAlertLevel
{
    IDLAlertLevel max = IDLAlertLevelUndefined;
    IDLAlertManagerItem *item = nil;
    NSMutableArray *alertManagerItems = [NSMutableArray array];
    for (NSObject *data in array) {
        item = CLASS_OR_NIL(data, IDLAlertManagerItem);
        if (item != nil) {
            max = MAX(max, item.level);
            [alertManagerItems addObject:item];
        }
    }
    if (maximumAlertLevel) {
        *maximumAlertLevel = max;
    }
    if (alertManagerItems.count > 0) {
        return [NSArray arrayWithArray:alertManagerItems];
    } else {
        return nil;
    }
}

-(NSArray *)extractAlertManagerItemsFromArray:(NSArray *)array maximumAlertLevel:(IDLAlertLevel *)maximumAlertLevel
{
    return [[self class] extractAlertManagerItemsFromArray:array maximumAlertLevel:maximumAlertLevel];
}

-(NSArray *)extractAlertManagerItemsFromArray:(NSArray *)array
{
    return [self extractAlertManagerItemsFromArray:array maximumAlertLevel:nil];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self alertViewDidHide:alertView];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    IDLAlertManagerItem *item = alertView.alertManagerItem;
    if (item != nil) {
        item.dismissTimeInterval = SystemTimeSinceSystemStartup();
        
        IDLAlertManagerItem *lastItem = [IDLAlertManagerItem itemWithItem:item];
        self.lastDismissedAlertItem = lastItem;
        
        __strong IDLAlertManagerItem *strongItem = item;
        if (item.dismissBlock != nil) {
            BOOL cancelled = (buttonIndex == alertView.cancelButtonIndex);
            dispatch_async(dispatch_get_main_queue(), ^{
                strongItem.dismissBlock(buttonIndex, cancelled);
            });
        }
        if (item.sequenceDismissBlock != nil) {
            BOOL cancelled = (buttonIndex == alertView.cancelButtonIndex);
            dispatch_async(dispatch_get_main_queue(), ^{
                strongItem.sequenceDismissBlock(buttonIndex, cancelled);
            });
        }
    }
    if (!self.alertsActive) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kIDLAlertManagerCurrentAlertsDismissedNotification];
    }
}

-(void)alertViewDidHide:(UIAlertView *)alertView
{
    if (self.currentAlertView == alertView) {
        self.currentAlertView = nil;
        self.currentAlertItem = nil;
        [self showNextAlert];
    }
}

@end
