//
//  IDLInterfaceDataSourceCollection.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 23/04/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLInterfaceDataSource.h"

@interface IDLInterfaceDataSourceCollection : NSObject

-(IDLInterfaceDataSource *)dataSourceForView:(UIView *)aView;
-(void)setDataSource:(IDLInterfaceDataSource *)dataSource forView:(UIView *)aView;

-(IDLInterfaceDataSource *)dataSourceForKey:(NSObject<NSCopying> *)aKey;
-(void)setDataSource:(IDLInterfaceDataSource *)dataSource forKey:(NSObject<NSCopying> *)aKey;

-(NSArray *)allKeys;
-(NSUInteger)count;

@end
