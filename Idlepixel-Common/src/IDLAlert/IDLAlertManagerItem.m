//
//  IDLAlertManagerItem.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 6/05/2014.
//  Copyright (c) 2014 Trystan Pfluger. All rights reserved.
//

#import "IDLAlertManagerItem.h"
#import "IDLNSInlineExtensions.h"
#import "IDLCommonMacros.h"

@interface IDLAlertManagerItem ()

@property (nonatomic, assign, readwrite) NSTimeInterval displayTimeInterval;
@property (nonatomic, assign, readwrite) NSTimeInterval dismissTimeInterval;

@end

@implementation IDLAlertManagerItem

+ (instancetype)itemWithItem:(IDLAlertManagerItem *)otherItem
{
    IDLAlertManagerItem *item = [IDLAlertManagerItem new];
    item.title = otherItem.title;
    item.message = otherItem.message;
    item.cancelButtonTitle = otherItem.cancelButtonTitle;
    item.otherButtonTitles = otherItem.otherButtonTitles;
    
    item.level = otherItem.level;
    item.tag = otherItem.tag;
    item.data = otherItem.data;
    
    item.displayTimeInterval = otherItem.displayTimeInterval;
    item.dismissTimeInterval = otherItem.dismissTimeInterval;
    
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title message:(NSString *)message
{
    return [[[self class] alloc] initWithTitle:title message:message];
}

+ (instancetype)itemWithTitle:(NSString *)title message:(NSString *)message level:(IDLAlertLevel)level
{
    IDLAlertManagerItem *item = [self itemWithTitle:title message:message];
    item.level = level;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles dismissBlock:(IDLAlertDismissBlock)dismissBlock
{
    return [[[self class] alloc] initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles dismissBlock:dismissBlock];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message
{
    return [self initWithTitle:title message:message cancelButtonTitle:nil otherButtonTitles:nil dismissBlock:nil];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles dismissBlock:(IDLAlertDismissBlock)dismissBlock
{
    self = [super init];
    if (self) {
        self.title = title;
        self.message = message;
        self.cancelButtonTitle = cancelButtonTitle;
        self.otherButtonTitles = otherButtonTitles;
        self.dismissBlock = dismissBlock;
    }
    return self;
}

- (BOOL)isEqualToItem:(IDLAlertManagerItem *)otherItem
{
    IDLComparisonResult result = NSObjectCompare(self, otherItem);
    if (result == IDLComparisonResultInconclusive) {
        if (!NSStringEquals(self.title, otherItem.title)) {
            result = IDLComparisonResultNotEqual;
        } else if (!NSStringEquals(self.message, otherItem.message)) {
            result = IDLComparisonResultNotEqual;
        } else if (!NSStringEquals(self.cancelButtonTitle, otherItem.cancelButtonTitle)) {
            result = IDLComparisonResultNotEqual;
        } else if (!NSArrayEquals(self.otherButtonTitles, otherItem.otherButtonTitles)) {
            result = IDLComparisonResultNotEqual;
        } else {
            result = IDLComparisonResultEqual;
        }
    }
    return result;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"<%@:%@ - '%@':'%@':%i>",self.className,self.pointerKey,self.title,self.message,(int)self.level];
}

@end
