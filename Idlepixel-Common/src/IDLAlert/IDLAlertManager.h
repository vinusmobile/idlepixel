//
//  IDLAlertManager.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 17/06/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLAbstractSharedSingleton.h"

#import "IDLAlertManagerItem.h"

extern NSString * const kIDLAlertManagerCurrentAlertsDismissedNotification;

@interface IDLAlertManager : IDLAbstractSharedSingleton

+ (instancetype)sharedManager;

+ (BOOL)showAlertWithTitle:(NSString *)title message:(NSString *)message;
+ (BOOL)showAlertWithTitle:(NSString *)title message:(NSString *)message alertDismissBlock:(IDLAlertDismissBlock)block;

+ (BOOL)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles;
+ (BOOL)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles alertDismissBlock:(IDLAlertDismissBlock)block;

+ (BOOL)showAlertManagerItem:(IDLAlertManagerItem *)item;
+ (void)showAlertManagerItems:(NSArray *)items sequenceDismissBlock:(IDLAlertDismissBlock)sequenceDismissBlock;

+ (BOOL)alertsActive;

//

- (void)configure;

- (BOOL)showAlertWithTitle:(NSString *)title message:(NSString *)message;
- (BOOL)showAlertWithTitle:(NSString *)title message:(NSString *)message alertDismissBlock:(IDLAlertDismissBlock)block;

- (BOOL)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles;
- (BOOL)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles alertDismissBlock:(IDLAlertDismissBlock)block;

- (BOOL)showAlertManagerItem:(IDLAlertManagerItem *)item;
- (void)showAlertManagerItems:(NSArray *)items sequenceDismissBlock:(IDLAlertDismissBlock)sequenceDismissBlock;

@property (readonly) BOOL alertsActive;
@property (nonatomic, strong) NSString *defaultCancelButtonTitle;
@property (nonatomic, assign) BOOL skipDuplicateQueuedAlerts;
@property (nonatomic, assign) BOOL skipDuplicateDismissedAlert;
@property (nonatomic, assign) NSTimeInterval skipDuplicateDismissedAlertMaximumTime;

+ (IDLAlertLevel)maximumAlertLevelfromAlertManagerItemsArray:(NSArray *)array;
- (IDLAlertLevel)maximumAlertLevelfromAlertManagerItemsArray:(NSArray *)array;

+ (NSArray *)extractAlertManagerItemsFromArray:(NSArray *)array maximumAlertLevel:(IDLAlertLevel *)maximumAlertLevel;
- (NSArray *)extractAlertManagerItemsFromArray:(NSArray *)array maximumAlertLevel:(IDLAlertLevel *)maximumAlertLevel;
- (NSArray *)extractAlertManagerItemsFromArray:(NSArray *)array;

// designed for override

- (void)showNextAlert;
- (UIAlertView *)createAlertViewWithAlertManagerItem:(IDLAlertManagerItem *)item;

@end
