//
//  IDLAbstractManager.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 8/11/2013.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLAbstractManager.h"

@implementation IDLAbstractManager

-(id)init
{
    self = [super init];
    if (self) {
        [self configure];
        [self setupObservers];
    }
    return self;
}

-(void)dealloc
{
    [self removeObservers];
}

-(void)configure
{
    // do nothing
}

-(void)setupObservers
{
    // do nothing
}

-(void)removeObservers
{
    // do nothing
}

-(void)notificationObserved:(NSNotification *)notification
{
    // do nothing
}

@end
