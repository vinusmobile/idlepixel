//
//  IDLGlobal.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 27/03/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLAbstractSharedSingleton.h"

@interface IDLGlobal : IDLAbstractSharedSingleton

+(instancetype)shared;

@property (readonly) NSInteger nextInteger;

@end

NS_INLINE NSInteger IDLGlobalNextInteger()
{
    return [IDLGlobal shared].nextInteger;
}
