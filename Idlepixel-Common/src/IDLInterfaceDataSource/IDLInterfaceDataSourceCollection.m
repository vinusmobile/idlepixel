//
//  IDLInterfaceDataSourceCollection.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 23/04/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLInterfaceDataSourceCollection.h"
#import "NSObject+Idlepixel.h"

NS_INLINE NSObject<NSCopying>* KeyFromView(UIView *aView)
{
	if (aView == nil) {
        return [NSNull null];
    } else {
        return aView.pointerKey;
    }
}

@interface IDLInterfaceDataSourceCollection ()

@property (nonatomic, strong) NSMutableDictionary *sources;

@end

@implementation IDLInterfaceDataSourceCollection

-(id)init
{
    self = [super init];
    if (self) {
        self.sources = [NSMutableDictionary new];
    }
    return self;
}

-(IDLInterfaceDataSource *)dataSourceForView:(UIView *)aView
{
    return [self dataSourceForKey:KeyFromView(aView)];
}

-(void)setDataSource:(IDLInterfaceDataSource *)dataSource forView:(UIView *)aView
{
    [self setDataSource:dataSource forKey:KeyFromView(aView)];
}

-(IDLInterfaceDataSource *)dataSourceForKey:(NSObject<NSCopying> *)aKey
{
    if (aKey != nil) {
        return [self.sources objectForKey:aKey];
    } else {
        return nil;
    }
}

-(void)setDataSource:(IDLInterfaceDataSource *)dataSource forKey:(NSObject<NSCopying> *)aKey
{
    if (aKey != nil) {
        if (dataSource != nil) {
            [self.sources setObject:dataSource forKey:aKey];
        } else {
            [self.sources removeObjectForKey:aKey];
        }
    }
}

-(NSArray *)allKeys
{
    return self.sources.allKeys;
}

-(NSUInteger)count
{
    return self.sources.count;
}

@end
