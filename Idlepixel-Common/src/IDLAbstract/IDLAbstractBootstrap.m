//
//  IDLAbstractBootstrap.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 25/07/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLAbstractBootstrap.h"
#import "NSObject+Idlepixel.h"

@interface IDLAbstractBootstrap ()

@property (nonatomic, assign, readwrite) BOOL executed;

@end

@implementation IDLAbstractBootstrap

static NSMutableSet *executedBootstrapClasses;

+(BOOL)instanceExecuted
{
    return [executedBootstrapClasses containsObject:[self class]];
}

+(void)registerBootstrapClassExecuted
{
    if (executedBootstrapClasses == nil) {
        executedBootstrapClasses = [NSMutableSet set];
    }
    [executedBootstrapClasses addObject:[self class]];
}

+(instancetype)executeInstance
{
    IDLAbstractBootstrap *bs = [[[self class] alloc] init];
    [bs execute];
    return bs;
}

+(BOOL)executeAtLaunch
{
    return YES;
}

-(void)execute
{
    //IDLLog(@"Executing %@",self.className);
    [[self class] registerBootstrapClassExecuted];
    _executed = YES;
}

-(id)init
{
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}

-(void)configure
{
    // do nothing
}

@end
