//
//  IDLMemoryCache.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 17/12/12.
//  Copyright (c) 2012 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLResourceCache.h"

extern uint64_t const kMemoryCacheDefaultTotalUsageLimit;
extern uint64_t const kMemoryCacheDefaultPerObjectUsageLimit;

@interface IDLMemoryCache : IDLResourceCache

@end
