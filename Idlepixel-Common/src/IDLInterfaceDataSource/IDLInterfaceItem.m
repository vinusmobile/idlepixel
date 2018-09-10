//
//  IDLInterfaceItem.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 5/02/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "IDLInterfaceItem.h"
#import "IDLMacroHeaders.h"
#import "NSMutableArray+Idlepixel.h"
#import "NSArray+Idlepixel.h"
#import "NSObject+Idlepixel.h"

@implementation IDLInterfaceItem

+(id)itemWithReuseIdentifier:(NSString *)reuseIdentifier
{
    return [self itemWithData:nil reuseIdentifier:reuseIdentifier];
}

+(id)itemWithData:(NSObject *)data
{
    return [self itemWithData:data reuseIdentifier:nil];
}

+(id)itemWithData:(NSObject *)data reuseIdentifier:(NSString *)reuseIdentifier
{
    return [[self alloc] initWithData:data reuseIdentifier:reuseIdentifier];
}

-(id)initWithData:(NSObject *)data reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super init];
    if (self) {
        self.data = data;
        self.reuseIdentifier = reuseIdentifier;
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@[%@] { link:%@, data:%@, dimensions:%@ }",self.pointerKey,self.reuseIdentifier,self.link,self.data,self.dimensions];
}

@end


