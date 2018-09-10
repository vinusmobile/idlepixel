//
//  UIResponder+Idlepixel.m
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 30/09/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import "UIResponder+Idlepixel.h"
#import "NSObject+Idlepixel.h"

@implementation UIResponder (IDLSwizzleLogging)

+(void)swizzleFirstResponderMethods
{
    [UIResponder swizzleInstanceSelector:@selector(becomeFirstResponder) withNewSelector:@selector(swizzled_becomeFirstResponder)];
    [UIResponder swizzleInstanceSelector:@selector(resignFirstResponder) withNewSelector:@selector(swizzled_resignFirstResponder)];
    [UIResponder swizzleInstanceSelector:@selector(canBecomeFirstResponder) withNewSelector:@selector(swizzled_canBecomeFirstResponder)];
    [UIResponder swizzleInstanceSelector:@selector(canResignFirstResponder) withNewSelector:@selector(swizzled_canResignFirstResponder)];
}

-(BOOL)swizzled_becomeFirstResponder
{
    BOOL result = [self swizzled_becomeFirstResponder];
    IDLLogContext(@"%@: %i",self.pointerKey,result);
    return result;
}

-(BOOL)swizzled_resignFirstResponder
{
    BOOL result = [self swizzled_resignFirstResponder];
    IDLLogContext(@"%@: %i",self.pointerKey,result);
    return result;
}

-(BOOL)swizzled_canBecomeFirstResponder
{
    BOOL result = [self swizzled_canBecomeFirstResponder];
    IDLLogContext(@"%@: %i",self.pointerKey,result);
    return result;
}

-(BOOL)swizzled_canResignFirstResponder
{
    BOOL result = [self swizzled_canResignFirstResponder];
    IDLLogContext(@"%@: %i",self.pointerKey,result);
    return result;
}

@end
