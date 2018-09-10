//
//  UIControl+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 27/03/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (IDLActions)

-(void)removeTargetsInArray:(NSArray *)targetArray;
-(void)removeTargetsInSet:(NSSet *)targetSet;

-(void)removeTarget:(NSObject *)target;

-(void)removeTargetsWithClass:(Class)aClass;

-(void)removeAllTargets;

@end
