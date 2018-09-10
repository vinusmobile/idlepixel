//
//  IDLModelDataItem.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 4/04/2014.
//  Copyright (c) 2014 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDLModelDataItem : NSObject

@property (nonatomic, strong, readonly) NSString *uid;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *group;
@property (nonatomic, assign, readonly) NSInteger sortOrder;
@property (nonatomic, assign, readonly) NSInteger groupSortOrder;
@property (nonatomic, assign, readonly) BOOL isHidden;
@property (nonatomic, assign, readonly) BOOL isDefault;

+(instancetype)itemWithUID:(NSString *)uid name:(NSString *)name group:(NSString *)group isHidden:(BOOL)isHidden isDefault:(BOOL)isDefault;
-(id)initWithUID:(NSString *)uid name:(NSString *)name group:(NSString *)group isHidden:(BOOL)isHidden isDefault:(BOOL)isDefault;

-(NSComparisonResult)compare:(IDLModelDataItem *)otherObject;

@end

@interface IDLModelDataGroup : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *parentName;
@property (nonatomic, strong) NSArray *children;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) BOOL open;
@property (nonatomic, assign, readonly) NSInteger sortOrder;

-(NSString *)uid;

@end
