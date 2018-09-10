//
//  IDLAbstractBootstrap.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 25/07/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLObjectProtocols.h"

@interface IDLAbstractBootstrap : NSObject <IDLConfigurable>

+(BOOL)instanceExecuted;
+(instancetype)executeInstance;
+(BOOL)executeAtLaunch;

@property (nonatomic, assign, readonly) BOOL executed;

-(void)execute;

@end
