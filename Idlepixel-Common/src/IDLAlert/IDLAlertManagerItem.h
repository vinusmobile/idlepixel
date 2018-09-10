//
//  IDLAlertManagerItem.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 6/05/2014.
//  Copyright (c) 2014 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLTypedefs.h"

typedef void(^IDLAlertDismissBlock)(NSInteger buttonIndex, BOOL cancelled);

@interface IDLAlertManagerItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *cancelButtonTitle;
@property (nonatomic, strong) NSArray *otherButtonTitles;
@property (nonatomic, copy) IDLAlertDismissBlock dismissBlock;

@property (nonatomic, assign) IDLAlertLevel level;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, strong) NSObject *data;

@property (nonatomic, copy) IDLAlertDismissBlock sequenceDismissBlock;

@property (nonatomic, assign, readonly) NSTimeInterval displayTimeInterval;
@property (nonatomic, assign, readonly) NSTimeInterval dismissTimeInterval;

+ (instancetype)itemWithItem:(IDLAlertManagerItem *)otherItem;
+ (instancetype)itemWithTitle:(NSString *)title message:(NSString *)message;
+ (instancetype)itemWithTitle:(NSString *)title message:(NSString *)message level:(IDLAlertLevel)level;
+ (instancetype)itemWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles dismissBlock:(IDLAlertDismissBlock)dismissBlock;

- (id)initWithTitle:(NSString *)title message:(NSString *)message;
- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles dismissBlock:(IDLAlertDismissBlock)dismissBlock;

- (BOOL)isEqualToItem:(IDLAlertManagerItem *)otherItem;

@end
