//
//  UIResponder+Idlepixel.h
//  Idlepixel-Common
//
//  Created by Trystan Pfluger on 30/09/13.
//  Copyright (c) 2013 Trystan Pfluger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (IDLSwizzleLogging)

+(void)swizzleFirstResponderMethods;

-(BOOL)swizzled_becomeFirstResponder;
-(BOOL)swizzled_resignFirstResponder;
-(BOOL)swizzled_canBecomeFirstResponder;
-(BOOL)swizzled_canResignFirstResponder;

@end
