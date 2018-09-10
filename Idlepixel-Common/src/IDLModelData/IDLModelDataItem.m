//
//  IDLModelDataItem.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 4/04/2014.
//  Copyright (c) 2014 Trystan Pfluger. All rights reserved.
//

#import "IDLModelDataItem.h"
#import "IDLNSInlineExtensions.h"

@interface IDLModelDataItem ()

@property (nonatomic, assign, readwrite) NSInteger sortOrder;
@property (nonatomic, assign, readwrite) NSInteger groupSortOrder;

@end

@interface IDLModelDataGroup ()

@property (nonatomic, assign, readwrite) NSInteger sortOrder;

@end

@implementation IDLModelDataItem

+(instancetype)itemWithUID:(NSString *)uid name:(NSString *)name group:(NSString *)group isHidden:(BOOL)isHidden isDefault:(BOOL)isDefault
{
    IDLModelDataItem *item = [[[self class] alloc] initWithUID:uid name:name group:group isHidden:isHidden isDefault:isDefault];
    return item;
}

-(id)initWithUID:(NSString *)uid name:(NSString *)name group:(NSString *)group isHidden:(BOOL)isHidden isDefault:(BOOL)isDefault
{
    self = [super init];
    if (self) {
        _uid = uid;
        _name = name;
        _group = group;
        _isHidden = isHidden;
        _isDefault = isDefault;
    }
    return self;
}

-(NSComparisonResult)compare:(IDLModelDataItem *)otherObject
{
    NSComparisonResult result = NSIntegerCompare(self.groupSortOrder, otherObject.groupSortOrder);
    if (result == NSOrderedSame) {
        result = NSIntegerCompare(self.sortOrder, otherObject.sortOrder);
    }
    return result;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"Item(%li)[%@,%@,%@]",(long)self.sortOrder,self.uid,self.name,self.group];
}

@end

@implementation IDLModelDataGroup

-(NSString *)uid
{
    return self.name;
}

-(NSComparisonResult)compare:(IDLModelDataGroup *)otherObject
{
    return NSIntegerCompare(self.sortOrder, otherObject.sortOrder);
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@(%li,i=%lu,c=%lu)[%@,%@]",self.pointerKey,(long)self.sortOrder,(unsigned long)self.items.count,(unsigned long)self.children.count,self.name,self.parentName];
}

@end
