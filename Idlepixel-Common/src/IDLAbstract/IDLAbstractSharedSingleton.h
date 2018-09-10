//
//  IDLAbstractSharedSingleton.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 13/03/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLAbstractManager.h"

@interface IDLAbstractSharedSingleton : IDLAbstractManager

+(instancetype)preferredSingleton;

+(BOOL)isPreferredSingletonClass;
+(BOOL)ignorePreferredSingletonClass;
+(Class)rootSingletonClass;

@end
